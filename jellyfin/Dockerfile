ARG JELLYFIN_VERSION=latest

FROM ghcr.io/jellyfin/jellyfin:${JELLYFIN_VERSION}

COPY ./jellyfin-ffmpeg7_7.0.2-7-bookworm_amd64.deb /jellyfin-ffmpeg7_7.0.2-7-bookworm_amd64.deb

RUN apt update && apt -y upgrade
RUN apt install -y /jellyfin-ffmpeg7_7.0.2-7-bookworm_amd64.deb --allow-downgrades
RUN rm -rf /jellyfin-ffmpeg7_7.0.2-7-bookworm_amd64.deb
RUN chown -R 1000:1000 /jellyfin/jellyfin-web
