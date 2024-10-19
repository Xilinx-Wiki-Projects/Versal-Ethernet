SUMMARY = "Xilinx AI Engine runtime"
DESCRIPTION = "This library provides APIs for the runtime support of the Xilinx AI Engine IP"

require aie-rt.inc

SECTION	= "libs"

AIEDIR ?= "${S}/driver"
S = "${WORKDIR}/git"
I = "${AIEDIR}/include"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:versal-ai-core = "versal-ai-core"
COMPATIBLE_MACHINE:versal-ai-edge = "${SOC_VARIANT_ARCH}"
PV = "3.3"

IOBACKENDS ?= "Linux"

DEPENDS = "${@bb.utils.contains('IOBACKENDS', 'metal', 'libmetal', '', d)}"
RDEPENDS:${PN} = "${@bb.utils.contains('IOBACKENDS', 'metal', 'libmetal', '', d)}"

PROVIDES = "libxaiengine"
RPROVIDES:${PN}	= "libxaiengine"

# The makefile isn't ready for parallel execution at the moment
PARALLEL_MAKE = "-j 1"

CFLAGS += "-Wall -Wextra"
CFLAGS += "${@bb.utils.contains('IOBACKENDS', 'Linux', ' -D__AIELINUX__', '', d)}"
CFLAGS += "${@bb.utils.contains('IOBACKENDS', 'metal', ' -D__AIEMETAL__', '', d)}"
EXTRA_OEMAKE = "-C ${AIEDIR}/src -f Makefile.Linux CFLAGS='${CFLAGS}'"


do_compile(){
	oe_runmake
}

do_install(){
	install -d ${D}${includedir}
	install ${I}/*.h ${D}${includedir}/
	install -d ${D}${includedir}/xaiengine
	install ${I}/xaiengine/*.h ${D}${includedir}/xaiengine/
	install -d ${D}${libdir}
	cp -dr ${AIEDIR}/src/*.so* ${D}${libdir}
}

PACKAGE_ARCH:versal-ai-core = "${SOC_VARIANT_ARCH}"
PACKAGE_ARCH:versal-ai-edge = "${SOC_VARIANT_ARCH}"

