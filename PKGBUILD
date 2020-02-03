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
depends_aarch64=('go' 'reprepro' 'arch-install-scripts')
source=(
"chrootstrap.sh"
"chrootstrap-alarm.sh"
"create-deb-pkg.sh"
"create-deb-repo.sh"
"PKGBUILD.chrootstrap"
"skyupdate.sh"
)
sha256sums=('43b9667be5959c6f2567d8bdcfee83bbe9742ec7ab8599ff438427eff40a7c20'
            '5593d5d7d19be49cfb050270fb610d8edf28feab3fe06e4134c90ba9e2e6f98a'
            'a9139cc6a42cedceaa1386dcb0b02230c449988e0aa9481dd5d594cfbb15f41d'
            '032a89359e9768330f8a2aee1a1597e4514e81b1147e4e937d7a8662f89744bc'
            '0412fd57385e84285a8526e42fd7b1f9647235af98b5af34ab2c8e3ab63318a6'
            'af84feeab52d039ae4c2757e5f2ba8005a95c8fb2218efebe9cdd3e9c3ae16d5')
systemarchitecture=$( uname -m )

build() {
  if [ ! -f "*.pkg.tar.xz" ]; then
    makepkg -cfp PKGBUILD.chrootstrap
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
}
