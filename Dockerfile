FROM debian:stretch-slim

ARG TZ=Europe/Paris
ARG GRS_USER=grs
ARG GRS_UID=1000

ENV TZ $TZ

RUN useradd -m -u $GRS_UID $GRS_USER \
  && apt-get -qq update \
  && apt-get -qq install \
    autoconf automake bsdmainutils build-essential g++ gcc git \
    libboost-all-dev libdb5.3 libdb5.3++-dev libdb5.3-dev libevent-dev \
    libssl1.0-dev libtool make pkg-config \
  && apt-get -qq clean \
  && apt-get -qq autoclean \
  && apt-get -qq autoremove \
  && git clone --depth=1 \
    https://github.com/Groestlcoin/groestlcoin.git /tmp/groestlcoin

WORKDIR /tmp/groestlcoin

RUN ./autogen.sh \
    && ./configure \
    && make \
    && make install

WORKDIR /

RUN rm -rf /tmp/groestlcoin

EXPOSE 1331

USER $GRS_USER
WORKDIR /home/$GRS_USER

CMD ["groestlcoind"]
