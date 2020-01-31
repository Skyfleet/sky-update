#!/bin/bash
#chrootstrapping scripts
#/usr/lib/skycoin/skyupdate/chrootstrap.any.pkg.tar.xz
#this script
#/usr/bin/skyupdate
  if [[ $EUID -ne 0 ]]; then
     echo "You must be root to do this." 1>&2
     exit 100
  fi

if [ -z $DEBIANCHECK ] && [ -z $ARMBIANCHECK ] && [ -z $RASPBIANCHECK ]; then
DEBIANCHECK=$(cat /etc/os-release | grep Debian)
ARMBIANCHECK=$(cat /etc/os-release | grep Armbian)
RASPBIANCHECK=$(cat /etc/os-release | grep Raspbian)
echo "PLEASE ONLY RUN THIS ON DEBIAN BASED DISTROS"
echo "YOUR SYSTEM:"
cat /etc/os-release
exit
fi

mkdir -p /root/skyupdate && cd /root/skyupdate

SYSTEMARCH=$(dpkg --print-architecture)
if [[ $SYSTEMARCH == *"amd64"* ]]; then
#arch amd64 detected"
MAGNETLINK=$(curl -s https://www.archlinux.org/download/ | sed -rn '/magnet/{s/.*(magnet:[^"]*).*/\1/g;p}')
MAGNETLINK="${MAGNETLINK%%&*}"
 if [ ! -f "torrent" ]; then
 export GOBIN=$(pwd)
 go get github.com/anacrolix/torrent/cmd/torrent
fi
#this will do nothing if the file in question already exists
./torrent $MAGNETLINK
if [ ! -d "arch" ]; then
ISO="*.iso"
DOWNLOADEDISO=( $ISO )
mount -t iso9660 -o loop $DOWNLOADEDISO archiso
cp -a archiso arch
umount archiso
rm archiso
fi
cd arch/arch/x86_64
if [ ! -d "squashfs-root" ]; then
unsquashfs airootfs.sfs
fi
#set up chroot
mount -t proc /proc squashfs-root/proc/
mount --rbind /sys squashfs-root/sys/
mount --rbind /dev squashfs-root/dev/
mount --rbind /run squashfs-root/run/
cp /etc/resolv.conf squashfs-root/etc/resolv.conf
if [ ! -f squashfs-root/root/*.pkg.tar.xz ]; then
cp -b /usr/lib/skycoin/skyupdate/*.pkg.tar.xz squashfs-root/root/
fi
chroot squashfs-root /bin/bash -c "pacman -U /root/*.pkg.tar.xz"
chroot squashfs-root /bin/bash -c "chrootstrap" $1
umount squashfs-root/proc/
umount squashfs-root/sys/
umount squashfs-root/dev/
umount squashfs-root/run/
dpkg -i squashfs-root/deb/*.deb --force-overwrite
exit
fi
#build packages for orange pi prime / pine64
if [[ $SYSTEMARCH == *"arm64"* ]]; then
  if [ ! -d archarm ]; then
    mkdir archarm
    curl http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz | bsdtar -xpf -C archarm
  fi
  mount -t proc /proc archarm/proc/
  mount --rbind /sys archarm/sys/
  mount --rbind /dev archarm/dev/
  mount --rbind /run archarm/run/
  cp /etc/resolv.conf archarm/etc/resolv.conf
  if [ ! -f archarm/root/*.pkg.tar.xz ]; then
    cp -b /usr/lib/skyupdate/*.pkg.tar.xz archarm/root/
    chroot archarm /bin/bash -c "pacman -U /root/*.pkg.tar.xz"
  fi
  chroot archarm /bin/bash -c "chrootstrap $1"
  umount archarm/proc/
  umount archarm/sys/
  umount archarm/dev/
  umount archarm/run/
  dpkg -i archarm/deb/*.deb --force-overwrite
fi
