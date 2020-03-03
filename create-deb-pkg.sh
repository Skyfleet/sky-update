#!/bin/bash
# make a debian package from an archlinux package
set -eo pipefail

archpackage=$(ls *.pkg.tar.*)
packagename=${archpackage%%[[:digit:]]*}
packageversion=${archpackage%_*}
packageversion=${packageversion#*$packagename}
packageversion=${packageversion%%-*}
packageversion=${packageversion#:*}
packagename=${packagename%-*}
packagerelease=${archpackage%-*}
packagerelease=${packagerelease##*-}
#create foreign architecture packages
if [ "$1" == "multiarch" ]; then
packagearchitecture=(arm64 armhf armel)
debpkgdir="${packagename}-${packageversion}-${packagerelease}"
else
packagearchitecture=$(dpkg --print-architecture)
debpkgdir="${packagename}-${packageversion}-${packagerelease}_${packagearchitecture}"
fi

if [ -d "$debpkgdir" ]; then
  rm -rf "$debpkgdir"
fi
mkdir -p $debpkgdir
bsdtar -xpf $archpackage -C $debpkgdir
set +e
packagedependancies=$(cat "$debpkgdir/.PKGINFO" | grep -v makedepend | grep depend |  tr '\n' ',')
packagedependancies=${packagedependancies//depend =/}
####################################################################
#CHANGE DEPENDANCY NAMES TO DEBIAN FORMAT MANUALLY AS NEEDED HERE#
####################################################################
packagedependancies=${packagedependancies/go,/golang,}
#END DEPENDANCY NAME CONVERSION SECTION#
packagedependancies=${packagedependancies%,*}
if [[ "$packagename" == *"skyupdate"* ]]; then
packagedependancies="$packagedependancies, bsdtar"
fi
packagedependancies=${packagedependancies#* }

mkdir -p $debpkgdir/DEBIAN
echo "Package: $packagename" > $debpkgdir/DEBIAN/control
echo "Version: $packageversion-$packagerelease" >> $debpkgdir/DEBIAN/control
echo "Priority: optional" >> $debpkgdir/DEBIAN/control
echo "Section: web" >> $debpkgdir/DEBIAN/control
echo "Architecture: $packagearchitecture" >> $debpkgdir/DEBIAN/control
if [ ! -z "$packagedependancies" ]; then
echo "Depends: $packagedependancies" >> $debpkgdir/DEBIAN/control
fi
echo "Maintainer: Moses Narrow" >> $debpkgdir/DEBIAN/control
echo "Description: lorem ipsum dolor sit amet!" >> $debpkgdir/DEBIAN/control
set -e
###########################################
#RULES FOR PACKAGE PATH CONVERSION GO HERE#
###########################################
#Not a comprehensive list ; TBI
#System.d service files for debian are located in /etc/systemd not /usr/lib/systemd
#move system.d service files to where debian expects to find them
if [ -d $debpkgdir/usr/lib/systemd ]; then
  #check for the existance of etc in the pkg dir
  if [ ! -d $debpkgdir/etc ]; then
      mkdir -p $debpkgdir/etc
  fi
  mv $debpkgdir/usr/lib/systemd $debpkgdir/etc
fi
#END PATH CONVERSION RULES

#need to remove these metadata files
if [ -f $debpkgdir/.BUILDINFO ]; then
rm $debpkgdir/.BUILDINFO
fi
if [ -f $debpkgdir/.MTREE ]; then
rm $debpkgdir/.MTREE
fi
if [ -f $debpkgdir/.PKGINFO ]; then
rm $debpkgdir/.PKGINFO
fi

#build the debian package
dpkg-deb --build $debpkgdir
rm -rf $debpkgdir
