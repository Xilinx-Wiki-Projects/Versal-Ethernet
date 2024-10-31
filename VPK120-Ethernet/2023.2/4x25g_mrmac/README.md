# Example Design Template

## **Design Summary**

This project is a template for creating your own example design repositories targeting VPK120 ACAP devices. 

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.

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

`petalinux-config --get-hw-description ../../Hardware/pre-built/ --silentconfig`

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

- eth0 -> 25G
- eth1 -> 25G
- eth2 -> 25G
- eth3 -> 25G
- eth4 -> 1G (PS-GEM)
- eth5 -> 1G (PS-GEM)

### IPERF TEST
#### MTU 1500
```
Petalinux:/home/petalinux# iperf3 -c 192.168.1.2 -B 192.168.1.1  -i 1 -b 2500M -u
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.1 port 58650 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec   298 MBytes  2.50 Gbits/sec  32716  
[  5]   1.00-2.00   sec   298 MBytes  2.50 Gbits/sec  32715  
[  5]   2.00-3.00   sec   298 MBytes  2.50 Gbits/sec  32743  
[  5]   3.00-4.00   sec   298 MBytes  2.50 Gbits/sec  32734  
[  5]   4.00-5.00   sec   298 MBytes  2.50 Gbits/sec  32733  
[  5]   5.00-6.00   sec   298 MBytes  2.50 Gbits/sec  32716  
[  5]   6.00-7.00   sec   298 MBytes  2.50 Gbits/sec  32737  
[  5]   7.00-8.00   sec   298 MBytes  2.50 Gbits/sec  32721  
[  5]   8.00-9.00   sec   298 MBytes  2.50 Gbits/sec  32740  
[  5]   9.00-10.00  sec   298 MBytes  2.50 Gbits/sec  32724  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  2.91 GBytes  2.50 Gbits/sec  0.000 ms  0/327279 (0%)  sender
[  5]   0.00-10.00  sec  0.00 Bytes  0.00 bits/sec  0.000 ms  0/0 (0%)  receiver

iperf Done.
```
### IPERF TEST
#### MTU 9000
```
Petalinux:/home/petalinux# iperf3 -c 192.168.1.2 -B 192.168.1.1  -i 1 -b 5000M -u
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.1 port 45322 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec   418 MBytes  3.50 Gbits/sec  45852  
[  5]   1.00-2.00   sec   419 MBytes  3.51 Gbits/sec  45991  
[  5]   2.00-3.00   sec   418 MBytes  3.50 Gbits/sec  45886  
[  5]   3.00-4.00   sec   407 MBytes  3.41 Gbits/sec  44662  
[  5]   4.00-5.00   sec   407 MBytes  3.42 Gbits/sec  44714  
[  5]   5.00-6.00   sec   407 MBytes  3.41 Gbits/sec  44656  
[  5]   6.00-7.00   sec   407 MBytes  3.41 Gbits/sec  44646  
[  5]   7.00-8.00   sec   407 MBytes  3.41 Gbits/sec  44664  
[  5]   8.00-9.00   sec   407 MBytes  3.41 Gbits/sec  44653  
[  5]   9.00-10.00  sec   406 MBytes  3.41 Gbits/sec  44590  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  4.00 GBytes  3.44 Gbits/sec  0.000 ms  0/450314 (0%)  sender
[  5]   0.00-10.00  sec  0.00 Bytes  0.00 bits/sec  0.000 ms  0/0 (0%)  receiver

iperf Done.

```

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

---
### Copyright (C) 2024, Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
