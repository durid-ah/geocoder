FROM postgis/postgis:16-3.4

COPY conf.d/postgres-tuning.conf /etc/postgresql/nominatim-tuning.conf
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# Only chmod our scripts — do NOT chmod 10_postgis.sh (must stay non-executable so
# the Postgres entrypoint sources it and the psql[] array is available).
RUN chmod +x \
    /docker-entrypoint-initdb.d/00-tuning.sh \
    /docker-entrypoint-initdb.d/11-nominatim-roles.sh \
    /docker-entrypoint-initdb.d/12-nominatim-database.sh \
    /docker-entrypoint-initdb.d/13-nominatim-restore.sh

EXPOSE 5432
