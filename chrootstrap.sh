#!/bin/bash
#root portion of the setup customization

set -e
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to do this." 1>&2
   exit 100
fi
ISO_USER="$(cat /etc/passwd | grep "/home" |cut -d: -f1 |head -1)"
package=yay-git
#if yay is installed, assume the system has been bootstrapped
#update and build the requested package
if pacman -Qi $package > /dev/null ; then
  sudo pacman -Syy
  yes | sudo pacman -Syu --noconfirm
  if [ ! -z $1 ]; then
  su -c "chrootstrap-alarm $1" $ISO_USER
  if [ -d /deb ]; then
    rm -rf /deb
  fi
  mkdir -p /deb
  cp -b /home/$ISO_USER/deb/*.deb /deb
fi
else
#boilerplate archlinux setup
pacman-key --init
pacman-key --populate
#sync the repos
pacman -Syy
#update the keyring first to avoid errors from missing keys
pacman -S archlinux-keyring --noconfirm
#install a few things needed for makepkg
yes | pacman -S base-devel git sudo dpkg --needed --noconfirm
#we need a usr which the x86_64 filesystem doesn't have by default
if [ -z $ISO_USER ]; then
  ISO_USER=alarm
  useradd -m -g users -G wheel -s /bin/bash $ISO_USER
  echo -e "alarm\nalarm" | (passwd $ISO_USER)
fi
#set easy sudo for user portion of configuration
wfile=/etc/sudoers
wfile1=/etc/sudoers-bak
wfile2=/root/sudoers
if [ ! -f $wfile1 ]; then
  cp $wfile $wfile1
  cp -a $wfile1 $wfile2
  echo "$ISO_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> $wfile2
  mv $wfile2 $wfile
else
  cp -a $wfile1 $wfile2
  echo "$ISO_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> $wfile2
  mv $wfile2 $wfile
fi

#run the user portion of the configuration - makepkg cannot be run as root
su -c "chrootstrap-alarm $1" $ISO_USER
mkdir -p /deb
cp -b /home/$ISO_USER/deb/*.deb /deb
fi
