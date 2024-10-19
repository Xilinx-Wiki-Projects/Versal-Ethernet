S = "${WORKDIR}/git"

ESW_VER ?= "${XILINX_XSCT_VERSION}"

inherit xlnx-embeddedsw xsctbase image-artifact-names

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

XSCTH_BASE_NAME ?= "${PN}${PKGE}-${PKGV}-${PKGR}-${MACHINE}${IMAGE_VERSION_SUFFIX}"

FILESEXTRAPATHS:append := ":${XLNX_SCRIPTS_DIR}"
SRC_URI:append = " file://app.tcl"
XSCTH_SCRIPT ?= "${WORKDIR}/app.tcl"

XSCTH_BUILD_DEBUG ?= "0"
XSCTH_BUILD_CONFIG ?= "${@['Debug', 'Release'][d.getVar('XSCTH_BUILD_DEBUG') == "0"]}"
XSCTH_APP_COMPILER_FLAGS ?= ""

SYSROOT_DIRS += "/boot"

do_compile[lockfiles] = "${TMPDIR}/xsct-invoke.lock"
do_compile() {

    cd ${B}/${XSCTH_PROJ}
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${XILINX_SDK_TOOLCHAIN}/tps/lnx64/cmake-3.3.2/libs/Ubuntu/x86_64-linux-gnu/:
    oe_runmake
    if [ ! -e ${B}/${XSCTH_PROJ}/${XSCTH_EXECUTABLE} ]; then
        bbfatal_log "${XSCTH_PROJ} compile failed."
    fi
}

do_install() {
    install -Dm 0644 ${B}/${XSCTH_PROJ}/${XSCTH_EXECUTABLE} ${D}/boot/${PN}-${SRCPV}.elf
}

do_deploy() {
    install -Dm 0644 ${B}/${XSCTH_PROJ}/${XSCTH_EXECUTABLE} ${DEPLOYDIR}/${XSCTH_BASE_NAME}.elf
    ln -sf ${XSCTH_BASE_NAME}.elf ${DEPLOYDIR}/${PN}-${MACHINE}.elf
}
addtask do_deploy after do_compile

FILES:${PN} = "/boot/${PN}-${SRCPV}.elf"
