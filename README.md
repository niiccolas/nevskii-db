# Nevskii DB

<p align="center">
  <img width="600" src="./assets/svg/seed.svg">
</p>

Starter PostgreSQL database for the Nevskii platform. Seed local with **Docker**, dump & deploy to **Heroku**!

## Setup

Clone and install dependencies.

At the project root, create a `.env` file with relevant credentials.

```bash
PG_PASS=abcd
PG_USER=postgres
PG_DB_NAME=nevskii
PG_HOST=localhost
PG_PORT=5432
```

Pull Docker's official [PostgreSQL image](https://hub.docker.com/_/postgres) and run an instance in a new container.

```bash
# Get Docker image
docker pull postgres

# Create new container...
docker run --name pgDocker -env POSTGRES_PASSWORD=abcd -d -p 5432:5432 postgres
# docker run --name {container_name} -env POSTGRES_PASSWORD={pg_pass} -d -p {host_port}:{container_port} {pg_username}
# -env  set environment variable(s)
# -d    run as daemon
# -p    expose port

# ...or start if already created!
docker start pgDocker
```

## Heroku

For deployment to Heroku's [PostgreSQL free tier](https://elements.heroku.com/addons/heroku-postgresql), take into account the 10,000 total SQL rows limit (as of Oct. 2020). **Processing all items from CSV source files will exceed that limit!** Use the table below for reference and set the [source file](https://github.com/niiccolas/nevskii-db/blob/b17d3dac9f8e8c2cd05934516766a0428953b4b3/src/index.js#L44) and [range](https://github.com/niiccolas/nevskii-db/blob/b17d3dac9f8e8c2cd05934516766a0428953b4b3/src/index.js#L43) to limit row count accordingly.

| source file                                    | items | range            | total SQL rows |
| ---------------------------------------------- | ----- | ---------------- | -------------- |
| `dvd_8182.csv`                                 | 8182  | 0-8182           | 164477         |
|                                                |       | **0-200**        | **5486 ✅**    |
| `dvd_8182_mint.csv` (default, no missing data) | 4412  | 0-4412 (default) | 100785         |
|                                                |       | **0-400**        | **8860 ✅**    |

## Deployment

Run the following commands in sequence. For more details, see Heroku [docs](https://devcenter.heroku.com/articles/heroku-postgres-import-export#import-to-heroku-postgres).

```bash
# Seed local DB
npm run seed

# Dump local DB
docker exec pgDocker pg_dump -Fc --no-acl --no-owner -h localhost -U postgres nevskii > nevskii.dump

# Upload local DB dump to HTTP-accessible URL (e.g.: AWS S3 bucket)
aws s3 cp nevskii.dump s3://{bucket_name}

# Generate signed URL
aws s3 presign s3://{bucket_name}/nevskii.dump

# Create Heroku DB
heroku addons:create heroku-postgresql:hobby-dev

# Deploy dump to Heroku DB
heroku pg:backups:restore '<SIGNED URL>' DATABASE_URL
```
