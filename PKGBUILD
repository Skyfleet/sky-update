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
            'c231e858e4544a809d432a790a21bcc8e12d3d92f31c19f0d771b98a292699a1'
            'e9825613c91061112b59a34268611a4acc15648b179a620a7fe0fe865377a30f'
            '1539212ca9792ec15371e76c0fd310afc34083bdd87595439e5ed6cd2d84074c'
            '54bc899a836a8595e4f7bd734d19997567fee4fcb35af54adfedc4951d6e7d34'
            'ec8ed874dc1d200d80925280b5e43d71fd95edeafac784871f0547a67be7e3be')
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
  install -Dm755 ${srcdir}/*.pkg.tar.zst ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  install -Dm755 ${srcdir}/pacman.conf ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/mirrorlist-amd64 ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/mirrorlist-arm ${pkgdir}/usr/lib/skycoin/${pkgname1}/
}
