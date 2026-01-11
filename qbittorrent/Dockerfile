FROM alpine:edge

# renovate: datasource=repology depName=alpine_edge/qbittorrent-nox packageName=alpine_edge/qbittorrent-nox versioning=loose
ARG QBITTORRENT_VERSION=5.1.0-r0
# renovate: datasource=github-releases depName=qbittorrent-cli packageName=fedarovich/qbittorrent-cli versioning=loose
ARG QBT_CLI_VERSION=v1.8.24285.1

ENV HOME="/config"
ENV XDG_CONFIG_HOME="/config"
ENV XDG_DATA_HOME="/config"
ENV WEBUI_PORT=8080
ENV TORRENTING_PORT_ARG=6881

# install runtime packages and qbitorrent-cli
RUN \
  echo "**** install packages ****" && \
  apk update --no-cache && \
  apk add --no-cache \
    jq \
    curl \
    grep \
    icu-libs \
    p7zip \
    python3 \
    qt6-qtbase-sqlite

RUN \
  echo "**** install qbittorrent-nox ****" && \
  apk add -U --upgrade --no-cache \
    qbittorrent-nox==${QBITTORRENT_VERSION}

RUN \
  echo "***** install qbitorrent-cli ****" && \
  mkdir /qbt && \
  curl -L -o /tmp/qbt.tar.gz \
    "https://github.com/fedarovich/qbittorrent-cli/releases/download/${QBT_CLI_VERSION}/qbt-linux-alpine-x64-net6-${QBT_CLI_VERSION#v}.tar.gz" && \
  tar xf \
    /tmp/qbt.tar.gz -C \
    /qbt

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /root/.cache \
    /tmp/*

COPY --from=ghcr.io/linuxserver/unrar:7.1.10 /usr/bin/unrar-alpine /usr/bin/unrar

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/qbittorrent-nox --webui-port=${WEBUI_PORT} ${TORRENTING_PORT_ARG}"]
