#!/bin/sh -eux

echo Contents of /etc/eventstore/eventstore.conf: | cat - /etc/eventstore/eventstore.conf
echo Contents of /etc/systemd/system/eventstore.service: | cat - /etc/systemd/system/eventstore.service | true
echo Contents of /lib/systemd/system/eventstore.service: | cat - /lib/systemd/system/eventstore.service | true

# Reload systemd to pick up eventstore.service file.
systemctl daemon-reload

# strace systemctl enable eventstore.service
systemctl enable eventstore.service
systemctl start eventstore.service
