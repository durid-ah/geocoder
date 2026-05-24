#!/bin/bash
set -euo pipefail

NOMINATIM_PASSWORD="${NOMINATIM_PASSWORD:-nominatim}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    DO \$\$
    BEGIN
      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'nominatim') THEN
        CREATE ROLE nominatim WITH LOGIN PASSWORD '${NOMINATIM_PASSWORD}' SUPERUSER;
      END IF;
    END
    \$\$;
EOSQL
