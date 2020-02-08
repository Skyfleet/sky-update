#!/bin/bash
#user portion of the setup customization
#prevent run as root
set -e
if [[ $EUID -eq 0 ]]; then
   echo "Please do not run this script as root." 1>&2
   exit 100
fi
githuburl=https://github.com/skyfleet/
#make sure yay-git is installed
if pacman -Qi yay-git > /dev/null ; then
echo
else
package=yay-git
#clone the build dir for yay-git to it's future package cache
mkdir -p ~/.cache/yay/ && cd ~/.cache/yay/
git clone https://aur.archlinux.org/$package
cd $package
yes | makepkg -scif --noconfirm
#full system update & the end of the bootstrapping
sudo pacman -Syy
yes | sudo pacman -Syu --noconfirm
fi
#use the argument passed to the script as the package to debianize
#limited to AUR packages for now
if [ ! -z $1 ]; then
package=$1
if [ "$package" == "skyupdate" ]; then
git clone $github$package
cd $package
makepkg -scf
create-deb-pkg multiarch
else
yay -S --noconfirm $package
cd ~/.cache/yay/$package
create-deb-pkg
fi
if [ -d ~/deb ]; then
rm -rf ~/deb
fi
mkdir ~/deb
cp *.deb ~/deb
fi
