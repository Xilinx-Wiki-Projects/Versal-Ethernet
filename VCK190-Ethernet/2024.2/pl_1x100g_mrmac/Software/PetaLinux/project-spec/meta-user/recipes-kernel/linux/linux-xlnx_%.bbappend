FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg \
                   file://1x100-MRMAC-fixes.patch \
                   file://0001-IDT-clock-fix.patch "
KERNEL_FEATURES:append = " bsp.cfg"

