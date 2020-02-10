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
#require root
  if [[ $EUID -ne 0 ]]; then
     echo "You must be root to do this." 1>&2
     exit 100
  fi
#This gets unset if non-debian distro is detected
installpackage="yes"
#default chroot dir
chrootdir=squashfs-root

########### CHECK IF THIS SCRIPT IS RUNNING ON A DEBIAN HOST #################
DEBIANCHECK=$(cat /etc/os-release | grep Debian)
ARMBIANCHECK=$(cat /etc/os-release | grep Armbian)
RASPBIANCHECK=$(cat /etc/os-release | grep Raspbian)
ARCHCHECK=$(cat /etc/os-release | grep arch)
if [ -z "$DEBIANCHECK" ] && [ -z "$ARMBIANCHECK" ] && [ -z "$RASPBIANCHECK" ]; then
echo "PLEASE ONLY RUN THIS ON DEBIAN BASED DISTROS"
echo "YOUR SYSTEM:"
cat /etc/os-release
installpackage="no"
#exit
fi

#### TO UPDATE THE PACKAGE CONTAINING THIS SCRIPT FOR ARM ARCHITECTURES #####
#  `skyupdate skyupdate arm64`
# to update the skyupdate debian package on the host architecture;
#from archlinux run ``./buildskyupdater.sh deb`
#https://github.com/skyfleet/sky-update

#require architecture argument for skyupdate
if [ "$1" ==  "skyupdate" ] && [ -z $2 ]; then
  echo "please specify an architecture"
  #list of available architectures here
  exit
fi

#only allow skyupdate to update itself on foreign architectures
if [ "$1" !=  "skyupdate" ] && [ ! -z $2 ]; then
  echo "this feature is currently not suppoted"
  exit
fi

#set systemarch as the second argument provided to this script
if [ "$1" ==  "skyupdate" ] && [ ! -z $2 ]; then
SYSTEMARCH=$2
SYSTEMARCHTEST=$(dpkg --print-architecture)
#prevent specifying the host architecture
if [ "$SYSTEMARCH" ==  "$SYSTEMARCHTEST" ]; then
echo "Error: host architecture specified."
exit
else
#use this for determining chroot method
foreignchroot=yes
fi
#append architecture to chrootdir
chrootdir=$chrootdir-$SYSTEMARCH
else
#Default ; ask dpkg for architecture
SYSTEMARCH=$(dpkg --print-architecture)
#default path
mkdir -p /root/skyupdate && cd /root/skyupdate
fi
#package cache sharing - prevent on foreign architectures
if [ "$foreignchroot" != "yes" ] && [ ! -z "$ARCHCHECK" ]; then
#switch for later in the script
availablehostpackagecache=yes
#sync pacman
sudo pacman -Syy
#set up shared cache
ln -sf /var/lib/pacman/sync/*.db /var/cache/pacman/pkg
 cd /var/cache/pacman/pkg
 killall darkhttpd
nohup darkhttpd . > /dev/null 2>&1 &
cd /root/skyupdate
fi

################ ARCHLINUXARM ROOT FILESYSTEM LINKS #######################
ALARMBASEURL="http://os.archlinuxarm.org/os/"
ARMV5GZ="ArchLinuxARM-armv5-latest.tar.gz"
ARMV6GZ="ArchLinuxARM-armv6-latest.tar.gz"
ARMV7GZ="ArchLinuxARM-armv7-latest.tar.gz"
ARMV8GZ="ArchLinuxARM-armv8-latest.tar.gz"
AARCH64GZ="ArchLinuxARM-aarch64-latest.tar.gz"


############### DOWNLOAD AND EXTRACT ROOT FILESYSTEM #####################
#SYSTEMARCH uses the debian naming convention for architectures
if [[ $SYSTEMARCH == "amd64" ]]; then
  if [ ! -d $chrootdir ]; then
    #unsquashfs makes the chrootdir
    #mkdir $chrootdir
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
#error on invalid architecture
if [ -z $chrootdir ]; then
  echo "Invalid or unsupported architecture"
  exit
fi

##################### CHROOTING SECTION #################################

#default chrooting
if [ "$foreignchroot" != "yes" ]; then
#The package is assumed to be installed if it already exists there
if [ ! -f $chrootdir/root/*.pkg.tar.xz ]; then
cp -b /usr/lib/skycoin/skyupdate/*.pkg.tar.xz $chrootdir/root/
cd $chrootdir/root/
pkgstoinstall=$(ls *.pkg.tar.xz)
cd ..
cd ..
arch-chroot $chrootdir pacman -U /root/$pkgstoinstall --noconfirm --noconfirm
echo
fi
if [ "$availablehostpackagecache" == "yes" ]; then
echo "Server = http://127.0.0.1:80" > $chrootdir/etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist >> $chrootdir/etc/pacman.d/mirrorlist
#now we can update the chroot from the host system package cache
#arch-chroot $chrootdir -c "[ ! -f /etc/pacman.d/mirrorlist.bak ] && cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && { echo -e 'Server = http://127.0.0.1:80'; cat /etc/pacman.d/mirrorlist.bak; } > /etc/pacman.d/mirrorlist"
#the above returns nothing so to keep the script from failing
echo
fi
arch-chroot $chrootdir chrootstrap $1
echo
fi

#THIS IS FAILING TO RESOLVE DNS
#for this to work, `systemctl enable systemd-binfmt.service`
#if [ "$foreignchroot" == "yes" ]; then
#  cp -b  /usr/bin/qemu-aarch64-static $chrootdir/usr/bin
  #The package is assumed to be installed if it already exists there
#  if [ ! -f $chrootdir/root/*.pkg.tar.xz ]; then
#  cp -b /usr/lib/skycoin/skyupdate/*.pkg.tar.xz $chrootdir/root/
#  cp -b /usr/lib/skycoin/skyupdate/pacman.conf $chrootdir/etc/
#  arch-chroot $chrootdir /bin/bash -c "pacman -U /root/*.pkg.tar.xz --noconfirm --noconfirm"
#  echo
#  fi
#  arch-chroot $(pwd)/$chrootdir /bin/bash -c "chrootstrap $1"
#  echo
#  fi

####################### END CHROOTING SECTION ############################

#test for created package
cd $chrootdir/deb
createdpackage=$(ls $1*.deb)
cd ..
cd ..
if [[ -z $createdpackage ]]; then
ls $chrootdir/deb/*.deb
echo -e "There have been errors, no package was created."
exit
fi

####################### PACKAGE INSTALLTION ###############################
#only on debian
if [ "$foreignchroot" != "yes" ] && [ "$installpackage" == "yes" ]; then
  createdpackage=$(ls $chrootdir/deb/${1}*.deb)
echo -e "install package $createdpackage?"
dpkg --force-overwrite -i $createdpackage
fi

####################### REPOSITORY CREATION ###############################

echo "packages:"
ls $chrootdir/deb/${1}*.deb
read -p "Create package repo to update nodes? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
#removes an existing repo
  rm -rf $chrootdir/deb/conf
  rm -rf $chrootdir/deb/db
  rm -rf $chrootdir/deb/dists
  rm -rf $chrootdir/deb/pool
#create a repo
  create-deb-repo $chrootdir/deb
fi
