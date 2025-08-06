# renovate: datasource=gitea-releases depName=forgejo-runner packageName=forgejo/runner registryUrl=https://code.forgejo.org
ARG FORGEJO_RUNNER_VERSION=9.0.3
FROM code.forgejo.org/forgejo/runner:${FORGEJO_RUNNER_VERSION}

LABEL org.opencontainers.image.source="https://code.forgejo.org/forgejo/runner"

USER 0:0

RUN apk add --no-cache \
      nodejs \
      npm \
      docker-cli

RUN node -v

USER 1000
