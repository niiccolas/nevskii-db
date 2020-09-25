const { execFileSync } = require("child_process");
const csv = require("csvtojson");
const path = require("path");
const { Pool } = require("pg");
const format = require("pg-format");

require("dotenv").config();
const { PG_PASS, PG_USER, PG_HOST, PG_PORT, PG_NAME } = process.env;

const CSV_RAW = path.join("raw", "dvd_all_200.csv");

const pool = new Pool({
  password: PG_PASS,
  user: PG_USER,
  host: PG_HOST,
  port: PG_PORT,
  database: PG_NAME,
});

const populate = async () => {
  const items = await csv({
    delimiter: ";",
    checkType: true,
  }).fromFile(CSV_RAW);

  // temp Sets to insert in tables
  const [
    publishers,
    availabilities,
    distributors,
    age_ratings,
    media_types,
    countries,
    stocks_statuses,
    authors_names,
    actors_names,
    video_categories,
    video_zones,
    audio_tracks,
    subcategories,
    subtitles,
  ] = Array(14)
    .fill()
    .map(() => new Set());

  items.forEach(
    ({
      title: csv_title,
      original_title: csv_original_title,
      price: csv_price,
      synopsis: csv_synopsis,
      production_year: csv_production_year,
      publication_date: csv_publication_date,
      EAN: csv_EAN,
      image_URL: csv_image_URL,
      authors: csv_authors,
      editor: csv_editor,
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
      format_cinema: csv_format_cinema,
      audio_track: csv_audio_track,
      subtitle_track: csv_subtitle_track,
      in_stock: csv_in_stock,
      category: csv_category,
      subcategory: csv_subcategory,
      subcategory_genre_1: csv_subcategory_genre_1,
      subcategory_genre_2: csv_subcategory_genre_2,
      subcategory_genre_3: csv_subcategory_genre_3,
      subcategory_genre_4: csv_subcategory_genre_4,
    }) => {
      // "video" table prep
      const video = {};
      video.bonus_content = csv_bonus_content;
      video.duration = csv_duration;
      // "video" peripheral tables prep
      publishers.add(csv_editor);
      availabilities.add(csv_availability);
      distributors.add(csv_distributor);
      age_ratings.add(csv_age_rating);
      media_types.add(csv_media_type);
      authors_names.add(...csv_authors.split(",")).delete("");
      countries.add(...csv_country.split(";").map((el) => el.toLowerCase()));
      stocks_statuses.add(csv_in_stock);

      // "product" table
      const product = {};
      product.title = csv_title;
      product.title_original = csv_original_title;
      product.price = parseInt(csv_price.replace(/\D/g, ""));
      product.synopsis = csv_synopsis;
      product.production_year = csv_production_year;
      product.created_at = csv_publication_date;
      product.ean = csv_EAN;
      product.imageURL = csv_image_URL;
      // "product" peripheral tables prep
      video_zones.add(csv_dvd_zone);
      video_categories.add(csv_category);
      actors_names.add(...csv_actors.split(",")).delete("");
      csv_audio_track
        .split(",")
        .forEach((track) =>
          audio_tracks.add(track.replace("Audio : ", "").trim()).delete("")
        );
      subcategories.add(csv_subcategory);
      csv_subtitle_track
        .split(",")
        .forEach((track) =>
          subtitles.add(track.replace("Sous-titrage : ", "").trim()).delete("")
        );
    }
  );

  insertInto("publishers", publishers);
  insertInto("availabilities", availabilities);
  insertInto("actors", actors_names);
  insertInto("authors", authors_names);
  insertInto("distributors", distributors);
  insertInto("age_ratings", age_ratings);
  insertInto("media_types", media_types);
  insertInto("countries", countries);
  insertInto("stocks_statuses", stocks_statuses);
  insertInto("video_zones", video_zones);
  insertInto("video_categories", video_categories);
  insertInto("audio_tracks", audio_tracks);
  insertInto("subcategories", subcategories);
  insertInto("subtitles", subtitles);

  // "user_types" table
  await pool.query(`INSERT INTO "user_types" ("id_user_type", "name")
  VALUES (0, 'admin'), (1, 'client');`);
  // "users" table
  await pool.query(`INSERT INTO "users" ("id_user",
  "id_user_type",
  "full_name",
  "email",
  "gender",
  "adress",
  "date_of_birth",
  "created_at",
  "country_code")
  VALUES
  (0, 0, 'Staff Potemkine', 'staff@ptmk.fr', 'female', null, '2006-01-01', now(), 0 ),
  (1, 1, 'Jane User', 'jane@mail.net', 'female', null, '1988-03-18', now(), 2 );`);
};

/**
 * Populates DB tables with csv values
 * @param {string} table
 * @param {Set} set
 */
const insertInto = (tableName, set) => {
  Array.from(set).forEach((setItem, i) => {
    pool.query(
      format(
        "INSERT INTO %I (%s, %s) VALUES (%s, %L)",
        tableName,
        singularID(tableName),
        "name",
        i,
        setItem
      ),
      (err, _res) => {
        if (err) throw err;
      }
    );
  });
};

/**
 * For a given table, returns name of singular ID
 * @param {string} str
 */
const singularID = (str) => {
  if (str === "countries") return "code";
  switch (str.slice(-3)) {
    case "ies":
      return "id_" + str.slice(0, -3) + "y";
    case "ses":
      return "id_" + str.slice(0, -2);
    default:
      return "id_" + str.slice(0, -1);
  }
};

// Clean previous DB
execFileSync(path.join(__dirname, "../bin", "refresh_db.sh"), {
  stdio: "inherit",
});

// Populate if DB empty only
pool.query("SELECT * FROM actors").then((res) => {
  if (res.rowCount !== 0) pool.end() && process.exit(1);

  populate().then(
    async () => {
      // console.log((await pool.query("select * from subtitles;")).rows);
      pool.end(() => console.log("-- Pool has ended", "\n👍 Job done!"));
    },
    (rej) => console.log(rej) && process.exit(1)
  );
});
