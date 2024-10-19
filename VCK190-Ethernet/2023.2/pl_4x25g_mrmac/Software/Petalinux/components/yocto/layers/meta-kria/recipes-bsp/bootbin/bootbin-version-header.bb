DESCRIPTION = "Kria SOM bootbin version string file"
SUMMARY = "The BIF file for the SOM bootbin requires a version file in a specific format"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:k26-kria = "${MACHINE}"
COMPATIBLE_MACHINE:k24-kria = "${MACHINE}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

BOOTBIN_VER_MAIN ?= ""
BOOTBIN_VER_MAIN:k26-kria = "01.00"
BOOTBIN_VER_MAIN:k24-kria = "01.00"

BOOTBIN_VER_SUFFIX ?= "${@(d.getVar('XILINX_VER_BUILD') or '')[:8] if d.getVar('XILINX_VER_UPDATE') != 'release' and not d.getVar('XILINX_VER_UPDATE').startswith('update') else ''}"
BOOTBIN_VER_FILE = "bootbin-version-header.txt"
BOOTBIN_VER_MAX_LEN = "36"

BOOTBIN_MANIFEST_FILE ?= "bootbin-version-header.manifest"

inherit deploy image-artifact-names

python do_configure() {
    version = d.getVar("MACHINE")[0:3].upper() + "-BootFW-" + d.getVar("BOOTBIN_VER_MAIN")
    if d.getVar("BOOTBIN_VER_SUFFIX"):
        version = version + "-" + d.getVar("BOOTBIN_VER_SUFFIX")

    if len(version) > int(d.getVar("BOOTBIN_VER_MAX_LEN")):
        bb.error("version string too long")

    with open(d.expand("${B}/${BOOTBIN_VER_FILE}"), "w") as f:
        f.write(version.encode("utf-8").hex())

    with open(d.expand("${B}/${BOOTBIN_MANIFEST_FILE}"), "w") as f:
        f.write("* %s\n" % d.getVar('PN'))
        f.write("VERSION: %s\n" % version)
        f.write("PV: %s\n" % d.getVar('PV'))
        f.write("XILINX_VER_MAIN: %s\n" % d.getVar('XILINX_VER_MAIN'))
        f.write("XILINX_VER_UPDATE: %s\n" % d.getVar('XILINX_VER_UPDATE'))
        f.write("XILINX_VER_BUILD: %s\n\n" % d.getVar('XILINX_VER_BUILD'))
}

do_install() {
    install -d ${D}/boot
    install -m 0644 ${B}/${BOOTBIN_VER_FILE} ${D}/boot/
}

do_deploy() {
    install -m 0644 ${B}/${BOOTBIN_VER_FILE} ${DEPLOYDIR}/${IMAGE_NAME}.txt
    ln -s ${IMAGE_NAME}.manifest ${DEPLOYDIR}/${IMAGE_LINK_NAME}.txt
    install -m 0644 ${B}/${BOOTBIN_MANIFEST_FILE} ${DEPLOYDIR}/${IMAGE_NAME}.manifest
    ln -s ${IMAGE_NAME}.manifest ${DEPLOYDIR}/${IMAGE_LINK_NAME}.manifest
}

addtask deploy after do_compile

SYSROOT_DIRS += "/boot"
FILES:${PN} += "/boot/${BOOTBIN_VER_FILE}"
