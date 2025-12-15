# VCK190 PS and PL based Ethernet
This repository contains VCK190 design files for PS and PL based Ethernet.

Currently, there are 2 available design versions:

**2020.2**
- **ps_mio_eth_1g** - PS 10/100/1000BASE-T design utilizing the GEM over MIO to the TI PHY onboard on the VCK190 ES board.
- **pl_eth_1g** - PL AXI 1G/2.5G Ethernet Subsystem over SGMII SFP plugged onto the VCK190 SFP cage.

**2021.1**
- **ps_mio_eth_1g_prod** - PS 10/100/1000BASE-T design utilizing the GEM over MIO to the TI PHY onboard on the VCK190 Production Board.

**2022.1**
- **ps_emio_basex_1g** - PS EMIO 1000BASEX design utilizing the GEM over EMIO to connect to PCS/PMA or SGMII IP in 1000BASEX mode on the VCK190 Production Board using SFP0.

**2023.2**
- **pl_basex_2_5g** - PL 2.5G 2500 BaseX design utilizing the AXI 1G/2.5G Ethernet Subsystem.
- **pl_eth_10g** - PL 10G design utilizing the 10G/25G High Speed Ethernet Subsystem.
- **pl_4x25g_mrmac** - PL 4x25G design utilizing the Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem.

**2024.1**
- **pl_eth_1g_rpll** - PL AXI 1G/2.5G Ethernet Subsystem over SGMII using RPLL.

**2024.2**
- **pl_eth_2p5g_1g** - PL 2.5G/1G Ethernet design.
- **pl_4x25g_mrmac** - PL 4x25G MRMAC design utilizing the Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem.
- **pl_1x100g_mrmac** - PL 1x100G MRMAC design.
---
## **What to Expect**
Each design directory contains the following general structure (note: directory names may vary between Hardware/Scripts/Software or hardware/scripts/software depending on the design):

```
<design>
├── Hardware (or hardware)
│   ├── constraints
│   │   └── <design>.xdc
│   └── <IP cores, RTL modules, or other hardware files as needed>
├── README.md
├── Scripts (or scripts)
│   ├── <design>_bd.tcl
│   └── <design>_top.tcl
└── Software (or software)
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
