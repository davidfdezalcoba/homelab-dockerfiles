FROM alpine AS alpine-build

ARG UNRAR_VERSION=7.0.9

COPY data.rar /data.rar

RUN \
  echo "**** install build dependencies ****" && \
  apk add --no-cache --virtual=build-dependencies \
    curl \
    build-base && \
  echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o \
    /tmp/unrar.tar.gz -L \
    "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \
  tar xf \
    /tmp/unrar.tar.gz -C \
    /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  sed -i 's|LDFLAGS=-pthread|LDFLAGS=-pthread -static|' makefile && \
  sed -i 's|CXXFLAGS=-march=native |CXXFLAGS=|' makefile && \
  make && \
  install -v -m755 unrar /usr/bin && \
  echo "**** test binary ****" && \
  /usr/bin/unrar v /data.rar && \
  /usr/bin/unrar t /data.rar && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.cache \
    /tmp/*

FROM scratch

# Add files from buildstage
COPY --from=alpine-build /usr/bin/unrar /usr/bin/unrar-alpine
