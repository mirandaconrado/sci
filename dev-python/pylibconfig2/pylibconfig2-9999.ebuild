# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Pure python library for libconfig syntax"
HOMEPAGE="https://github.com/heinzK1X/pylibconfig2"
EGIT_REPO_URI="https://github.com/heinzK1X/${PN}.git git://git@github.com:heinzK1X/${PN}.git"
KEYWORDS=""

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing
	esetup.py test || die
}
