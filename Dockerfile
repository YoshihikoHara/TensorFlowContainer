#
# Last Updete: 2024/4/21
#
# Author: Yoshihiko Hara
#
# Overview:
#   This is a Dockerfile for creating a container image containing Python and TensorFlow.
#
# Example of Build command:
#   > docker build --no-cache -t shinodas/tensorflow:20240421 .
#
# Example of container initial start command:
#   > docker run -it --name TensorFlow --privileged shinodas/tensorflow:20240421
# 

# Specify the image (Ubuntu 22.04) to be the base of the container.
from ubuntu:22.04

# Change the settings so that interactive operations that may cause waiting for input, etc., do not occur while building the container.
ENV DEBIAN_FRONTEND=noninteractive

# Specify working directory (/root).
WORKDIR /root

# Modernize the container userland.
# For the "upgrade" command, specify the options "--force-confdef" and "--force-confold" to automatically update packages non-interactively.
run apt-get update \
  && apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Install "language-pack" to be able to use Japanese.
run apt-get install -y language-pack-ja-base language-pack-ja

# Set the time zone and locale ("Asia/Tokyo", "ja_JP.UTF-8").
run ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && echo 'Asia/Tokyo' > /etc/timezone \
  && locale-gen ja_JP.UTF-8 \
  && echo 'LC_ALL=ja_JP.UTF-8' > /etc/default/locale \
  && echo 'LANG=ja_JP.UTF-8' >> /etc/default/locale
env LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8

# Install Systemd
run apt-get -y install init \
  systemd

# Install "vim" for text editing.
run apt-get -y install vim

# Install the standard development environment(c, make, ...)
run apt-get -y install build-essential

# Install downloaders(git, wget, curl)
run apt-get -y install git \
  wget \
  curl

# Install Python(Python3, python3-pip)
run apt-get -y install python3 \
  python3-pip

# Install TensorFlow
# See:https://www.tensorflow.org/install/pip?hl=ja
run pip install --upgrade pip
run pip install tensorflow
run pip install matplotlib

# Delete unnecessary caches, etc.
run apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/*

