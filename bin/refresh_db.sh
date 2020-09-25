#!/usr/bin/env bash

RESTORE='\033[0m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
BOLD='\033[01;37m'

printf "${BOLD}-- Dropping old DB...${RESTORE}\n"
dropdb -h localhost -p 5432 -U postgres $PG_NAME

if [ $? -eq 0 ];
then
  createdb -h $PG_HOST -p 5432 -U postgres $PG_NAME
  psql -h $PG_HOST -p 5432 -U postgres $PG_NAME < ./bin/sql/init_db.sql > /dev/null 2>&1
  printf "${LGREEN}🍉 Fresh DB ready${RESTORE}\n"
else
  printf "${LRED}💩 Error!${RESTORE}\n"
fi


