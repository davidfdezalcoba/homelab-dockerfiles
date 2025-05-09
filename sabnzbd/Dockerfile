FROM davidfdezalcoba/unrar:latest AS unrar
FROM python:alpine

# renovate: datasource=github-releases depName=sabnzbd packageName=sabnzbd/sabnzbd
ARG SABNZBD_VERSION=4.5.1
LABEL org.opencontainers.image.source="https://github.com/sabnzbd/sabnzbd"

# environment settings
ENV HOME="/config" \
  PYTHONIOENCODING=utf-8

RUN \
  echo "**** install packages ****" && \
  apk add -U --update --no-cache --virtual=build-dependencies \
    autoconf \
    automake \
    build-base \
    libffi-dev \
    openssl-dev \
    curl \
    python3-dev && \
  apk add  -U --update --no-cache \
    7zip \
    python3

RUN \
  echo "**** install sabnzbd ****" && \
  mkdir -p /app/sabnzbd && \
  curl -o \
    /tmp/sabnzbd.tar.gz -L \
    "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" && \
  tar xf \
    /tmp/sabnzbd.tar.gz -C \
    /app/sabnzbd --strip-components=1 && \
  cd /app/sabnzbd && \
  python3 -m venv /venv && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir -r requirements.txt && \
  echo "**** build sab translations ****" && \
  python3 tools/make_mo.py && \
  echo "**** install par2cmdline-turbo from source ****" && \
  PAR2_VERSION=$(curl -s https://api.github.com/repos/animetosho/par2cmdline-turbo/releases/latest \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  mkdir /tmp/par2cmdline && \
  curl -o \
    /tmp/par2cmdline.tar.gz -L \
    "https://github.com/animetosho/par2cmdline-turbo/archive/${PAR2_VERSION}.tar.gz" && \
  tar xf \
    /tmp/par2cmdline.tar.gz -C \
    /tmp/par2cmdline --strip-components=1 && \
  cd /tmp/par2cmdline && \
  ./automake.sh && \
  ./configure && \
  make && \
  make check && \
  make install

RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

WORKDIR /app/sabnzbd

ENTRYPOINT ["python3", "-OO", "SABnzbd.py", "--config-file", "/config", "--server", "0.0.0.0:8080"]

# ports and volumes
EXPOSE 8080
VOLUME /config
