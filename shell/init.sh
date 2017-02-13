#!/bin/bash

# Update system
apt-get update && apt-get dist-upgrade -y
apt-get install -y wget git vim

# Install frills
apt-get install -y screenfetch

# Prepare (insecure) base box vagrant user
mkdir -pm 700 /home/vagrant/.ssh

# Make sure home directory and contents is owned by vagrant
chown -R vagrant:vagrant /home/vagrant
chmod 755 /home/vagrant

# Grab the vagrant base box user public key
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

# Copy files made by file provisioner 
mv /home/vagrant/tmp.bash.bashrc /etc/bash.bashrc
chown root:root /etc/bash.bashrc
chmod 644 /etc/bash.bashrc

mv /home/vagrant/tmp.vim /home/vagrant/.vim
chown vagrant:vagrant /home/vagrant/.vim

# Customize the message of the day
# echo 'Welcome' > /etc/motd
