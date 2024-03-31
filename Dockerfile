ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION} as builder

ENV DEBIAN_FRONTEND noninteractive

ADD https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags /usr/local/bin/print-github-tags

RUN set -e \
      && ln -sf bash /bin/sh

RUN set -e \
      && apt-get -y update \
      && apt-get -y upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates curl g++ make \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -eo pipefail \
      && chmod +x /usr/local/bin/print-github-tags \
      && /usr/local/bin/print-github-tags --release --latest --tar ggerganov/llama.cpp \
        | xargs -t curl -sSL -o /tmp/llamacpp.tar.gz \
      && tar xvf /tmp/llamacpp.tar.gz -C /opt --remove-files \
      && mv /opt/llama.cpp-* /opt/llamacpp \
      && cd /opt/llamacpp \
      && make


FROM ubuntu:${UBUNTU_VERSION} as runtime

COPY --from=builder /opt/llamacpp /opt/llamacpp

ENV DEBIAN_FRONTEND noninteractive

RUN set -e \
      && apt-get -y update \
      && apt-get -y upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.utf8

ENTRYPOINT ["/opt/llamacpp/main"]
