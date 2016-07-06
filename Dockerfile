FROM debian:jessie

ENV OPENVAS_LIBRARIES_VERSION=8.0.7 \
  OPENVAS_MANAGER_VERSION=6.0.8

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends --fix-missing \
  pkg-config libssh-dev libgnutls28-dev libglib2.0-dev libpcap-dev \
  libgpgme11-dev uuid-dev bison libksba-dev libhiredis-dev libsnmp-dev
RUN apt-get install -y --no-install-recommends --fix-missing \
  wget cmake build-essential libgcrypt-dev libldap2-dev doxygen \
  libsqlite3-dev && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /openvas-src && \

    cd /openvas-src && \
    wget -nv http://wald.intevation.org/frs/download.php/2291/openvas-libraries-${OPENVAS_LIBRARIES_VERSION}.tar.gz && \
    tar zxvf openvas-libraries-${OPENVAS_LIBRARIES_VERSION}.tar.gz && \
    cd /openvas-src/openvas-libraries-${OPENVAS_LIBRARIES_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc) && \
    make install && \
    make rebuild_cache && \

    cd /openvas-src && \
    wget -nv http://wald.intevation.org/frs/download.php/2295/openvas-manager-${OPENVAS_MANAGER_VERSION}.tar.gz && \
    tar zxvf openvas-manager-${OPENVAS_MANAGER_VERSION}.tar.gz && \
    cd /openvas-src/openvas-manager-${OPENVAS_MANAGER_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc) && \
    make install && \
    make rebuild_cache && \

    ldconfig

EXPOSE 9390

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "--help" ]
