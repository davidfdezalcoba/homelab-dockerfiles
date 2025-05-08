# syntax=docker/dockerfile:1

FROM alpine:3.20

# renovate: datasource=github-releases depName=sonarr packageName=Sonarr/Sonarr versioning=loose
ARG SONARR_VERSION=4.0.14.2939

ENV XDG_CONFIG_HOME="/config/xdg" \
  SONARR_CHANNEL="v4-stable" \
  SONARR_BRANCH="main" \
  COMPlus_EnableDiagnostics=0 \
  TMPDIR=/run/sonarr-temp

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    icu-libs \
    sqlite-libs \
    bash \
    curl \
    tzdata \
    coreutils \
    jq \
    xmlstarlet

RUN \
  echo "**** install sonarr ****" && \
  mkdir -p /app/sonarr/bin ${TMPDIR} && \
  chown 1000:1000 ${TMPDIR} && \
  curl -o \
    /tmp/sonarr.tar.gz -L \
    "https://services.sonarr.tv/v1/update/${SONARR_BRANCH}/download?version=${SONARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
  tar xzf \
    /tmp/sonarr.tar.gz -C \
    /app/sonarr/bin --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /app/sonarr/bin/Sonarr.Update \
    /tmp/*

ENTRYPOINT ["/bin/sh", "-c", "/app/sonarr/bin/Sonarr -nobrowser -data=/config"]
