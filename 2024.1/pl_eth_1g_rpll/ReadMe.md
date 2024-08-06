# Versal AXI 1G/2.5G Ethernet Subsystem 

## **Design Summary**

This project is about building Versal based AXI 1G/2.5G Ethernet Subsystem example design and testing it by targeting on VCK190 ACAP device using SGMII SFP. 

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VCK190 ES1 Eval Board
- 1G Ethernet Cable
- SGMII SFP
- A host machine that VCK190 is connected to through the cable

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `pl_axi1G_vck190/axi_eth_subsys_hw` directory.

### **PetaLinux**:

1. Enter the `software` directory and use the XSA to create petalinux workspace. Follow the commands for the following:

   To create Petalinux project, run the following 
  
  petalinux-create --type project --template versal --name <name_of_project> 
  cd <name_of_project>
 
  To export XSA and do configuration
     
  petalinux-config --get-hw-description=<PATH TO XSA>
   
  To build the PetaLinux project, run the following from the directory:
  
  petalinux-build

1. Once complete, the built images can be found in the plnx/images/linux/ directory. To package these images for SD boot, run the following from the plnx directory:

  petalinux-package --boot 

1. Once packaged, the BOOT.bin and image.ub files (in the plnx/images/linux directory) can be copied to an SD card, and used to boot.

## **Validation**

Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are U-Boot and Kernel examples:

### **Kernel:**
```
root@pl_eth_sgmii:~# dmesg | grep -i ethernet
[    2.884985] xilinx_axienet a4040000.ethernet: TX_CSUM 0
[    2.890256] xilinx_axienet a4040000.ethernet: RX_CSUM 0
[    2.895669] libphy: Xilinx Axi Ethernet MDIO: probed
[    3.241784] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.387645] macb ff0c0000.ethernet: Not enabling partial store and forward
[    3.394543] macb ff0c0000.ethernet: invalid hw address, using random
[    3.409897] macb ff0c0000.ethernet eth1: Could not attach to PHY
[    3.431830] macb ff0d0000.ethernet: Not enabling partial store and forward
[    3.438741] macb ff0d0000.ethernet: invalid hw address, using random
[    3.486707] Generic PHY ff0d0000.ethernet-ffffffff:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=ff0d0000.ethernet-ffffffff:00, irq=POLL)
[    3.499932] macb ff0d0000.ethernet eth1: Cadence GEM rev 0x0107010b at 0xff0d0000 irq 17 (9e:bf:48:2f:73:74)
[    4.841101] xilinx_axienet a4040000.ethernet eth0: Link is Down
[    6.891255] xilinx_axienet a4040000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

```

On target:
```
root@pl_eth_sgmii:~# ifconfig eth0           
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:10.10.70.1  Bcast:10.255.255.255  Mask:255.0.0.0
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1033 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:336078 (328.2 KiB)

root@pl_eth_sgmii:~# ifconfig eth0 192.168.3.10
root@pl_eth_sgmii:~# ifconfig eth0 
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.3.10  Bcast:192.168.3.255  Mask:255.255.255.0
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1275 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:413047 (403.3 KiB)

root@pl_eth_sgmii:~# ping 192.168.3.12
PING 192.168.3.12 (192.168.3.12): 56 data bytes
64 bytes from 192.168.3.12: seq=0 ttl=64 time=0.315 ms
64 bytes from 192.168.3.12: seq=1 ttl=64 time=0.157 ms
64 bytes from 192.168.3.12: seq=2 ttl=64 time=0.155 ms
64 bytes from 192.168.3.12: seq=3 ttl=64 time=0.149 ms
64 bytes from 192.168.3.12: seq=4 ttl=64 time=0.153 ms
--- 192.168.3.12 ping statistics ---
28 packets transmitted, 28 packets received, 0% packet loss
round-trip min/avg/max = 0.133/0.158/0.315 ms

root@pl_eth_sgmii:~# ifconfig eth0    
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.3.10  Bcast:192.168.3.255  Mask:255.255.255.0
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:113 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1430 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:10846 (10.5 KiB)  TX bytes:437123 (426.8 KiB)

```
On host machine:
```
verifethernet3:$ ifconfig ens1f2
ens1f2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.3.12  netmask 255.255.255.0  broadcast 192.168.3.255
        ether b4:96:91:8a:ed:d6  txqueuelen 1000  (Ethernet)
        RX packets 3055  bytes 927513 (927.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1264  bytes 118292 (118.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

verifethernet3:$ ping 192.168.3.10
PING 192.168.3.10 (192.168.3.10) 56(84) bytes of data.
64 bytes from 192.168.3.10: icmp_seq=1 ttl=64 time=0.102 ms
64 bytes from 192.168.3.10: icmp_seq=2 ttl=64 time=0.096 ms
64 bytes from 192.168.3.10: icmp_seq=3 ttl=64 time=0.104 ms
64 bytes from 192.168.3.10: icmp_seq=4 ttl=64 time=0.098 ms
64 bytes from 192.168.3.10: icmp_seq=5 ttl=64 time=0.093 ms

--- 192.168.3.10 ping statistics ---
39 packets transmitted, 39 received, 0% packet loss, time 38896ms
rtt min/avg/max/mdev = 0.088/0.104/0.174/0.025 ms

```
---

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

---
Copyright 2021 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
