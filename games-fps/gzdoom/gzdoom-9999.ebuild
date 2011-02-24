# I originally swiped this from someone's bug
# report, but I've chopped it to bits over time.
EAPI="2"
inherit games cmake-utils subversion eutils

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code that also supports Heretic, Hexen, and Strife"
HOMEPAGE="http://grafzahl.drdteam.org/"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/gzdoom/trunk/"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"

KEYWORDS=""
IUSE="mmx gtk"
RDEPEND="
	mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )
	gtk? ( x11-libs/gtk+:2 )
	media-libs/libsdl
	media-libs/fmod:1
	media-libs/flac
	media-libs/jpeg
	media-sound/fluidsynth
"

src_prepare() {
	# Use default game data path.
	sed -ie "s:/usr/local/share/:${GAMES_DATADIR}/${PN}/:" src/sdl/i_system.h || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)
	cmake-utils_src_configure
}

src_install() {
	# Does anyone really care about the docs?
	dodoc docs/*.{txt,TXT} || die
	dohtml docs/console*.{css,html} || die

	# Binary.
	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	# Install zdoom.pk3.
	insinto "${GAMES_DATADIR}/${PN}"
	doins ${PN}.pk3 || die

	# So make a desktop entry.
	doicon ${FILESDIR}/${PN}.svg
	make_desktop_entry ${PN} "GZDoom"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Before you can play, you need to do one of the following:"
	elog " - Copy or link wad files into ${GAMES_DATADIR}/${PN}/"
	elog "    (The files must be readable by the 'games' group)."
	elog " - Add your IWAD directory to your ~/zdoom.ini file."
	elog " - Start ${PN} with the -iwad <iwadpath> option."
	elog " - Get ZDL. (games-util/zdl) ;)"
	elog
	elog "To play, run: \"${PN}\" (and add options and stuff)"
}

