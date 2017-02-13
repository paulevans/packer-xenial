#!/bin/bash -eux
# Script attempts to remove cruft caused by installation and make image easier to compress.

# Remove Ubutnu metrics packages
apt-get -y purge popularity-contest installation-report 

# Remove X11 libraries (headless after all)
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

# Remove obsolete networking (we do not need backward compatibility here)
apt-get -y purge ppp pppconfig pppoeconf;

# Delete docs packages (extended docs)
# dpkg --list \
#    | awk '{ print $2 }' \
#    | grep -- '-doc$' \
#    | xargs apt-get -y purge;

# Cleanup packages
apt-get -y autoremove

# Clean removes *all* download stuff, autoclean leaves more around.
apt-get -y clean

# Remove virtual tools images
rm -rf prl-tools-lin.iso VBoxGuestAdditions.iso VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

# Fill empty space with zeros to help with image compression
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? for zeroing out space is suppressed";
rm -f /EMPTY

# Force wait until the file is deleted
sync
