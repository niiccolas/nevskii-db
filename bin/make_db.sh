#!/usr/bin/env bash

RESTORE='\033[0m'
LRED='\033[01;31m'

dropdb -h localhost -p 5432 -U postgres $PG_NAME

if [ $? -eq 0 ];
then
  createdb -h $PG_HOST -p 5432 -U postgres $PG_NAME
  psql -h $PG_HOST -p 5432 -U postgres $PG_NAME < ./bin/sql/QuickDBD-nevskii.sql > /dev/null 2>&1
else
  printf "${LRED}💩 dropdb failed!${RESTORE}\n"
fi


