# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cuda unpacker

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DISTRO=fedora16-1

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="http://developer.nvidia.com/cuda"
CURI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel-update-1/installers/"
SRC_URI="
	amd64? ( ${CURI}/cuda_${PV}_linux_64_${DISTRO}.run )
	x86? ( ${CURI}/cuda_${PV}_linux_32_${DISTRO}.run )"

SLOT="0"
LICENSE="NVIDIA"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debugger doc eclipse profiler"

DEPEND=""
RDEPEND="${DEPEND}
	|| (
		sys-devel/gcc:4.4
		sys-devel/gcc:4.5
		sys-devel/gcc:4.6
		)
	!<=x11-drivers/nvidia-drivers-270.41
	debugger? ( sys-libs/libtermcap-compat )
	profiler? ( >=virtual/jre-1.6 )"

S="${WORKDIR}"

QA_PREBUILT="opt/cuda/*"

src_unpack() {
	unpacker
	unpacker run_files/cudatoolkit*run
}

src_prepare() {
	local cuda_supported_gcc

	cuda_supported_gcc="4.4 4.5 4.6"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	find cuda-installer.pl install-linux.pl jre run_files -delete || die
}

src_install() {
	local cudadir=/opt/cuda
	local prefix="${EPREFIX}"${cudadir}

	if use doc; then
		dodoc doc/{*.txt,pdf/*}
		dohtml -r doc/html/*
	fi

	find doc -delete || die

	use debugger || rm -r bin/cuda-gdb extras/Debugger
	use eclipse || find libnsight -delete

	if use profiler; then
		# hack found in install-linux.pl
		cat > bin/nvvp <<- EOF
			#!${EPREFIX}bin/sh
			LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${prefix}/lib:${prefix}/lib64 \
				UBUNTU_MENUPROXY=0 LIBOVERLAY_SCROLLBAR=0 ${prefix}/libnvvp/nvvp
		EOF
		chmod a+x bin/nvvp
	else
		rm -r extras/CUPTI libnvvp
	fi

	dodir ${cudadir}
	mv * "${ED}"${cudadir}

	cat > "${T}"/99cuda <<- EOF
		PATH=${prefix}/bin:${prefix}/libnvvp
		ROOTPATH=${prefix}/bin
		LDPATH=${prefix}/lib$(use amd64 && echo "64:${prefix}/lib")
	EOF
	doenvd "${T}"/99cuda

	dobin "${T}"/cuda-config
}
