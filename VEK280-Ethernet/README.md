# VEK280 PS and PL based Ethernet
This repository contains VEK280 design files for PS and PL based Ethernet.

Currently, there are 1 available design:

**2024.1**
- **pl_eth_sgmii_rpll** - PL AXI 1G/2.5G Ethernet Subsystem over SGMII SFP plugged onto the VEK280 SFP cage.
A or SGMII IP in 1000BASEX mode on the VCK190 Production Board using SFP0. 
---
## **What to Expect**
Each design directory contains the following general structure:

```
<design>
├── Hardware
│   └── constraints
│       └── <design>.xdc
├── README.md
├── Scripts
│   ├── <design>_bd.tcl
│   └── <design>_top.tcl
└── Software
    ├── Vitis
    └── PetaLinux

````
Each design's `README.md` will provide:

- **Design Summary** - Brief summary of the design.

- **Required Hardware** - Listing of required hardware

- **Build Instructions** - Instructions on how to re-build the designs

- **Validation** - Setup and results of validation tests run against the design

- **Known Issues** - Current known issues with the design and/or workarounds for these issues.

---
## **Troubleshooting / Assistance**
If you find you are having difficulty bringing up one of the designs, or need some additional assistance, please reach out on the [Xilinx Community Forums](https://forums.xilinx.com).

Be sure to [search](https://forums.xilinx.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&inactive=false) the forums first before posting, as someone may already have the solution!

---
### Copyright 2020 Xilinx Inc.
### Copyright (C) 2022, Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
