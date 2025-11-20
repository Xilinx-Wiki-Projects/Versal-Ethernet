# 2023.2 VPK120 1x100G CAUI-4 DCMAC

---
## **Design Summary**
This directory contains VPK120 design files for DCMAC Ethernet design in 2023.2.

---

**Disclaimer:** 
The segmented-to-unsegmented converter logic included in this project is provided as an encrypted RTL file. If you require the source code, you can request it using the link below:
https://account.amd.com/en/member/ip-secure-site-4.html

This design is intended as a reference implementation using DCMAC on the VPK120 evaluation board running PetaLinux. We recommend downloading the source code from the link above and then deciding whether to use the provided converter or implement your own.

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
`petalinux-config --get-hw-description ../../Hardware/prebuilt/ --silentconfig`

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
xilinx-vpk120-20232:/home/petalinux# iperf3 -s
-----------------------------------------------------------
Server listening on 5201 (test #1)
-----------------------------------------------------------
Accepted connection from 192.168.1.2, port 37692
[  5] local 192.168.1.1 port 5201 connected to 192.168.1.2 port 37706
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   151 MBytes  1.26 Gbits/sec                  
[  5]   1.00-2.00   sec   148 MBytes  1.24 Gbits/sec                  
[  5]   2.00-3.00   sec   146 MBytes  1.23 Gbits/sec                  
[  5]   3.00-4.00   sec   146 MBytes  1.23 Gbits/sec                  
[  5]   4.00-5.00   sec   148 MBytes  1.24 Gbits/sec                  
[  5]   5.00-6.00   sec   148 MBytes  1.24 Gbits/sec                  
[  5]   6.00-7.00   sec   150 MBytes  1.26 Gbits/sec                  
[  5]   7.00-8.00   sec   149 MBytes  1.25 Gbits/sec                  
[  5]   8.00-9.00   sec   147 MBytes  1.23 Gbits/sec                  
[  5]   9.00-10.00  sec   148 MBytes  1.24 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  1.45 GBytes  1.24 Gbits/sec                  receiver
-----------------------------------------------------------

```
---
## **Known Issues**

---
### Copyright &copy; 2025, Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
