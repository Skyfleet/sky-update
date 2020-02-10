# Maintainer: Moses Narrow <moe_narrow@use.startmail.com>
pkgname=skyupdate
pkgname1=skyupdate
pkgdesc="skyupdate package FOR DEBIAN"
pkgver=0.0.1
pkgrel=1
arch=('any')
license=()
makedepends=()
depends_x86_64=('squashfs-tools')
depends=('go' 'reprepro' 'arch-install-scripts' 'wget')
source=(
"chrootstrap.sh"
"chrootstrap-alarm.sh"
"create-deb-pkg.sh"
"create-deb-repo.sh"
"pacman.conf"
#'mirrorlist-amd64'
#'mirrorlist-arm'
"PKGBUILD.chrootstrap"
"skyupdate.sh"
)
sha256sums=('43b9667be5959c6f2567d8bdcfee83bbe9742ec7ab8599ff438427eff40a7c20'
            '8c20b86660ec76f08f20e95f50f93f6d0f6c5b3f5f04eae950a682edcd1db474'
            '05c8b564265815b076a38e22e8b14f1b8b619530f318b0322297304de62fdbe6'
            'b64528cd0510deb2be3768247c93c68364685ec40a5a127c4bb3838f7abc7ad5'
            '1539212ca9792ec15371e76c0fd310afc34083bdd87595439e5ed6cd2d84074c'
            '388f7666f93eda8e460a2862ff22aa07bba3b913740c98af852e4a565e4d6191'
            'e9bed182dce043a5517cb3366804cabbac80af585065aa3aafdbd33d42f0c2a2')
systemarchitecture=$( uname -m )

build() {
  if [ ! -f "*.pkg.tar.xz" ]; then
    makepkg -scfp PKGBUILD.chrootstrap
  fi

#if [[ "$systemarchitecture" == "x86_64" ]]; then
#export GOPATH=$(pwd)
#export GOBIN=$(pwd)
#if [ -f "../torrent" ]; then
#  ln ../torrent torrent
#fi
#if [ ! -f "torrent" ] && [ ! -f "../torrent" ]; then
#go get github.com/anacrolix/torrent/cmd/torrent
#fi
#fi
}

package() {
	mkdir -p ${pkgdir}/usr/lib/skycoin/${pkgname1}
	mkdir -p ${pkgdir}/usr/bin
	#if [ "$systemarchitecture" == "x86_64" ]; then
	#install -Dm755 ${srcdir}/torrent ${pkgdir}/usr/bin/torrent
  #fi
	install -Dm755 ${srcdir}/skyupdate.sh ${pkgdir}/usr/bin/${pkgname1}
	install -Dm755 ${srcdir}/create-deb-repo.sh ${pkgdir}/usr/bin/create-deb-repo
	chmod +x ${pkgdir}/usr/bin/*
  install -Dm755 ${srcdir}/*.pkg.tar.xz ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  install -Dm755 ${srcdir}/pacman.conf ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/mirrorlist-amd64 ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/mirrorlist-arm ${pkgdir}/usr/lib/skycoin/${pkgname1}/
}
