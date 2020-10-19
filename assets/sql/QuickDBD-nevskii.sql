-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/gxS8VJ
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "products" (
    "id_product" serial   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "title_original" varchar(255)   NOT NULL,
    -- price in cents
    "price" bigint   NULL,
    "synopsis" text   NULL,
    "production_year" smallint   NULL,
    "created_at" timestamptz   NOT NULL,
    "ean" bigint   NULL,
    "image_url" varchar   NULL,
    "id_video" int   NULL,
    "id_vinyl" int   NULL,
    "id_publisher" int   NOT NULL,
    "id_availability" int   NOT NULL,
    "id_distributor" int   NOT NULL,
    "id_age_rating" int   NULL,
    "id_media_type" int   NULL,
    "id_stock_status" int   NOT NULL,
    CONSTRAINT "pk_products" PRIMARY KEY (
        "id_product"
     )
);

CREATE TABLE "stock_statuses" (
    "id_stock_status" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_stock_statuses" PRIMARY KEY (
        "id_stock_status"
     )
);

CREATE TABLE "media_types" (
    "id_media_type" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_media_types" PRIMARY KEY (
        "id_media_type"
     )
);

CREATE TABLE "distributors" (
    "id_distributor" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_distributors" PRIMARY KEY (
        "id_distributor"
     )
);

CREATE TABLE "availabilities" (
    "id_availability" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_availabilities" PRIMARY KEY (
        "id_availability"
     )
);

CREATE TABLE "product_authors" (
    "id_product_authors" serial   NOT NULL,
    "id_pau_product" int   NULL,
    "id_pau_author" int   NULL,
    CONSTRAINT "pk_product_authors" PRIMARY KEY (
        "id_product_authors"
     )
);

CREATE TABLE "product_countries" (
    "id_product_countries" serial   NOT NULL,
    "id_pco_product" int   NULL,
    "id_pco_country" int   NULL,
    CONSTRAINT "pk_product_countries" PRIMARY KEY (
        "id_product_countries"
     )
);

CREATE TABLE "authors" (
    "id_author" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "image_url" varchar   NULL,
    CONSTRAINT "pk_authors" PRIMARY KEY (
        "id_author"
     )
);

CREATE TABLE "video_actors" (
    "id_video_actors" serial   NOT NULL,
    "id_vac_video" int   NULL,
    "id_vac_actor" int   NULL,
    CONSTRAINT "pk_video_actors" PRIMARY KEY (
        "id_video_actors"
     )
);

CREATE TABLE "actors" (
    "id_actor" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "image_url" varchar   NULL,
    CONSTRAINT "pk_actors" PRIMARY KEY (
        "id_actor"
     )
);

CREATE TABLE "countries" (
    "id_country" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    CONSTRAINT "pk_countries" PRIMARY KEY (
        "id_country"
     )
);

CREATE TABLE "publishers" (
    "id_publisher" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "website" varchar   NULL,
    CONSTRAINT "pk_publishers" PRIMARY KEY (
        "id_publisher"
     )
);

CREATE TABLE "videos" (
    "id_video" serial   NOT NULL,
    "bonus_content" text   NULL,
    "minutes" int   NULL,
    "id_zone" int   NULL,
    "id_category" int   NULL,
    "id_tv_format" int   NULL,
    "id_film_format" int   NULL,
    CONSTRAINT "pk_videos" PRIMARY KEY (
        "id_video"
     )
);

CREATE TABLE "video_audio" (
    "id_video_audio" serial   NOT NULL,
    "id_vau_video" int   NULL,
    "id_vau_audio_track" int   NULL,
    CONSTRAINT "pk_video_audio" PRIMARY KEY (
        "id_video_audio"
     )
);

CREATE TABLE "audio_tracks" (
    "id_audio_track" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_audio_tracks" PRIMARY KEY (
        "id_audio_track"
     )
);

CREATE TABLE "age_ratings" (
    "id_age_rating" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    CONSTRAINT "pk_age_ratings" PRIMARY KEY (
        "id_age_rating"
     )
);

CREATE TABLE "subcategories" (
    "id_subcategory" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_subcategories" PRIMARY KEY (
        "id_subcategory"
     )
);

CREATE TABLE "genres" (
    "id_genre" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_genres" PRIMARY KEY (
        "id_genre"
     )
);

CREATE TABLE "tv_formats" (
    "id_tv_format" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_tv_formats" PRIMARY KEY (
        "id_tv_format"
     )
);

CREATE TABLE "film_formats" (
    "id_film_format" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_film_formats" PRIMARY KEY (
        "id_film_format"
     )
);

CREATE TABLE "video_genres" (
    "id_video_genres" serial   NOT NULL,
    "id_vge_video" int   NULL,
    "id_vge_genre" int   NULL,
    CONSTRAINT "pk_video_genres" PRIMARY KEY (
        "id_video_genres"
     )
);

CREATE TABLE "video_subcategories" (
    "id_video_subcategories" serial   NOT NULL,
    "id_vsc_video" int   NULL,
    "id_vsc_subcategory" int   NULL,
    CONSTRAINT "pk_video_subcategories" PRIMARY KEY (
        "id_video_subcategories"
     )
);

CREATE TABLE "video_categories" (
    "id_video_category" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_video_categories" PRIMARY KEY (
        "id_video_category"
     )
);

CREATE TABLE "video_zones" (
    "id_video_zone" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_video_zones" PRIMARY KEY (
        "id_video_zone"
     )
);

CREATE TABLE "video_subtitles" (
    "id_video_subtitles" serial   NOT NULL,
    "id_vst_video" int   NULL,
    "id_vst_subtitle" int   NULL,
    CONSTRAINT "pk_video_subtitles" PRIMARY KEY (
        "id_video_subtitles"
     )
);

CREATE TABLE "subtitles" (
    "id_subtitle" serial   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_subtitles" PRIMARY KEY (
        "id_subtitle"
     )
);

CREATE TABLE "orders" (
    "id_order" serial   NOT NULL,
    "id_user" int   NOT NULL,
    "status" varchar(100)   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_orders" PRIMARY KEY (
        "id_order"
     )
);

CREATE TABLE "order_products" (
    "id_order_products" serial   NOT NULL,
    "id_orp_order" int   NULL,
    "id_orp_product" int   NULL,
    "quantity" int   NOT NULL,
    CONSTRAINT "pk_order_products" PRIMARY KEY (
        "id_order_products"
     )
);

CREATE TABLE "users" (
    "id_user" serial   NOT NULL,
    "id_user_type" int   NOT NULL,
    "id_country" int   NOT NULL,
    "full_name" varchar(255)   NOT NULL,
    "email" varchar(255)   NOT NULL,
    "gender" char(2)   NULL,
    "address" varchar(255)   NULL,
    "date_of_birth" date   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_users" PRIMARY KEY (
        "id_user"
     )
);

CREATE TABLE "user_types" (
    "id_user_type" serial   NOT NULL,
    "description" varchar(50)   NOT NULL,
    CONSTRAINT "pk_user_types" PRIMARY KEY (
        "id_user_type"
     )
);

CREATE TABLE "video_collections" (
    "id_video_collections" serial   NOT NULL,
    "id_vco_video" int   NULL,
    "id_vco_collection" int   NULL,
    CONSTRAINT "pk_video_collections" PRIMARY KEY (
        "id_video_collections"
     )
);

CREATE TABLE "collections" (
    "id_collection" serial   NOT NULL,
    "name" varchar(255)   NOT NULL,
    CONSTRAINT "pk_collections" PRIMARY KEY (
        "id_collection"
     )
);

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_video" FOREIGN KEY("id_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_publisher" FOREIGN KEY("id_publisher")
REFERENCES "publishers" ("id_publisher");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_availability" FOREIGN KEY("id_availability")
REFERENCES "availabilities" ("id_availability");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_distributor" FOREIGN KEY("id_distributor")
REFERENCES "distributors" ("id_distributor");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_age_rating" FOREIGN KEY("id_age_rating")
REFERENCES "age_ratings" ("id_age_rating");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_media_type" FOREIGN KEY("id_media_type")
REFERENCES "media_types" ("id_media_type");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_stock_status" FOREIGN KEY("id_stock_status")
REFERENCES "stock_statuses" ("id_stock_status");

ALTER TABLE "product_authors" ADD CONSTRAINT "fk_product_authors_id_pau_product" FOREIGN KEY("id_pau_product")
REFERENCES "products" ("id_product");

ALTER TABLE "product_authors" ADD CONSTRAINT "fk_product_authors_id_pau_author" FOREIGN KEY("id_pau_author")
REFERENCES "authors" ("id_author");

ALTER TABLE "product_countries" ADD CONSTRAINT "fk_product_countries_id_pco_product" FOREIGN KEY("id_pco_product")
REFERENCES "products" ("id_product");

ALTER TABLE "product_countries" ADD CONSTRAINT "fk_product_countries_id_pco_country" FOREIGN KEY("id_pco_country")
REFERENCES "countries" ("id_country");

ALTER TABLE "video_actors" ADD CONSTRAINT "fk_video_actors_id_vac_video" FOREIGN KEY("id_vac_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_actors" ADD CONSTRAINT "fk_video_actors_id_vac_actor" FOREIGN KEY("id_vac_actor")
REFERENCES "actors" ("id_actor");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_zone" FOREIGN KEY("id_zone")
REFERENCES "video_zones" ("id_video_zone");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_category" FOREIGN KEY("id_category")
REFERENCES "video_categories" ("id_video_category");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_tv_format" FOREIGN KEY("id_tv_format")
REFERENCES "tv_formats" ("id_tv_format");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_film_format" FOREIGN KEY("id_film_format")
REFERENCES "film_formats" ("id_film_format");

ALTER TABLE "video_audio" ADD CONSTRAINT "fk_video_audio_id_vau_video" FOREIGN KEY("id_vau_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_audio" ADD CONSTRAINT "fk_video_audio_id_vau_audio_track" FOREIGN KEY("id_vau_audio_track")
REFERENCES "audio_tracks" ("id_audio_track");

ALTER TABLE "video_genres" ADD CONSTRAINT "fk_video_genres_id_vge_video" FOREIGN KEY("id_vge_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_genres" ADD CONSTRAINT "fk_video_genres_id_vge_genre" FOREIGN KEY("id_vge_genre")
REFERENCES "genres" ("id_genre");

ALTER TABLE "video_subcategories" ADD CONSTRAINT "fk_video_subcategories_id_vsc_video" FOREIGN KEY("id_vsc_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_subcategories" ADD CONSTRAINT "fk_video_subcategories_id_vsc_subcategory" FOREIGN KEY("id_vsc_subcategory")
REFERENCES "subcategories" ("id_subcategory");

ALTER TABLE "video_subtitles" ADD CONSTRAINT "fk_video_subtitles_id_vst_video" FOREIGN KEY("id_vst_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_subtitles" ADD CONSTRAINT "fk_video_subtitles_id_vst_subtitle" FOREIGN KEY("id_vst_subtitle")
REFERENCES "subtitles" ("id_subtitle");

ALTER TABLE "orders" ADD CONSTRAINT "fk_orders_id_user" FOREIGN KEY("id_user")
REFERENCES "users" ("id_user");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_id_orp_order" FOREIGN KEY("id_orp_order")
REFERENCES "orders" ("id_order");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_id_orp_product" FOREIGN KEY("id_orp_product")
REFERENCES "products" ("id_product");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_id_user_type" FOREIGN KEY("id_user_type")
REFERENCES "user_types" ("id_user_type");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_id_country" FOREIGN KEY("id_country")
REFERENCES "countries" ("id_country");

ALTER TABLE "video_collections" ADD CONSTRAINT "fk_video_collections_id_vco_video" FOREIGN KEY("id_vco_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_collections" ADD CONSTRAINT "fk_video_collections_id_vco_collection" FOREIGN KEY("id_vco_collection")
REFERENCES "collections" ("id_collection");

