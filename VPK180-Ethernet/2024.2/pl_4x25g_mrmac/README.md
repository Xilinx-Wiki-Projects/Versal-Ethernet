# pl_4x25g_mrmac - Versal MRMAC 

## **Design Summary**

This project utilizes Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem. This design provides 4 ethernet interfaces routed to QSFP in a VPK180 board. This design is capable of doing dynamic runtime rate switching from 25G to 10G to 25G using *ethtool*. 


## **Required Hardware**
- VPK180
- QSFP DAC
- 10G/25G capable link partner

## **Build Instructions**
### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux:**

Enter the 'Software/PetaLinux/' directory. From the command line run the following:

`petalinux-config --get-hw-description ../../Hardware/pre-built/ --silentconfig`

followed by:

Enable `iperf3` under user packages in `petalinux-config -c rootfs`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the PetaLinux/images/linux/ directory. To package these images for SD boot, run the following from the PetaLinux directory:

`petalinux-package --boot --u-boot --force`

Once packaged, the `boot.scr`, `BOOT.bin` and `image.ub` files (in the PetaLinux/images/linux directory) can be copied to an SD card, and used to boot.
---

## **Validation**

**NOTE:** The interfaces are assigned as follows:
- end0 -> 1G (PS-GEM)
- eth0 -> 25G
- eth1 -> 25G
- eth2 -> 25G
- eth3 -> 25G

```
Petalinux:/home/petalinux# ifconfig
Petalinux:/home/petalinux# ifconfig
end0      Link encap:Ethernet  HWaddr 1A:7E:74:8B:D5:F3  
          inet addr:10.10.71.1  Bcast:10.10.71.255  Mask:255.255.255.0
          inet6 addr: fe80::187e:74ff:fe8b:d5f3/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:102 errors:0 dropped:0 overruns:0 frame:0
          TX packets:134 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:13546 (13.2 KiB)  TX bytes:17471 (17.0 KiB)
          Interrupt:37 

eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:0/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:59851 errors:0 dropped:0 overruns:0 frame:0
          TX packets:59875 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5867021 (5.5 MiB)  TX bytes:5872232 (5.5 MiB)

eth1      Link encap:Ethernet  HWaddr 00:0A:35:00:00:01  
          inet addr:192.168.2.2  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:1/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:54234 errors:0 dropped:0 overruns:0 frame:0
          TX packets:54243 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5318388 (5.0 MiB)  TX bytes:5320104 (5.0 MiB)

eth2      Link encap:Ethernet  HWaddr 00:0A:35:00:00:02  
          inet addr:192.168.3.2  Bcast:192.168.3.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:2/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:55747 errors:0 dropped:0 overruns:0 frame:0
          TX packets:55785 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5465035 (5.2 MiB)  TX bytes:5471102 (5.2 MiB)

eth3      Link encap:Ethernet  HWaddr 00:0A:35:00:00:03  
          inet addr:192.168.4.2  Bcast:192.168.4.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:3/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:54192 errors:0 dropped:0 overruns:0 frame:0
          TX packets:54215 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5314667 (5.0 MiB)  TX bytes:5317204 (5.0 MiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:12 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:1344 (1.3 KiB)  TX bytes:1344 (1.3 KiB)
```

# Ethtool showing *25G*
```
Petalinux:/home/petalinux# ethtool eth0
Settings for eth0:
        Supported ports: [  ]
        Supported link modes:   Not reported
        Supported pause frame use: No
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 25000Mb/s
        Duplex: Half
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Link detected: yes
```

# Ping test
```
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth0 192.168.1.1 
pPING 192.168.1.1 (192.168.1.1): 56 data bytes
ing -A -q -w 3 -I eth1 192.168.2.1 
ping -A -q -w 3 -I eth2 192.168.3.1 
ping -A -q -w 3 -I eth3 192.168.4.1 

--- 192.168.1.1 ping statistics ---
59825 packets transmitted, 59825 packets received, 0% packet loss
round-trip min/avg/max = 0.042/0.049/1.308 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth1 192.168.2.1 
PING 192.168.2.1 (192.168.2.1): 56 data bytes

--- 192.168.2.1 ping statistics ---
54194 packets transmitted, 54194 packets received, 0% packet loss
round-trip min/avg/max = 0.049/0.055/0.426 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth2 192.168.3.1 
PING 192.168.3.1 (192.168.3.1): 56 data bytes

--- 192.168.3.1 ping statistics ---
55730 packets transmitted, 55730 packets received, 0% packet loss
round-trip min/avg/max = 0.042/0.053/4.019 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth3 192.168.4.1 
PING 192.168.4.1 (192.168.4.1): 56 data bytes

--- 192.168.4.1 ping statistics ---
54159 packets transmitted, 54159 packets received, 0% packet loss
round-trip min/avg/max = 0.044/0.055/0.750 ms
```
# iperf3 test
*Client side* ``` iperf3 -c 192.168.1.1 -I eth0 -u -b 10G ```
*Server side:*
```
Server listening on 5201 (test #1)
-----------------------------------------------------------
Accepted connection from 192.168.1.2, port 58680                                                                                                        
[  5] local 192.168.1.1 port 5201 connected to 192.168.1.2 port 43002                                                                           
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams                                                      
[  5]   0.00-1.00   sec   155 MBytes  1.30 Gbits/sec  0.004 ms  159/112216 (0.14%)                                       
[  5]   1.00-2.00   sec   155 MBytes  1.30 Gbits/sec  0.005 ms  0/112266 (0%)                                         
[  5]   2.00-3.00   sec   155 MBytes  1.30 Gbits/sec  0.005 ms  0/112249 (0%)                                              
[  5]   3.00-4.00   sec   155 MBytes  1.30 Gbits/sec  0.005 ms  0/112301 (0%)                                              
[  5]   4.00-5.00   sec   155 MBytes  1.30 Gbits/sec  0.004 ms  0/112242 (0%)                                              
[  5]   5.00-6.00   sec   155 MBytes  1.30 Gbits/sec  0.004 ms  0/112208 (0%)                                              
[  5]   6.00-7.00   sec   155 MBytes  1.30 Gbits/sec  0.004 ms  0/112201 (0%)                                              
[  5]   7.00-8.00   sec   155 MBytes  1.30 Gbits/sec  0.003 ms  0/112178 (0%)                                              
[  5]   8.00-9.00   sec   155 MBytes  1.30 Gbits/sec  0.005 ms  0/112233 (0%)                                              
[  5]   9.00-10.00  sec   155 MBytes  1.30 Gbits/sec  0.006 ms  0/112060 (0%)                                              
- - - - - - - - - - - - - - - - - - - - - - - - -                               
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams                                                                          
[  5]   0.00-10.00  sec  1.51 GBytes  1.30 Gbits/sec  0.006 ms  159/1122154 (0.014%)  receiver                                       
-----------------------------------------------------------                                            
```

# Rate Change
- *Bring the link down*
```
Petalinux:/home/petalinux# ifconfig eth0 down
Petalinux:/home/petalinux# ifconfig eth1 down
Petalinux:/home/petalinux# ifconfig eth2 down
Petalinux:/home/petalinux# ifconfig eth3 down
```
- *Use ethtool to change rate*
```
Petalinux:/home/petalinux# ethtool -s eth0 autoneg off speed 10000 duplex full
etPetalinux:/home/petalinux# ethtool -s eth1 autoneg off speed 10000 duplex full
etPetalinux:/home/petalinux# ethtool -s eth2 autoneg off speed 10000 duplex full
etPetalinux:/home/petalinux# ethtool -s eth3 autoneg off speed 10000 duplex full
```
- *Bring link up*
``` 
Petalinux:/home/petalinux# ifconfig eth0 up
[ 1307.699546] xilinx_axienet a4000000.mrmac eth0: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth1 up
[ 1307.813265] xilinx_axienet a4001000.mrmac eth1: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth2 up
[ 1307.926622] xilinx_axienet a4002000.mrmac eth2: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth3 up
[ 1308.040560] xilinx_axienet a4003000.mrmac eth3: MRMAC setup at 10000
```
- *Issue RX Reset*
```
Petalinux:/home/petalinux# devmem 0xa4060008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4060008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003

Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4070008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4070008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003

Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4080008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4080008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              

0x00000003
Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4090008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4090008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003
```
- *Confirm using Ethtool*
```
Petalinux:/home/petalinux# ethtool eth0
Settings for eth0:
        Supported ports: [  ]
        Supported link modes:   Not reported
        Supported pause frame use: No
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Half
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Link detected: yes
```
- *Ping test at 10G*
```
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth0 192.168.1.1 
pPING 192.168.1.1 (192.168.1.1): 56 data bytes
ing -A -q -w 3 -I eth1 192.168.2.1 
ping -A -q -w 3 -I eth2 192.168.3.1 
ping -A -q -w 3 -I eth3 192.168.4.1

--- 192.168.1.1 ping statistics ---
60742 packets transmitted, 60742 packets received, 0% packet loss
round-trip min/avg/max = 0.039/0.049/0.208 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth1 192.168.2.1 
PING 192.168.2.1 (192.168.2.1): 56 data bytes

--- 192.168.2.1 ping statistics ---
54114 packets transmitted, 54114 packets received, 0% packet loss
round-trip min/avg/max = 0.044/0.055/0.120 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth2 192.168.3.1 
PING 192.168.3.1 (192.168.3.1): 56 data bytes

--- 192.168.3.1 ping statistics ---
54882 packets transmitted, 54882 packets received, 0% packet loss
round-trip min/avg/max = 0.043/0.054/0.240 ms
Petalinux:/home/petalinux# ping -A -q -w 3 -I eth3 192.168.4.1
PING 192.168.4.1 (192.168.4.1): 56 data bytes

--- 192.168.4.1 ping statistics ---
56838 packets transmitted, 56838 packets received, 0% packet loss
round-trip min/avg/max = 0.043/0.052/0.173 ms
```
---
# **Known Issues**
In some device families, multiple RX resets may be required to bring the link up. If a user observes the following message but cannot ping, they can issue an RX reset by writing to gt_ctrl_common register.

*Kernel log shows driver has set the right rate. However, status register shows no link.*
```
[ 1307.699546] xilinx_axienet a4000000.mrmac eth0: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth1 up
[ 1307.813265] xilinx_axienet a4001000.mrmac eth1: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth2 up
[ 1307.926622] xilinx_axienet a4002000.mrmac eth2: MRMAC setup at 10000
Petalinux:/home/petalinux# ifconfig eth3 up
[ 1308.040560] xilinx_axienet a4003000.mrmac eth3: MRMAC setup at 10000

Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744          
0x00000180
```
### Issue RX Reset
```
Petalinux:/home/petalinux# devmem 0xa4060008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4060008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003

Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4070008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4070008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003

Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4080008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4080008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              

0x00000003
Petalinux:/home/petalinux# 
Petalinux:/home/petalinux# devmem 0xa4090008 32 0x2 
Petalinux:/home/petalinux# devmem 0xa4090008 32 0x0 
Petalinux:/home/petalinux# devmem 0xa4000744 32 0xffffffff
Petalinux:/home/petalinux# devmem 0xa4000744              
0x00000003
```
---
## **Troubleshooting / Assistance**
If you find you are having difficulty bringing up one of the designs, or need some additional assistance, please reach out on the [Xilinx Community Forums](https://forums.xilinx.com).

Be sure to [search](https://forums.xilinx.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&inactive=false) the forums first before posting, as someone may already have the solution!
---
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
 
