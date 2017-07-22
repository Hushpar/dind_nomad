FROM docker:latest

ENV GLIBC_VERSION=2.25-r0

RUN apk update && apk upgrade && \
    mkdir -p /etc/BUILDS/ && \
    printf "Build of nimmis/alpine-glibc:3.5, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/alpine-glibc && \
    apk add curl && \
    curl -L -o glibc-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -L -o glibc-bin-${GLIBC_VERSION}.apk \
      "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
    apk del curl && \
    rm -fr glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk /var/cache/apk/*

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache curl util-linux

ENV NOMAD_VERSION 0.5.6
ENV NOMAD_SHA256 3f5210f0bcddf04e2cc04b14a866df1614b71028863fe17bcdc8585488f8cb0c

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip /tmp/nomad.zip
RUN echo "${NOMAD_SHA256}  /tmp/nomad.zip" > /tmp/nomad.sha256 \
  && sha256sum -c /tmp/nomad.sha256 \
  && cd /bin \
  && unzip /tmp/nomad.zip \
  && chmod +x /bin/nomad \
  && rm /tmp/nomad.zip

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip nomad.zip
RUN echo "${NOMAD_SHA256}  nomad.zip" > nomad.sha256 \
    && sha256sum -c nomad.sha256 \
    && unzip nomad.zip \
    && rm nomad.zip \
    && chmod +x nomad \
    && mv nomad /usr/bin/nomad

ENV CONSUL_VERSION 0.8.5
ENV CONSUL_SHA256 35dc317c80862c306ea5b1d9bc93709483287f992fd0797d214d1cc1848e7b62

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip consul.zip
RUN echo "${CONSUL_SHA256}  consul.zip" > consul.sha256 \
    && sha256sum -c consul.sha256 \
    && unzip consul.zip \
    && rm consul.zip \
    && chmod +x consul \
    && mv consul /usr/bin/consul

ENV VAULT_VERSION 0.7.3
ENV VAULT_SHA256 2822164d5dd347debae8b3370f73f9564a037fc18e9adcabca5907201e5aab45

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
