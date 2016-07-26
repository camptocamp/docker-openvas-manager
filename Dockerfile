FROM debian:jessie

ENV OPENVAS_LIBRARIES_VERSION=8.0.7 \
  OPENVAS_SCANNER_VERSION=5.0.5 \
  OPENVAS_MANAGER_VERSION=6.0.8

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends --fix-missing \
  pkg-config libssh-dev libgnutls28-dev libglib2.0-dev libpcap-dev \
  libgpgme11-dev uuid-dev bison libksba-dev libhiredis-dev libsnmp-dev \
  rsync wget cmake build-essential libgcrypt-dev libldap2-dev doxygen \
  libsqlite3-dev sqlite3 xsltproc && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /openvas-src && \

    # Building openvas-libraries
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

    # Building openvas-scanner
    cd /openvas-src && \
    wget -nv http://wald.intevation.org/frs/download.php/2266/openvas-scanner-${OPENVAS_SCANNER_VERSION}.tar.gz && \
    tar zxvf openvas-scanner-${OPENVAS_SCANNER_VERSION}.tar.gz && \
    cd /openvas-src/openvas-scanner-${OPENVAS_SCANNER_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc) && \
    make install && \
    make rebuild_cache && \

    # Building openvas-manager
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

RUN ln -sf /proc/1/fd/1 /usr/local/var/log/openvas/openvasmd.log

EXPOSE 9390

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "--help" ]
