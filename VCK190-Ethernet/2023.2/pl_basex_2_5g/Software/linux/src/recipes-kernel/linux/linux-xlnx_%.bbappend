FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI:append = " file://0001-net-axienet-Fix-phylink_create-error-for-2.5.patch"
SRC_URI:append = " file://0001-net-axienet-Add-support-for-2.5-using-phylink-framew.patch"




