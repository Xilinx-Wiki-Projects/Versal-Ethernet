# XXV_VERSAL_2023.2

## **Design Summary**

This project utilizes AXI 10G/25G Ethernet Subsystem configured for 10GBASE-R. This has been routed to the SFP cage on SFP0 for use on a VMK180 board. System is configured to use the VMK180 Si570 at 156.25MHz.

- `eth0` is configured as GEM0 routed via RGMII to the on-board PHY.
- `eth1` is configured as 10G/25G Ethernet Subsystem routed to SFP0.

## **Required Hardware**
- VMK180
- SFP supporting 10GBASE-R
- 10G capable link partner

## **Build Instructions**
### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux:**

Enter the 'Software/PetaLinux/' directory. From the command line run the following:

`petalinux-config --get-hw-description ../../Hardware/pre-built/ --silentconfig`

or

`petalinux-config --get-hw-description ../Hardware/xxv_versal.xsa`

followed by:

Enable `iperf3` under user packages in `petalinux-config -c rootfs`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the PetaLinux/images/linux/ directory. To package these images for SD boot, run the following from the PetaLinux directory:

`petalinux-package --boot --u-boot --force`

Once packaged, the `boot.scr`, `BOOT.bin` and `image.ub` files (in the PetaLinux/images/linux directory) can be copied to an SD card, and used to boot.

## **Validation**

### Kernel:
**NOTE:** The interfaces are assigned as follows:

- eth0 -> 10G
- eth1 -> 1G

```
xilinx-vmk180-20232:/home/petalinux# ifconfig 
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:02 
          inet6 addr: fe80::20a:35ff:fe00:2/64 Scope:Link 
          UP BROADCAST RUNNING  MTU:1500  Metric:1 
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0 
          TX packets:14 errors:0 dropped:0 overruns:0 carrier:0 
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:2386 (2.3 KiB) 

eth1      Link encap:Ethernet  HWaddr EE:D7:99:53:E8:2E
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:32

eth2      Link encap:Ethernet  HWaddr 5E:AE:37:87:AB:1B
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:33

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:140 (140.0 B)  TX bytes:140 (140.0 B)

xilinx-vmk180-20232:/home/petalinux# ifconfig eth0 192.168.1.11
xilinx-vmk180-20232:/home/petalinux#
xilinx-vmk180-20232:/home/petalinux# ping 192.168.1.10
PING 192.168.1.10 (192.168.1.10): 56 data bytes
64 bytes from 192.168.1.10: seq=0 ttl=64 time=0.227 ms
64 bytes from 192.168.1.10: seq=1 ttl=64 time=0.091 ms
64 bytes from 192.168.1.10: seq=2 ttl=64 time=0.084 ms
^C
--- 192.168.1.10 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.084/0.134/0.227 ms
```
### Performance:
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.
```
These performance numbers reflect an MTU of 9000.
xilinx-vmk180-20232:/home/petalinux# iperf3 -c 192.168.1.10 -t 6000 -p 5201
Connecting to host 192.168.1.10, port 5201
[  5] local 192.168.1.11 port 42792 connected to 192.168.1.10 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   175 MBytes  1.46 Gbits/sec    0   1.64 MBytes
[  5]   1.00-2.00   sec   209 MBytes  1.76 Gbits/sec    0   1.96 MBytes
[  5]   2.00-3.00   sec   218 MBytes  1.83 Gbits/sec    0   1.96 MBytes
[  5]   3.00-4.00   sec   246 MBytes  2.06 Gbits/sec    0   1.96 MBytes
[  5]   4.00-5.00   sec   241 MBytes  2.02 Gbits/sec    0   2.22 MBytes
[  5]   5.00-6.00   sec   174 MBytes  1.46 Gbits/sec    0   2.22 MBytes
[  5]   6.00-7.00   sec   176 MBytes  1.48 Gbits/sec    0   2.22 MBytes
[  5]   7.00-8.00   sec   214 MBytes  1.79 Gbits/sec    0   2.46 MBytes
[  5]   8.00-9.00   sec   245 MBytes  2.06 Gbits/sec    0   2.46 MBytes
[  5]   9.00-10.00  sec   246 MBytes  2.06 Gbits/sec    0   2.46 MBytes
^C[  5]  10.00-10.78  sec   174 MBytes  1.88 Gbits/sec    0   2.53 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.78  sec  2.26 GBytes  1.80 Gbits/sec    0             sender
[  5]   0.00-10.78  sec  0.00 Bytes   0.00 bits/sec                  receiver

iperf Done.
```

## **Known Issues**
In case petalinux booting fails in SD boot mode with the below log, press the push button switch (SW2) on the VMK180 board.

```
[9509.644]PMC EAM ERR1: 0x20000
[9512.478]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x20000. The corresponding Error ID: 0x11
[9549.658]PMC EAM ERR1: 0x20C00
[9549.706]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x400. The corresponding Error ID: 0xA
[9559.017]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x800. The corresponding Error ID: 0xB   
```

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
