FROM jpetazzo/dind

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV NOMAD_VERSION 0.5.6
ENV NOMAD_SHA256 3f5210f0bcddf04e2cc04b14a866df1614b71028863fe17bcdc8585488f8cb0c

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

ADD ./citadel /usr/bin/citadel
RUN chmod +x /usr/bin/citadel

ENTRYPOINT ["wrapdocker"]
CMD []
