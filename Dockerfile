FROM ubuntu:22.04 as base
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib gdb-multiarch

RUN apt-get install -y automake autoconf build-essential texinfo libtool \
    libftdi-dev libusb-1.0-0-dev pkg-config

RUN apt-get install -y git

WORKDIR /pico

RUN git clone https://github.com/raspberrypi/openocd.git \
    --branch rp2040-v0.12.0 \
    --depth=1 --no-single-branch

WORKDIR /pico/openocd

RUN ./bootstrap
RUN ./configure
RUN make -j$(nproc)
RUN make install

WORKDIR /pico

RUN git clone https://github.com/raspberrypi/pico-sdk.git

RUN git -C pico-sdk submodule update --init

ENV PICO_SDK_PATH=/pico/pico-sdk

RUN apt-get install -y python3 python3-pytest

RUN apt-get install -y udev # for terminal inside devcontainer

RUN apt-get install -y wget

RUN  wget -q -O /usr/local/bin/wokwi-cli https://github.com/wokwi/wokwi-cli/releases/latest/download/wokwi-cli-linuxstatic-x64

RUN chmod +x /usr/local/bin/wokwi-cli

RUN curl -L https://raw.githubusercontent.com/rafaelcorsi/wokwi-cli/main/scripts/install.sh | sh


RUN git clone https://github.com/danielmpinto/WorkPico

WORKDIR /WorkPico/scripts

RUN sh cmsis-device-config.sh


# creating tester && client cmsis-XXX.cfg
