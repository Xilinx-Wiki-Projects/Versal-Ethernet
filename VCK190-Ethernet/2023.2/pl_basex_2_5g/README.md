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
