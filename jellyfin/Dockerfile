# renovate: datasource=github-releases depName=jellyfin packageName=jellyfin/jellyfin
ARG JELLYFIN_VERSION=10.11.0

FROM ghcr.io/jellyfin/jellyfin:${JELLYFIN_VERSION}

RUN chown -R 1000:1000 /jellyfin/jellyfin-web
