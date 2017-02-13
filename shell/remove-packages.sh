#!/bin/sh -eux
# Removes things not typically needed in a VM.
# Some of these things may be scorthed earth... could be worth revisiting / making optional.

# Based on https://github.com/chef/bento/blob/master/scripts/ubuntu/cleanup.sh
# https://github.com/chef/bento/blob/master/LICENSE

# Remove docs
rm -rf /usr/share/doc/*

# Delete all Linux headers
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

# Delete development packages
# dpkg --list \
#    | awk '{ print $2 }' \
#    | grep -- '-dev$' \
#    | xargs apt-get -y purge;

# delete docs packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge;

# Cleanup packages
apt-get -y autoremove
apt-get -y clean
