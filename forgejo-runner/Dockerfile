# renovate: datasource=gitea-releases depName=forgejo-runner packageName=forgejo/runner registryUrl=https://code.forgejo.org
ARG FORGEJO_RUNNER_VERSION=12.7.0
FROM code.forgejo.org/forgejo/runner:${FORGEJO_RUNNER_VERSION}

# renovate: datasource=gitea-releases depName=tea packageName=gitea/tea registryUrl=https://gitea.com
ARG TEA_VERSION=0.11.1

LABEL org.opencontainers.image.source="https://code.forgejo.org/forgejo/runner"

USER 0:0

RUN apk add --no-cache \
      nodejs \
      jq \
      curl \
      npm \
      docker-cli

RUN \
  echo "**** install tea ****" && \
  echo "https://dl.gitea.com/tea/${TEA_VERSION}/tea-${TEA_VERSION}-linux-amd64" && \
  curl -sL -o /usr/local/bin/tea \
    "https://dl.gitea.com/tea/${TEA_VERSION}/tea-${TEA_VERSION}-linux-amd64" && \
  chmod +x /usr/local/bin/tea

RUN node -v

USER 1000
