FROM ubuntu:14.04
MAINTAINER Nicolas Pouillard [https://nicolaspouillard.fr]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://bitcoin.org/bin/bitcoin-core-0.12.1/bitcoin-0.12.1-linux64.tar.gz bitcoin-0.12.1-linux64.tar.gz
RUN echo '54aca14b7512801ab78cc93f8576e1b66364a890e8017e8a187e4bf0209fd28c  bitcoin-0.12.1-linux64.tar.gz' | sha256sum -c
RUN tar -C /usr/local/ --strip-components=1 -xzf bitcoin-0.12.1-linux64.tar.gz

ENV HOME /bitcoin
RUN useradd -s /bin/bash -m -d /bitcoin bitcoin
RUN chown bitcoin:bitcoin -R /bitcoin

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER bitcoin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoin

CMD ["btc_oneshot"]

