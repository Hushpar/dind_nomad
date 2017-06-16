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
    && mv nomad /usr/bin/nomad \
    && mkdir -pm 0600 /etc/nomad.d \
    && mkdir -pm 0600 /opt/nomad \
    && mkdir -p /opt/nomad/data

ENTRYPOINT ["wrapdocker"]
CMD []
