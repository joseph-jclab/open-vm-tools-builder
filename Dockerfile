FROM ubuntu:20.04 as icecc-builder
MAINTAINER Joseph Lee <joseph@jc-lab.net>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y \
    bash curl wget gnupg2 \
    debhelper build-essential git \
    automake make \
    doxygen libcunit1-dev libfuse-dev libnotify-dev libprocps-dev libxss-dev libudev-dev libdrm-dev liblzma-dev \
    gobjc++ libtool pkg-config libmspack-dev libglib2.0-dev libpam0g-dev libssl-dev libxml2-dev libxmlsec1-dev libx11-dev libxext-dev libxinerama-dev libxi-dev libxrender-dev libxrandr-dev libxtst-dev libgdk-pixbuf2.0-dev libgtk-3-dev libgtkmm-3.0-dev

ARG ORIG_ARCHIVE_HASH=27f88f7f498b145f4bc94123e0e321de287776bc3991d42dd5554e63be459eb5
ARG DEBIAN_ARCHIVE_HASH=c3d4a381e5267f5403ffdba3a03ad8fcdbd6560a1b29d52873f3280ae0773461

RUN mkdir -p /work && \
    cd /work && \
    curl -o orig.tar.xz http://archive.ubuntu.com/ubuntu/pool/main/o/open-vm-tools/open-vm-tools_11.0.5.orig.tar.xz && \
    curl -o debian.tar.xz http://archive.ubuntu.com/ubuntu/pool/main/o/open-vm-tools/open-vm-tools_11.0.5-4.debian.tar.xz && \
    echo -e "${ORIG_ARCHIVE_HASH}  orig.tar.xz\n${DEBIAN_ARCHIVE_HASH} debian.tar.xz" | sha256sum -c && \
    mkdir -p src src/debian && \
    tar --strip-components=1 -xf orig.tar.xz -C src && \
    tar --strip-components=1 -xf debian.tar.xz -C src/debian

RUN sed -i 's/Architecture: amd64 i386/Architecture: amd64 i386 arm64/g' src/debian/control

WORKDIR /work/src

RUN dpkg-buildpackage --no-sign -b

