FROM haveagitgat/tdarr_node:latest

ARG TDARR_NODE_VERSION

RUN \
mkdir -p /etc/apt/keyrings && \
curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | gpg --dearmor -o /etc/apt/keyrings/jellyfin.gpg && \
export VERSION_OS="$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release )" && \
export VERSION_CODENAME="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )" && \
export DPKG_ARCHITECTURE="$( dpkg --print-architecture )" && \
cat <<EOF | tee /etc/apt/sources.list.d/jellyfin.sources
Types: deb
URIs: https://repo.jellyfin.org/${VERSION_OS}
Suites: ${VERSION_CODENAME}
Components: main
Architectures: ${DPKG_ARCHITECTURE}
Signed-By: /etc/apt/keyrings/jellyfin.gpg
EOF

RUN \
  apt update && apt -y upgrade && apt install -y jellyfin-ffmpeg7 && \
  cp -r /usr/lib/jellyfin-ffmpeg /usr/lib/jellyfin-ffmpeg7
