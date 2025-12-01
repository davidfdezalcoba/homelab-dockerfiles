# renovate: datasource=github-releases depName=recyclarr packageName=recyclarr/recyclarr
ARG RECYCLARR_VERSION=7.5.2

FROM ghcr.io/recyclarr/recyclarr:${RECYCLARR_VERSION}

LABEL org.opencontainers.image.source="https://github.com/recyclarr/recyclarr"

USER 0:0

RUN apk add curl jq

USER 1000:1000
