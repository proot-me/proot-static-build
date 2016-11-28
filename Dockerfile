FROM debian:jessie
MAINTAINER Jonathan Passerat-Palmbach, Imperial College London <j.passerat-palmbach@imperial.ac.uk>

RUN apt update && apt install -y build-essential gawk autoconf autotools-dev python cmake uthash-dev

COPY . /tmp/proot-static-build
WORKDIR /tmp/proot-static-build

CMD bash

