#!/bin/sh -eux

# Install applications here e.g. EventStore
# exit

# EventStore
ES_VERSION=3.9.3
ES_PRERELEASE_VERSION=4.0.0-alpha3
ES_USE_PRERELEASE=1
ES_SERVICE_SRC=/tmp/eventstore.service
ES_SERVICE_DEST=/etc/systemd/system/eventstore.service

apt-get install -y curl 

if [ -z ${ES_USE_PRERELEASE+x} ]; then 
    echo Use EventStore-OSS release
    source <(curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh)
    apt-get install -y eventstore-oss=$ES_VERSION
else 
    echo Use EventStore-OSS pre-release
    source <(curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS-PreRelease/script.deb.sh)
    apt-get install -y eventstore-oss=$ES_PRERELEASE_VERSION
fi

#TODO: In packer I just cannot get these files to stick :( :(  They seem to not be there by the time of vagrant ssh
# Create service
cp -f $ES_SERVICE_SRC $ES_SERVICE_DEST
chown root:root $ES_SERVICE_DEST
chmod 664 $ES_SERVICE_DEST

#echo Contents of $ES_SERVICE_DEST
#cat $ES_SERVICE_DEST

# Copy dev config from host to guest.
mkdir -pm 755 /etc/eventstore
cp -f /tmp/eventstore.conf /etc/eventstore/eventstore.conf
chown -R eventstore:eventstore /etc/eventstore
chmod 754 /etc/eventstore/eventstore.conf

# Flush all file ops... hopefully.
sync

#echo Contents of /etc/eventstore/eventstore.conf:
#cat /etc/eventstore/eventstore.conf

# Reload systemd to pick up eventstore.service file.
systemctl daemon-reload
# strace systemctl enable eventstore.service
systemctl enable eventstore.service
# Make sure any extra state from systemd is flushed
systemctl daemon-reload
