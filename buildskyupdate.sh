#!/bin/bash
set -ex
updpkgsums PKGBUILD.chrootstrap
updpkgsums
makepkg -scif
if [ "$1" == "deb" ]; then
  SYSARCHITECTURE=$(dpkg --print-architecture)
  if [ "$SYSARCHITECTURE" != "amd64" ]; then
./create-deb-pkg.sh multiarch
else
./create-deb-pkg.sh
fi
fi
