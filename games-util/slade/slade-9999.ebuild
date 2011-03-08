# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Mmmm, a file editor for Doom. Purtyful.
EAPI="2"
inherit games subversion

DESCRIPTION="Slayer's Leet-Ass Doom Editor"
HOMEPAGE="http://slade.mancubus.net/"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/slade/trunk/"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE=""
RDEPEND="
	>=x11-libs/wxGTK-2.9.1
	>=media-libs/freeimage-3.13.1
	>=media-sound/fluidsynth-1.1.2
"

src_prepare() {
	# Use default game data path.
	sed -ie "s:wxStandardPaths\:\:Get().GetDataDir();:\"${GAMES_DATADIR}/slade\";:" src/MainApp.cpp || die
}

src_compile() {
	emake -f Makefile-no_audiere || die "emake fialed!"
}

src_install() {
	# Binary.
	dogamesbin dist/${PN} || die "Couldn't install the binary!"

	# Install slade.pk3.
	insinto "${GAMES_DATADIR}/${PN}"
	doins dist/${PN}.pk3 || die "Couldn't install slade.pk3!"

	# Make a desktop entry.
	doicon ${FILESDIR}/${PN}.png
	domenu slade.desktop

	prepgamesdirs

	ewarn "Audiere is very broken, so SLADE has been built"
	ewarn "without sound support. Sorry 'bout that. :P"
	ewarn "MIDI should work if you have FluidSynth set up properly though."
}

