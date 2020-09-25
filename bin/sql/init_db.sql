-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/gxS8VJ
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "products" (
    -- id_prd
    "id_product" serial   NOT NULL,
    "id_video" int   NULL,
    "id_vinyl" int   NULL,
    "country_code" int   NOT NULL,
    "id_publisher" int   NOT NULL,
    "id_availability" int   NOT NULL,
    "id_distributor" int   NOT NULL,
    "id_age_rating" int   NULL,
    "id_media_type" int   NOT NULL,
    "id_stock_status" int   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "title_original" varchar(255)   NOT NULL,
    -- prices stored in cents
    "price" bigint   NOT NULL,
    "synopsis" text   NULL,
    "production_year" int   NULL,
    "created_at" date   NOT NULL,
    "ean" int   NULL,
    "image_url" varchar   NULL,
    CONSTRAINT "pk_products" PRIMARY KEY (
        "id_product"
     )
);

CREATE TABLE "stocks_statuses" (
    "id_stocks_status" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_stocks_statuses" PRIMARY KEY (
        "id_stocks_status"
     )
);

CREATE TABLE "media_types" (
    "id_media_type" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_media_types" PRIMARY KEY (
        "id_media_type"
     )
);

CREATE TABLE "distributors" (
    "id_distributor" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_distributors" PRIMARY KEY (
        "id_distributor"
     )
);

CREATE TABLE "availabilities" (
    "id_availability" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_availabilities" PRIMARY KEY (
        "id_availability"
     )
);

CREATE TABLE "product_authors" (
    "id_pau_product" int   NOT NULL,
    "id_pau_author" int   NOT NULL
);

CREATE TABLE "authors" (
    "id_author" int   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "image_url" varchar   NULL,
    CONSTRAINT "pk_authors" PRIMARY KEY (
        "id_author"
     )
);

-- many to many
-- n_n
CREATE TABLE "video_actors" (
    -- id_pa_prd
    "id_video_vid-act" int   NOT NULL,
    "id_actor_vid-act" int   NOT NULL
);

CREATE TABLE "actors" (
    "id_actor" int   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "image_url" varchar   NULL,
    CONSTRAINT "pk_actors" PRIMARY KEY (
        "id_actor"
     )
);

CREATE TABLE "countries" (
    "code" int   NOT NULL,
    "name" varchar(255)   NOT NULL,
    CONSTRAINT "pk_countries" PRIMARY KEY (
        "code"
     )
);

-- 1_n
CREATE TABLE "publishers" (
    "id_publisher" int   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "website" varchar   NULL,
    CONSTRAINT "pk_publishers" PRIMARY KEY (
        "id_publisher"
     )
);

-- database design for multiple product types
-- with variable attributes
-- https://stackoverflow.com/questions/17122656/database-design-for-multiple-product-types-with-variable-attributes
CREATE TABLE "videos" (
    "id_video" int   NOT NULL,
    "id_zone" int   NOT NULL,
    "id_category" int   NOT NULL,
    "format_tv" varchar(100)   NULL,
    "format_cinema" decimal   NULL,
    "bonus_content" text   NULL,
    -- minutes
    "duration" int   NULL,
    CONSTRAINT "pk_videos" PRIMARY KEY (
        "id_video"
     )
);

CREATE TABLE "video_audio" (
    "id_vau_video" int   NOT NULL,
    "id_vau_audio_track" int   NOT NULL
);

CREATE TABLE "audio_tracks" (
    "id_audio_track" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_audio_tracks" PRIMARY KEY (
        "id_audio_track"
     )
);

CREATE TABLE "age_ratings" (
    "id_age_rating" int   NOT NULL,
    "name" varchar(255)   NOT NULL,
    CONSTRAINT "pk_age_ratings" PRIMARY KEY (
        "id_age_rating"
     )
);

CREATE TABLE "subcategories" (
    "id_subcategory" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_subcategories" PRIMARY KEY (
        "id_subcategory"
     )
);

CREATE TABLE "genres" (
    "id_genre" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_genres" PRIMARY KEY (
        "id_genre"
     )
);

CREATE TABLE "video_genres" (
    "id_vgn_video" int   NOT NULL,
    "id_vgn_genre" int   NOT NULL
);

CREATE TABLE "video_subcategories" (
    "id_vsc_video" int   NOT NULL,
    "id_vsc_subcategory" int   NOT NULL
);

CREATE TABLE "video_categories" (
    "id_video_category" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_video_categories" PRIMARY KEY (
        "id_video_category"
     )
);

CREATE TABLE "video_zones" (
    "id_video_zone" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_video_zones" PRIMARY KEY (
        "id_video_zone"
     )
);

CREATE TABLE "video_subtitles" (
    "id_vsu_video" int   NOT NULL,
    "id_vsu_subtitle" int   NOT NULL
);

CREATE TABLE "subtitles" (
    "id_subtitle" int   NOT NULL,
    "name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_subtitles" PRIMARY KEY (
        "id_subtitle"
     )
);

-- orders
CREATE TABLE "orders" (
    "id_order" int   NOT NULL,
    "id_user" int   NOT NULL,
    "status" varchar(100)   NOT NULL,
    "created_at" date   NOT NULL,
    CONSTRAINT "pk_orders" PRIMARY KEY (
        "id_order"
     )
);

CREATE TABLE "order_products" (
    "id_order" int   NOT NULL,
    "id_product" int   NOT NULL,
    "quantity" int   NOT NULL
);

-- users
CREATE TABLE "users" (
    "id_user" int   NOT NULL,
    "id_user_type" int   NOT NULL,
    "full_name" varchar(255)   NOT NULL,
    "email" varchar(255)   NOT NULL,
    "gender" varchar(100)   NULL,
    "adress" varchar(255)   NULL,
    "date_of_birth" date   NOT NULL,
    "created_at" date   NOT NULL,
    "country_code" int   NOT NULL,
    CONSTRAINT "pk_users" PRIMARY KEY (
        "id_user"
     )
);

CREATE TABLE "user_types" (
    "id_user_type" int   NOT NULL,
    "name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_user_types" PRIMARY KEY (
        "id_user_type"
     )
);

ALTER TABLE "products" ADD CONSTRAINT "fk_products_id_video" FOREIGN KEY("id_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "products" ADD CONSTRAINT "fk_products_country_code" FOREIGN KEY("country_code")
REFERENCES "countries" ("code");

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
REFERENCES "stocks_statuses" ("id_stocks_status");

ALTER TABLE "product_authors" ADD CONSTRAINT "fk_product_authors_id_pau_product" FOREIGN KEY("id_pau_product")
REFERENCES "products" ("id_product");

ALTER TABLE "product_authors" ADD CONSTRAINT "fk_product_authors_id_pau_author" FOREIGN KEY("id_pau_author")
REFERENCES "authors" ("id_author");

ALTER TABLE "video_actors" ADD CONSTRAINT "fk_video_actors_id_video_vid-act" FOREIGN KEY("id_video_vid-act")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_actors" ADD CONSTRAINT "fk_video_actors_id_actor_vid-act" FOREIGN KEY("id_actor_vid-act")
REFERENCES "actors" ("id_actor");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_zone" FOREIGN KEY("id_zone")
REFERENCES "video_zones" ("id_video_zone");

ALTER TABLE "videos" ADD CONSTRAINT "fk_videos_id_category" FOREIGN KEY("id_category")
REFERENCES "video_categories" ("id_video_category");

ALTER TABLE "video_audio" ADD CONSTRAINT "fk_video_audio_id_vau_video" FOREIGN KEY("id_vau_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_audio" ADD CONSTRAINT "fk_video_audio_id_vau_audio_track" FOREIGN KEY("id_vau_audio_track")
REFERENCES "audio_tracks" ("id_audio_track");

ALTER TABLE "video_genres" ADD CONSTRAINT "fk_video_genres_id_vgn_video" FOREIGN KEY("id_vgn_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_genres" ADD CONSTRAINT "fk_video_genres_id_vgn_genre" FOREIGN KEY("id_vgn_genre")
REFERENCES "genres" ("id_genre");

ALTER TABLE "video_subcategories" ADD CONSTRAINT "fk_video_subcategories_id_vsc_video" FOREIGN KEY("id_vsc_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_subcategories" ADD CONSTRAINT "fk_video_subcategories_id_vsc_subcategory" FOREIGN KEY("id_vsc_subcategory")
REFERENCES "subcategories" ("id_subcategory");

ALTER TABLE "video_subtitles" ADD CONSTRAINT "fk_video_subtitles_id_vsu_video" FOREIGN KEY("id_vsu_video")
REFERENCES "videos" ("id_video");

ALTER TABLE "video_subtitles" ADD CONSTRAINT "fk_video_subtitles_id_vsu_subtitle" FOREIGN KEY("id_vsu_subtitle")
REFERENCES "subtitles" ("id_subtitle");

ALTER TABLE "orders" ADD CONSTRAINT "fk_orders_id_user" FOREIGN KEY("id_user")
REFERENCES "users" ("id_user");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_id_order" FOREIGN KEY("id_order")
REFERENCES "orders" ("id_order");

ALTER TABLE "order_products" ADD CONSTRAINT "fk_order_products_id_product" FOREIGN KEY("id_product")
REFERENCES "products" ("id_product");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_id_user_type" FOREIGN KEY("id_user_type")
REFERENCES "user_types" ("id_user_type");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_country_code" FOREIGN KEY("country_code")
REFERENCES "countries" ("code");

