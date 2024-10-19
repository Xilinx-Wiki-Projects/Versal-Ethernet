require petalinux-image-common-sc.inc

IMAGE_INSTALL:append:eval-brd-sc-zynqmp = " \
    packagegroup-petalinux-syscontroller \
    packagegroup-petalinux-scweb \
    "

IMAGE_INSTALL:append:vck-sc-zynqmp = " \
    packagegroup-petalinux-syscontroller \
    packagegroup-petalinux-scweb \
    "