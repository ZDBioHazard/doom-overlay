# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils games qt4-r2 cmake-utils mercurial

DESCRIPTION="Cross-platform server browser for Doom"
HOMEPAGE="http://skulltag.com/doomseeker/"
EHG_REPO_URI="https://bitbucket.org/Blzut3/doomseeker"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

RDEPEND="
	dev-util/cmake
	sys-libs/zlib
	>=dev-qt/qtgui-4.7"

src_prepare() {
	GAMES_LIBDIR=$(games_get_libdir)
	epatch ${FILESDIR}/${PN}-fixpaths.patch
	einfo "Fixing the library path... (${GAMES_LIBDIR})"
	sed -ie "s:/usr/local/share/doomseeker/engines/:${GAMES_LIBDIR}:" src/core/main.cpp || die
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die

	# Libraries.
	dogameslib engines/lib*.so

	# Binary.
	dogamesbin ${PN} || die

	# Desktop entry.
	mv ${S}/media/icon_small.png ${PN}.png
	doicon ${PN}.png
	make_desktop_entry ${PN} "Doomseeker"

	prepgamesdirs
}

