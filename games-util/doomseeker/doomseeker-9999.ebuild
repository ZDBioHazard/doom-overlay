# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"
inherit eutils games qt4-r2 cmake-utils subversion

DESCRIPTION="Cross-platform server browser for Doom"
HOMEPAGE="http://skulltag.com/doomseeker/"
ESVN_REPO_URI="svn://skulltag.net/doomseeker/trunk/"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE="extras"
RDEPEND="
	dev-util/cmake
	>=x11-libs/qt-gui-4.7
	sys-libs/zlib
"

src_prepare() {
	GAMES_LIBDIR=`games_get_libdir`
	epatch ${FILESDIR}/${PN}-fixpaths.patch
	einfo "Fixing the library path... (${GAMES_LIBDIR})"
	sed -ie "s:/usr/local/share/doomseeker/engines/:${GAMES_LIBDIR}:" src/core/main.cpp || die
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die

	# Libraries.
	dogameslib libwadseeker.so
	dogameslib engines/libskulltag.so
	if use extras; then
		dogameslib engines/lib{chocolatedoom,odamex,vavoom,zdaemon}.so
	fi

	# Binary.
	dogamesbin ${PN} || die

	# Desktop entry.
	mv ${S}/media/icon_small.png ${PN}.png
	doicon ${PN}.png
	make_desktop_entry ${PN} "Doomseeker"

	prepgamesdirs
}

