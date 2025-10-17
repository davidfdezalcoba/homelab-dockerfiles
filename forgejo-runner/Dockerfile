# renovate: datasource=gitea-releases depName=forgejo-runner packageName=forgejo/runner registryUrl=https://code.forgejo.org
ARG FORGEJO_RUNNER_VERSION=11.1.2

# renovate: datasource=gitea-releases depName=tea packageName=gitea/tea registryUrl=https://gitea.com
ARG TEA_VERSION=0.10.1

FROM code.forgejo.org/forgejo/runner:${FORGEJO_RUNNER_VERSION}

LABEL org.opencontainers.image.source="https://code.forgejo.org/forgejo/runner"

USER 0:0

RUN apk add --no-cache \
      nodejs \
      jq \
      curl \
      npm \
      docker-cli

RUN \
  curl -sL https://dl.gitea.io/tea/${TEA_VERSION}/tea-${TEA_VERSION}-linux-amd64 -o /usr/local/bin/tea && \
  chmod +x /usr/local/bin/tea

RUN node -v

USER 1000
