#!/bin/sh -e

apk upgrade --no-cache --no-progress
apk add --no-cache --no-progress \
    autoconf \
    automake \
    bash \
    binutils-gold \
    bzip2 \
    ca-certificates \
    cmake \
    coreutils \
    dpkg \
    file \
    findutils \
    g++ \
    gawk \
    ghc \
    git \
    gmp-dev \
    gzip \
    libedit-dev \
    libffi-dev \
    libtool \
    make \
    musl-dev \
    ninja \
    numactl-dev \
    openssh \
    patch \
    perl \
    py3-sphinx \
    sed \
    subversion \
    tar \
    xz \
    zlib-dev

update-alternatives --install /bin/sh sh /bin/bash 40
update-alternatives --install /usr/bin/sphinx-build sphinx-build /usr/bin/sphinx-build-3 30

mkdir -p /root/.local/bin
tar xz --wildcards --strip-components=1 -C /root/.local/bin '*/stack' -f /tmp/stack-1.6.0.20171022-linux-x86_64-static.tar.gz
stack --no-terminal --resolver lts-9 --system-ghc install \
    alex \
    happy \
    hscolour

cd /tmp
git clone git://git.haskell.org/ghc.git
cd ghc
git checkout c7297342a4797ea36df8767d9c208cfb45de2d09
git submodule update --init --recursive
mv /tmp/build.mk mk/
./boot
./configure --prefix=/root/.stack/programs/x86_64-linux/ghc-8.3.20171116 --disable-ld-override
make -j4
make install
printf "installed" > /root/.stack/programs/x86_64-linux/ghc-8.3.20171116.installed
apk del ghc

cd /tmp
svn co http://llvm.org/svn/llvm-project/llvm/branches/release_50 llvm --quiet
cd llvm
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_FFI:BOOL=ON -DLLVM_USE_LINKER=gold -DLLVM_ENABLE_SPHINX:BOOL=ON ..
ninja install
cd /root

mv /root/.stack/programs /tmp/programs
rm -rf \
    /tmp/bootstrap.sh \
    /tmp/ghc \
    /tmp/llvm \
    /tmp/stack-1.6.0.20171022-linux-x86_64-static.tar.gz \
    /root/.local/bin/HsColour \
    /root/.local/bin/alex \
    /root/.local/bin/happy \
    /root/.stack
mkdir /root/.stack
mv /tmp/config.yaml /root/.stack/
mv /tmp/programs /root/.stack/programs
