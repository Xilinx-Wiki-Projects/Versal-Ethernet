# pl_4x25g_mrmac - Versal MRMAC 

## Design Summary

This project utilizes Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem. This design provides 4 ethernet interfaces routed to QSFP a VPK180 board. 


## Required Hardware
- VPK180
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
- end0 -> 1G (PS-GEM)



 
