FROM alpine:3.22

# renovate: datasource=custom.servarr depName=radarr packageName=radarr versioning=loose
ARG RADARR_VERSION=6.0.4.10291
LABEL org.opencontainers.image.source="https://github.com/Radarr/Radarr"

ENV XDG_CONFIG_HOME="/config/xdg" \
  COMPlus_EnableDiagnostics=0 \
  TMPDIR=/run/radarr-temp

RUN \
  echo "**** install packages ****" && \
  apk add -U --upgrade --no-cache \
    icu-libs \
    sqlite-libs \
    bash \
    curl \
    tzdata \
    coreutils \
    jq \
    xmlstarlet

RUN \
  echo "**** install radarr ****" && \
  mkdir -p /app/radarr/bin && \
  curl -L -o /tmp/radarr.tar.gz \
    "https://radarr.servarr.com/v1/update/master/updatefile?version=${RADARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
  tar xzf \
    /tmp/radarr.tar.gz -C \
    /app/radarr/bin --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /app/radarr/bin/Radarr.Update \
    /tmp/*

ENTRYPOINT ["/bin/sh", "-c", "/app/radarr/bin/Radarr -nobrowser -data=/config"]
