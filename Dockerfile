FROM postgres:12-alpine

COPY ./schema.sql /docker-entrypoint-initdb.d/init.sql