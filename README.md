# Ubuntu 16.04 Xenial64 Packer

A sparse VM for Vagrant via Packer that is updated when created. Only a few extra packages I personally find useful right now.

## Prerequistes
Install vagrant.

## Packer
packer build xenial64_virtualbox.json

### Virtual Box
Install vbguest plugin:
  * vagrant plugin install vagrant-vbguest
  * vagrant up --provider=virtualbox

### Parallels
  * Install Parallels. Must be "Pro" or "Business" Edition.
  * Install homebrew via https://brew.sh/
    * brew cask install vagrant
    * brew cask install vagrant-manager
    * brew cask install parallels-virtualization-sdk
    * vagrant plugin install vagrant-parallels
  * vagrant up --provider=parallels
