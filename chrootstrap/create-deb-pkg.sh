#!/bin/bash
# make a debian package from an archlinux package
set -exo pipefail
#remove previous
if [ -f *.deb ]; then
  rm *.deb
fi
#if [ -d DEBIAN ]; then
#  rm -rf DEBIAN
#fi

archpackage=$(ls *.pkg.tar.xz)
packagename=${archpackage%%[[:digit:]]*}
packageversion=${archpackage%_*}
packageversion=${packageversion#*$packagename}
packageversion=${packageversion%%-*}
packageversion=${packageversion#:*}
packagename=${packagename%-*}
packagerelease=${archpackage%-*}
packagerelease=${packagerelease##*-}
packagearchitecture=$(dpkg --print-architecture)
debpkgdir="$packagename-$packageversion-$packagerelease"

if [ -d "$debpkgdir" ]; then
  rm -rf "$debpkgdir"
fi
mkdir -p $debpkgdir
bsdtar -xpf $archpackage -C $debpkgdir

mkdir -p $debpkgdir/DEBIAN
echo "Package: $packagename" > $debpkgdir/DEBIAN/control
echo "Version: $packageversion-$packagerelease" >> $debpkgdir/DEBIAN/control
echo "Priority: optional" >> $debpkgdir/DEBIAN/control
echo "Section: web" >> $debpkgdir/DEBIAN/control
echo "Architecture: $packagearchitecture" >> $debpkgdir/DEBIAN/control
echo "Maintainer: Moses Narrow" >> $debpkgdir/DEBIAN/control
echo "Description: lorem ipsum dolor sit amet!" >> $debpkgdir/DEBIAN/control


#System.d service files for debian are located in /etc/systemd not /usr/lib/systemd
#move system.d service files to where debian expects to find them
if [ -d $debpkgdir/usr/lib/systemd ]; then
  #check for the existance of etc in the pkg dir
  if [ ! -d $debpkgdir/etc ]; then
      mkdir -p $debpkgdir/etc
  fi
  mv $debpkgdir/usr/lib/systemd $debpkgdir/etc
fi
if [ -f $debpkgdir/.BUILDINFO ]; then
rm $debpkgdir/.BUILDINFO
fi
if [ -f $debpkgdir/.MTREE ]; then
rm $debpkgdir/.MTREE
fi
if [ -f $debpkgdir/.PKGINFO ]; then
rm $debpkgdir/.PKGINFO
fi
dpkg-deb --build $debpkgdir
