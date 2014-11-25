#!/bin/bash -x

PWD="`pwd`"
CWD=$(cd "$(dirname "$0")"; pwd)

CUBIAN_CONFIG_REPO="https://github.com/inn1983/Cubian_config"
CUBIAN_CONFIG_REPO_LOCAL=Cubian_config

KERNEL_REPO="https://github.com/inn1983/sunxi_mem-mb"
KERNEL_REPO_LOCAL="sunxi_mem-mb"

LIBFAAC_REPO="https://github.com/inn1983/faac-1.28_build"
LIBFAAC_REPO_LOCAL="faac-1.28_build"

APP_REPO="https://github.com/inn1983/pikapika_server"
APP_REPO_LOCAL="pikapika_server"

#timezone setting
sudo sh -c "echo "Asia/Tokyo" > /etc/timezone"
sudo dpkg-reconfigure -f noninteractive tzdata

#cubian update
sudo apt-get update
sudo apt-get install -y cubian-update

sudo cubian-update -v

#git install
sudo apt-get install -y git

#build-essential install
sudo apt-get install -y build-essential

#vsftpd install
sudo apt-get install -y vsftpd=2.3.5-3
cd $CWD
git clone $CUBIAN_CONFIG_REPO $CUBIAN_CONFIG_REPO_LOCAL
sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.orig
sudo cp $CWD/$CUBIAN_CONFIG_REPO_LOCAL/etc/vsftpd.conf /etc/.

#ftp install
sudo apt-get install -y ftp

#node.js install
cd $CWD
sudo apt-get install curl
sudo bash -c "curl -sL https://deb.nodesource.com/setup | bash -"
sudo apt-get install -y nodejs

#app install
cd $CWD
git clone $APP_REPO $APP_REPO_LOCAL
cd $APP_REPO_LOCAL
npm install serialport

#arduino tool install
cd $CWD
sudo aptitude install arduino
sudo aptitude install python-pip
sudo pip install https://github.com/datsuns/ino/archive/master.zip
#
sudo bash -c "echo sunxi_cedar_mod >> /etc/modules"

#Resolve stability issue on cubieboard 2
cd /boot/
wget https://raw.githubusercontent.com/mmplayer/sunxi-boards/master/sys_config/a20/cubieboard2_argon.fex
sudo mv script.fex script.fex.orig
sudo mv script.bin script.bin.orig
sudo mv cubieboard2_argon.fex script.fex
sudo bash -c "fex2bin script.fex > script.bin"

# clean history
history -c





