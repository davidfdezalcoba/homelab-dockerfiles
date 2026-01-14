# renovate: datasource=github-releases depName=wg-easy packageName=wg-easy/wg-easy
ARG WG_EASY_VERSION=15.2.1

FROM ghcr.io/wg-easy/wg-easy:${WG_EASY_VERSION}

RUN ln -sf /usr/sbin/iptables-nft /usr/sbin/iptables
RUN ln -sf /usr/sbin/ip6tables-nft /usr/sbin/ip6tables
