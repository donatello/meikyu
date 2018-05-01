#!/bin/sh -e

echo HOME=$HOME STACK_ROOT=$STACK_ROOT
export PATH=${HOME}/.local/bin:${STACK_ROOT}/programs/x86_64-linux/ghc-${GHC_VER}/bin:$PATH
export LANG=en_US.UTF-8

mkdir -p ${HOME}/.local/bin
tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack' -f /tmp/stack-1.6.5-linux-x86_64-static.tar.gz
stack --no-terminal --resolver lts-9 --system-ghc install \
    alex \
    happy \
    hscolour

cd /tmp
git clone git://git.haskell.org/ghc.git
cd ghc
git checkout $GHC_REV
git submodule update --init --recursive
mv /tmp/build.mk mk/
./boot
SPHINXBUILD=/usr/bin/sphinx-build-3 ./configure --prefix=${STACK_ROOT}/programs/x86_64-linux/ghc-$GHC_VER --disable-ld-override $GHC_CONF_OPTS
make -j4
make install
printf "installed" > ${STACK_ROOT}/programs/x86_64-linux/ghc-$GHC_VER.installed

# Cleanup!
rm -rf \
   /tmp/bootstrap.sh \
   /tmp/ghc \
   /tmp/html \
   /tmp/stack-1.6.5-linux-x86_64-static.tar.gz \
   ${HOME}/.local/bin/HsColour \
   ${HOME}/.local/bin/alex \
   ${HOME}/.local/bin/happy \
   ${HOME}/.stack

mv /tmp/config.yaml ${STACK_ROOT}/
