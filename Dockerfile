FROM myoung34/github-runner:2.284.0
LABEL maintainer="murat.kilivan@gmail.com"

# Upgrade system and install required Yocto dependencies
# http://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-host-development-system
RUN apt-get update && apt-get install --no-install-recommends --yes \
  gawk wget git-core diffstat unzip texinfo gcc-multilib \
  build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
  xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
  xterm python3-setuptools file libsdl1.2-dev xterm curl locales apt-utils \
  && apt-get install --no-install-recommends --yes --reinstall ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install kas
RUN pip3 install --no-cache-dir kas

# Fix "server certificate verification failed" error
RUN update-ca-certificates

# Set up locales
RUN dpkg-reconfigure locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG en_US.utf8

# Create a non-root user that will perform actual build
RUN addgroup --gid 1001 --system build \
 && adduser  --uid 1001 --system --ingroup build --home /home/build build

USER build
