FROM python:3.13-alpine3.21

# renovate: datasource=github-releases depName=yt-dlp packageName=yt-dlp/yt-dlp
ARG SONARR_YT_DLP_VERSION=2025.05.22
LABEL org.opencontainers.image.source="https://github.com/yt-dlp/yt-dlp"

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    bash \
    curl \
    jq \
    ffmpeg \
    coreutils

RUN \
  echo "**** install yt-dlp ****" && \
  curl -L  -o /bin/yt-dlp \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" && \
  chmod a+rx /bin/yt-dlp

COPY --chown=1000:1000 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
