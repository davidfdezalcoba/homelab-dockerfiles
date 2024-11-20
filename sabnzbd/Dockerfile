FROM python:alpine

# environment settings
ENV HOME="/config" \
  PYTHONIOENCODING=utf-8

ARG SABNZBD_VERSION
ARG UNRAR_VERSION=7.0.9

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
  if [ -z ${SABNZBD_VERSION+x} ]; then \
    SABNZBD_VERSION=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /app/sabnzbd && \
  curl -o \
    /tmp/sabnzbd.tar.gz -L \
    "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" && \
  tar xf \
    /tmp/sabnzbd.tar.gz -C \
    /app/sabnzbd --strip-components=1 && \
  cd /app/sabnzbd && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.20/ -r requirements.txt && \
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

COPY ./data.rar /data.rar

RUN \
  echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o \
    /tmp/unrar.tar.gz -L \
    "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \
  tar xf \
    /tmp/unrar.tar.gz -C \
    /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  sed -i 's|LDFLAGS=-pthread|LDFLAGS=-pthread -static|' makefile && \
  sed -i 's|CXXFLAGS=-march=native |CXXFLAGS=|' makefile && \
  make && \
  install -v -m755 unrar /usr/bin && \
  echo "**** test binary ****" && \
  /usr/bin/unrar v /data.rar && \
  /usr/bin/unrar t /data.rar

RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

WORKDIR /app/sabnzbd

ENTRYPOINT ["python3", "-OO", "SABnzbd.py", "--config-file", "/config", "--server", "0.0.0.0:8080"]

# ports and volumes
EXPOSE 8080
VOLUME /config
