# Ubuntu 16.04 Xenial64 Packer

A sparse VM for Vagrant via Packer that is updated when created. Only a few extra packages I personally find useful right now.

Other types of boxes may come later if I can test them.  I do not own vmware.

## Prerequistes
Install vagrant.

## Packer
packer build xenial64.json

You may only want to build a particular flavour (VirtualBox or Parallels).  For this:

*  packer build -only=parallels-iso xenial64.json
*  packer build -only=virtualbox-iso xenial64.json

### Virtual Box
Install vbguest plugin - this helps keep the file sharing between host and guest up to date.
NOTE: It is likely the box will fail without the vbguest plugin installed.

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
