# Example Design Template

## **Design Summary**

This project is a template for creating your own example design repositories targeting VCK190 ACAP devices. 

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VCK190 Prod Eval Board
- 1000BASEX SFP module
- 1G Ethernet Cable
- A host machine that VCK190 is connected to through the SFP0 slot and with the SFP module and 1G cable

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux**:

Enter the `Software` directory. From the command line run the following:

To build the PetaLinux project, run the following from the directory:

`make all`

Once complete, the built images can be found in the `linux/vck190-versal/images/linux` directory. For SD boot, copy the images from the `sd_card` directory. 

For more details, please refer to the README in the `Software` directory. 

---

## **Validation**

Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. 

To get the link up, `phytool` will need to be used to reset PCS/PMA IP once through its control register0. 

`phytool write eth0/0x9/0x0 0x9140`

Shown below the Kernel examples:

### **Kernel:**
```
vck190-versal:~$ sudo phytool write eth0/0x9/0x0 0x9140
vck190-versal:~$ [  146.793609] macb ff0c0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
[  146.801297] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

vck190-versal:~$ ping 192.168.8.12
PING 192.168.8.12 (192.168.8.12): 56 data bytes
64 bytes from 192.168.8.12: seq=0 ttl=64 time=0.365 ms
64 bytes from 192.168.8.12: seq=1 ttl=64 time=0.162 ms
64 bytes from 192.168.8.12: seq=2 ttl=64 time=0.160 ms
64 bytes from 192.168.8.12: seq=3 ttl=64 time=0.177 ms
64 bytes from 192.168.8.12: seq=4 ttl=64 time=0.156 ms
64 bytes from 192.168.8.12: seq=5 ttl=64 time=0.140 ms
64 bytes from 192.168.8.12: seq=6 ttl=64 time=0.158 ms
^C
--- 192.168.8.12 ping statistics ---
7 packets transmitted, 7 packets received, 0% packet loss
round-trip min/avg/max = 0.140/0.188/0.365 ms
vck190-versal:~$ 

```

On host machine:
```
xhdsswverifethernet3:/home/nanz $ ping 192.168.8.10
PING 192.168.8.10 (192.168.8.10) 56(84) bytes of data.
64 bytes from 192.168.8.10: icmp_seq=1 ttl=64 time=0.164 ms
64 bytes from 192.168.8.10: icmp_seq=2 ttl=64 time=0.078 ms
64 bytes from 192.168.8.10: icmp_seq=3 ttl=64 time=0.084 ms
64 bytes from 192.168.8.10: icmp_seq=4 ttl=64 time=0.079 ms
64 bytes from 192.168.8.10: icmp_seq=5 ttl=64 time=0.121 ms
64 bytes from 192.168.8.10: icmp_seq=6 ttl=64 time=0.122 ms
64 bytes from 192.168.8.10: icmp_seq=7 ttl=64 time=0.077 ms
^C
--- 192.168.8.10 ping statistics ---
7 packets transmitted, 7 received, 0% packet loss, time 6146ms
rtt min/avg/max/mdev = 0.077/0.103/0.164/0.032 ms


```
---

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

---
### Copyright (C) 2021 Xilinx Inc.
### Copyright (C) 2022, Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.