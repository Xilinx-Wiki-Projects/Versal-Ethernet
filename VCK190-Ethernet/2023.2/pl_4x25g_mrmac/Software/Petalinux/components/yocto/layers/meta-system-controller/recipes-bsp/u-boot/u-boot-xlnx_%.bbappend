SRC_URI:append:eval-brd-sc-zynqmp = " file://sc_u-boot.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGE_UBOOT_DTB_NAME:eval-brd-sc-zynqmp = "uboot-device-tree.dtb"
SYSTEM_DTB_BLOB:eval-brd-sc-zynqmp = "1"
# u-boot blob generation configuration for system controller
UBOOT_IMAGE_BLOB_DEFAULT:eval-brd-sc-zynqmp = "1"
DT_BLOB_DIR:eval-brd-sc-zynqmp = "${B}/arch/arm/dts/dt-blob"

IMPORT_CC_DTBS:eval-brd-sc-zynqmp = " \
			zynqmp-sc-vpk120-revB.dtbo:zynqmp-sc-revB.dtb:zynqmp-vpk120-revB01.dtb \
			zynqmp-sc-vpk180-revA.dtbo:zynqmp-sc-revB.dtb:zynqmp-vpk180-revA01.dtb \
			zynqmp-sc-vpk180-revB.dtbo:zynqmp-sc-revB.dtb:zynqmp-vpk180-revB01.dtb \
			zynqmp-sc-vhk158-revA.dtbo:zynqmp-sc-revB.dtb:zynqmp-vhk158-revA01.dtb \
			zynqmp-sc-vek280-revA.dtbo:zynqmp-sc-revB.dtb:zynqmp-vek280-revA01.dtb \
			"
IMPORT_CC_UBOOT_DTBS:eval-brd-sc-zynqmp = "zynqmp-sc-vek280-revB.dtbo:zynqmp-sc-revC.dtb:zynqmp-vek280-revB01.dtb"
