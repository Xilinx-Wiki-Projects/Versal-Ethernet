# Copyright (C) 2021 Xilinx Inc.
# Copyright (C) 2022, Advanced Micro Devices, Inc.

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI                 += "file://system-conf.dtsi"
EXTRA_OVERLAYS           = "system-user.dtsi"

