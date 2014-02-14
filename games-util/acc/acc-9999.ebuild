# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils games git-2

DESCRIPTION="ACS script compiler for use with ZDoom and/or Hexen"
HOMEPAGE="http://zdoom.org/"
EGIT_REPO_URI="https://github.com/rheit/acc.git"

LICENSE="DOOMLIC BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	# Add the game data path to the include list.
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

