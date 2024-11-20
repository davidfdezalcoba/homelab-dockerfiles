FROM alpine:3.20

ARG RADARR_VERSION

ARG RADARR_BRANCH="master"
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
  if [ -z ${RADARR_VERSION+x} ]; then \
    RADARR_VERSION=$(curl -sL "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/changes?runtime=netcore&os=linuxmusl" \
    | jq -r '.[0].version'); \
  fi && \
  curl -o \
    /tmp/radarr.tar.gz -L \
    "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/updatefile?version=${RADARR_VERSION}&os=linuxmusl&runtime=netcore&arch=x64" && \
  tar xzf \
    /tmp/radarr.tar.gz -C \
    /app/radarr/bin --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /app/radarr/bin/Radarr.Update \
    /tmp/*

ENTRYPOINT ["/bin/sh", "-c", "/app/radarr/bin/Radarr -nobrowser -data=/config"]
