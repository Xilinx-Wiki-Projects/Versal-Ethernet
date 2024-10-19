LICENSE = "Proprietary & GPL-2.0"
LIC_FILES_CHKSUM = " \
	file://${WORKDIR}/git/LICENSE-BINARIES;md5=fa9b03ada9ffccf51dd60899bf28c702 \
	file://${WORKDIR}/git/LICENSE-GPLv2;md5=9afdcd1be3f71bd3791fa5961075d776 \
	"
BRANCH = "xlnx_rel_v2022.2"
SRC_URI = "git://github.com/Xilinx/versal-sc-firmware.git;protocol=https;branch=${BRANCH}"
SRCREV ?= "4b753be936372b8dee8ce3d77c4bde94a4a824b3"

inherit dfx_user_dts
COMPATIBLE_MACHINE = "^$"
PACKAGE_ARCH = "${MACHINE_ARCH}"
