#!/bin/bash
set -ex
updpkgsums PKGBUILD.chrootstrap
updpkgsums
makepkg -cf
./create-deb-pkg.sh
