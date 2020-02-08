#!/bin/bash
#chrootstrap package
#/usr/lib/skycoin/skyupdate/chrootstrap.any.pkg.tar.xz
#this script
#/usr/bin/skyupdate
#working dir
#/root/skyupdate
#local debian package repo hosted on LAN
#/root/skyupdate/squashfs-root/deb
set -x
  if [[ $EUID -ne 0 ]]; then
     echo "You must be root to do this." 1>&2
     exit 100
  fi
installpackage="yes"
DEBIANCHECK=$(cat /etc/os-release | grep Debian)
ARMBIANCHECK=$(cat /etc/os-release | grep Armbian)
RASPBIANCHECK=$(cat /etc/os-release | grep Raspbian)
ARCHCHECK=$(cat /etc/os-release | grep arch)
if [ -z $DEBIANCHECK ] && [ -z $ARMBIANCHECK ] && [ -z $RASPBIANCHECK ]; then
echo "PLEASE ONLY RUN THIS ON DEBIAN BASED DISTROS"
echo "YOUR SYSTEM:"
cat /etc/os-release
installpackage="no"
#exit
if [ "$1" ==  "skyupdate" ] && [ -z $2 ]; then
  echo "please specify an architecture"
  exit
fi
chrootdir=squashfs-root

if [ "$1" ==  "skyupdate" ] && [ ! -z $2 ]; then
SYSTEMARCH=$2
chrootdir=$chrootdir-$SYSTEMARCH
else
SYSTEMARCH=$(dpkg --print-architecture)
mkdir -p /root/skyupdate && cd /root/skyupdate
fi
#don't do the package cache sharing on foreign architectures
if [ -z $2 ] && [ ! -z $ARCHCHECK ]; then
  #testing considerations ; configure host with read only cache
  sudo pacman -Syy
ln -sf /var/lib/pacman/sync/*.db /var/cache/pacman/pkg
 cd /var/cache/pacman/pkg
 killall darkhttpd
nohup darkhttpd . > /dev/null 2>&1 &
fi
fi

ALARMBASEURL="http://os.archlinuxarm.org/os/"
ARMV5GZ="ArchLinuxARM-armv5-latest.tar.gz"
ARMV6GZ="ArchLinuxARM-armv6-latest.tar.gz"
ARMV7GZ="ArchLinuxARM-armv7-latest.tar.gz"
ARMV8GZ="ArchLinuxARM-armv8-latest.tar.gz"
AARCH64GZ="ArchLinuxARM-aarch64-latest.tar.gz"


#SYSTEMARCH uses the debian naming convention for architectures
if [[ $SYSTEMARCH == "amd64" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
#obtain the latest rootFS sources
MAGNETLINK=$(curl -s https://www.archlinux.org/download/ | sed -rn '/magnet/{s/.*(magnet:[^"]*).*/\1/g;p}')
MAGNETLINK="${MAGNETLINK%%&*}"
#this will do nothing if the file in question already exists
torrent $MAGNETLINK
if [ ! -d "arch" ]; then
ISO="*.iso"
DOWNLOADEDISO=( $ISO )
if [ ! -d "archiso" ]; then
mkdir -p archiso
fi
umount archiso
mount -t iso9660 -o loop $DOWNLOADEDISO archiso
cp -a archiso arch
 umount archiso
rm -rf archiso
fi
unsquashfs -d $chrootdir arch/arch/x86_64/airootfs.sfs
fi
fi

if [[ $SYSTEMARCH == "arm64" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
    if [ ! -f $AARCH64GZ ]; then
    wget  $ALARMBASEURL$AARCH64GZ
  fi
    bsdtar -xpf $AARCH64GZ -C $chrootdir
  fi
fi

if [[ $SYSTEMARCH == "armhf" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
    if [ ! -f $ARMV7GZ ]; then
    wget $ALARMBASEURL$ARMV7GZ
  fi
    bsdtar -xpf $ARMV7GZ -C $chrootdir
  fi
fi

if [[ $SYSTEMARCH == "armel" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
    if [ ! -f $ARMV5GZ ]; then
    wget $ALARMBASEURL$ARMV5GZ
  fi
    bsdtar -xpf $ARMV5GZ -C $chrootdir
  fi
fi

if [[ $SYSTEMARCH == "armv6" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
    if [ ! -f $ARMV6GZ ]; then
    wget $ALARMBASEURL$ARMV6GZ
  fi
    bsdtar -xpf $ARMV6GZ -C $chrootdir
  fi
fi

if [[ $SYSTEMARCH == "armv8" ]]; then
  if [ ! -d $chrootdir ]; then
    mkdir $chrootdir
    if [ ! -f $ARMV8GZ ]; then
    wget $ALARMBASEURL$ARMV8GZ
  fi
    bsdtar -xpf $ARMV8GZ -C $chrootdir
  fi
fi

if [ -z $chrootdir ]; then
  echo "Invalid or unsupported architecture"
  exit
fi

cp -b /etc/resolv.conf $chrootdir/etc/resolv.conf
if [ ! -f $chrootdir/root/*.pkg.tar.xz ]; then
cp -b /usr/lib/skycoin/skyupdate/*.pkg.tar.xz $chrootdir/root/
arch-chroot $chrootdir /bin/bash -c "pacman -U /root/*.pkg.tar.xz --noconfirm"
fi
if [ -z $2 ] && [ ! -z $ARCHCHECK ]; then
#testing consierations - update the chroot from the host system package cache
arch-chroot $chrootdir /bin/bash -c "[ ! -f /etc/pacman.d/mirrorlist.bak ] && cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && { echo -e 'Server = http://127.0.0.1:80'; cat /etc/pacman.d/mirrorlist.bak; } > /etc/pacman.d/mirrorlist"
#the above returns nothing so to keep the script from failing
echo
fi

arch-chroot $chrootdir /bin/bash -c "chrootstrap $1"
if [ -z $2 ] && [ "$installpackage" == "yes" ]; then
dpkg --force-overwrite -i $chrootdir/deb/*.deb
fi
read -p "Create package repo to update nodes? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf $chrootdir/deb/conf
  rm -rf $chrootdir/deb/db
  rm -rf $chrootdir/deb/dists
  rm -rf $chrootdir/deb/pool
  create-deb-repo $chrootdir/deb
fi
