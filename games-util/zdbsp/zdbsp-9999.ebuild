# I originally swiped this from someone's bug
# report, but I've chopped it to bits over time.
EAPI="2"
inherit games cmake-utils subversion eutils

DESCRIPTION="This is a standalone version of ZDoom's internal node builder"
HOMEPAGE="http://zdoom.org/"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/zdoom/zdbsp/trunk/"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE=""
RDEPEND=""

src_install() {
	# Does anyone really care about the docs?
	dohtml *.{html,png} || die

	# Binary.
	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	prepgamesdirs
}

