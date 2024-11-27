# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-any-r1

DESCRIPTION="helper library that coordinates the modification of the intercept API table(s) of the HSA/HIP/ROCTx runtime libraries by the ROCprofiler (v2) library"
HOMEPAGE="https://github.com/ROCm/rocprofiler-register"
SRC_URI="https://github.com/ROCm/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocr-runtime
	dev-util/roctracer
	dev-cpp/glog
	"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.4-remove-packaging-external-glog-fmt.patch"
	"${FILESDIR}/${PN}-6.2.4_use_lib64.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/rocprofiler-register"
		-DCMAKE_BUILD_TYPE=Release
        -DROCPROFILER_REGISTER_BUILD_GLOG=OFF
        -DROCPROFILER_REGISTER_BUILD_FMT=OFF
	)

	cmake_src_configure
}
