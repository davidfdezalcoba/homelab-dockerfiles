FROM davidfdezalcoba/unrar:latest AS unrar

FROM alpine:edge

ARG QBITTORRENT_VERSION
ARG QBT_CLI_VERSION

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
  if [ -z ${QBITTORRENT_VERSION+x} ]; then \
    QBITTORRENT_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:qbittorrent-nox$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  echo ${QBITTORRENT_VERSION} && \
  apk add -U --upgrade --no-cache \
    qbittorrent-nox==${QBITTORRENT_VERSION}

RUN \
  echo "***** install qbitorrent-cli ****" && \
  mkdir /qbt && \
  if [ -z ${QBT_CLI_VERSION+x} ]; then \
    QBT_CLI_VERSION=$(curl -sL "https://api.github.com/repos/fedarovich/qbittorrent-cli/releases/latest" \
    | jq -r '. | .tag_name'); \
  fi && \
  curl -o \
    /tmp/qbt.tar.gz -L \
    "https://github.com/fedarovich/qbittorrent-cli/releases/download/${QBT_CLI_VERSION}/qbt-linux-alpine-x64-net6-${QBT_CLI_VERSION#v}.tar.gz" && \
  tar xf \
    /tmp/qbt.tar.gz -C \
    /qbt

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /root/.cache \
    /tmp/*

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/qbittorrent-nox --webui-port=${WEBUI_PORT} ${TORRENTING_PORT_ARG}"]

