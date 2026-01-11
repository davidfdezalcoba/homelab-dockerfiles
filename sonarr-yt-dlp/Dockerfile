FROM python:3.13-alpine3.20

# renovate: datasource=github-tags depName=yt-dlp packageName=yt-dlp/yt-dlp versioning=loose
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
    "https://github.com/yt-dlp/yt-dlp/releases/download/${SONARR_YT_DLP_VERSION}/yt-dlp" && \
  chmod a+rx /bin/yt-dlp

COPY --chown=1000:1000 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
