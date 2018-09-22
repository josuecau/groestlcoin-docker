FROM debian:stretch-slim

ARG TZ=Europe/Paris
ARG GRS_USER=grs
ARG GRS_UID=1000
ARG GRS_VERSION=2.16.3
ARG GRS_ARCHIVE=groestlcoin-${GRS_VERSION}-x86_64-linux-gnu.tar.gz
ARG GRS_SUM=f15bd5e38b25a103821f1563cd0e1b2cf7146ec9f9835493a30bd57313d3b86f
ARG GRS_URL=https://github.com/Groestlcoin/groestlcoin/releases/download/v${GRS_VERSION}/${GRS_ARCHIVE}
ARG GRS_BIN=/usr/local/bin

ENV TZ $TZ

RUN useradd -m -u $GRS_UID $GRS_USER \
  && apt-get -qq update \
  && apt-get -qq install wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q ${GRS_URL} \
  && sha256sum ${GRS_ARCHIVE} | grep -q ${GRS_SUM} \
  && tar -zxf ${GRS_ARCHIVE} -C ${GRS_BIN} \
  && chmod -R +x ${GRS_BIN} \
  && rm -f ${GRS_ARCHIVE}

EXPOSE 1331

USER $GRS_USER
WORKDIR /home/$GRS_USER

CMD ["groestlcoind"]
