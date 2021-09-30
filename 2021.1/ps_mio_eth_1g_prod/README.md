# Example Design Template

## **Design Summary**

This project is a template for creating your own example design repositories targeting VCK190 ACAP devices. 

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VCK190 Prod Eval Board
- 1G Ethernet Cable
- A host machine that VCK190 is connected to through the cable

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux**:

Enter the `Software/PetaLinux` directory. From the command line run the following:

To build the PetaLinux project, run the following from the directory:

`petalinux-build`

Once complete, the built images can be found in the `/images/linux/` directory. To package these images for SD boot, run the following from the `plnx` directory:

`petalinux-package --boot --plm --psmfw --uboot --dtb --force`

Once packaged, the `BOOT.BIN`, `boot.scr` and `image.ub` files (in the `/images/linux` directory) can be copied to an SD card, and used to boot.

Alternatively, you can use XSA file to build linux images from scratch by following the steps:

`petalinux-create -t project --template versal -n ps_mio_1g_prod`
`cd ps_mio_1g_prod`
`petalinux-config --get-hw-description=<path to XSA file>` (Image Packaging Configuration => change "INITRAMFS/INITRD Image name" to "petalinux-image-minimal". Please see Known Issues (1))
`petalinux-build`
`cd ./images/linux`
`petalinux-package --boot --plm --psmfw --uboot --dtb --force`


### **Vitis:**

To build the Baremetal Example Applications for this project, create a new Vitis workspace in the Software/Vitis directory. Once created, build a new platform project targeting the xsa file from `Software/Vitis` folder.

Please note, there is an known issue with using Vitis 2021.1. A patch will be needed. Please see Known Issues (2) below. 

Once patch is applied, you can create a new application project. Select File > New > New Application Project

Vitis offers several Ethernet-based example application projects which leverage the LwIP Library. These can be selected on the second page of the New Application Project dialogue.

---

## **Validation**

Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are U-Boot and Kernel examples:

### **Kernel:**
```
root@ps_mio_1g_prod:~# ifconfig
eth0      Link encap:Ethernet  HWaddr AA:9A:15:1C:3D:42  
          inet addr:10.10.71.3  Bcast:10.10.71.255  Mask:255.255.255.0
          inet6 addr: fe80::a89a:15ff:fe1c:3d42/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:10 errors:0 dropped:0 overruns:0 frame:0
          TX packets:15 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:1494 (1.4 KiB)  TX bytes:1882 (1.8 KiB)
          Interrupt:23 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@ps_mio_1g_prod:~# ping 10.10.71.101
PING 10.10.71.101 (10.10.71.101): 56 data bytes
64 bytes from 10.10.71.101: seq=0 ttl=64 time=0.997 ms
64 bytes from 10.10.71.101: seq=1 ttl=64 time=0.500 ms
64 bytes from 10.10.71.101: seq=2 ttl=64 time=0.930 ms
64 bytes from 10.10.71.101: seq=3 ttl=64 time=0.582 ms
64 bytes from 10.10.71.101: seq=4 ttl=64 time=0.786 ms
64 bytes from 10.10.71.101: seq=5 ttl=64 time=0.815 ms
^C
--- 10.10.71.101 ping statistics ---
6 packets transmitted, 6 packets received, 0% packet loss


```

### **Vitis:**

Here uses lwip echo server application from Vitis. 

On target:
```
-----lwIP TCP echo server ------
TCP packets sent to port 6001 will be echoed back
Start PHY autonegotiation 
Waiting for PHY to complete autonegotiation.
Auto negotiation error 
Phy setup error 
Start PHY autonegotiation 
Waiting for PHY to complete autonegotiation.
autonegotiation complete 
Clock Divisors incorrect - Please check
link speed for phy address 1: 1000
Board IP: 10.10.71.4
Netmask : 255.255.255.0
Gateway : 10.10.71.101
TCP echo server started @ port 7

```
On host machine:
```
agaricus3:/home/nanz $ ping 10.10.71.4
PING 10.10.71.4 (10.10.71.4) 56(84) bytes of data.
64 bytes from 10.10.71.4: icmp_seq=1 ttl=255 time=0.289 ms
64 bytes from 10.10.71.4: icmp_seq=2 ttl=255 time=0.277 ms
64 bytes from 10.10.71.4: icmp_seq=3 ttl=255 time=0.304 ms
64 bytes from 10.10.71.4: icmp_seq=4 ttl=255 time=0.269 ms
64 bytes from 10.10.71.4: icmp_seq=5 ttl=255 time=0.306 ms
64 bytes from 10.10.71.4: icmp_seq=6 ttl=255 time=0.351 ms
^C
--- 10.10.71.4 ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5107ms
rtt min/avg/max/mdev = 0.269/0.299/0.351/0.026 ms

```
---

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.
1. https://support.xilinx.com/s/article/76842?language=en_US
2. https://support.xilinx.com/s/article/76668?language=en_US

---
# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.