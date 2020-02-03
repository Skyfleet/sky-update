#!/bin/bash
set -ex
updpkgsums PKGBUILD.chrootstrap
updpkgsums
makepkg -scf
./create-deb-pkg.sh
