#!/bin/sh -eux

# Install applications here e.g. EventStore
# exit

# EventStore
ES_VERSION=3.9.3
ES_PRERELEASE_VERSION=4.0.0-alpha3
ES_USE_PRERELEASE=1

apt-get install -y curl 

if [ -z ${ES_USE_PRERELEASE+x} ]; then 
    echo Use EventStore-OSS release
    curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | sudo bash 
    apt-get install -y eventstore-oss=$ES_VERSION
else 
    echo Use EventStore-OSS pre-release
    curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS-PreRelease/script.deb.sh | sudo bash
    apt-get install -y eventstore-oss=$ES_PRERELEASE_VERSION
fi

sync

systemctl daemon-reload
systemctl enable eventstore.service
systemctl stop eventstore.service
systemctl show eventstore.service

chown eventstore:eventstore /home/vagrant/tmp.eventstore.conf
chmod 664 /home/vagrant/tmp.eventstore.conf
cp -rf /home/vagrant/tmp.eventstore.conf /etc/eventstore/eventstore.conf
echo Contents of /etc/eventstore/eventstore.conf:
cat /etc/eventstore/eventstore.conf
# rm -rf /home/vagrant/tmp.eventstore.conf

cp -rf /home/vagrant/tmp.eventstore.service /etc/systemd/system/eventstore.service
chown root:root /etc/systemd/system/eventstore.service
chmod 664 /etc/systemd/system/eventstore.service
echo Contents of /etc/systemd/system/eventstore.service:
cat /etc/systemd/system/eventstore.service
# rm -rf /home/vagrant/tmp.eventstore.service

# rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Even small files seem to be going missing on Windows running packer.  Try sync.
sync
