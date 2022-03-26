FROM postgres:13
COPY create-multiple-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/create-multiple-db.sh