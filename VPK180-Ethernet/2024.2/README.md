# VPK180 PL-based Ethernet v2024.2
This repository contains VPK180 design files for PL-based Ethernet designs.

Currently, there is 1 available design:

- **pl_4x25g_mrmac** - PL 10G/25G design utilizing the Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem.

---
## **What to Expect**
Each design directory contains the following general structure:

```
<design>
├── Hardware
│   ├── constraints
│   │   └── <design>.xdc
│   └── <IP patches, RTL modules, or other hardware files as needed>
├── README.md
├── Scripts
│   ├── <design>_bd.tcl
│   └── <design>_top.tcl
└── Software
    ├── Vitis
    ├── PetaLinux
    └── <or other software build files>

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
