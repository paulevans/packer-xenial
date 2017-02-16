#!/bin/sh -eux

# Install applications here e.g. EventStore
# exit

# EventStore
ES_VERSION=3.9.3
ES_PRERELEASE_VERSION=4.0.0-alpha3
ES_USE_PRERELEASE=1
ES_SERVICE_SRC=/tmp/eventstore.service
ES_SERVICE_DEST=/etc/systemd/system/eventstore.service
ES_SERVICE_DEST2=/lib/systemd/system/eventstore.service

apt-get install -y curl debhelper

if [ -z ${ES_USE_PRERELEASE+x} ]; then 
    echo Use EventStore-OSS release
    wget -O /tmp/eventstore.script.deb.sh https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh
    chmod +x /tmp/eventstore.script.deb.sh 
    /tmp/eventstore.script.deb.sh 
    apt-get install -y eventstore-oss=$ES_VERSION
else 
    echo Use EventStore-OSS pre-release
    wget -O /tmp/eventstore.script.deb.sh https://packagecloud.io/install/repositories/EventStore/EventStore-OSS-PreRelease/script.deb.sh
    chmod +x /tmp/eventstore.script.deb.sh 
    /tmp/eventstore.script.deb.sh 
    apt-get install -y eventstore-oss=$ES_PRERELEASE_VERSION
fi

# Remove the SysV script installed by package above.
# ... it might be messing up systemctl ?  Explain why the files go missing later?
rm -f /etc/init/eventstore.conf
sync

#TODO: In packer I just cannot get these files to stick :( :(  They seem to not be there by the time of vagrant ssh
# Create service file for systemd that replaces /etc/init/eventstore.conf
cp -f $ES_SERVICE_SRC $ES_SERVICE_DEST
chown root:root $ES_SERVICE_DEST
chmod 644 $ES_SERVICE_DEST
cp -f $ES_SERVICE_DEST $ES_SERVICE_DEST2

# I think systemd may delete a service on reload if there is no .d directory?
# mkdir -pm 755 $ES_SERVICE_DEST.d
# touch $ES_SERVICE_DEST.d/eventstore.conf

# Copy dev config from host to guest.
mkdir -pm 755 /etc/eventstore
cp -f /tmp/eventstore.conf /etc/eventstore/eventstore.conf
chown -R eventstore:eventstore /etc/eventstore
chmod 754 /etc/eventstore/eventstore.conf
