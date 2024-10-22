FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


SRC_URI	+= " file://bsp.cfg \
		     file://0001-net-xilinx-axienet-MRMAC-PTP-Rx-enhancement.patch \
		     file://0002-net-xilinx-axienet-MRMAC-PTP-Tx-enhancement.patch \
		     file://0003-net-xilinx-axienet-Remove-FIFO-related-code-for-MRMA.patch \
		     file://0004-net-xilinx-axienet-Add-ethtool-coalesce-configuratio.patch \
		     file://0005-net-xilinx-axienet-Add-support-for-PTP-1step.patch \
		     file://0006-net-xilinx-axienet-Add-speed-switching-10-25G-suppor.patch \
		     file://0007-ptp-clockmatrix-Add-defer-probe.patch" 

KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2024-10-07-16-55-00.cfg \
            file://user_2024-10-08-00-36-00.cfg \
            file://user_2024-10-08-01-13-00.cfg \
            file://user_2024-10-08-04-46-00.cfg \
            "

