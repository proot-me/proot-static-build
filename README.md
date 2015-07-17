# proot-static-build
Build static variants of PRoot

Here are some notes from the developer of PRoot on how to build a static exectuable:

PRoot static binaries were built using: 

    https://github.com/proot-me/proot-static-build 

The ARM one was built on x86_64 using this command (IIRC): 

    proot -R slackwarearm-14.1/ -b $(which cmake) -q qemu-arm make glibc-version=glibc-2.18 make proot 

Where slackwarearm-14.1 was created this way (IIRC): 

    wget -r -np http://ftp.arm.slackware.com/slackwarearm/slackwarearm-14.1/slackware/ 
    mkdir slackwarearm-14.1/ 
    tar -C slackwarearm-14.1/ -xf ../ftp.arm.slackware.com/slackwarearm/slackwarearm-14.1/slackware/*/*.t?z 
    proot -R slackwarearm-14.1/ ldconfig 
