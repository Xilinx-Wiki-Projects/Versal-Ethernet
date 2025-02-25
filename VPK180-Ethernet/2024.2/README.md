# VPK180 PL-based Ethernet v2024.2
This repository contains VPK180 design files for PL-based Ethernet designs.

Currently, there are 2 available designs:

- **pl_4x25g_mrmac** - PL 10G/25G design utilizing the Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem.

---
## **What to Expect**
Each design directory contains the following general structure:

```
<design>
├── Hardware
│   ├── constraints
│   │    └── <design>.xdc
│   └── <IP Patches and other RTL modules>
├── README.md
├── Scripts
│   ├── <design>_bd.tcl
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


