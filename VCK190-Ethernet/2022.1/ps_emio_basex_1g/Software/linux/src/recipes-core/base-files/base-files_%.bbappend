# Copyright (C) 2021 Xilinx Inc.
# Copyright (C) 2022, Advanced Micro Devices, Inc.

do_install:append() {
  sed -i  '/mmcblk0p1/s/^#//g'                   ${D}${sysconfdir}/fstab
  sed -i  's+/media/card+/run/media/mmcblk0p1+g' ${D}${sysconfdir}/fstab
  sed -i  '/mmcblk0p1/s/,noauto//g'              ${D}${sysconfdir}/fstab
}

