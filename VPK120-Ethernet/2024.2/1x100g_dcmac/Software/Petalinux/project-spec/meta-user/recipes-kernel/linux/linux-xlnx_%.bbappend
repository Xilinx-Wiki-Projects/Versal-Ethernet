FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg file://0001-net-axienet-Port-DCMAC-driver-to-2023.2.patch"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2025-10-22-20-58-00.cfg"

