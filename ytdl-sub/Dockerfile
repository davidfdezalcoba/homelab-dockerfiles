FROM ubuntu:noble

# renovate: datasource=github-releases depName=ytdl-sub packageName=jmbannon/ytdl-sub versioning=loose
ARG YTDL_SUB_VERSION=2025.09.24
LABEL org.opencontainers.image.source="https://github.com/jmbannon/ytdl-sub"

# For phantomjs
ENV OPENSSL_CONF="/etc/ssl"
# For downloading thumbnails
ENV SSL_CERT_DIR="/etc/ssl/certs/"

###############################################################################
# YTDL-SUB INSTALL

SHELL ["/bin/bash", "-c"]
RUN mkdir -p /config && \
    chown 1000:1000 /config && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
      software-properties-common && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
      curl \
      vim \
      g++ \
      nano \
      make \
      python3-dev \
      python3-pip \
      fontconfig \
      xz-utils \
      bzip2 \
      aria2 \
      python3-venv

RUN \
  curl -L -o ffmpeg.tar.gz https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz && \
    tar -xf ffmpeg.tar.gz && \
    chmod +x ffmpeg-master-latest-linux64-gpl/bin/ffmpeg && \
    chmod +x ffmpeg-master-latest-linux64-gpl/bin/ffprobe && \
    mv ffmpeg-master-latest-linux64-gpl/bin/ffmpeg /usr/bin/ffmpeg && \
    mv ffmpeg-master-latest-linux64-gpl/bin/ffprobe /usr/bin/ffprobe && \
    rm ffmpeg.tar.gz && \
    rm -rf ffmpeg-master-latest-linux64-gpl/ && \
    ffmpeg -version

# Install phantomjs if using x86_64, ensure it is properly installed
RUN \
  curl -L -o phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -xvf phantomjs.tar.bz2 && \
    mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs && \
    rm -rf phantomjs-2.1.1-linux-x86_64/ && \
    rm phantomjs.tar.bz2 && \
    echo "Phantom JS version:" && \
    phantomjs --version

RUN \
  curl -L -o ytdl-sub https://github.com/jmbannon/ytdl-sub/releases/download/${YTDL_SUB_VERSION}/ytdl-sub && \
    chmod +x ytdl-sub && \
    ./ytdl-sub -h

RUN apt-get remove -y \
      g++ \
      make \
      xz-utils \
      bzip2 \
      python3-dev \
      python3-venv && \
    apt-get autoremove -y && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*
