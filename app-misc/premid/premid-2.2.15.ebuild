# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

DESCRIPTION="Discord Rich Presence for web services"
HOMEPAGE="https://premid.app/"
SRC_URI="https://github.com/${PN}/Linux/releases/download/v${PV}/${PN}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/PreMiD

QA_PRESTRIPPED="/opt/${PN}/${PN} /opt/${PN}/libffmpeg.so /opt/${PN}/libvk_swiftshader.so /opt/${PN}/crashpad_handler /opt/${PN}/chome-sandbox"

src_prepare() {
	sed -i -e 's:Icon=premid.png:Icon=premid:' ${S}/assets/${PN}.desktop || die
	rename appIcon.png premid.png ${S}/assets/appIcon.png

	default
}

src_install() {
	local destdir="/opt/${PN}"

	insinto $destdir
	doins -r locales assets resources swiftshader
	doins *

	# PreMiD icon
	doicon assets/premid.png

	# PreMiD desktop file
	domenu assets/premid.desktop

	# /usr/bin/premid
	exeinto $destdir
	doexe ${PN}

	dosym $destdir/premid /usr/bin/premid

	# Link libraries
	dosym /usr/lib64/libEGL.so $destdir/libEGL.so
	dosym /usr/lib64/libGLESv2.so $destdir/libGLESv2.so
	dosym /usr/lib64/libEGL.so $destdir/swiftshader/libEGL.so
	dosym /usr/lib64/libGLESv2.so $destdir/swiftshader/libGLESv2.so
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
