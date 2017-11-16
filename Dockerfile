FROM docker:latest

ENV GLIBC_VERSION=2.25-r0

RUN apk update && apk upgrade && \
    mkdir -p /etc/BUILDS/ && \
    printf "Build of nimmis/alpine-glibc:3.5, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/alpine-glibc && \
    apk add tar curl libstdc++ && \
    curl -L -o glibc-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -L -o glibc-bin-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    apk del curl && \
    rm -fr glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk /var/cache/apk/*

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache curl util-linux

ENV NOMAD_VERSION 0.7.0
ENV NOMAD_SHA256 b3b78dccbdbd54ddc7a5ffdad29bce2d745cac93ea9e45f94e078f57b756f511

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip nomad.zip
RUN echo "${NOMAD_SHA256}  nomad.zip" > nomad.sha256 \
    && sha256sum -c nomad.sha256 \
    && unzip nomad.zip \
    && rm nomad.zip \
    && chmod +x nomad \
    && mv nomad /usr/bin/nomad

ENV CONSUL_VERSION 1.0.0
ENV CONSUL_SHA256 585782e1fb25a2096e1776e2da206866b1d9e1f10b71317e682e03125f22f479

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip consul.zip
RUN echo "${CONSUL_SHA256}  consul.zip" > consul.sha256 \
    && sha256sum -c consul.sha256 \
    && unzip consul.zip \
    && rm consul.zip \
    && chmod +x consul \
    && mv consul /usr/bin/consul

ENV VAULT_VERSION 0.9.0
ENV VAULT_SHA256 801ce0ceaab4d2e59dbb35ea5191cfe8e6f36bb91500e86bec2d154172de59a4

ADD https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip vault.zip
RUN echo "${VAULT_SHA256}  vault.zip" > vault.sha256 \
    && sha256sum -c vault.sha256 \
    && unzip vault.zip \
    && rm vault.zip \
    && chmod +x vault \
    && mv vault /usr/bin/vault

ADD citadel citadel
RUN chmod +x citadel \
    && mv citadel /usr/bin/citadel

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
