FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg \
		   file://0001-VPK180-Patch.patch"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2025-02-19-21-00-00.cfg"

