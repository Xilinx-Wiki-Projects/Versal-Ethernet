# Override fancontrol configuration file, making this SC specific
FILESEXTRAPATHS:prepend:eval-brd-sc-zynqmp := "${THISDIR}/${PN}:"

PACKAGE_ARCH:eval-brd-sc-zynqmp = "${MACHINE_ARCH}"
