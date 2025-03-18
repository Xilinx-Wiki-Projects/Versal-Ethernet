# Versal AXI 1G/2.5G Ethernet Subsystem

## **Design Summary**
This project is about building Versal based AXI 1G/2.5G Ethernet Subsystem and testing it by targeting on VCK190 ACAP device to run 2500-Basex on SFP0 and 1000-Basex on SFP1.

## **Required Hardware**
Here is a list of the required hardware to run the example design:

- VCK190 Eval Board
- 2.5G Ethernet Cable
- 1G Ethernet Cable
- A host machine that VCK190 is connected to through the cable

## **Build Instructions**
### **Vivado:**
Enter the `Scripts` directory. From the command line run the following:
`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware/pl_basex_2_5g_hw` directory.

### **Petalinux:**
Enter the `Software/PetaLinux` directory. From the command line run the following:
`petalinux-config --get-hw-description ../../Hardware/prebuilt/ --silentconfig`
`petalinux-build`
`petalinux-package --boot --plm --psmfw --u-boot --dtb --force`
This will build the petalinux images and inside `images/linux` directory. 

### **Validation:**
```
PetaLinux:/home/petalinux# dmesg | grep axie
[    3.202356] xilinx_axienet a4080000.ethernet: TX_CSUM 0
[    3.207595] xilinx_axienet a4080000.ethernet: RX_CSUM 0
[    3.217814] xilinx_axienet a4000000.ethernet: TX_CSUM 0
[    3.223060] xilinx_axienet a4000000.ethernet: RX_CSUM 0
[    6.364901] xilinx_axienet a4080000.ethernet end2: renamed from eth2
[    6.451560] xilinx_axienet a4000000.ethernet end3: renamed from eth3
[    8.130924] xilinx_axienet a4080000.ethernet end2: configuring for inband/1000base-x link mode
[    8.167704] xilinx_axienet a4000000.ethernet end3: configuring for inband/2500base-x link mode
[    9.184373] xilinx_axienet a4080000.ethernet end2: Link is Up - 1Gbps/Full - flow control rx/tx
[    9.211731] xilinx_axienet a4000000.ethernet end3: Link is Up - 2.5Gbps/Full - flow control rx/tx


PetaLinux:/home/petalinux# ifconfig
end0      Link encap:Ethernet  HWaddr 56:13:73:AC:A8:30  
          inet addr:10.10.71.1  Bcast:10.10.71.255  Mask:255.255.255.0
          inet6 addr: fe80::5413:73ff:feac:a830/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:301 errors:0 dropped:0 overruns:0 frame:0
          TX packets:344 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:43330 (42.3 KiB)  TX bytes:48915 (47.7 KiB)
          Interrupt:30 

end1      Link encap:Ethernet  HWaddr CE:26:CA:81:71:D0  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:31 

end2      Link encap:Ethernet  HWaddr 00:0A:35:00:00:02  
          inet6 addr: fe80::20a:35ff:fe00:2/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:41 errors:0 dropped:0 overruns:0 frame:0
          TX packets:32 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:10556 (10.3 KiB)  TX bytes:9691 (9.4 KiB)

end3      Link encap:Ethernet  HWaddr 00:0A:35:00:00:03  
          inet6 addr: fe80::20a:35ff:fe00:3/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:31 errors:0 dropped:0 overruns:0 frame:0
          TX packets:33 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:8601 (8.3 KiB)  TX bytes:10016 (9.7 KiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

```
> **_NOTE:_** 
end0 = PS GEM0
end1 = PS GEM1
end2 = 1G
end3 = 2.5G

### Ping test
```
PetaLinux:/home/petalinux# ping -A -q -w 3 -I end2 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes

--- 192.168.1.1 ping statistics ---
55371 packets transmitted, 55371 packets received, 0% packet loss
round-trip min/avg/max = 0.043/0.053/0.262 ms
PetaLinux:/home/petalinux# 

PetaLinux:/home/petalinux# ping -A -q -w 3 -I end3 192.168.2.1
PING 192.168.2.1 (192.168.2.1): 56 data bytes

--- 192.168.2.1 ping statistics ---
57389 packets transmitted, 57389 packets received, 0% packet loss
round-trip min/avg/max = 0.041/0.051/0.128 ms


```

## **Known Issues**
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

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
