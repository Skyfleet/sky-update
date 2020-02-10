# Maintainer: Moses Narrow <moe_narrow@use.startmail.com>
pkgname=skyupdate
pkgname1=skyupdate
pkgdesc="skyupdate package FOR DEBIAN"
pkgver=0.0.1
pkgrel=1
arch=('any')
license=()
makedepends=()
depends_x86_64=('go' 'squashfs-tools' 'reprepro' 'arch-install-scripts')
depends_aarch64=('go' 'reprepro' 'arch-install-scripts' 'wget')
source=(
"chrootstrap.sh"
"chrootstrap-alarm.sh"
"create-deb-pkg.sh"
"create-deb-repo.sh"
#"pacman.conf"
'mirrorlist-amd64'
#'mirrorlist-arm'
"PKGBUILD.chrootstrap"
"skyupdate.sh"
)
sha256sums=('43b9667be5959c6f2567d8bdcfee83bbe9742ec7ab8599ff438427eff40a7c20'
            '8c20b86660ec76f08f20e95f50f93f6d0f6c5b3f5f04eae950a682edcd1db474'
            '230e3077036b731f6ca9c3bb11000158d8d3368ef4666281f0f5431cc7fceba0'
            '719b37c4bb4b64fdca76376484d4fa20d5fccf4e92d193f9835039055b18f7c0'
            '8b5e78aa55c41039038b4da050219192357e6e524b78bdf80a87cc65e0bab362'
            '43be60c79c87745707cfdfa2cdeb8456747877a920674f4a249f00b2b2306988'
            'c0aef2ae58e25be224eaabea53b353fd6e336932806ec83529a5429c23ad3b55')
systemarchitecture=$( uname -m )

build() {
  if [ ! -f "*.pkg.tar.xz" ]; then
    makepkg -scfp PKGBUILD.chrootstrap
  fi

if [[ "$systemarchitecture" == "x86_64" ]]; then
export GOPATH=$(pwd)
export GOBIN=$(pwd)
if [ -f "../torrent" ]; then
  ln ../torrent torrent
fi
if [ ! -f "torrent" ] && [ ! -f "../torrent" ]; then
go get github.com/anacrolix/torrent/cmd/torrent
fi
fi
}

package() {
	mkdir -p ${pkgdir}/usr/lib/skycoin/${pkgname1}
	mkdir -p ${pkgdir}/usr/bin
	if [ "$systemarchitecture" == "x86_64" ]; then
	install -Dm755 ${srcdir}/torrent ${pkgdir}/usr/bin/torrent
fi
	install -Dm755 ${srcdir}/skyupdate.sh ${pkgdir}/usr/bin/${pkgname1}
	install -Dm755 ${srcdir}/create-deb-repo.sh ${pkgdir}/usr/bin/create-deb-repo
	chmod +x ${pkgdir}/usr/bin/*
  install -Dm755 ${srcdir}/*.pkg.tar.xz ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/pacman.conf ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  install -Dm755 ${srcdir}/mirrorlist-amd64 ${pkgdir}/usr/lib/skycoin/${pkgname1}/
  #install -Dm755 ${srcdir}/mirrorlist-arm ${pkgdir}/usr/lib/skycoin/${pkgname1}/
}
