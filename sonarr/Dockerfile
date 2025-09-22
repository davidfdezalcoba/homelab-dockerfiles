FROM alpine:3.22

# renovate: datasource=custom.sonarr depName=sonarr packageName=sonarr versioning=loose
ARG SONARR_VERSION=4.0.15.2941
LABEL org.opencontainers.image.source="https://github.com/Sonarr/Sonarr"

ENV XDG_CONFIG_HOME="/config/xdg" \
  SONARR_CHANNEL="v4-stable" \
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
  curl -L -o /tmp/sonarr.tar.gz \
    "https://services.sonarr.tv/v1/update/main/download?version=${SONARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
  tar xzf \
    /tmp/sonarr.tar.gz -C \
    /app/sonarr/bin --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /app/sonarr/bin/Sonarr.Update \
    /tmp/*

ENTRYPOINT ["/bin/sh", "-c", "/app/sonarr/bin/Sonarr -nobrowser -data=/config"]
