# renovate: datasource=github-releases depName=recyclarr packageName=recyclarr/recyclarr
ARG RECYCLARR_VERSION=v7.4.1

FROM ghcr.io/recyclarr/recyclarr:${RECYCLARR_VERSION}

USER 0:0

RUN apk add curl jq

USER 1000:1000
