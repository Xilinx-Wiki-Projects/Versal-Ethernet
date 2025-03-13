# Versal AXI 1G/2.5G Ethernet Subsystem 

## **Design Summary**

This project is about building a based AXI 1G/2.5G Ethernet Subsystem example design and testing it by targeting on VEk280 device. 

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VEK280 Eval Board
- 1G Supported Ethernet Cable
- SGMII SFP
- A host machine as a link partner

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line, and run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware/pl_eth_sgmii_rpll_hw` directory.

### **PetaLinux**:

1. Enter the `Software/PetaLinux` directory and use the XSA from `Hardware/prebuilt` to create petalinux workspace. Follow the commands for the following:

   To configure the PetaLinux project, run the following 
  
  `petalinux-config --get-hw-description  ../../Hardware/prebuilt --silentconfig`
  
  To build the PetaLinux project, run the following from the directory:
  
  `petalinux-build`

1. Once complete, the built images can be found in the `<$PROJ_DIR>/images/linux/` directory. To package these images for SD boot, run the following from the plnx directory:

  `petalinux-package --boot --plm --psmfw --u-boot --dtb --force` 

1. Once packaged, the `BOOT.bin`, `image.ub` and `boot.scr` files (in the `<$PROJ_DIR>/images/linux` directory) can be copied to an SD card, and used to boot.


---
### **Validation**:
#### Ping Test
```
PetaLinux:/home/petalinux# ping -A -q -w 3 -I eth1 192.168.1.1 
PING 192.168.1.1 (192.168.1.1): 56 data bytes

--- 192.168.1.1 ping statistics ---
658 packets transmitted, 655 packets received, 0% packet loss
round-trip min/avg/max = 0.044/0.046/0.126 ms

PetaLinux:/home/petalinux# ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:0/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:6081134 errors:0 dropped:0 overruns:0 frame:59238
          TX packets:201413 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:9105440596 (8.4 GiB)  TX bytes:13977846 (13.3 MiB)
```

---
## **Known Issues**
If the interface is up but the link is not, the user may need to follow the manual steps below to turn off the AN:
```
PetaLinux:/home/petalinux# ethtool -s eth1 autoneg off
PetaLinux:/home/petalinux# [  369.303529] xilinx_axienet a4000000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off
[  369.313244] net eth1: Promiscuous mode enabled.
[  369.317814] net eth1: Promiscuous mode enabled. 
```

---
Copyright 2024 AMD-Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
