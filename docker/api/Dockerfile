ARG NOMINATIM_VERSION=5.3

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV PROJECT_DIR=/nominatim

WORKDIR /nominatim

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-icu \
        libicu-dev \
        pkg-config \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

ARG NOMINATIM_VERSION
RUN pip install --no-cache-dir --break-system-packages \
    "nominatim-api==${NOMINATIM_VERSION}" \
    falcon \
    psycopg[binary] \
    "gunicorn>=25.0"

EXPOSE 8080

# HTTP directly (no --protocol uwsgi; that is only for nginx uwsgi_pass)
CMD ["gunicorn", "-b", "0.0.0.0:8080", "-w", "2", \
     "--worker-class", "asgi", \
     "--worker-connections", "1000", \
     "nominatim_api.server.falcon.server:run_wsgi()"]
