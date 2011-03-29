# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"
inherit versionator games

MY_PV=$(delete_all_version_separators)
DESCRIPTION="A ZDoom-based Doom source port designed for Internet multi-player."
HOMEPAGE="http://www.skulltag.com"
SRC_URI="
	http://www.skulltag.com/download/files/release/st-v${MY_PV}_linux-base.tar.bz2
	x86? ( http://www.skulltag.com/download/files/release/st-v${MY_PV}_linux-x86.tar.bz2 )
	amd64? ( http://www.skulltag.com/download/files/release/st-v${MY_PV}_linux-x86_64.tar.bz2 )
"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="
	media-libs/libpng:1.2
	media-libs/jpeg:62
	=media-libs/fmod-4.24.16
"
RESTRICT="strip"

src_unpack() {
	# Might as well check the portage prefix here.
	# Because we have to hex-edit the binary, there
	# isn't enough room for an arbitrary root prefix.
	if [ ${EPREFIX} != "/" ]; then
		eerror "Unfortunately, you can't use skulltag"
		eerror "unless your portage prefix is \"/\"."
		die "Invalid portage prefix.";
	fi

	# Unpack the files.
	unpack st-v${MY_PV}_linux-base.tar.bz2
	if use x86; then
		unpack st-v${MY_PV}_linux-x86.tar.bz2
	elif use amd64; then
		unpack st-v${MY_PV}_linux-x86_64.tar.bz2
	else
		die "You aren't using a supported archetecture. :("
	fi

	# Fix the binaries.
	PATHPATTERN="s:/usr/local/share/\x00:/opt/skulltag/\x00\x00\x00\x00:"
	einfo "Fixing the file path in the client binary."
	sed -ieb ${PATHPATTERN} skulltag || die "Couldn't fix the client binary!"
	einfo "Fixing the file path in the server binary."
	sed -ieb ${PATHPATTERN} skulltag-server || die "Couldn't fix the server binary!"
}

INSTALLDIR=${GAMES_PREFIX_OPT}/${PN}
src_install() {
	insinto ${INSTALLDIR}
	exeinto ${INSTALLDIR}

	# Install the everything.
	doins -r ${WORKDIR}/*
	doexe ${WORKDIR}/skulltag
	doexe ${WORKDIR}/skulltag-server

	games_make_wrapper ${PN} ./skulltag "${INSTALLDIR}" "${INSTALLDIR}"
	games_make_wrapper ${PN} ./skulltag-server "${INSTALLDIR}" "${INSTALLDIR}"

	# Hook-up the binary and library path.
	echo PATH="${INSTALLDIR}" > ${T}/70${PN}
	echo LDPATH="${INSTALLDIR}" >> ${T}/70${PN}
	doenvd ${T}/70${PN}

	# So make a desktop entry.
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry ${PN} "Skulltag"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Before you can play ${PN}, you must to do one of the following:"
	elog " - Copy or link IWAD files into ${INSTALLDIR}"
	elog "    (The files must be readable by the 'games' group)."
	elog " - Add your IWAD directory to your ~/.${PN}/${PN}.ini"
	elog "    file in the [IWADSearch.Directories] section."
	elog " - Start ${PN} with the -iwad <iwadpath> option."
	elog " - Get ZDL. (games-util/zdl) ;)"
	elog
	elog "To play, run: \"${PN}\" (and add options and stuff)"
}

