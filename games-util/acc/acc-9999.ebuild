# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Yay ACC. Don't know if it works with SLADE.
EAPI="2"
inherit games subversion eutils

DESCRIPTION="ACS script compiler for use with ZDoom and/or Hexen"
HOMEPAGE="http://zdoom.org/"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/zdoom/acc/trunk/"

LICENSE="DOOMLIC BSD"
SLOT="0"

KEYWORDS=""
IUSE=""
RDEPEND=""

src_prepare() {
	epatch ${FILESDIR}/${PN}-custom_cflags.patch

	# Add the game data path to the include list.
	epatch ${FILESDIR}/${PN}-add_usr_include_path.patch
	sed -ie "s:/usr/local/share/:${GAMES_DATADIR}/:" acc.c || die
}

src_install() {
	# Binary.
	dogamesbin ${PN} || die

	# Install the bundled *.acs files.
	insinto "${GAMES_DATADIR}/${PN}"
	doins *.acs || die

	prepgamesdirs
}

