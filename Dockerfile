FROM ubuntu:14.04
MAINTAINER Nicolas Pouillard [https://nicolaspouillard.fr]

RUN apt-get update && \
    apt-get install -y aria2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://bitcoin.org/bin/bitcoin-core-0.10.0/bitcoin-0.10.0-linux64.tar.gz
RUN echo '1443d9ea1d21c5999543112c2081316713854f99199e0a61c867b18dd61727c8  bitcoin-0.10.0-linux64.tar.gz' | sha256sum -c
ADD tar -C /usr/local/ --strip-components=1 -xzf bitcoin-0.10.0-linux64.tar.gz

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

EXPOSE 8332 8333 6881 6882

WORKDIR /bitcoin

CMD ["btc_oneshot"]

