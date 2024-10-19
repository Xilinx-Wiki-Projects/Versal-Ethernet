# Build Instructions to create ZynqMP full bitstream loading firmware recipes

* [Introduction](#introduction)
* [How to create a firmware recipe app](#how-to-create-a-firmware-recipe-app)
* [Test Procedure on Target](#test-procedure-on-target)
  * [Loading PL bitstream and dt overlay](#loading-pl-bitstream-and-dt-overlay)
  * [Testing PL functionality](#testing-pl-functionality)
  * [Unloading PL bitstream and dt overlay](#unloading-pl-bitstream-and-dt-overlay)
* [References](#references)

## Introduction
This readme describes the build instructions to create firmware recipes using
dfx_dtg_zynqmp_full.bbclass for ZynqMP full bitstream loading configuration.

> **Note:** Refer https://github.com/Xilinx/dfx-mgr/blob/master/README.md for
> shell.json and accel.json file content.

* **ZynqMP**:
  * Design: Vivado flat design.
    * Input files to firmware recipes: .xsa, .dtsi (optional: to add pl custom dt
      nodes), shell.json (optional) and .xclbin (optional).
    * Usage Examples:
```
SRC_URI = " \
    file://<flat_design_pl>.xsa \
    file://<flat_design_pl_custom>.dtsi \
    file://shell.json \
    file://<flat_design_pl>.xclbin \
    "
```

---

## How to create a firmware recipe app

1. Follow [Building Instructions](https://github.com/Xilinx/meta-xilinx/blob/master/README.building.md) upto step 4.
2. Create recipes-firmware directory in meta layer and copy the .xsa, .dtsi,
   .json and .xclbin file to these directories.
```
$ mkdir -p <meta-layer>/recipes-fimrware/<recipes-firmware-app>/files
$ cp -r <path-to-files>/*.{xsa, dtsi, shell.json and .xclbin} <meta-layer>/recipes-fimrware/<firmware-app-name>/files
```
3. Now create the recipes for full bitstream loading firmware app using recipetool.
```
$ recipetool create -o <meta-layer>/recipes-fimrware/<firmware-app-name>/firmware-app-name.bb file:///<meta-layer>/recipes-fimrware/<firmware-app-name>/files 
```
4. Modify the recipe and inherit dfx_dtg_zynqmp_full bbclass as shown below.
```
SUMMARY = "ZynqMP Full Bitstream loading firmware app using dfx_dtg_zynqmp_full bbclass"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit dfx_dtg_zynqmp_full

SRC_URI = "\
    file://zcu111_pl_demo.xsa \
    file://shell.json \
    file://zcu111-pl-demo.dtsi \
    "

COMPATIBLE_MACHINE:zynqmp = "zynqmp"
```
5. Add firmware-recipe app to image and enable fpga-overlay machine features to
   local.conf as shown below.
> **Note:** fpga-manager-script provides fpgautil tool to load .bit.bin and dtbo
> at runtime linux.
```
MACHINE_FEATURES += "fpga-overlay"
IMAGE_INSTALL:append = " \
  firmware-app-name \
  fpga-manager-script \
  "
```
6. Follow [Building Instructions](https://github.com/Xilinx/meta-xilinx/blob/master/README.building.md) and continue from step 5.
7. Once images are built firmware app files will be installed on target_rootfs.
```
# <target_rootfs>/lib/firmware/xilinx/firmware-app-name
```
---

## Test Procedure on Target
* Once Linux boots on target, use fpgautil command to load .bit.bin and
  corresponding dt overlay as shown below.
> **Note:** firmware can be loaded only with sudo or root permissions.
---

### Loading PL bitstream and dt overlay

* ZynqMP
```
yocto-zynqmp-generic-20231:~$ sudo su
yocto-zynqmp-generic-20231:/home/petalinux# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
 11:      13309      13021      13673      14170     GICv2  30 Level     arch_timer
 14:          0          0          0          0     GICv2  67 Level     zynqmp_ipi
 15:          0          0          0          0     GICv2 175 Level     arm-pmu
 16:          0          0          0          0     GICv2 176 Level     arm-pmu
 17:          0          0          0          0     GICv2 177 Level     arm-pmu
 18:          0          0          0          0     GICv2 178 Level     arm-pmu
 19:          0          0          0          0     GICv2  58 Level     ffa60000.rtc
 20:          0          0          0          0     GICv2  59 Level     ffa60000.rtc
 21:          0          0          0          0     GICv2  42 Level     ff960000.memory-controller
 22:          0          0          0          0     GICv2  88 Level     ams-irq
 23:          0          0          0          0     GICv2 155 Level     axi-pmon, axi-pmon
 24:        327          0          0          0     GICv2  53 Level     xuartps
 27:          0          0          0          0     GICv2 156 Level     zynqmp-dma
 28:          0          0          0          0     GICv2 157 Level     zynqmp-dma
 29:          0          0          0          0     GICv2 158 Level     zynqmp-dma
 30:          0          0          0          0     GICv2 159 Level     zynqmp-dma
 31:          0          0          0          0     GICv2 160 Level     zynqmp-dma
 32:          0          0          0          0     GICv2 161 Level     zynqmp-dma
 33:          0          0          0          0     GICv2 162 Level     zynqmp-dma
 34:          0          0          0          0     GICv2 163 Level     zynqmp-dma
 35:          0          0          0          0     GICv2 109 Level     zynqmp-dma
 36:          0          0          0          0     GICv2 110 Level     zynqmp-dma
 37:          0          0          0          0     GICv2 111 Level     zynqmp-dma
 38:          0          0          0          0     GICv2 112 Level     zynqmp-dma
 39:          0          0          0          0     GICv2 113 Level     zynqmp-dma
 40:          0          0          0          0     GICv2 114 Level     zynqmp-dma
 41:          0          0          0          0     GICv2 115 Level     zynqmp-dma
 42:          0          0          0          0     GICv2 116 Level     zynqmp-dma
 43:          0          0          0          0     GICv2 154 Level     fd4c0000.dma-controller
 44:       5938          0          0          0     GICv2  47 Level     ff0f0000.spi
 45:         76          0          0          0     GICv2  95 Level     eth0, eth0
 46:          0          0          0          0     GICv2  57 Level     axi-pmon, axi-pmon
 47:       4802          0          0          0     GICv2  49 Level     cdns-i2c
 48:        501          0          0          0     GICv2  50 Level     cdns-i2c
 50:          0          0          0          0     GICv2  84 Edge      ff150000.watchdog
 51:          0          0          0          0     GICv2 151 Level     fd4a0000.display
 52:        548          0          0          0     GICv2  81 Level     mmc0
 53:          0          0          0          0     GICv2 165 Level     ahci-ceva[fd0c0000.ahci]
 54:          0          0          0          0     GICv2  97 Level     xhci-hcd:usb1
 55:          0          0          0          0  zynq-gpio  22 Edge      sw19
IPI0:        64         25         87         38       Rescheduling interrupts
IPI1:      1933       6579       1096       5686       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast interrupts
IPI5:         0          0          0          0       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
yocto-zynqmp-generic-20231:/home/petalinux# tree /lib/firmware/
/lib/firmware/
`-- xilinx
    `-- zcu111-pl-demo
        |-- zcu111-pl-demo.bit.bin
        `-- zcu111-pl-demo.dtbo

2 directories, 2 files
yocto-zynqmp-generic-20231:/home/petalinux# fpgautil -b /lib/firmware/xilinx/zcu111-pl-demo/zcu111-pl-demo.bit -o /lib/firmware/xilinx/zcu111-pl-demo/zcu111-pl-demo.dtbo
[   91.039773] fpga_manager fpga0: writing zcu111-pl-demo.bit to Xilinx ZynqMP FPGA Manager
[   91.528214] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/firmware-name
[   91.538354] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/pid
[   91.547598] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/resets
[   91.557087] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/uid
[   91.566804] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/afi0
[   91.576312] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/clocking0
[   91.586255] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/axi_gpio_0
[   91.596280] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/misc_clk_0
[   91.606300] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/axi_gpio_1
[   91.616325] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/axi_gpio_2
[   91.626342] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/axi_uartlite_0
[   91.636705] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /__symbols__/ddr4_0
[   91.661849] gpio gpiochip3: (a0000000.gpio): not an immutable chip, please consider fixing it!
[   91.662020] gpio gpiochip4: (a0010000.gpio): not an immutable chip, please consider fixing it!
[   91.863492] a0030000.serial: ttyUL0 at MMIO 0xa0030000 (irq = 58, base_baud = 0) is a uartlite
[   91.876674] uartlite a0030000.serial: Runtime PM usage count underflow!
[   91.906539] input: pl-gpio-keys as /devices/platform/pl-gpio-keys/input/input1
Time taken to load BIN is 901.000000 Milli Seconds
BIN FILE loaded through FPGA manager successfully
yocto-zynqmp-generic-20231:/home/petalinux#
```

---

### Testing PL functionality

* This examples uses PL GPIO DIP switches and Push buttons to capture interrupts.
* Verify PL GPIO DIP switches and Push buttons are registered.
* Move the DIP Switches ON/OFF and verify the interrupt counts.

* ZynqMP
```
yocto-zynqmp-generic-20231:/home/petalinux# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
 11:      23303      22971      24203      24990     GICv2  30 Level     arch_timer
 14:          0          0          0          0     GICv2  67 Level     zynqmp_ipi
 15:          0          0          0          0     GICv2 175 Level     arm-pmu
 16:          0          0          0          0     GICv2 176 Level     arm-pmu
 17:          0          0          0          0     GICv2 177 Level     arm-pmu
 18:          0          0          0          0     GICv2 178 Level     arm-pmu
 19:          0          0          0          0     GICv2  58 Level     ffa60000.rtc
 20:          0          0          0          0     GICv2  59 Level     ffa60000.rtc
 21:          0          0          0          0     GICv2  42 Level     ff960000.memory-controller
 22:          0          0          0          0     GICv2  88 Level     ams-irq
 23:          0          0          0          0     GICv2 155 Level     axi-pmon, axi-pmon
 24:        515          0          0          0     GICv2  53 Level     xuartps
 27:          0          0          0          0     GICv2 156 Level     zynqmp-dma
 28:          0          0          0          0     GICv2 157 Level     zynqmp-dma
 29:          0          0          0          0     GICv2 158 Level     zynqmp-dma
 30:          0          0          0          0     GICv2 159 Level     zynqmp-dma
 31:          0          0          0          0     GICv2 160 Level     zynqmp-dma
 32:          0          0          0          0     GICv2 161 Level     zynqmp-dma
 33:          0          0          0          0     GICv2 162 Level     zynqmp-dma
 34:          0          0          0          0     GICv2 163 Level     zynqmp-dma
 35:          0          0          0          0     GICv2 109 Level     zynqmp-dma
 36:          0          0          0          0     GICv2 110 Level     zynqmp-dma
 37:          0          0          0          0     GICv2 111 Level     zynqmp-dma
 38:          0          0          0          0     GICv2 112 Level     zynqmp-dma
 39:          0          0          0          0     GICv2 113 Level     zynqmp-dma
 40:          0          0          0          0     GICv2 114 Level     zynqmp-dma
 41:          0          0          0          0     GICv2 115 Level     zynqmp-dma
 42:          0          0          0          0     GICv2 116 Level     zynqmp-dma
 43:          0          0          0          0     GICv2 154 Level     fd4c0000.dma-controller
 44:       5938          0          0          0     GICv2  47 Level     ff0f0000.spi
 45:        110          0          0          0     GICv2  95 Level     eth0, eth0
 46:          0          0          0          0     GICv2  57 Level     axi-pmon, axi-pmon
 47:       4802          0          0          0     GICv2  49 Level     cdns-i2c
 48:        501          0          0          0     GICv2  50 Level     cdns-i2c
 50:          0          0          0          0     GICv2  84 Edge      ff150000.watchdog
 51:          0          0          0          0     GICv2 151 Level     fd4a0000.display
 52:        548          0          0          0     GICv2  81 Level     mmc0
 53:          0          0          0          0     GICv2 165 Level     ahci-ceva[fd0c0000.ahci]
 54:          0          0          0          0     GICv2  97 Level     xhci-hcd:usb1
 55:          0          0          0          0  zynq-gpio  22 Edge      sw19
 59:          0          0          0          0  gpio-xilinx   4 Edge      PL_GPIO_PB_SW9_N
 60:          0          0          0          0  gpio-xilinx   3 Edge      PL_GPIO_PB_SW12_E
 61:          0          0          0          0  gpio-xilinx   2 Edge      PL_GPIO_PB_SW13_S
 62:          0          0          0          0  gpio-xilinx   1 Edge      PL_GPIO_PB_SW10_W
 63:          0          0          0          0  gpio-xilinx   0 Edge      PL_GPIO_PB_SW11_C
 64:          0          0          0          0  gpio-xilinx   7 Edge      PL_GPIO_DIP_SW7
 65:          0          0          0          0  gpio-xilinx   6 Edge      PL_GPIO_DIP_SW6
 66:          0          0          0          0  gpio-xilinx   5 Edge      PL_GPIO_DIP_SW5
 67:          0          0          0          0  gpio-xilinx   4 Edge      PL_GPIO_DIP_SW4
 68:          0          0          0          0  gpio-xilinx   3 Edge      PL_GPIO_DIP_SW3
 69:          0          0          0          0  gpio-xilinx   2 Edge      PL_GPIO_DIP_SW2
 70:          0          0          0          0  gpio-xilinx   1 Edge      PL_GPIO_DIP_SW1
 71:          0          0          0          0  gpio-xilinx   0 Edge      PL_GPIO_DIP_SW0
IPI0:        64         25         87         38       Rescheduling interrupts
IPI1:      2066       6747       1212       5791       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast interrupts
IPI5:         0          0          0          0       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
yocto-zynqmp-generic-20231:/home/petalinux# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
 11:      28169      27725      29250      30190     GICv2  30 Level     arch_timer
 14:          0          0          0          0     GICv2  67 Level     zynqmp_ipi
 15:          0          0          0          0     GICv2 175 Level     arm-pmu
 16:          0          0          0          0     GICv2 176 Level     arm-pmu
 17:          0          0          0          0     GICv2 177 Level     arm-pmu
 18:          0          0          0          0     GICv2 178 Level     arm-pmu
 19:          0          0          0          0     GICv2  58 Level     ffa60000.rtc
 20:          0          0          0          0     GICv2  59 Level     ffa60000.rtc
 21:          0          0          0          0     GICv2  42 Level     ff960000.memory-controller
 22:          0          0          0          0     GICv2  88 Level     ams-irq
 23:          0          0          0          0     GICv2 155 Level     axi-pmon, axi-pmon
 24:        603          0          0          0     GICv2  53 Level     xuartps
 27:          0          0          0          0     GICv2 156 Level     zynqmp-dma
 28:          0          0          0          0     GICv2 157 Level     zynqmp-dma
 29:          0          0          0          0     GICv2 158 Level     zynqmp-dma
 30:          0          0          0          0     GICv2 159 Level     zynqmp-dma
 31:          0          0          0          0     GICv2 160 Level     zynqmp-dma
 32:          0          0          0          0     GICv2 161 Level     zynqmp-dma
 33:          0          0          0          0     GICv2 162 Level     zynqmp-dma
 34:          0          0          0          0     GICv2 163 Level     zynqmp-dma
 35:          0          0          0          0     GICv2 109 Level     zynqmp-dma
 36:          0          0          0          0     GICv2 110 Level     zynqmp-dma
 37:          0          0          0          0     GICv2 111 Level     zynqmp-dma
 38:          0          0          0          0     GICv2 112 Level     zynqmp-dma
 39:          0          0          0          0     GICv2 113 Level     zynqmp-dma
 40:          0          0          0          0     GICv2 114 Level     zynqmp-dma
 41:          0          0          0          0     GICv2 115 Level     zynqmp-dma
 42:          0          0          0          0     GICv2 116 Level     zynqmp-dma
 43:          0          0          0          0     GICv2 154 Level     fd4c0000.dma-controller
 44:       5938          0          0          0     GICv2  47 Level     ff0f0000.spi
 45:        134          0          0          0     GICv2  95 Level     eth0, eth0
 46:          0          0          0          0     GICv2  57 Level     axi-pmon, axi-pmon
 47:       4802          0          0          0     GICv2  49 Level     cdns-i2c
 48:        501          0          0          0     GICv2  50 Level     cdns-i2c
 50:          0          0          0          0     GICv2  84 Edge      ff150000.watchdog
 51:          0          0          0          0     GICv2 151 Level     fd4a0000.display
 52:        548          0          0          0     GICv2  81 Level     mmc0
 53:          0          0          0          0     GICv2 165 Level     ahci-ceva[fd0c0000.ahci]
 54:          0          0          0          0     GICv2  97 Level     xhci-hcd:usb1
 55:          0          0          0          0  zynq-gpio  22 Edge      sw19
 59:          2          0          0          0  gpio-xilinx   4 Edge      PL_GPIO_PB_SW9_N
 60:          4          0          0          0  gpio-xilinx   3 Edge      PL_GPIO_PB_SW12_E
 61:          2          0          0          0  gpio-xilinx   2 Edge      PL_GPIO_PB_SW13_S
 62:          2          0          0          0  gpio-xilinx   1 Edge      PL_GPIO_PB_SW10_W
 63:          2          0          0          0  gpio-xilinx   0 Edge      PL_GPIO_PB_SW11_C
 64:          2          0          0          0  gpio-xilinx   7 Edge      PL_GPIO_DIP_SW7
 65:          2          0          0          0  gpio-xilinx   6 Edge      PL_GPIO_DIP_SW6
 66:          4          0          0          0  gpio-xilinx   5 Edge      PL_GPIO_DIP_SW5
 67:          2          0          0          0  gpio-xilinx   4 Edge      PL_GPIO_DIP_SW4
 68:          2          0          0          0  gpio-xilinx   3 Edge      PL_GPIO_DIP_SW3
 69:          2          0          0          0  gpio-xilinx   2 Edge      PL_GPIO_DIP_SW2
 70:          2          0          0          0  gpio-xilinx   1 Edge      PL_GPIO_DIP_SW1
 71:          2          0          0          0  gpio-xilinx   0 Edge      PL_GPIO_DIP_SW0
IPI0:        64         26         87         38       Rescheduling interrupts
IPI1:      2163       6791       1243       5866       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast interrupts
IPI5:         0          0          0          0       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
yocto-zynqmp-generic-20231:/home/petalinux#
```
---

### Unloading PL bitstream and dt overlay
* ZynqMP
```
yocto-zynqmp-generic-20231:/home/petalinux# fpgautil -R
```

---

## References
* https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841847/Solution+ZynqMP+PL+Programming
