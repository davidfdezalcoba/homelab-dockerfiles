FROM alpine:3.20

ARG JACKETT_VERSION

# environment settings
ENV XDG_DATA_HOME="/config" \
  XDG_CONFIG_HOME="/config" \
  TMPDIR=/run/jackett-temp

RUN \
  echo "**** install packages ****" && \
  apk --no-cache add \
    icu-data-full \
    curl \
    jq \
    icu-libs

RUN \
  echo "**** install jackett ****" && \
  mkdir -p \
    /app/Jackett && \
  if [ -z ${JACKETT_VERSION+x} ]; then \
    JACKETT_VERSION=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  curl -o \
    /tmp/jacket.tar.gz -L \
    "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxMuslAMDx64.tar.gz" && \
  tar xf \
    /tmp/jacket.tar.gz -C \
    /app/Jackett --strip-components=1
  # echo "**** fix for host id mapping error ****" && \
  # chown -R root:root /app/Jackett && \

RUN \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

RUN \
  mkdir -p /run/jackett-temp && \
  chown 1000:1000 -R /app/Jackett && \
  chown 1000:1000 -R /run/jackett-temp

ENTRYPOINT ["/bin/sh", "-c", "/app/Jackett/jackett --NoUpdates"]
