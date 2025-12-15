# pl_1x100g_mrmac-caui-4 - Versal MRMAC 

## **Design Summary**

This project utilizes Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem. This design provides 1 ethernet interface routed to QSFP a VCK190 board. 


## **Required Hardware**
- VCK190
- QSFP DAC
- 100G capable link partner

## **Build Instructions**
### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux:**

Enter the 'Software/PetaLinux/' directory. From the command line run the following:

`petalinux-config --get-hw-description ../../Hardware/pre-built/ --silentconfig`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the PetaLinux/images/linux/ directory. To package these images for SD boot, run the following from the PetaLinux directory:

`petalinux-package --boot --u-boot --force`

Once packaged, the `boot.scr`, `BOOT.bin` and `image.ub` files (in the PetaLinux/images/linux directory) can be copied to an SD card, and used to boot.

## **Validation**

### Kernel:
**NOTE:** The interfaces are assigned as follows:

- eth0 -> 100G
- end0 -> 1G (PS-GEM)
- end1 -> 1G (PS-GEM)


```
PetaLinux:/home/petalinux# ifconfig
end0      Link encap:Ethernet  HWaddr 52:54:36:95:07:5A  
          inet addr:10.10.71.2  Bcast:10.10.71.255  Mask:255.255.255.0
          inet6 addr: fe80::5054:36ff:fe95:75a/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:475 errors:0 dropped:0 overruns:0 frame:0
          TX packets:532 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:68014 (66.4 KiB)  TX bytes:76108 (74.3 KiB)
          Interrupt:32 

end1      Link encap:Ethernet  HWaddr 9E:AB:85:94:63:63  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:33 

eth0      Link encap:Ethernet  HWaddr D2:95:B3:34:5E:FB  
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::d095:b3ff:fe34:5efb/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:64273 errors:0 dropped:0 overruns:0 frame:0
          TX packets:64273 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:6334024 (6.0 MiB)  TX bytes:6334024 (6.0 MiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


#Ping from link partner side (partner is at 192.168.1.2)
PetaLinux:/home/petalinux# ping -A -q -w 3 -I eth0 192.168.1.1 
PING 192.168.1.1 (192.168.1.1): 56 data bytes

--- 192.168.1.1 ping statistics ---
63868 packets transmitted, 63868 packets received, 0% packet loss
round-trip min/avg/max = 0.039/0.046/0.137 ms


```
### Performance:
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.
```
-----------------------------------------------------------
Accepted connection from 192.168.1.2, port 57806
[  5] local 192.168.1.1 port 5201 connected to 192.168.1.2 port 57054
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec   206 MBytes  1.73 Gbits/sec  0.001 ms  0/149493 (0%)  
[  5]   1.00-2.00   sec   207 MBytes  1.73 Gbits/sec  0.001 ms  0/149632 (0%)  
[  5]   2.00-3.00   sec   207 MBytes  1.73 Gbits/sec  0.001 ms  0/149557 (0%)  
[  5]   3.00-4.00   sec   207 MBytes  1.73 Gbits/sec  0.001 ms  0/149564 (0%)  
[  5]   4.00-5.00   sec   206 MBytes  1.73 Gbits/sec  0.001 ms  0/149487 (0%)  
[  5]   5.00-6.00   sec   206 MBytes  1.73 Gbits/sec  0.001 ms  0/149442 (0%)  
[  5]   6.00-7.00   sec   207 MBytes  1.73 Gbits/sec  0.001 ms  0/149544 (0%)  
[  5]   7.00-8.00   sec   206 MBytes  1.73 Gbits/sec  0.001 ms  0/149502 (0%)  
[  5]   8.00-9.00   sec   206 MBytes  1.73 Gbits/sec  0.001 ms  385/149713 (0.26%)  
[  5]   9.00-10.00  sec   207 MBytes  1.74 Gbits/sec  0.001 ms  0/149787 (0%)  
[  5]  10.00-10.00  sec   211 KBytes  1.12 Gbits/sec  0.001 ms  0/149 (0%)  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  2.02 GBytes  1.73 Gbits/sec  0.001 ms  385/1495870 (0.026%)  receiver
-----------------------------------------------------------
```

## **Known Issues**
 

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
