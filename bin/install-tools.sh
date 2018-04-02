#!/usr/bin/env bash

### Exit script on error
set -e

echo "********* Install basic tools **********"
apt-get install -y vim wget net-tools locales bzip2 \
                   python-numpy #python-numpy used for websockify/novnc

echo "Generate locales"
locale-gen en_US.UTF-8

