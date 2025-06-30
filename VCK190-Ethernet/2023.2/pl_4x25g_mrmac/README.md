# pl_4x25g_mrmac - Versal MRMAC - WITHOUT PTP

## Design Summary

This project utilizes Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem. This design provides 4 ethernet interfaces routed to QSFP a VCK190 board. 


## Required Hardware
- VCK190
- QSFP DAC
- 10G/25G capable link partner

## Build Instructions
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

## **Validation**

### Kernel:
**NOTE:** The interfaces are assigned as follows:

- eth0 -> 25G
- eth1 -> 25G
- eth2 -> 25G
- eth3 -> 25G
- eth4 -> 1G (PS-GEM)
- eth5 -> 1G (PS-GEM)



```
xilinx-vck190-20232:/home/petalinux# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:0/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:332374 errors:0 dropped:0 overruns:0 frame:0
          TX packets:332387 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:32742642 (31.2 MiB)  TX bytes:32745948 (31.2 MiB)

eth1      Link encap:Ethernet  HWaddr 00:0A:35:00:00:01  
          inet addr:192.168.4.2  Bcast:192.168.4.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:1/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:68121 errors:0 dropped:0 overruns:0 frame:0
          TX packets:68122 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:6687620 (6.3 MiB)  TX bytes:6688564 (6.3 MiB)
 
eth2      Link encap:Ethernet  HWaddr 00:0A:35:00:00:02  
          inet addr:192.168.3.2  Bcast:192.168.3.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:2/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:96594 errors:0 dropped:0 overruns:0 frame:0
          TX packets:96595 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:9478608 (9.0 MiB)  TX bytes:9479552 (9.0 MiB)

eth3      Link encap:Ethernet  HWaddr 00:0A:35:00:00:03  
          inet addr:192.168.2.101  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:3/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:88269 errors:0 dropped:0 overruns:0 frame:0
          TX packets:88263 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:8675104 (8.2 MiB)  TX bytes:8675668 (8.2 MiB)
 
eth0 
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
^C
--- 192.168.1.1 ping statistics ---
34523 packets transmitted, 34522 packets received, 0% packet loss
round-trip min/avg/max = 0.032/0.036/0.254 ms

eth1
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.4.2
PING 192.168.4.2 (192.168.4.2): 56 data bytes
^C
--- 192.168.4.2 ping statistics ---
32355 packets transmitted, 32354 packets received, 0% packet loss
round-trip min/avg/max = 0.035/0.044/0.346 ms

eth2
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.3.2  
PING 192.168.3.2 (192.168.3.2): 56 data bytes
^C
--- 192.168.3.2 ping statistics ---
40183 packets transmitted, 40182 packets received, 0% packet loss
round-trip min/avg/max = 0.034/0.043/0.160 ms

eth3
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.2.101
PING 192.168.2.101 (192.168.2.101): 56 data bytes
^C
--- 192.168.2.101 ping statistics ---
46858 packets transmitted, 46857 packets received, 0% packet loss
round-trip min/avg/max = 0.034/0.044/0.163 ms

```
### Performance:
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.
```
xilinx-vck190-20232:/home/petalinux# iperf3 -c 192.168.3.1
Connecting to host 192.168.3.1, port 5201
[  5] local 192.168.3.2 port 44644 connected to 192.168.3.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   247 MBytes  2.07 Gbits/sec  2417    139 KBytes       
[  5]   1.00-2.00   sec   239 MBytes  2.00 Gbits/sec  2790    106 KBytes       
[  5]   2.00-3.00   sec   240 MBytes  2.01 Gbits/sec  2454    117 KBytes       
[  5]   3.00-4.00   sec   240 MBytes  2.01 Gbits/sec  2448    123 KBytes       
[  5]   4.00-5.00   sec   238 MBytes  1.99 Gbits/sec  2877    112 KBytes       
[  5]   5.00-6.00   sec   240 MBytes  2.01 Gbits/sec  2194    126 KBytes       
[  5]   6.00-7.00   sec   233 MBytes  1.95 Gbits/sec  2943    129 KBytes       
[  5]   7.00-8.00   sec   239 MBytes  2.00 Gbits/sec  2917    109 KBytes       
[  5]   8.00-9.00   sec   239 MBytes  2.00 Gbits/sec  2660    126 KBytes       
[  5]   9.00-10.00  sec   240 MBytes  2.01 Gbits/sec  3203    129 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  2.34 GBytes  2.01 Gbits/sec  26903             sender
[  5]   0.00-10.00  sec  2.33 GBytes  2.01 Gbits/sec                  receiver
iperf Done.
```

### Known Issues
 
