FROM debian
MAINTAINER Jonathan Passerat-Palmbach, Imperial College London <j.passerat-palmbach@imperial.ac.uk>

# Install development packages
#RUN wget -r -np http://mirrors.slackware.com/slackware/slackware64-14.1/slackware64/{a,d}
#RUN ls mirrors.slackware.com/slackware/slackware64-14.1/slackware64/*/*.t?z | xargs -n 1 installpkg

# Add missing uthash lib for CARE
#RUN wget -r -np http://packages.slackonly.com/pub/packages/14.1-x86_64/libraries/uthash/uthash-1.9.9-x86_64-1_slack.txz -O uthash.txz && installpkg uthash.txz
RUN apt update && apt install -y build-essential gawk autoconf autotools-dev python cmake uthash-dev

COPY . /tmp/proot-static-build
WORKDIR /tmp/proot-static-build

CMD bash
