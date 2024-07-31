
################################################################
# This is a generated script based on design: xxv_versal
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xxv_versal_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvm1802-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vmk180:part0:3.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xxv_versal

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:xxv_ethernet:4.1\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:bufg_gt:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:smartconnect:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ch0_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c0 ]

  set ch1_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c0 ]

  set lpddr4_sma_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200321000} \
   ] $lpddr4_sma_clk1

  set xxv_ethernet_0_diff_gt_ref_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 xxv_ethernet_0_diff_gt_ref_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $xxv_ethernet_0_diff_gt_ref_clock

  set GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial ]


  # Create ports

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_c0} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_c0} \
    CONFIG.MC1_FLIPPED_PINOUT {true} \
    CONFIG.MC_CHANNEL_INTERLEAVING {true} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_EN_INTR_RESP {TRUE} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.NUM_CLKS {9} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {9} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_sma_clk1} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S08_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Enable} \
    CONFIG.DEBUG_MODE {Custom} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      CLOCK_MODE {Custom} \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      DESIGN_MODE {1} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_OSPI_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_QSPI_COHERENCY {0} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_COHERENCY {0} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
      PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 0} {CH9 0}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE_EP_RESET1_IO {PMC_MIO 38} \
      PS_PCIE_EP_RESET2_IO {PMC_MIO 39} \
      PS_PCIE_RESET {{ENABLE 1}} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_M_AXI_FPD {0} \
      PS_USE_M_AXI_LPD {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create instance: xxv_ethernet_0, and set properties
  set xxv_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xxv_ethernet:4.1 xxv_ethernet_0 ]
  set_property -dict [list \
    CONFIG.BASE_R_KR {BASE-R} \
    CONFIG.GT_REF_CLK_FREQ {156.25} \
    CONFIG.LINE_RATE {10} \
  ] $xxv_ethernet_0


  # Create instance: gt_quad_base_0, and set properties
  set gt_quad_base_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base_0 ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {100.0} \
    CONFIG.CHANNEL_ORDERING {/gt_quad_base_0/TX2_GT_IP_Interface xxv_versal_xxv_ethernet_0_1_0./xxv_ethernet_0/gt_tx_serdes_interface_0.0 /gt_quad_base_0/RX2_GT_IP_Interface xxv_versal_xxv_ethernet_0_1_0./xxv_ethernet_0/gt_rx_serdes_interface_0.0}\
\
    CONFIG.GT_TYPE {GTY} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {unconnected {RX0 RX1 RX3 TX0 TX1 TX3} PROT0 {RX2 TX2}} GT_TYPE GTY REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 10.3125 TX_PLL_TYPE\
RPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING 64B66B_ASYNC TX_USER_DATA_WIDTH\
64 TX_INT_DATA_WIDTH 64 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 156.250\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET GTY-Ethernet_10G\
RX_PAM_SEL NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET Ethernet_10G RX_LINE_RATE 10.3125 RX_PLL_TYPE RPLL RX_REFCLK_FREQUENCY\
156.25 RX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING 64B66B_ASYNC RX_USER_DATA_WIDTH 64 RX_INT_DATA_WIDTH\
64 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE RPLL RXPROGDIV_FREQ_VAL 156.250 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 312.500 INS_LOSS_NYQ 20 RX_EQ_MODE\
AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CB_K 00000000 RX_CB_DISP 00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false\
RX_CB_MASK_0_2 false RX_CB_VAL_0_2 00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0\
00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2\
false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT\
0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00000000 RX_CC_K_0_0\
false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3\
false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 00000000 RX_CC_K_1_1\
false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ\
250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 6.1862627 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE\
RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS {NA NA} \
    CONFIG.PROT0_LR2_SETTINGS {NA NA} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {1} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX2} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX2} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/gt_quad_base_0 {/gt_quad_base_0 undef,undef,xxv_versal_xxv_ethernet_0_1_0.IP_CH0,undef MSTRCLK 0,0,1,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/gt_quad_base_0\
{/gt_quad_base_0 undef,undef,xxv_versal_xxv_ethernet_0_1_0.IP_CH0,undef MSTRCLK 0,0,1,0 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {{/xxv_ethernet_0_diff_gt_ref_clock_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK1_RPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {unconnected} \
    CONFIG.RX1_LANE_SEL {unconnected} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {unconnected} \
    CONFIG.TX0_LANE_SEL {unconnected} \
    CONFIG.TX1_LANE_SEL {unconnected} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {unconnected} \
  ] $gt_quad_base_0

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.GT_TYPE.VALUE_MODE {auto} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_base_0


  # Create instance: bufg_gt, and set properties
  set bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt ]

  # Create instance: bufg_gt_1, and set properties
  set bufg_gt_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt_1 ]

  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_1


  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_include_sg {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {16} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
  ] $axi_dma_0


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_3


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {32768} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.IS_ACLK_ASYNC {0} \
  ] $axis_data_fifo_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property CONFIG.C_EXT_RST_WIDTH {1} $proc_sys_reset_1


  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]
  set_property CONFIG.C_EXT_RST_WIDTH {1} $proc_sys_reset_2


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_5


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {32768} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.IS_ACLK_ASYNC {0} \
  ] $axis_data_fifo_1


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {156.25,100.000,350,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,true,true,false,false,false,false} \
  ] $clk_wizard_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_noc_0/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_noc_0/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_dma_0/M_AXI_SG] [get_bd_intf_pins axi_noc_0/S06_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins xxv_ethernet_0/axis_tx_0]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins axis_data_fifo_1/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net gt_quad_base_0_GT_Serial [get_bd_intf_pins gt_quad_base_0/GT_Serial] [get_bd_intf_ports GT_Serial]
  connect_bd_intf_net -intf_net lpddr4_sma_clk1_1 [get_bd_intf_ports lpddr4_sma_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_LPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_LPD]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S05_AXI]
  connect_bd_intf_net -intf_net xxv_ethernet_0_axis_rx_0 [get_bd_intf_pins axis_data_fifo_1/S_AXIS] [get_bd_intf_pins xxv_ethernet_0/axis_rx_0]
  connect_bd_intf_net -intf_net xxv_ethernet_0_diff_gt_ref_clock_1 [get_bd_intf_pins util_ds_buf/CLK_IN_D] [get_bd_intf_ports xxv_ethernet_0_diff_gt_ref_clock]
  connect_bd_intf_net -intf_net xxv_ethernet_0_gt_rx_serdes_interface_0 [get_bd_intf_pins xxv_ethernet_0/gt_rx_serdes_interface_0] [get_bd_intf_pins gt_quad_base_0/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net xxv_ethernet_0_gt_tx_serdes_interface_0 [get_bd_intf_pins xxv_ethernet_0/gt_tx_serdes_interface_0] [get_bd_intf_pins gt_quad_base_0/TX2_GT_IP_Interface]

  # Create port connections
  connect_bd_net -net Net2 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_noc_0/aclk6] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins xxv_ethernet_0/s_axi_aclk_0] [get_bd_pins smartconnect_0/aclk] [get_bd_pins versal_cips_0/m_axi_lpd_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_0/mm2s_prmry_reset_out_n] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net axi_dma_0_s2mm_prmry_reset_out_n [get_bd_pins axi_dma_0/s2mm_prmry_reset_out_n] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net bufg_gt_1_usrclk [get_bd_pins bufg_gt_1/usrclk] [get_bd_pins gt_quad_base_0/ch2_txusrclk] [get_bd_pins xxv_ethernet_0/tx_core_clk_0] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axi_noc_0/aclk8]
  connect_bd_net -net bufg_gt_usrclk [get_bd_pins bufg_gt/usrclk] [get_bd_pins gt_quad_base_0/ch2_rxusrclk] [get_bd_pins xxv_ethernet_0/rx_core_clk_0] [get_bd_pins xxv_ethernet_0/rx_serdes_clk_0] [get_bd_pins proc_sys_reset_2/slowest_sync_clk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_noc_0/aclk7]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins xxv_ethernet_0/gtwiz_reset_clk_freerun_in_0] [get_bd_pins gt_quad_base_0/apb3clk]
  connect_bd_net -net gt_quad_base_0_ch2_rxoutclk [get_bd_pins gt_quad_base_0/ch2_rxoutclk] [get_bd_pins bufg_gt/outclk]
  connect_bd_net -net gt_quad_base_0_ch2_txoutclk [get_bd_pins gt_quad_base_0/ch2_txoutclk] [get_bd_pins bufg_gt_1/outclk]
  connect_bd_net -net gt_quad_base_0_gtpowergood [get_bd_pins gt_quad_base_0/gtpowergood] [get_bd_pins xxv_ethernet_0/gtpowergood_in_0]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins xxv_ethernet_0/s_axi_aresetn_0]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins proc_sys_reset_1/peripheral_reset] [get_bd_pins xxv_ethernet_0/tx_reset_0]
  connect_bd_net -net proc_sys_reset_2_peripheral_aresetn [get_bd_pins proc_sys_reset_2/peripheral_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn]
  connect_bd_net -net proc_sys_reset_2_peripheral_reset [get_bd_pins proc_sys_reset_2/peripheral_reset] [get_bd_pins xxv_ethernet_0/rx_reset_0]
  connect_bd_net -net util_ds_buf_IBUF_OUT [get_bd_pins util_ds_buf/IBUF_OUT] [get_bd_pins gt_quad_base_0/GT_REFCLK0]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xxv_ethernet_0/rx_serdes_reset_0] [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_5/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins util_vector_logic_3/Res] [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_pins util_vector_logic_4/Res] [get_bd_pins proc_sys_reset_2/ext_reset_in]
  connect_bd_net -net util_vector_logic_5_Res [get_bd_pins util_vector_logic_5/Res] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net xxv_ethernet_0_gtwiz_loopback_0 [get_bd_pins xxv_ethernet_0/gtwiz_loopback_0] [get_bd_pins gt_quad_base_0/ch2_loopback]
  connect_bd_net -net xxv_ethernet_0_gtwiz_rxcdrhold_0 [get_bd_pins xxv_ethernet_0/gtwiz_rxcdrhold_0] [get_bd_pins gt_quad_base_0/ch2_rxcdrhold]
  connect_bd_net -net xxv_ethernet_0_gtwiz_txmaincursor_0 [get_bd_pins xxv_ethernet_0/gtwiz_txmaincursor_0] [get_bd_pins gt_quad_base_0/ch2_txmaincursor]
  connect_bd_net -net xxv_ethernet_0_gtwiz_txpostcursor_0 [get_bd_pins xxv_ethernet_0/gtwiz_txpostcursor_0] [get_bd_pins gt_quad_base_0/ch2_txpostcursor]
  connect_bd_net -net xxv_ethernet_0_gtwiz_txprecursor_0 [get_bd_pins xxv_ethernet_0/gtwiz_txprecursor_0] [get_bd_pins gt_quad_base_0/ch2_txprecursor]
  connect_bd_net -net xxv_ethernet_0_rx_resetdone_out_0 [get_bd_pins xxv_ethernet_0/rx_resetdone_out_0] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net xxv_ethernet_0_tx_resetdone_out_0 [get_bd_pins xxv_ethernet_0/tx_resetdone_out_0] [get_bd_pins util_vector_logic_1/Op1]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs xxv_ethernet_0/s_axi_0/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW1]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C2_DDR_LOW1]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW1]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


