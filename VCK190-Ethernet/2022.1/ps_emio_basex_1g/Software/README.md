## **Software**

In this directory, you will find the Hardware XSA file located in the `vivado` directory. 

This is the XSA file exported from the Vivado project. Users can simply replace it with the one from `Hardware` directory. 

Please remame the XSA to `ps_emio_basex_2022_1.xsa` and simply use `make all` commmand to build the Linux images. 

---

## **Petalinux Build Step-by-Step Instructions**

To build the image manually, alternatively, you can use the following steps:

`petalinux-create -t project --template versal -n ps_emio_basex`

`cd ps_emio_basex`

`petalinux-config --get-hw-description=<path to XSA file>`
		
NOTE: Select DTG Settings → (template) MACHINE_NAME, change it to “versal-vck190-reva-x-ebm-01-reva”

Modify the system_user.dtsi to add: 

```
&gem0 {
    phy-handle = <&phy9>;
    phy9: phy@9 {
      reg = <0x9>;
      xlnx,phy-type = <0x4>;
    };
};

```

To get the link up, we need to do a core reset through the control reigster0, bit 15. Please see PG047 for more details. 

Thus, we will need `phytool` to do so. In 2022.1, in `petalinuxbsp.conf` file, add the following:

`IMAGE_INSTALL:append = " phytool" `

Then do the following continously:

`petalinux-build`

`cd ./images/linux`

`petalinux-package --boot --plm --psmfw --uboot --dtb --force`

Then, you can boot the device normally by copying the images to the SD card.

---
### Copyright 2025 AMD-Xilinx Inc.
### Copyright (C) 2025, Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


