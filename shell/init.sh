#!/bin/bash
# Paul attempt at vagrant init file.

apt-get update && apt-get upgrade
apt-get install -y wget

mkdir -pm 700 /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "started script" >> /home/vagrant/delme.txt

sudo -u vagrant wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys

# Add to sudoers vagrant user does not need password for sudo
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# sudoers don't need password for sudo.
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# Add vagrant user to sudoers.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# Customize the message of the day
echo 'Well this did something then? Woot.' > /etc/motd

echo "finished script" >> /home/vagrant/delme.txt
