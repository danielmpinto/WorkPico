
FROM ubuntu:20.04
ENV REFRESHED_AT 2023-11-20
ENV PROCESSOR RP2040
ENV TZ=America/São_Paulo
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/dev

RUN apt-get update \
&& apt-get -y install git cmake gcc-arm-none-eabi python3 g++ libnewlib-arm-none-eabi build-essential usbutils minicom

# packages for apps openocd e raspitool
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
        cmake \
        build-essential \
        wget \
        ca-certificates \
        gdb-multiarch \
        binutils-multiarch \
        automake \
        autoconf \
        libtool \
        libftdi-dev \
        libusb-1.0-0-dev \
        pkg-config \
        clang-format 

# rp2040 related staff
RUN git clone https://github.com/raspberrypi/pico-sdk --branch master /opt/sdk/pico-sdk \
    && cd /opt/sdk/pico-sdk \
    && git submodule update --init \
    && cd /home/dev \
    && git clone https://github.com/raspberrypi/pico-examples --branch master
ENV PICO_SDK_PATH=/opt/sdk/pico-sdk




RUN git clone https://github.com/raspberrypi/openocd.git -b picoprobe --depth=1 && \
    cd openocd && ./bootstrap && ./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio --enable-picoprobe && make -j 8 install && \
    cd /dev && git clone https://github.com/raspberrypi/picotool.git --depth=1 && \
    cd picotool && mkdir build && cd build && cmake ../ && make -j 8 && cp picotool /usr/local/bin && \
    cd /dev && git clone https://github.com/wtarreau/bootterm.git --depth=1 && \
    cd bootterm && make -j 8 install 
