# The MIT License
#
# Copyright (c) 2020, Serhiy Makarenko

FROM alpine:3.9
LABEL maintainer="serhiy.makarenko@me.com"

ENV TELEGRAF_VERSION=1.13.4

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
RUN HOST_ARCH="$(uname -m)" && \
    case "${HOST_ARCH##*-}" in \
      x86_64)  PKG_ARCH='amd64';; \
      armv7l)  PKG_ARCH='armhf';; \
      aarch64) PKG_ARCH='arm64';; \
      *)       echo "Unsupported architecture: ${HOST_ARCH}"; exit 1;; \
    esac && \
    if [ "$PKG_ARCH" = "amd64" ] ; then \
      apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata smartmontools sudo ; \
    elif [ "$PKG_ARCH" = "armhf" ] || [ "$PKG_ARCH" = "arm64" ] ; then \
      apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata raspberrypi; \
    fi && \
    update-ca-certificates && \
    set -ex && \
    apk add --no-cache --virtual .build-deps wget gnupg tar && \
    for key in \
        05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
    do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_linux_${PKG_ARCH}.tar.gz.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_linux_${PKG_ARCH}.tar.gz && \
    gpg --batch --verify telegraf-${TELEGRAF_VERSION}_linux_${PKG_ARCH}.tar.gz.asc telegraf-${TELEGRAF_VERSION}_linux_${PKG_ARCH}.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}_linux_${PKG_ARCH}.tar.gz && \
    mv /usr/src/telegraf/etc/telegraf/telegraf.conf /etc/telegraf/ && \
    mv /usr/src/telegraf/usr/bin/telegraf /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
    apk del .build-deps

EXPOSE 8125/udp 8092/udp 8094

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
