# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit games qt4-r2 git-2

DESCRIPTION="The first Qt ZDL! (Also the /not/ vaporware one.)"
HOMEPAGE="https://github.com/qbasicer/qzdl/"
EGIT_REPO_URI="https://github.com/qbasicer/qzdl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/gdb" # Why does this require GDB? o.O
RDEPEND=">=dev-qt/qtgui-4.7"

src_configure() {
	econf --disable-updater
}

src_install() {
	mv zdl ${PN} # Rename to qzdl to avoid confusion.
	dogamesbin ${PN} || die "Couldn't install the binary! D:"

	newicon include/ico_icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "qZDL"
}

