#!/bin/bash
#chrootstrap package
#/usr/lib/skycoin/skyupdate/chrootstrap.any.pkg.tar.xz
#this script
#/usr/bin/skyupdate
#working dir
#/root/skyupdate
#local debian package repo hosted on LAN
#/root/skyupdate/squashfs-root/deb

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
if [ ! -z $ARCHCHECK ]; then
  sudo pacman -Syy
ln -sf /var/lib/pacman/sync/*.db /var/cache/pacman/pkg
 cd /var/cache/pacman/pkg
 killall darkhttpd
nohup darkhttpd . > /dev/null 2>&1 &
fi

fi

mkdir -p /root/skyupdate && cd /root/skyupdate

SYSTEMARCH=$(dpkg --print-architecture)
if [[ $SYSTEMARCH == *"amd64"* ]]; then
  #set -eo pipefail
if [ ! -d "squashfs-root" ]; then
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
unsquashfs arch/arch/x86_64/airootfs.sfs
fi
fi

if [[ $SYSTEMARCH == *"arm64"* ]]; then
  if [ ! -d squashfs-root ]; then
    mkdir squashfs-root
    if [ ! -f ArchLinuxARM-aarch64-latest.tar.gz ]; then
    #curl -L http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz -o ArchLinuxARM-aarch64-latest.tar.gz
    wget  http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
  fi
    bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C squashfs-root
  fi
fi
cp /etc/resolv.conf squashfs-root/etc/resolv.conf
if [ ! -f squashfs-root/root/*.pkg.tar.xz ]; then
cp -b /usr/lib/skycoin/skyupdate/*.pkg.tar.xz squashfs-root/root/
arch-chroot squashfs-root /bin/bash -c "pacman -U /root/*.pkg.tar.xz --noconfirm"
fi
if [ ! -z $ARCHCHECK ]; then
arch-chroot squashfs-root /bin/bash -c "[ ! -f /etc/pacman.d/mirrorlist.bak ] && cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && { echo -e 'Server = http://127.0.0.1:80'; cat /etc/pacman.d/mirrorlist.bak; } > /etc/pacman.d/mirrorlist"
echo
fi

arch-chroot squashfs-root /bin/bash -c "chrootstrap $1"
if [ "$installpackage" == "yes" ]; then
dpkg --force-overwrite -i squashfs-root/deb/*.deb
fi
read -p "Create package repo to update nodes? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf squashfs-root/deb/conf
  rm -rf squashfs-root/deb/db
  rm -rf squashfs-root/deb/dists
  rm -rf squashfs-root/deb/pool
  create-deb-repo squashfs-root/deb
fi
