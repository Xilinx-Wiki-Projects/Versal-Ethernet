# Versal AXI 1G/2.5G Ethernet Subsystem

## **Design Summary**
This project is about building Versal based AXI 1G/2.5G Ethernet Subsystem and testing it by targeting on VCK190 ACAP device to run 2500-Basex design.

## **Required Hardware**
Here is a list of the required hardware to run the example design:

- VCK190 Eval Board
- 2.5G Ethernet Cable
- A host machine that VCK190 is connected to through the cable

## **Build Instructions**
### **Vivado:**
Enter the `Scripts` directory. From the command line run the following:
`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware/pl_basex_2_5g_hw` directory.

### **Petalinux:**
Enter the `Software` directory. From the command line run the following:
`make all`

This will build the petalinux images and copy them to the `sd_card` directory. 
