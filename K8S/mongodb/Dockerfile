FROM mongo:latest

COPY dump /docker-entrypoint-initdb.d/dump
COPY init_mongo.sh /docker-entrypoint-initdb.d/
