#!/bin/bash
set -euo pipefail

DUMP="/docker-entrypoint-initdb.d/dump/nominatim.dump"

if [ ! -f "$DUMP" ]; then
  echo "No nominatim.dump found at $DUMP — skipping restore."
  exit 0
fi

echo "Restoring Nominatim database from $DUMP ..."
pg_restore -U "$POSTGRES_USER" -d nominatim --no-owner --role=nominatim "$DUMP"
