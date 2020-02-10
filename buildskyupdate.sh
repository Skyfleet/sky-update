#!/bin/bash
set -ex
updpkgsums PKGBUILD.chrootstrap
updpkgsums
makepkg -scif
if [ "$1" == "deb" ]; then
./create-deb-pkg.sh
fi
