FROM python:3.13-alpine3.21

# renovate: datasource=github-releases depName=bazarr packageName=morpheus65535/bazarr
ARG BAZARR_VERSION=v1.5.3
LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    cargo \
    libffi-dev \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    curl

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
  curl -v --connect-timeout 5 --retry 5 --retry-delay 1 -o \
    /tmp/bazarr.zip -L \
    "https://github.com/morpheus65535/bazarr/releases/download/${BAZARR_VERSION}/bazarr.zip" && \
  unzip \
    /tmp/bazarr.zip -d \
    /app/bazarr/bin && \
  rm -Rf /app/bazarr/bin/bin
  # curl -v --connect-timeout 5 --retry 5 --retry-delay 1 -o \
  #   /app/bazarr/bin/postgres-requirements.txt -L \
  #   "https://raw.githubusercontent.com/morpheus65535/bazarr/${BAZARR_VERSION}/postgres-requirements.txt"

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

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

ENTRYPOINT ["/bin/sh", "-c", "python3 /app/bazarr/bin/bazarr.py --no-update --config /config"]
