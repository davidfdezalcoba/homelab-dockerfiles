FROM alpine:3.22

# renovate: datasource=github-releases depName=jackett packageName=Jackett/Jackett
ARG JACKETT_VERSION=v0.22.2196
LABEL org.opencontainers.image.source="https://github.com/Jackett/Jackett"

# environment settings
ENV XDG_DATA_HOME="/config" \
  XDG_CONFIG_HOME="/config" \
  TMPDIR=/run/jackett-temp

RUN \
  echo "**** install packages ****" && \
  apk --no-cache add \
    icu-data-full \
    curl \
    icu-libs

RUN \
  echo "**** install jackett ****" && \
  mkdir -p \
    /app/Jackett && \
  curl -v --connect-timeout 5 --retry 5 --retry-delay 1 -o \
    /tmp/jacket.tar.gz -L \
    "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxMuslAMDx64.tar.gz" && \
  tar xf \
    /tmp/jacket.tar.gz -C \
    /app/Jackett --strip-components=1

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

RUN \
  mkdir -p /run/jackett-temp && \
  chown 1000:1000 -R /app/Jackett && \
  chown 1000:1000 -R /run/jackett-temp

ENTRYPOINT ["/bin/sh", "-c", "/app/Jackett/jackett --NoUpdates"]
