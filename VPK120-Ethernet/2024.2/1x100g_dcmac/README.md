# Example Design Template

## **Design Summary**

This project is a template for creating your own example design repositories targeting VPK120 ACAP devices. 

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.

**Disclaimer:** 
The segmented-to-unsegmented converter logic included in this project is provided as an encrypted RTL file. If you require the source code, you can request it using the link below:
https://account.amd.com/en/member/ip-secure-site-4.html

This design is intended as a reference implementation using DCMAC on the VPK120 evaluation board running PetaLinux. We recommend downloading the source code from the link above and 
then deciding whether to use the provided converter or implement your own.

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VPK120 Prod Eval Board
- QSFP module or DAC cable
- A host machine that VPK120 is connected to through the QSFP port via DAC cable
---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux**:

Enter the `Software/Petainux/` directory. From the command line run the following:
1. Generate HW description using SDT flow
`xsct sdt.tcl ../../Hardware/prebuilt/vpk120_4x25g_mrmac_wrapper.xsa sdt_outdir`
2. Use the HW description
`petalinux-config --get-hw-description sdt_outdir/ --silentconfig`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the `Petalinux/images/linux/`
directory. To package these images for SD boot, run the following from the `PetaLinux` directory:
`petalinux-package --boot --plm --psmfw --u-boot --dtb --force`

Once packaged, the `BOOT.bin`, `boot.scr` and `image.ub` files (in the `Petalinux/images/linux` directory) can be copied to an SD card, and used to boot.

---
## **Validation**

### Kernel:
**NOTE:** The interfaces are assigned as follows:

- end0 -> 1G (PS-GEM)
- eth1 -> 100G
### IPERF TEST
#### MTU 1500
```

```
### IPERF TEST
#### MTU 9000
```


```

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

---
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
