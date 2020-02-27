# The MIT License
#
# Copyright (c) 2020, Serhiy Makarenko

FROM telegraf:1.13.4
LABEL maintainer="serhiy.makarenko@me.com"

ARG DEBIAN_FRONTEND=noninteractive

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
      amd64) ARCH='amd64';; \
      armhf) ARCH='armhf';; \
      armel) ARCH='armel';; \
      *)     echo "Unsupported architecture: ${dpkgArch}"; exit 1;; \
    esac && \
    if [ "$ARCH" = "amd64" ] ; then apt-get update && apt-get install -y --no-install-recommends --no-install-suggests smartmontools ; fi && \
    if [ "$ARCH" = "armhf" ] || [ "$ARCH" = "armel" ]; then \
    curl -1sLf 'http://raspbian.raspberrypi.org/raspbian.public.key' | apt-key add - && \
    echo 'deb http://raspbian.raspberrypi.org/raspbian/ stretch main firmware contrib non-free rpi' > /etc/apt/sources.list.d/rpi.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests libraspberrypi-bin && \
    rm -rf /var/lib/apt/lists/* ; fi
