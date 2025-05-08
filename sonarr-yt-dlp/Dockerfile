FROM python:3.13-alpine3.20

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
  pip install --upgrade --no-cache-dir -U --break-system-packages \
    yt-dlp

COPY --chown=1000:1000 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
