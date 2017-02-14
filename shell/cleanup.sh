#!/bin/bash -eux
# Script attempts to remove cruft caused by installation and make image easier to compress.

# Remove any left over files copied by the file provisioner
rm -rf /home/vagrant/tmp.*

# Remove Ubutnu metrics packages
apt-get -y purge popularity-contest installation-report 

# Remove X11 libraries (headless after all)
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

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
# ... these might actually need to stick around. Having trouble with them being missing when running packer on Windows.
# rm -rf prl-tools-lin.iso VBoxGuestAdditions.iso VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

# Remove list of packages will get downloaded from the Ubuntu servers
rm -rf /var/lib/apt/lists/*

# Remove temp folders 
rm -rf /tmp/* /var/tmp/*

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

# Fill empty space with zeros to help with image compression
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? for zeroing out space is suppressed";
rm -f /EMPTY

# Force wait until the file is deleted
sync
