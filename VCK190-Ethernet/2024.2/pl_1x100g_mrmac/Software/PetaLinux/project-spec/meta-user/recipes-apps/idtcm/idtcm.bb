#
# This file is the idtcm recipe.
#

SUMMARY = "Simple idtcm application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI = "file://idtcm.bin \
        "

S = "${WORKDIR}"

TARGET_CC_ARCH += "${LDFLAGS}"

inherit allarch

do_install() {
             install -d ${D}/${base_libdir}/firmware/
             install -m 0777 ${S}/idtcm.bin ${D}/${base_libdir}/firmware/
}


FILES:${PN} += "${base_libdir}/firmware/*"
FILES_SOLIBSDEV = ""

