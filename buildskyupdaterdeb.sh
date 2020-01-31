#!/bin/bash
set -ex
cd chrootstrap
updpkgsums
makepkg -cf
cd ..
ln -f chrootstrap/create-deb-pkg.sh skyupdate/create-deb-pkg.sh
cp -b chrootstrap/*.pkg.tar.xz skyupdate/
cp -b skyupdate.sh skyupdate/skyupdate.sh
cp -b create-deb-repo.sh skyupdate/create-deb-repo.sh

cd skyupdate
bsdtar -czvf skyupdate.tar.gz chrootstrap*.pkg.tar.xz skyupdate.sh create-deb-repo.sh
rm chrootstrap*.pkg.tar.xz skyupdate.sh create-deb-repo.sh
updpkgsums
makepkg -cf
./create-deb-pkg.sh
rm create-deb-pkg.sh
