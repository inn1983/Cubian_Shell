#!/bin/bash -x

PWD="`pwd`"
CWD=$(cd "$(dirname "$0")"; pwd)

CUBIAN_CONFIG_REPO="https://github.com/inn1983/Cubian_config"
CUBIAN_CONFIG_REPO_LOCAL=Cubian_config

KERNEL_REPO="https://github.com/inn1983/sunxi_mem-mb"
KERNEL_REPO_LOCAL="sunxi_mem-mb"

LIBFAAC_REPO="https://github.com/inn1983/faac-1.28_build"
LIBFAAC_REPO_LOCAL="faac-1.28_build"

APP_REPO="https://github.com/inn1983/rtmpstreamer"
APP_REPO_LOCAL="rtmpstreamer"

#CRTMPSERVER_INSTALLDIR=rtmptest/crtmp

#timezone setting
sudo echo "Asia/Tokyo" > /etc/timezone
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

#faac install
cd $CWD
git clone $LIBFAAC_REPO $LIBFAAC_REPO_LOCAL
sudo cp -r $CWD/$LIBFAAC_REPO_LOCAL/libfaac_bin/include/ /usr/local/.
sudo cp -r $CWD/$LIBFAAC_REPO_LOCAL/libfaac_bin/lib /usr/local/.

#app install
sudo apt-get install -y libcommoncpp2-dev
sudo apt-get install -y libasound2-dev
cd $CWD
git clone $APP_REPO $APP_REPO_LOCAL
cd $CWD/$APP_REPO_LOCAL
git checkout aac_merge
make clean
make
mkfifo fifo.pcm
rm *.cpp *.c *.o
sudo rm -r .git
rm -r Camera include watermark

#rtmp server install
cd $CWD
mkdir -p rtmptest/crtmp
cd rtmptest/crtmp
wget http://cubieboard.jp/downloadfiles/crtmp_build.tar.gz
tar zxvf crtmp_build.tar.gz

#
cd $CWD
mkdir red5
cd red5
wget http://www.red5.org/downloads/red5/1_0_1/red5-1.0.1.tar.gz
tar zxvf red5-1.0.1.tar.gz

#web server install
sudo apt-get install -y apache2
cd /var/www
sudo git clone https://github.com/inn1983/rtmp_flowplayer

#
sudo bash -c "echo sunxi_cedar_mod >> /etc/modules"

#kernel install
cd $CWD
git clone $KERNEL_REPO $KERNEL_REPO_LOCAL

cd /boot
sudo mv uImage uImage.orig
sudo cp $CWD/$KERNEL_REPO_LOCAL/uImage .

cd /lib
sudo mv modules modules.orig
sudo mv firmware firmware.orig
sudo cp -r $CWD/$KERNEL_REPO_LOCAL/lib/modules .
sudo cp -r $CWD/$KERNEL_REPO_LOCAL/lib/firmware .

# clean history
sudo history -c





