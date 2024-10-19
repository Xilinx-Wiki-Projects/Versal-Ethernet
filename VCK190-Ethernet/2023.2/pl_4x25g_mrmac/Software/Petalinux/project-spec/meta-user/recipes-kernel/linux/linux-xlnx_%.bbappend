FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2024-10-07-16-55-00.cfg \
            file://user_2024-10-08-00-36-00.cfg \
            file://user_2024-10-08-01-13-00.cfg \
            file://user_2024-10-08-04-46-00.cfg \
            "

