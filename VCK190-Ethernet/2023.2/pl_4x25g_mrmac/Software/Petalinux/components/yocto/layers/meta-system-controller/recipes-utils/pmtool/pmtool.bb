#
# This file is the Power Management Tool for system controller recipe.
#

SUMMARY = "Power Management Tool"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../LICENSE.md;beginline=1;endline=21;md5=17b8e1d4035e928378878301dbf1d92c"

SRC_URI = " \
    git://github.com/Xilinx/system-controller-pmtool.git;protocol=https;branch=xlnx_rel_v2023.2 \
    file://LICENSE.md \
    file://pmtool.conf \
    "

SRCREV = "8aaad5c95c67974df8a1c590d1afb3f6ad39fa31"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:vck-sc-zynqmp = "${MACHINE}"
COMPATIBLE_MACHINE:eval-brd-sc-zynqmp = "${MACHINE}"
PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec]="1"
do_compile[noexec]="1"

RDEPENDS:${PN} += " \
        apache2 \
        "

do_install() {
        install -d ${D}${localstatedir}/www/pmtool/
        cp -r ${S}/* ${D}${localstatedir}/www/pmtool/

        install -d ${D}${sysconfdir}/apache2/conf.d/
        cp -r ${WORKDIR}/pmtool.conf ${D}${sysconfdir}/apache2/conf.d/
}

FILES:${PN} += "\
    ${localstatedir}/www/pmtool \
    ${sysconfdir}/apache2/conf.d \
    "


