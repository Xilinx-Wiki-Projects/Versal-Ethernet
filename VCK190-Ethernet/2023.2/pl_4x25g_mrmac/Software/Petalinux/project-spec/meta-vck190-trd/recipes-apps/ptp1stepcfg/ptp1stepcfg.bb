#
# This file is the ptp1stepcfg recipe.
#

SUMMARY = "Simple ptp1stepcfg application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://default_onestep.cfg \
	"

S = "${WORKDIR}"

do_install() {
	     install -d ${D}/${bindir}
	     install -m 0755 ${S}/default_onestep.cfg ${D}/${bindir}
}
