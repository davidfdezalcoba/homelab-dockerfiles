FROM alpine:3.20

# renovate: datasource=github-releases depName=prowlarr packageName=Prowlarr/Prowlarr
ARG PROWLARR_VERSION=1.32.2.4987

# environment settings
ARG PROWLARR_BRANCH="master"
ENV XDG_CONFIG_HOME="/config/xdg" \
  COMPlus_EnableDiagnostics=0 \
  TMPDIR=/run/prowlarr-temp

RUN \
  echo "**** install packages ****" && \
  apk add -U --upgrade --no-cache \
    icu-libs \
    sqlite-libs \
    curl \
    jq \
    xmlstarlet

RUN \
  echo "**** install prowlarr ****" && \
  mkdir -p /app/prowlarr/bin && \
  if [ -z ${PROWLARR_VERSION+x} ]; then \
    PROWLARR_VERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/changes?runtime=netcore&os=linuxmusl" \
    | jq -r '.[0].version'); \
  fi && \
  curl -o \
    /tmp/prowlarr.tar.gz -L \
    "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/updatefile?version=${PROWLARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
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
