# XXV_VERSAL_2023.2

## Design Summary

This project utilizes AXI 10G/25G Ethernet Subsystem configured for 10GBASE-R. This has been routed to the SFP cage on SFP0 for use on a VCK190 board. System is configured to use the VCK190 Si570 at 156.25MHz.

- `eth0` is configured as GEM0 routed via RGMII to the on-board PHY.
- `eth1` is configured as 10G/25G Ethernet Subsystem routed to SFP0.

## Required Hardware
- VCK190
- SFP supporting 10GBASE-R
- 10G capable link partner

## Build Instructions
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
TODO
```
### Performance:
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.
```
TODO
```

### Known Issues
In case petalinux booting fails in SD boot mode with the below log, press the push button switch (SW2) on the VCK190 board.

```
[9509.644]PMC EAM ERR1: 0x20000
[9512.478]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x20000. The corresponding Error ID: 0x11
[9549.658]PMC EAM ERR1: 0x20C00
[9549.706]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x400. The corresponding Error ID: 0xA
[9559.017]Received EAM error. ErrorNodeId: 0x28100000, Register Mask: 0x800. The corresponding Error ID: 0xB   
```
