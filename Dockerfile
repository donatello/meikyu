FROM alpine:3.7

ARG GHC_REV
ARG GHC_VER
ARG GHC_CONF_OPTS

RUN apk update --no-progress && apk add --no-progress util-linux
# RUN addgroup stack && adduser -D -G stack -h /home/stack stack

ADD run.sh bootstrap.sh build.mk config.yaml https://github.com/commercialhaskell/stack/releases/download/v1.6.5/stack-1.6.5-linux-x86_64-static.tar.gz /tmp/

ENV STACK_ROOT /opt/stack

RUN GHC_REV=${GHC_REV} GHC_VER=${GHC_VER} GHC_CONF_OPTS=${GHC_CONF_OPTS} sh -e /tmp/run.sh
