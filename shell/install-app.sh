#!/bin/sh -eux

# Install applications here e.g. EventStore
# exit

# EventStore
ES_VERSION=3.9.3
ES_PRERELEASE_VERSION=4.0.0-alpha3
# ES_USE_PRERELEASE=1

chown root:root /home/vagrant/tmp.eventstore.conf
chmod 644 /home/vagrant/tmp.eventstore.conf
mv /home/vagrant/tmp.eventstore.conf /etc/eventstore.conf

apt-get install -y curl 

if [ -z ${ES_USE_PRERELEASE+x} ]; then 
    curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | sudo bash 
    apt-get install -y eventstore-oss=$ES_VERSION
else 
    curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS-PreRelease/script.deb.sh | sudo bash
    apt-get install -y eventstore-oss=ES_PRERELEASE_VERSION
fi

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
