FROM vbatts/slackware:14.1
MAINTAINER Jonathan Passerat-Palmbach, Imperial College London <j.passerat-palmbach@imperial.ac.uk>

# Install development packages
RUN wget -r -np http://mirrors.slackware.com/slackware/slackware64-14.1/slackware64/{a,d}
RUN ls mirrors.slackware.com/slackware/slackware64-14.1/slackware64/*/*.t?z | xargs -n 1 installpkg

# Add missing uthash lib for CARE
RUN wget -r -np http://packages.slackonly.com/pub/packages/14.1-x86_64/libraries/uthash/uthash-1.9.9-x86_64-1_slack.txz -O uthash.txz && installpkg uthash.txz

WORKDIR /tmp/proot-static-build

ENTRYPOINT make glibc-version=glibc-2.18 -f GNUmakefile proot care -j4

