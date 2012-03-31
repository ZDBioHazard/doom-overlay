# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Mmmm, an ebuild for my own project. Sexy.
EAPI="2"
inherit games qt4-r2 git-2

DESCRIPTION="A Doom engine frontend designed with ease-of-use and flexibility in mind."
HOMEPAGE="https://github.com/ZDBioHazard/ZDL/"
EGIT_REPO_URI="
	  git://github.com/ZDBioHazard/ZDL.git
	https://github.com/ZDBioHazard/ZDL.git"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS=""
IUSE=""
RDEPEND=">=x11-libs/qt-gui-4.7"

src_install() {
	# Who decided the application name should be in all caps?!
	dogamesbin ${PN} || die "Couldn't install the binary! D:"

	doicon res/${PN}.svg
	make_desktop_entry ${PN} "ZDL"
}

