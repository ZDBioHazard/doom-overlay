# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit games wxwidgets cmake-utils subversion

DESCRIPTION="Slayer's Leet-Ass Doom Editor"
HOMEPAGE="http://slade.mancubus.net/"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/slade/trunk/"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE="+acc +zdbsp"
RDEPEND="
	sys-libs/zlib
	app-arch/bzip2
	app-arch/zip
	virtual/opengl

	>=x11-libs/wxGTK-2.9
	>=media-sound/fluidsynth-1.1
	>=media-libs/freeimage-3.15
	>=media-libs/libsfml-1.6
	>=media-libs/ftgl-2.1
	>=media-libs/glew-1.9
	>=media-libs/freetype-2.4

	acc? ( games-util/acc )
	zdbsp? ( games-util/zdbsp )
"

src_prepare() {
	# Use default game data path.
	sed -ie "s:wxStandardPaths\:\:Get().GetDataDir();:\"${GAMES_DATADIR}/slade\";:" src/MainApp.cpp || die
}

src_configure() {
	WX_GTK_VER="2.9"
	need-wxwidgets unicode
	cmake-utils_src_configure
}

src_install() {
	# Binary. (Why such a weird directory? o.O)
	dogamesbin ${WORKDIR}/${P}_build/${PN} || die "Couldn't install the binary!"

	# Create and install slade.pk3.
	cd ${WORKDIR}/${P}/dist/res
	zip -r slade.pk3 .
	insinto "${GAMES_DATADIR}/${PN}"
	doins slade.pk3 || die "Couldn't install slade.pk3!"

	# Make a desktop entry.
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry ${PN} "SLADE"

	prepgamesdirs
}

