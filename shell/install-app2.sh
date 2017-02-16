#!/bin/sh -eux

# Install applications here e.g. EventStore
# exit

# EventStore
ES_SERVICE_SRC=/tmp/eventstore.service
ES_SERVICE_DEST=/etc/systemd/system/eventstore.service

#TODO: In packer I just cannot get these files to stick :( :(  They seem to not be there by the time of vagrant ssh
# Create service file for systemd that replaces /etc/init/eventstore.conf
cp -f $ES_SERVICE_SRC $ES_SERVICE_DEST
chown root:root $ES_SERVICE_DEST
chmod 764 $ES_SERVICE_DEST
# I think systemd may delete a service on reload if there is no .d directory?
# mkdir -pm 755 $ES_SERVICE_DEST.d
# touch $ES_SERVICE_DEST.d/eventstore.conf

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

echo Contents of $ES_SERVICE_DEST
cat $ES_SERVICE_DEST

# strace systemctl enable eventstore.service
systemctl enable eventstore.service
