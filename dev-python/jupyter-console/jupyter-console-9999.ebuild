# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1

MY_PN="jupyter_console"

DESCRIPTION="A terminal-based console frontend for Jupyter kernels"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${MY_PN}.git git://github.com/jupyter/${MY_PN}.git"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/ipython-3.0.0[${PYTHON_USEDEP}]
	dev-python/ipython-ipykernel[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	dev-python/jupyter-client[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"