Important note on the PKGBUILD in this directory:

The skyupdate package is meant to be installed on **DEBIAN BASED DISTROS ONLY.**

The `skyupdate.pkg.tar.xz` is created with `makepkg` and converted to `skyupdate.deb` with the `create-deb-pkg.sh` script which can be found in the `chrootstrap.pkg.tar.xz`.

The chrootstrap package is installed to the archlinux root filesystem via a chroot on debian amd64 and armbian arm64 systems.
