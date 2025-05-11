FROM alpine:3.21

# renovate: datasource=github-releases depName=prowlarr packageName=Prowlarr/Prowlarr versioning=loose
ARG PROWLARR_VERSION=1.35.1.5034
LABEL org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr"

# environment settings
ENV XDG_CONFIG_HOME="/config/xdg" \
  COMPlus_EnableDiagnostics=0 \
  TMPDIR=/run/prowlarr-temp

RUN \
  echo "**** install packages ****" && \
  apk add -U --upgrade --no-cache \
    icu-libs \
    sqlite-libs \
    curl \
    xmlstarlet

RUN \
  echo "**** install prowlarr ****" && \
  mkdir -p /app/prowlarr/bin && \
  curl -v --connect-timeout 5 --retry 5 --retry-delay 1 -o \
    /tmp/prowlarr.tar.gz -L \
    "https://prowlarr.servarr.com/v1/update/master/updatefile?version=${PROWLARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
  tar xzf \
    /tmp/prowlarr.tar.gz -C \
    /app/prowlarr/bin --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /app/prowlarr/bin/Prowlarr.Update \
    /tmp/* \
    /var/tmp/*

ENTRYPOINT ["/bin/sh", "-c", "/app/prowlarr/bin/Prowlarr -nobrowser -data=/config"]
