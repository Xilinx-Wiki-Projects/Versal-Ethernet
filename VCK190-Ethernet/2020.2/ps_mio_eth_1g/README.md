# Example Design Template

## **Design Summary**

This project is a template for creating your own example design repositories targeting VCK190 ACAP devices. 

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VCK190 ES1 Eval Board
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

Once complete, the built images can be found in the `plnx/images/linux/` directory. To package these images for SD boot, run the following from the `plnx` directory:

`petalinux-package --boot --atf --u-boot`

Once packaged, the `BOOT.bin` and `image.ub` files (in the `plnx/images/linux` directory) can be copied to an SD card, and used to boot.

### **Vitis:**

To build the Baremetal Example Applications for this project, create a new Vitis workspace in the Software/Vitis directory. Once created, build a new platform project targeting the xsa file from `Software/Vitis` folder.

You can now create a new application project. Select File > New > New Application Project

Vitis offers several Ethernet-based example application projects which leverage the LwIP Library. These can be selected on the second page of the New Application Project dialogue.

---

## **Validation**

Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are U-Boot and Kernel examples:

### **Kernel:**
```
root@plnx_project:~# ifconfig eth0 192.168.1.100
root@plnx_project:~# ping 192.168.1.124
64 bytes from 192.168.1.124: seq=19 ttl=128 time=0.238 ms
64 bytes from 192.168.1.124: seq=20 ttl=128 time=0.239 ms
^C
--- 192.168.1.124 ping statistics ---
21 packets transmitted, 21 packets received, 0% packet loss

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
link speed for phy address 1: 1000
Board IP: 10.10.71.2
Netmask : 255.255.255.0
Gateway : 10.10.71.101
TCP echo server started @ port 7
```
On host machine:
```
gomphus5:/home/user $ ping 10.10.71.2
PING 10.10.71.2 (10.10.71.2) 56(84) bytes of data.
64 bytes from 10.10.71.2: icmp_seq=1 ttl=255 time=0.586 ms
64 bytes from 10.10.71.2: icmp_seq=2 ttl=255 time=0.297 ms
64 bytes from 10.10.71.2: icmp_seq=3 ttl=255 time=0.317 ms
^C
--- 10.10.71.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 1999ms
rtt min/avg/max/mdev = 0.297/0.400/0.586/0.131 ms

```
---

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

---
Copyright 2025 AMD-Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.