#!/bin/sh -e

apk upgrade --no-cache --no-progress
apk add --no-cache --no-progress \
    autoconf \
    automake \
    binutils-gold \
    bzip2 \
    ca-certificates \
    coreutils \
    file \
    findutils \
    g++ \
    gawk \
    gcc \
    ghc \
    git \
    gmp-dev \
    gzip \
    libffi-dev \
    make \
    musl-dev \
    ncurses-dev \
    openssh \
    patch \
    perl \
    py3-sphinx \
    sed \
    tar \
    zlib-dev

# chown stack /tmp/bootstrap.sh \
#       /tmp/build.mk /tmp/config.yaml \
#       /tmp/stack-1.6.5-linux-x86_64-static.tar.gz

# su -s /bin/sh stack /tmp/bootstrap.sh
/tmp/bootstrap.sh

apk del \
    autoconf \
    automake \
    binutils-gold \
    bzip2 \
    coreutils \
    file \
    findutils \
    g++ \
    gawk \
    ghc \
    gmp-dev \
    make \
    patch \
    perl \
    py3-sphinx \
    sed
