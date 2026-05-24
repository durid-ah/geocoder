#!/bin/bash
set -euo pipefail

# Apply Nominatim tuning on every fresh volume; persisted in $PGDATA/postgresql.conf.
if ! grep -q "nominatim-tuning.conf" "$PGDATA/postgresql.conf"; then
  echo "include_if_exists = '/etc/postgresql/nominatim-tuning.conf'" >> "$PGDATA/postgresql.conf"
fi
