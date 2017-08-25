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

ENV NOMAD_VERSION 0.6.0
ENV NOMAD_SHA256 fcf108046164cfeda84eab1c3047e36ad59d239b66e6b2f013e6c93064bc6313

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip nomad.zip
RUN echo "${NOMAD_SHA256}  nomad.zip" > nomad.sha256 \
    && sha256sum -c nomad.sha256 \
    && unzip nomad.zip \
    && rm nomad.zip \
    && chmod +x nomad \
    && mv nomad /usr/bin/nomad

ENV CONSUL_VERSION 0.9.2
ENV CONSUL_SHA256 0a2921fc7ca7e4702ef659996476310879e50aeeecb5a205adfdbe7bd8524013

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip consul.zip
RUN echo "${CONSUL_SHA256}  consul.zip" > consul.sha256 \
    && sha256sum -c consul.sha256 \
    && unzip consul.zip \
    && rm consul.zip \
    && chmod +x consul \
    && mv consul /usr/bin/consul

ENV VAULT_VERSION 0.8.1
ENV VAULT_SHA256 3c4d70ba71619a43229e65c67830e30e050eab7a81ac6b28325ff707e5914188

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

ENV SNOWBOARD_VERSION 0.6.7
RUN curl -o snowboard.tar.gz -SL https://github.com/bukalapak/snowboard/releases/download/v${SNOWBOARD_VERSION}/snowboard-v${SNOWBOARD_VERSION}.linux-amd64.tar.gz \
    && tar -xzf snowboard.tar.gz \ 
    && chmod +x snowboard \
    && mv snowboard /usr/bin/snowboard

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
