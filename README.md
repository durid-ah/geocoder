# geocoder

Two-container [Nominatim](https://nominatim.org/) setup. Split up the project into two containers one for PostgreSQL/PostGIS (`db`) and the other Python API (`api`).

> [!WARNING]
> Setting up the project into separate images is the result of some research and and an attempt to customize the exisitng images to meet my personal needs, BUT, the implemantation was done with the help of AI so proceed at your own risk
  
## Prerequisites

- Docker with Compose v2
- `nominatim.dump` at repo root (custom-format `pg_restore` archive), or set `NOMINATIM_DUMP` to its path. If you are not restoring yet, comment out the dump volume in `docker-compose.yml` (Compose requires the bind-mount path to exist).
- `project/.env` with `NOMINATIM_DATABASE_DSN` (see `project/.env.example`)

Copy root env defaults:

```bash
cp .env.example .env
cp project/.env.example project/.env
```

Passwords in `.env`, `project/.env`, and `docker-compose.yml` substitution must match (`NOMINATIM_PASSWORD`).

## Build and run

```bash
./scripts/geocoder-build.sh
./scripts/geocoder-run.sh
```

Detached:

```bash
./scripts/geocoder-run.sh -d
```

First start initializes Postgres, applies [postgres tuning](docker/db/conf.d/postgres-tuning.conf), and restores the dump when present. Restore can take a long time for large dumps.

API: http://localhost:8091

## Verify

After `db` finishes init/restore:

```bash
# Postgres tuning is active
docker compose exec db psql -U postgres -c "SHOW shared_buffers;"
docker compose exec db psql -U postgres -c "SHOW work_mem;"

# API health
curl -s http://localhost:8091/status

# Sample search
curl -s 'http://localhost:8091/search?q=Richmond&format=json' | head
```

Expected: `shared_buffers` is `2GB`, `work_mem` is `50MB`, `/status` returns OK.

## Layout

| Path | Role |
|------|------|
| `docker/db/` | PostGIS 16 image, init scripts, `postgres-tuning.conf` |
| `docker/api/` | `nominatim-api` + gunicorn ASGI on port 8080 |
| `project/.env` | Nominatim project config (mounted read-only into API) |
| `docker-compose.yml` | Orchestrates `db` + `api` |

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_PASSWORD` | `postgres` | Postgres superuser password |
| `NOMINATIM_PASSWORD` | `nominatim` | Nominatim DB role password |
| `NOMINATIM_VERSION` | `5.3` | `nominatim-api` pip version (must match dump) |
| `NOMINATIM_DUMP` | `./nominatim.dump` | Path to dump file mounted for first-time restore |
