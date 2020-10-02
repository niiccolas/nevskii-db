const format = require("pg-format");
const pgtools = require("pgtools");
const { Pool } = require("pg");
const fs = require("fs");

const { getIdIndex, parseMonthFR, generateIdName, log } = require("./utils");
require("dotenv").config();

const { PG_PASS, PG_USER, PG_HOST, PG_PORT, PG_DB_NAME } = process.env;
const DB_CONFIG = {
  password: PG_PASS,
  user: PG_USER,
  host: PG_HOST,
  port: PG_PORT,
};
const pool = new Pool({ database: PG_DB_NAME, ...DB_CONFIG });

const [
  publishers,
  availabilities,
  distributors,
  age_ratings,
  media_types,
  countries,
  stock_statuses,
  authors_names,
  actors_names,
  video_categories,
  video_zones,
  audio_tracks,
  subcategories,
  subtitles,
  collections,
  tv_formats,
  film_formats,
  genres,
] = Array(18)
  .fill()
  .map(() => new Set());

/**
 * Write data to VIDEOS, PRODUCTS and associated join tables
 * @param {Array<{}>} data
 */
const buildMainTables = async (data) => {
  for await (const [
    index,
    {
      title: csv_title,
      original_title: csv_original_title,
      price: csv_price,
      synopsis: csv_synopsis,
      production_year: csv_production_year,
      publication_date: csv_publication_date,
      EAN: csv_EAN,
      image_URL: csv_image_URL,
      authors: csv_authors,
      editor: csv_publisher,
      collection: csv_collection,
      bonus_content: csv_bonus_content,
      actors: csv_actors,
      country: csv_country,
      age_rating: csv_age_rating,
      duration: csv_duration,
      availability: csv_availability,
      distributor: csv_distributor,
      media_type: csv_media_type,
      dvd_zone: csv_dvd_zone,
      format_tv: csv_format_tv,
      format_cinema: csv_format_film,
      audio_track: csv_audio_track,
      subtitle_track: csv_subtitle_track,
      category: csv_category,
      subcategory: csv_subcategory,
      subcategory_genre_1: csv_scg1,
      subcategory_genre_2: csv_scg2,
      subcategory_genre_3: csv_scg3,
      subcategory_genre_4: csv_scg4,
    },
  ] of data.entries()) {
    try {
      await pool.query(
        `INSERT INTO videos(
      id_video,
      id_zone,
      id_category,
      id_tv_format,
      id_film_format,
      bonus_content,
      minutes)
      VALUES($1, $2, $3, $4, $5, $6, $7)`,
        [
          index,
          getIdIndex(video_zones, csv_dvd_zone),
          getIdIndex(video_categories, csv_category),
          getIdIndex(tv_formats, csv_format_tv),
          getIdIndex(film_formats, csv_format_film),
          !!csv_bonus_content ? csv_bonus_content : null,
          !!csv_duration ? parseInt(csv_duration) : null,
        ]
      );

      await pool.query(
        `INSERT INTO products(
          id_product,
        id_video,
        title,
        title_original,
        price,
        synopsis,
        production_year,
        created_at,
        ean,
        image_url,
        id_publisher,
        id_availability,
        id_distributor,
        id_age_rating,
        id_media_type,
        id_stock_status)
        VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`,
        [
          index,
          index,
          csv_title,
          csv_original_title,
          csv_price === "N.C." ? null : parseInt(csv_price.replace(/\D/g, "")),
          csv_synopsis,
          csv_production_year || null,
          parseMonthFR(csv_publication_date),
          csv_EAN,
          csv_image_URL,
          getIdIndex(publishers, csv_publisher),
          getIdIndex(availabilities, csv_availability),
          getIdIndex(distributors, csv_distributor),
          getIdIndex(age_ratings, csv_age_rating),
          getIdIndex(media_types, csv_media_type),
          0,
        ]
      );

      csv_actors.split(",").forEach(async (actor) => {
        // console.log(getIdIndex(actors_names, actor));
        await pool.query(
          `INSERT INTO video_actors(
            id_vac_video,
            id_vac_actor)
          VALUES($1, $2)`,
          [index, getIdIndex(actors_names, actor)]
        );
      });

      csv_audio_track.split(",").forEach(async (track) => {
        const parsedTrack = track.replace("Audio : ", "").trim();
        const trackId = getIdIndex(audio_tracks, parsedTrack);

        if (trackId !== null) {
          await pool.query(
            `INSERT INTO video_audio(
               id_vau_video,
               id_vau_audio_track)
             VALUES($1, $2)`,
            [index, trackId]
          );
        }
      });

      if (!!csv_subcategory) {
        await pool.query(
          `INSERT INTO video_subcategories(
                id_vsc_video,
                id_vsc_subcategory)
               VALUES($1, $2)`,
          [index, getIdIndex(subcategories, csv_subcategory)]
        );
      }

      [csv_scg1, csv_scg2, csv_scg3, csv_scg4].forEach(
        async (csv_subcategory_genre) => {
          if (!!csv_subcategory_genre) {
            await pool.query(
              `INSERT INTO video_genres(
              id_vge_video,
              id_vge_genre)
                 VALUES($1, $2)`,
              [index, getIdIndex(genres, csv_subcategory_genre)]
            );
          }
        }
      );

      csv_subtitle_track.split(",").forEach(async (track) => {
        const parsedSubTrack = track.replace("Sous-titrage : ", "").trim();
        const trackId = getIdIndex(subtitles, parsedSubTrack);

        if (trackId !== null) {
          await pool.query(
            `INSERT INTO video_subtitles(
              id_vst_video,
              id_vst_subtitle)
             VALUES($1, $2)`,
            [index, trackId]
          );
        }
      });

      if (!!csv_collection) {
        await pool.query(
          `INSERT INTO video_collections(
            id_vco_video,
            id_vco_collection)
           VALUES($1, $2)`,
          [index, getIdIndex(collections, csv_collection)]
        );
      }

      if (!!csv_country) {
        csv_country.split(";").forEach(async (country) => {
          try {
            await pool.query(
              `INSERT INTO product_countries(
                id_pco_product,
                id_pco_country)
               VALUES($1, $2)`,
              [index, getIdIndex(countries, country.toLowerCase())]
            );
          } catch (error) {
            log(error, csv_EAN);
          }
        });
      }

      if (!!csv_authors) {
        csv_authors.split(",").forEach(async (author) => {
          try {
            await pool.query(
              `INSERT INTO product_authors(
                  id_pau_product,
                  id_pau_author)
                 VALUES($1, $2)`,
              [index, getIdIndex(authors_names, author)]
            );
          } catch (error) {
            log(error, csv_EAN);
          }
        });
      }
    } catch (error) {
      log(error, csv_EAN);
    }
  }
};

/**
 * Write data to foreign/accessory tables
 * @param {Array<{}>} data
 */
const buildForeignTables = async (data) => {
  data.forEach(
    async ({
      authors: csv_authors,
      editor: csv_publisher,
      collection: csv_collection,
      actors: csv_actors,
      country: csv_country,
      age_rating: csv_age_rating,
      availability: csv_availability,
      distributor: csv_distributor,
      media_type: csv_media_type,
      dvd_zone: csv_dvd_zone,
      format_tv: csv_format_tv,
      format_cinema: csv_format_film,
      audio_track: csv_audio_track,
      subtitle_track: csv_subtitle_track,
      in_stock: csv_in_stock,
      category: csv_category,
      subcategory: csv_subcategory,
      subcategory_genre_1: csv_scg1,
      subcategory_genre_2: csv_scg2,
      subcategory_genre_3: csv_scg3,
      subcategory_genre_4: csv_scg4,
    }) => {
      // prep VIDEO Sets
      video_zones.add(csv_dvd_zone).delete("");
      video_categories.add(csv_category).delete("");
      tv_formats.add(csv_format_tv).delete("");
      film_formats.add(csv_format_film).delete("");
      csv_actors
        .split(",")
        .forEach((actor) => actors_names.add(actor).delete(""));
      csv_audio_track
        .split(",")
        .forEach((track) =>
          audio_tracks.add(track.replace("Audio : ", "").trim()).delete("")
        );
      subcategories.add(csv_subcategory).delete("");
      [csv_scg1, csv_scg2, csv_scg3, csv_scg4].forEach(
        (genre) => !!genre && genres.add(genre)
      );
      csv_subtitle_track
        .split(",")
        .forEach((track) =>
          subtitles.add(track.replace("Sous-titrage : ", "").trim()).delete("")
        );
      collections.add(csv_collection).delete("");

      // prep PRODUCTS Sets
      publishers.add(csv_publisher);
      availabilities.add(csv_availability);
      distributors.add(csv_distributor);
      age_ratings.add(csv_age_rating);
      media_types.add(csv_media_type);
      stock_statuses.add(csv_in_stock);
      csv_country
        .split(";")
        .map((el) => el.toLowerCase())
        .forEach((country) => countries.add(country).delete(""));
      csv_authors
        .split(",")
        .forEach((author) => authors_names.add(author).delete(""));
    }
  );

  insertIntoTable("publishers", publishers);
  insertIntoTable("availabilities", availabilities);
  insertIntoTable("actors", actors_names);
  insertIntoTable("authors", authors_names);
  insertIntoTable("distributors", distributors);
  insertIntoTable("age_ratings", age_ratings);
  insertIntoTable("media_types", media_types);
  insertIntoTable("countries", countries);
  insertIntoTable("stock_statuses", stock_statuses);
  insertIntoTable("video_zones", video_zones);
  insertIntoTable("video_categories", video_categories);
  insertIntoTable("audio_tracks", audio_tracks);
  insertIntoTable("subcategories", subcategories);
  insertIntoTable("subtitles", subtitles);
  insertIntoTable("collections", collections);
  insertIntoTable("tv_formats", tv_formats);
  insertIntoTable("film_formats", film_formats);
  insertIntoTable("genres", genres);
};

/**
 * Populate user_types & users table
 * @param {Array<{}>} an array of user objects
 */
const buildUsers = async (users) => {
  await pool.query(`INSERT INTO user_types ("description")
  VALUES ('admin'), ('user');`);

  users.forEach(
    async ({ type, name, email, gender, address, birthDate, countryId }) => {
      await pool.query(
        `INSERT INTO users (
        "id_user_type",
        "full_name",
        "email",
        "gender",
        "address",
        "date_of_birth",
        "created_at",
        "id_country")
      VALUES
      ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          type || 2,
          name || "John Doe",
          email || "mail@mail.com",
          gender || "F",
          address || "1 avenue de Paris",
          birthDate || "2006-01-01",
          "now()",
          countryId || 0,
        ]
      );
    }
  );
};

/**
 * Populate DB table from given Set
 * @param {string} table
 * @param {Set} set
 */
const insertIntoTable = (tableName, set) => {
  Array.from(set).forEach((setItem, i) => {
    pool.query(
      format(
        "INSERT INTO %I (%s, %s) VALUES (%s, %L)",
        tableName,
        generateIdName(tableName),
        "name",
        i,
        setItem
      ),
      (err, _) => {
        if (err) throw err;
      }
    );
  });
};

/**
 * Drop existing DB if any, recreate it from sql schema
 */
const rebootDB = async () => {
  var schema = fs
    .readFileSync("bin/sql/QuickDBD-nevskii.sql")
    .toString()
    .trim();

  try {
    await pgtools.dropdb(DB_CONFIG, PG_DB_NAME);
    await pgtools.createdb(DB_CONFIG, PG_DB_NAME);
    await pool.query(schema);
  } catch (error) {
    // swallow non-existing db drop error, create db either way
    await pgtools.createdb(DB_CONFIG, PG_DB_NAME);
    await pool.query(schema);
  }
};

module.exports = {
  pool,
  buildMainTables,
  buildForeignTables,
  buildUsers,
  rebootDB,
};
