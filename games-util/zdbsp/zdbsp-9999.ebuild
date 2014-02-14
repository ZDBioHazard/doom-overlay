# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# I don't think there's actually a use for ZDBSP yet, but here it is anyway.
EAPI="2"
inherit eutils games cmake-utils git-2

DESCRIPTION="This is a standalone version of ZDoom's internal node builder"
HOMEPAGE="http://zdoom.org/"
EGIT_REPO_URI="https://github.com/rheit/zdbsp.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

src_install() {
	# Does anyone really care about the docs?
	use doc && ( dohtml *.{html,png} || die )

	# Binary.
	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	prepgamesdirs
}

