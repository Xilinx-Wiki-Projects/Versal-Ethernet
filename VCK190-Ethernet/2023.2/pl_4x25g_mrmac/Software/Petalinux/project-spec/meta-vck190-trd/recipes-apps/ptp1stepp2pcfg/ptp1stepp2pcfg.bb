#
# This file is the ptp1stepp2pcfg recipe.
#

SUMMARY = "Simple ptp1stepp2pcfg application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://default_onestepp2p.cfg \
	"

S = "${WORKDIR}"

do_install() {
	     install -d ${D}/${bindir}
	     install -m 0755 ${S}/default_onestepp2p.cfg ${D}/${bindir}
}
