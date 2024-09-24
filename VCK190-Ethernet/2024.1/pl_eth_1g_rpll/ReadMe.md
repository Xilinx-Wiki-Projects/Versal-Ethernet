# Versal AXI 1G/2.5G Ethernet Subsystem 

## **Design Summary**

This project is about building a based AXI 1G/2.5G Ethernet Subsystem example design and testing it by targeting on VCK190 ACAP device. 

---

## **Required Hardware**

Here is a list of the required hardware to run the example design:
- VCK190 Eval Board
- 1G Supported Ethernet Cable
- 1000 Base-X SFP
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


---

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
