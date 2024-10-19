DESCRIPTION = "TSN talker listner examples"
LICENSE = "LGPL-2.1-only & BSD-3-Clause & GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
	file://LICENSE.md;md5=6add0857cdd1d555be070a9b1bca8b9b \
	file://OpenAvnu/README.rst;beginline=41;endline=58;md5=421b581669f30d492238ab13a0b86cbd \
"

BRANCH = "xlnx_rel_v2023.2"
SRC_URI = " \
	gitsm://github.com/Xilinx/tsn-talker-listener.git;branch=${BRANCH};protocol=https \
	file://0001-openavb_tasks-Add-missing-include-file.patch \
"
SRCREV = "5959b0819c0ed72444b78984d2f98077c45d54f3"

S = "${WORKDIR}/git"

inherit autotools-brokensep

do_configure[noexec] = '1'
