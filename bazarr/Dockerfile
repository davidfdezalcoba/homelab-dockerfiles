FROM davidfdezalcoba/unrar:latest AS unrar

FROM python:3.12-alpine3.21

# renovate: datasource=github-releases depName=bazarr packageName=morpheus65535/bazarr
ARG BAZARR_VERSION=v1.5.2
LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    cargo \
    libffi-dev \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    curl \
    python3-dev

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    ffmpeg \
    libxml2 \
    libxslt \
    mediainfo \
    python3

RUN \
  echo "**** install bazarr ****" && \
  mkdir -p \
    /app/bazarr/bin && \
  curl --connect-timeout 5 --retry 5 --retry-delay 10 -o \
    /tmp/bazarr.zip -L \
    "https://github.com/morpheus65535/bazarr/releases/download/${BAZARR_VERSION}/bazarr.zip" && \
  unzip \
    /tmp/bazarr.zip -d \
    /app/bazarr/bin && \
  rm -Rf /app/bazarr/bin/bin && \
  curl -o \
    /app/bazarr/bin/postgres-requirements.txt -L \
    "https://raw.githubusercontent.com/morpheus65535/bazarr/${BAZARR_VERSION}/postgres-requirements.txt"

RUN \
  echo "**** Install requirements ****" && \
  python3 -m venv /venv && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir \
    -r /app/bazarr/bin/requirements.txt \
    -r /app/bazarr/bin/postgres-requirements.txt
  
RUN \
  echo "**** clean up ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    $HOME/.cache \
    $HOME/.cargo \
    /tmp/*

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

ENTRYPOINT ["/bin/sh", "-c", "python3 /app/bazarr/bin/bazarr.py --no-update --config /config"]
