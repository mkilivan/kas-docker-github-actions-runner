FROM myoung34/github-runner:latest
LABEL maintainer="murat.kilivan@gmail.com"

# Upgrade system and install required Yocto dependencies
# http://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-host-development-system
RUN apt-get update && sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
        xterm python3-setuptools file libsdl1.2-dev xterm curl

# Install kas
RUN pip3 install kas

# Fix "server certificate verification failed" error
RUN apt-get install -y --reinstall ca-certificates
RUN update-ca-certificates

# Set up locales
RUN apt-get -y install locales apt-utils sudo \
  && dpkg-reconfigure locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG en_US.utf8

# Create a non-root user that will perform actual build
RUN useradd -u 1001 -m build && echo "build:build" | chpasswd && adduser build sudo

USER build

