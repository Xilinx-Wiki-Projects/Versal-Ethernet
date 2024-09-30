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
# source mrmac_0_exdes_support_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:3.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name mrmac_0_exdes_support

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
xilinx.com:ip:mrmac:2.2\
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:axi_mcdma:1.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_gpio:2.0\
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


# Hierarchical cell: mrmac_0_gt_wrapper
proc create_hier_cell_mrmac_0_gt_wrapper { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mrmac_0_gt_wrapper() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI4_LITE_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX0_GT_IP_Interface


  # Create pins
  create_bd_pin -dir O ch1_rxpmaresetdone_0
  create_bd_pin -dir O ch2_rxpmaresetdone_0
  create_bd_pin -dir O ch3_rxpmaresetdone_0
  create_bd_pin -dir O -from 0 -to 0 -type clk RX_REC_CLK_out_n_0_0
  create_bd_pin -dir O -from 0 -to 0 -type clk RX_REC_CLK_out_p_0_0
  create_bd_pin -dir O -type rst ch1_rxmstresetdone_1
  create_bd_pin -dir O -from 3 -to 0 rx_usr_clk1_0
  create_bd_pin -dir O -type rst ch0_rxmstresetdone_1
  create_bd_pin -dir O -from 3 -to 0 tx_usr_clk_0
  create_bd_pin -dir I -from 3 -to 0 tx_mst_reset_in_0
  create_bd_pin -dir O -type rst ch3_rxmstresetdone_1
  create_bd_pin -dir I -from 3 -to 0 tx_userrdy_in_0
  create_bd_pin -dir O -type rst ch2_rxmstresetdone_2
  create_bd_pin -dir I -from 3 -to 0 rx_mst_reset_in_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF6
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR6
  create_bd_pin -dir O ch1_txpmaresetdone_0
  create_bd_pin -dir O ch0_txpmaresetdone_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF7
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR7
  create_bd_pin -dir O ch2_txpmaresetdone_0
  create_bd_pin -dir I -from 3 -to 0 TX_MST_DP_RESET_0
  create_bd_pin -dir O -from 3 -to 0 gt_reset_all_0
  create_bd_pin -dir O ch3_txpmaresetdone_0
  create_bd_pin -dir O -type rst ch0_txmstresetdone_0
  create_bd_pin -dir O -type rst ch1_txmstresetdone_0
  create_bd_pin -dir O -type rst ch2_txmstresetdone_0
  create_bd_pin -dir O -from 3 -to 0 gt_reset_tx_datapath_0
  create_bd_pin -dir O -type rst ch3_txmstresetdone_0
  create_bd_pin -dir O ch0_rxpmaresetdone_0
  create_bd_pin -dir I -from 3 -to 0 RX_MST_DP_RESET_0
  create_bd_pin -dir I -from 3 -to 0 rx_userrdy_in_0
  create_bd_pin -dir I -type rst aresetn_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF1
  create_bd_pin -dir O -from 3 -to 0 gt_txn_out_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR1
  create_bd_pin -dir I -from 3 -to 0 gt_rxn_in_0
  create_bd_pin -dir I -from 3 -to 0 gt_rxp_in_0
  create_bd_pin -dir O -from 3 -to 0 gt_txp_out_0
  create_bd_pin -dir O -from 3 -to 0 gt_reset_rx_datapath_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF3
  create_bd_pin -dir I -type clk apb3clk_quad
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF5
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR4
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR5
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR3
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF4
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF2
  create_bd_pin -dir O gtpowergood
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR2
  create_bd_pin -dir I -from 0 -to 0 -type clk IBUF_DS_P_0
  create_bd_pin -dir I -from 0 -to 0 -type clk IBUF_DS_N_0

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {199.999817} \
    CONFIG.CHANNEL_ORDERING {/mrmac_0_gt_wrapper/gt_quad_base/TX0_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_0./mrmac_0_core/gt_tx_serdes_interface_0.0 /mrmac_0_gt_wrapper/gt_quad_base/TX1_GT_IP_Interface\
mrmac_0_exdes_support_mrmac_0_core_0_1./mrmac_0_core/gt_tx_serdes_interface_1.1 /mrmac_0_gt_wrapper/gt_quad_base/TX2_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_2./mrmac_0_core/gt_tx_serdes_interface_2.2\
/mrmac_0_gt_wrapper/gt_quad_base/TX3_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_3./mrmac_0_core/gt_tx_serdes_interface_3.3 /mrmac_0_gt_wrapper/gt_quad_base/RX0_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_0./mrmac_0_core/gt_rx_serdes_interface_0.0\
/mrmac_0_gt_wrapper/gt_quad_base/RX1_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_1./mrmac_0_core/gt_rx_serdes_interface_1.1 /mrmac_0_gt_wrapper/gt_quad_base/RX2_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_2./mrmac_0_core/gt_rx_serdes_interface_2.2\
/mrmac_0_gt_wrapper/gt_quad_base/RX3_GT_IP_Interface mrmac_0_exdes_support_mrmac_0_core_0_3./mrmac_0_core/gt_rx_serdes_interface_3.3} \
    CONFIG.GT_TYPE {GTY} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 TX0} PROT1 {RX1 TX1} PROT2 {RX2 TX2} PROT3 {RX3 TX3}} GT_TYPE GTY REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT0_LR2_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {1} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.PROT1_ENABLE {true} \
    CONFIG.PROT1_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT1_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT1_LR10_SETTINGS {NA NA} \
    CONFIG.PROT1_LR11_SETTINGS {NA NA} \
    CONFIG.PROT1_LR12_SETTINGS {NA NA} \
    CONFIG.PROT1_LR13_SETTINGS {NA NA} \
    CONFIG.PROT1_LR14_SETTINGS {NA NA} \
    CONFIG.PROT1_LR15_SETTINGS {NA NA} \
    CONFIG.PROT1_LR1_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT1_LR2_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT1_LR3_SETTINGS {NA NA} \
    CONFIG.PROT1_LR4_SETTINGS {NA NA} \
    CONFIG.PROT1_LR5_SETTINGS {NA NA} \
    CONFIG.PROT1_LR6_SETTINGS {NA NA} \
    CONFIG.PROT1_LR7_SETTINGS {NA NA} \
    CONFIG.PROT1_LR8_SETTINGS {NA NA} \
    CONFIG.PROT1_LR9_SETTINGS {NA NA} \
    CONFIG.PROT1_NO_OF_LANES {1} \
    CONFIG.PROT1_RX_MASTERCLK_SRC {RX1} \
    CONFIG.PROT1_TX_MASTERCLK_SRC {TX1} \
    CONFIG.PROT2_ENABLE {true} \
    CONFIG.PROT2_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT2_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT2_LR10_SETTINGS {NA NA} \
    CONFIG.PROT2_LR11_SETTINGS {NA NA} \
    CONFIG.PROT2_LR12_SETTINGS {NA NA} \
    CONFIG.PROT2_LR13_SETTINGS {NA NA} \
    CONFIG.PROT2_LR14_SETTINGS {NA NA} \
    CONFIG.PROT2_LR15_SETTINGS {NA NA} \
    CONFIG.PROT2_LR1_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT2_LR2_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT2_LR3_SETTINGS {NA NA} \
    CONFIG.PROT2_LR4_SETTINGS {NA NA} \
    CONFIG.PROT2_LR5_SETTINGS {NA NA} \
    CONFIG.PROT2_LR6_SETTINGS {NA NA} \
    CONFIG.PROT2_LR7_SETTINGS {NA NA} \
    CONFIG.PROT2_LR8_SETTINGS {NA NA} \
    CONFIG.PROT2_LR9_SETTINGS {NA NA} \
    CONFIG.PROT2_NO_OF_LANES {1} \
    CONFIG.PROT2_RX_MASTERCLK_SRC {RX2} \
    CONFIG.PROT2_TX_MASTERCLK_SRC {TX2} \
    CONFIG.PROT3_ENABLE {true} \
    CONFIG.PROT3_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT3_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT3_LR10_SETTINGS {NA NA} \
    CONFIG.PROT3_LR11_SETTINGS {NA NA} \
    CONFIG.PROT3_LR12_SETTINGS {NA NA} \
    CONFIG.PROT3_LR13_SETTINGS {NA NA} \
    CONFIG.PROT3_LR14_SETTINGS {NA NA} \
    CONFIG.PROT3_LR15_SETTINGS {NA NA} \
    CONFIG.PROT3_LR1_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT3_LR2_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 156.25 RX_ACTUAL_REFCLK_FREQUENCY\
156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM\
0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CB_K 00000000 RX_CB_DISP\
00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2\
0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0\
false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3\
0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_MASK 00000000 RX_CC_VAL\
00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false\
RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3\
0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1\
false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ\
250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE\
ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTY} \
    CONFIG.PROT3_LR3_SETTINGS {NA NA} \
    CONFIG.PROT3_LR4_SETTINGS {NA NA} \
    CONFIG.PROT3_LR5_SETTINGS {NA NA} \
    CONFIG.PROT3_LR6_SETTINGS {NA NA} \
    CONFIG.PROT3_LR7_SETTINGS {NA NA} \
    CONFIG.PROT3_LR8_SETTINGS {NA NA} \
    CONFIG.PROT3_LR9_SETTINGS {NA NA} \
    CONFIG.PROT3_NO_OF_LANES {1} \
    CONFIG.PROT3_RX_MASTERCLK_SRC {RX3} \
    CONFIG.PROT3_TX_MASTERCLK_SRC {TX3} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/mrmac_0_gt_wrapper/gt_quad_base {/mrmac_0_gt_wrapper/gt_quad_base mrmac_0_exdes_support_mrmac_0_core_0_0.IP_CH0,mrmac_0_exdes_support_mrmac_0_core_0_1.IP_CH1,mrmac_0_exdes_support_mrmac_0_core_0_2.IP_CH2,mrmac_0_exdes_support_mrmac_0_core_0_3.IP_CH3\
MSTRCLK 1,1,1,1 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/mrmac_0_gt_wrapper/gt_quad_base {/mrmac_0_gt_wrapper/gt_quad_base mrmac_0_exdes_support_mrmac_0_core_0_0.IP_CH0,mrmac_0_exdes_support_mrmac_0_core_0_1.IP_CH1,mrmac_0_exdes_support_mrmac_0_core_0_2.IP_CH2,mrmac_0_exdes_support_mrmac_0_core_0_3.IP_CH3\
MSTRCLK 1,1,1,1 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {/gt_ref_clk_p /gt_ref_clk_p} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_PROT1_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT2_R0_PROT3_R0_156.25_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT1} \
    CONFIG.RX2_LANE_SEL {PROT2} \
    CONFIG.RX3_LANE_SEL {PROT3} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT1} \
    CONFIG.TX2_LANE_SEL {PROT2} \
    CONFIG.TX3_LANE_SEL {PROT3} \
  ] $gt_quad_base

  set_property -dict [list \
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
    CONFIG.PROT1_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT1_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT1_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT1_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT1_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT2_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT2_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT2_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT2_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT2_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT3_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT3_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT3_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT3_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT3_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_base


  # Create instance: mbufg_gt_0, and set properties
  set mbufg_gt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0


  # Create instance: mbufg_gt_0_1, and set properties
  set mbufg_gt_0_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_0_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0_1


  # Create instance: mbufg_gt_0_2, and set properties
  set mbufg_gt_0_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_0_2 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0_2


  # Create instance: mbufg_gt_0_3, and set properties
  set mbufg_gt_0_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_0_3 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0_3


  # Create instance: mbufg_gt_1, and set properties
  set mbufg_gt_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1


  # Create instance: mbufg_gt_1_1, and set properties
  set mbufg_gt_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_1


  # Create instance: mbufg_gt_1_2, and set properties
  set mbufg_gt_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_2 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_2


  # Create instance: mbufg_gt_1_3, and set properties
  set mbufg_gt_1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mbufg_gt_1_3 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_3


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: xlconst_mbufg_0, and set properties
  set xlconst_mbufg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconst_mbufg_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $xlconst_mbufg_0


  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {1} $axi_apb_bridge_0


  # Create instance: bufg_gt_div_val, and set properties
  set bufg_gt_div_val [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 bufg_gt_div_val ]
  set_property CONFIG.CONST_WIDTH {3} $bufg_gt_div_val


  # Create instance: gt_rate_ctl_ch3_tx_rx, and set properties
  set gt_rate_ctl_ch3_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch3_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch3_tx_rx


  # Create instance: mrmac_obuf_ds_gte5_0, and set properties
  set mrmac_obuf_ds_gte5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mrmac_obuf_ds_gte5_0 ]
  set_property CONFIG.C_BUF_TYPE {OBUFDS_GTE} $mrmac_obuf_ds_gte5_0


  # Create instance: conct_rx_mst_reset_done_out, and set properties
  set conct_rx_mst_reset_done_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_rx_mst_reset_done_out ]
  set_property CONFIG.NUM_PORTS {4} $conct_rx_mst_reset_done_out


  # Create instance: xlslice_gt_reset_tx_datapath_0, and set properties
  set xlslice_gt_reset_tx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_0


  # Create instance: xlslice_gt_reset_tx_datapath_1, and set properties
  set xlslice_gt_reset_tx_datapath_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_1


  # Create instance: xlslice_gt_reset_tx_datapath_2, and set properties
  set xlslice_gt_reset_tx_datapath_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_2


  # Create instance: xlslice_gt_reset_tx_datapath_3, and set properties
  set xlslice_gt_reset_tx_datapath_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_3


  # Create instance: xlslice_rx_mst_reset_0, and set properties
  set xlslice_rx_mst_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_mst_reset_0


  # Create instance: xlslice_gt_reset_all_0, and set properties
  set xlslice_gt_reset_all_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_0 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_0


  # Create instance: conct_tx_mst_reset_done_out, and set properties
  set conct_tx_mst_reset_done_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_tx_mst_reset_done_out ]
  set_property CONFIG.NUM_PORTS {4} $conct_tx_mst_reset_done_out


  # Create instance: xlslice_rx_mst_reset_1, and set properties
  set xlslice_rx_mst_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_1


  # Create instance: xlslice_gt_reset_all_1, and set properties
  set xlslice_gt_reset_all_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_1 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_1


  # Create instance: xlslice_rx_mst_reset_2, and set properties
  set xlslice_rx_mst_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_2


  # Create instance: xlslice_gt_reset_all_2, and set properties
  set xlslice_gt_reset_all_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_2 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_2


  # Create instance: xlslice_tx_userrdy_0, and set properties
  set xlslice_tx_userrdy_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_userrdy_0


  # Create instance: xlslice_rx_mst_reset_3, and set properties
  set xlslice_rx_mst_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_3


  # Create instance: xlslice_gt_reset_all_3, and set properties
  set xlslice_gt_reset_all_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_3 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_3


  # Create instance: xlslice_tx_userrdy_1, and set properties
  set xlslice_tx_userrdy_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_1


  # Create instance: xlslice_tx_userrdy_2, and set properties
  set xlslice_tx_userrdy_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_2


  # Create instance: xlslice_tx_userrdy_3, and set properties
  set xlslice_tx_userrdy_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_3


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {4} \
    CONFIG.IN1_WIDTH {4} \
  ] $xlconcat_0


  # Create instance: gt_rate_ctl_ch2_tx_rx, and set properties
  set gt_rate_ctl_ch2_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch2_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch2_tx_rx


  # Create instance: gt_rate_ctl_ch1_tx_rx, and set properties
  set gt_rate_ctl_ch1_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch1_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch1_tx_rx


  # Create instance: xlslice_tx_mst_reset_0, and set properties
  set xlslice_tx_mst_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_mst_reset_0


  # Create instance: xlslice_tx_mst_reset_1, and set properties
  set xlslice_tx_mst_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_1


  # Create instance: xlslice_tx_mst_reset_2, and set properties
  set xlslice_tx_mst_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_2


  # Create instance: xlslice_tx_mst_reset_3, and set properties
  set xlslice_tx_mst_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_3


  # Create instance: xlslice_tx_mst_dp_rst_0, and set properties
  set xlslice_tx_mst_dp_rst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_mst_dp_rst_0


  # Create instance: xlslice_tx_mst_dp_rst_1, and set properties
  set xlslice_tx_mst_dp_rst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_tx_mst_dp_rst_1


  # Create instance: xlslice_tx_mst_dp_rst_2, and set properties
  set xlslice_tx_mst_dp_rst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_dp_rst_2


  # Create instance: xlslice_tx_mst_dp_rst_3, and set properties
  set xlslice_tx_mst_dp_rst_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_dp_rst_3


  # Create instance: gt_rate_ctl_ch0_tx_rx, and set properties
  set gt_rate_ctl_ch0_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch0_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch0_tx_rx


  # Create instance: axi_gpio_gt_reset_mask, and set properties
  set axi_gpio_gt_reset_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_reset_mask ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {8} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_reset_mask


  # Create instance: xlconcat_gt_rest_all, and set properties
  set xlconcat_gt_rest_all [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_all ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_all


  # Create instance: xlconcat_gt_rest_tx_datapath, and set properties
  set xlconcat_gt_rest_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_tx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_tx_datapath


  # Create instance: xlconcat_gt_rest_rx_datapath, and set properties
  set xlconcat_gt_rest_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_rx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_rx_datapath


  # Create instance: xlslice_gt_reset_rx_datapath_0, and set properties
  set xlslice_gt_reset_rx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_0


  # Create instance: xlslice_gt_reset_rx_datapath_1, and set properties
  set xlslice_gt_reset_rx_datapath_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_1


  # Create instance: axi_gpio_gt_rate_reset_ctl_0, and set properties
  set axi_gpio_gt_rate_reset_ctl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_0


  # Create instance: xlslice_gt_reset_rx_datapath_2, and set properties
  set xlslice_gt_reset_rx_datapath_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_2


  # Create instance: axi_gpio_gt_rate_reset_ctl_1, and set properties
  set axi_gpio_gt_rate_reset_ctl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_1 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_1


  # Create instance: xlslice_gt_reset_rx_datapath_3, and set properties
  set xlslice_gt_reset_rx_datapath_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_3


  # Create instance: axi_gpio_gt_rate_reset_ctl_2, and set properties
  set axi_gpio_gt_rate_reset_ctl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_2 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_2


  # Create instance: axi_gpio_gt_rate_reset_ctl_3, and set properties
  set axi_gpio_gt_rate_reset_ctl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_3 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_3


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {5} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: xlslice_rx_userrdy_0, and set properties
  set xlslice_rx_userrdy_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_userrdy_0


  # Create instance: xlslice_rx_userrdy_1, and set properties
  set xlslice_rx_userrdy_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_1


  # Create instance: xlslice_rx_userrdy_2, and set properties
  set xlslice_rx_userrdy_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_2


  # Create instance: xlslice_rx_userrdy_3, and set properties
  set xlslice_rx_userrdy_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_3


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlslice_rx_mst_dp_rst_0, and set properties
  set xlslice_rx_mst_dp_rst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_0


  # Create instance: xlslice_rx_mst_dp_rst_1, and set properties
  set xlslice_rx_mst_dp_rst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_1


  # Create instance: xlslice_rx_mst_dp_rst_2, and set properties
  set xlslice_rx_mst_dp_rst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_2


  # Create instance: xlslice_rx_mst_dp_rst_3, and set properties
  set xlslice_rx_mst_dp_rst_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_3


  # Create instance: conct_rx_usr_clk, and set properties
  set conct_rx_usr_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_rx_usr_clk ]
  set_property CONFIG.NUM_PORTS {4} $conct_rx_usr_clk


  # Create instance: conct_tx_usr_clk, and set properties
  set conct_tx_usr_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_tx_usr_clk ]
  set_property CONFIG.NUM_PORTS {4} $conct_tx_usr_clk


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins AXI4_LITE_0] [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S00_AXI_0] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_pins axi_apb_bridge_0/APB_M] [get_bd_intf_pins gt_quad_base/APB3_INTF]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_pins GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_0 [get_bd_intf_pins RX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_1 [get_bd_intf_pins RX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_2 [get_bd_intf_pins RX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_3 [get_bd_intf_pins RX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_0 [get_bd_intf_pins TX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_1 [get_bd_intf_pins TX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_2 [get_bd_intf_pins TX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_3 [get_bd_intf_pins TX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_gt_reset_mask/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI1 [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_2/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_3/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]

  # Create port connections
  connect_bd_net -net IBUF_DS_N_0_1 [get_bd_pins IBUF_DS_N_0] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
  connect_bd_net -net IBUF_DS_P_0_1 [get_bd_pins IBUF_DS_P_0] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
  connect_bd_net -net RX_MST_DP_RESET_1 [get_bd_pins RX_MST_DP_RESET_0] [get_bd_pins xlslice_rx_mst_dp_rst_1/Din] [get_bd_pins xlslice_rx_mst_dp_rst_2/Din] [get_bd_pins xlslice_rx_mst_dp_rst_3/Din] [get_bd_pins xlslice_rx_mst_dp_rst_0/Din]
  connect_bd_net -net TX_MST_DP_RESET_1 [get_bd_pins TX_MST_DP_RESET_0] [get_bd_pins xlslice_tx_mst_dp_rst_1/Din] [get_bd_pins xlslice_tx_mst_dp_rst_2/Din] [get_bd_pins xlslice_tx_mst_dp_rst_3/Din] [get_bd_pins xlslice_tx_mst_dp_rst_0/Din]
  connect_bd_net -net apb3clk_quad_1 [get_bd_pins apb3clk_quad] [get_bd_pins gt_quad_base/apb3clk] [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aclk] [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/s_axi_aclk] [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/s_axi_aclk] [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/s_axi_aclk] [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aclk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn_0] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_0_gpio2_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio2_io_o] [get_bd_pins xlslice_gt_reset_all_0/Din] [get_bd_pins xlslice_gt_reset_rx_datapath_0/Din] [get_bd_pins xlslice_gt_reset_tx_datapath_0/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_0_gpio_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio_io_o] [get_bd_pins gt_rate_ctl_ch0_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_1_gpio2_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/gpio2_io_o] [get_bd_pins xlslice_gt_reset_all_1/Din] [get_bd_pins xlslice_gt_reset_rx_datapath_1/Din] [get_bd_pins xlslice_gt_reset_tx_datapath_1/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_1_gpio_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/gpio_io_o] [get_bd_pins gt_rate_ctl_ch1_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_2_gpio2_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/gpio2_io_o] [get_bd_pins xlslice_gt_reset_all_2/Din] [get_bd_pins xlslice_gt_reset_rx_datapath_2/Din] [get_bd_pins xlslice_gt_reset_tx_datapath_2/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_2_gpio_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/gpio_io_o] [get_bd_pins gt_rate_ctl_ch2_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_3_gpio2_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/gpio2_io_o] [get_bd_pins xlslice_gt_reset_all_3/Din] [get_bd_pins xlslice_gt_reset_rx_datapath_3/Din] [get_bd_pins xlslice_gt_reset_tx_datapath_3/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_3_gpio_io_o [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/gpio_io_o] [get_bd_pins gt_rate_ctl_ch3_tx_rx/Din]
  connect_bd_net -net bufg_gt_div_val_dout [get_bd_pins bufg_gt_div_val/dout] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_1/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_0_3/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_0_2/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_0_1/MBUFG_GT_DIV] [get_bd_pins mbufg_gt_0/MBUFG_GT_DIV]
  connect_bd_net -net ch3_txrate_1 [get_bd_pins gt_rate_ctl_ch3_tx_rx/Dout] [get_bd_pins gt_quad_base/ch3_txrate] [get_bd_pins gt_quad_base/ch3_rxrate]
  connect_bd_net -net conct_rx_mst_reset_done_out1_dout [get_bd_pins conct_tx_mst_reset_done_out/dout] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net conct_rx_mst_reset_done_out_dout [get_bd_pins conct_rx_mst_reset_done_out/dout] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net conct_rx_usr_clk_dout [get_bd_pins conct_rx_usr_clk/dout] [get_bd_pins rx_usr_clk1_0]
  connect_bd_net -net conct_tx_usr_clk_dout [get_bd_pins conct_tx_usr_clk/dout] [get_bd_pins tx_usr_clk_0]
  connect_bd_net -net everything_else_Dout1 [get_bd_pins xlslice_rx_mst_reset_0/Dout] [get_bd_pins gt_quad_base/ch0_rxmstreset]
  connect_bd_net -net everything_else_Dout2 [get_bd_pins xlslice_rx_mst_reset_1/Dout] [get_bd_pins gt_quad_base/ch1_rxmstreset]
  connect_bd_net -net everything_else_Dout3 [get_bd_pins xlslice_rx_mst_reset_2/Dout] [get_bd_pins gt_quad_base/ch2_rxmstreset]
  connect_bd_net -net everything_else_Dout4 [get_bd_pins xlslice_tx_userrdy_0/Dout] [get_bd_pins gt_quad_base/ch0_txuserrdy]
  connect_bd_net -net everything_else_Dout5 [get_bd_pins xlslice_rx_mst_reset_3/Dout] [get_bd_pins gt_quad_base/ch3_rxmstreset]
  connect_bd_net -net everything_else_Dout6 [get_bd_pins xlslice_tx_userrdy_1/Dout] [get_bd_pins gt_quad_base/ch1_txuserrdy]
  connect_bd_net -net everything_else_Dout7 [get_bd_pins xlslice_tx_userrdy_2/Dout] [get_bd_pins gt_quad_base/ch2_txuserrdy]
  connect_bd_net -net everything_else_Dout8 [get_bd_pins xlslice_tx_userrdy_3/Dout] [get_bd_pins gt_quad_base/ch3_txuserrdy]
  connect_bd_net -net everything_else_Dout9 [get_bd_pins gt_rate_ctl_ch2_tx_rx/Dout] [get_bd_pins gt_quad_base/ch2_txrate] [get_bd_pins gt_quad_base/ch2_rxrate]
  connect_bd_net -net everything_else_Dout10 [get_bd_pins gt_rate_ctl_ch1_tx_rx/Dout] [get_bd_pins gt_quad_base/ch1_txrate] [get_bd_pins gt_quad_base/ch1_rxrate]
  connect_bd_net -net everything_else_Dout11 [get_bd_pins xlslice_tx_mst_reset_0/Dout] [get_bd_pins gt_quad_base/ch0_txmstreset]
  connect_bd_net -net everything_else_Dout12 [get_bd_pins xlslice_tx_mst_reset_1/Dout] [get_bd_pins gt_quad_base/ch1_txmstreset]
  connect_bd_net -net everything_else_Dout13 [get_bd_pins xlslice_tx_mst_reset_2/Dout] [get_bd_pins gt_quad_base/ch2_txmstreset]
  connect_bd_net -net everything_else_Dout14 [get_bd_pins xlslice_tx_mst_reset_3/Dout] [get_bd_pins gt_quad_base/ch3_txmstreset]
  connect_bd_net -net everything_else_Dout15 [get_bd_pins xlslice_tx_mst_dp_rst_0/Dout] [get_bd_pins gt_quad_base/ch0_txmstdatapathreset]
  connect_bd_net -net everything_else_Dout16 [get_bd_pins xlslice_tx_mst_dp_rst_1/Dout] [get_bd_pins gt_quad_base/ch1_txmstdatapathreset]
  connect_bd_net -net everything_else_Dout17 [get_bd_pins xlslice_tx_mst_dp_rst_2/Dout] [get_bd_pins gt_quad_base/ch2_txmstdatapathreset]
  connect_bd_net -net everything_else_Dout18 [get_bd_pins xlslice_tx_mst_dp_rst_3/Dout] [get_bd_pins gt_quad_base/ch3_txmstdatapathreset]
  connect_bd_net -net everything_else_Dout19 [get_bd_pins gt_rate_ctl_ch0_tx_rx/Dout] [get_bd_pins gt_quad_base/ch0_txrate] [get_bd_pins gt_quad_base/ch0_rxrate]
  connect_bd_net -net everything_else_Dout20 [get_bd_pins xlslice_rx_userrdy_0/Dout] [get_bd_pins gt_quad_base/ch0_rxuserrdy]
  connect_bd_net -net everything_else_Dout21 [get_bd_pins xlslice_rx_userrdy_1/Dout] [get_bd_pins gt_quad_base/ch1_rxuserrdy]
  connect_bd_net -net everything_else_Dout22 [get_bd_pins xlslice_rx_userrdy_2/Dout] [get_bd_pins gt_quad_base/ch2_rxuserrdy]
  connect_bd_net -net everything_else_Dout23 [get_bd_pins xlslice_rx_userrdy_3/Dout] [get_bd_pins gt_quad_base/ch3_rxuserrdy]
  connect_bd_net -net everything_else_Dout24 [get_bd_pins xlslice_rx_mst_dp_rst_0/Dout] [get_bd_pins gt_quad_base/ch0_rxmstdatapathreset]
  connect_bd_net -net everything_else_Dout25 [get_bd_pins xlslice_rx_mst_dp_rst_1/Dout] [get_bd_pins gt_quad_base/ch1_rxmstdatapathreset]
  connect_bd_net -net everything_else_Dout26 [get_bd_pins xlslice_rx_mst_dp_rst_2/Dout] [get_bd_pins gt_quad_base/ch2_rxmstdatapathreset]
  connect_bd_net -net everything_else_Dout27 [get_bd_pins xlslice_rx_mst_dp_rst_3/Dout] [get_bd_pins gt_quad_base/ch3_rxmstdatapathreset]
  connect_bd_net -net everything_else_RX_REC_CLK_out_n_0 [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_OB] [get_bd_pins RX_REC_CLK_out_n_0_0]
  connect_bd_net -net everything_else_RX_REC_CLK_out_p_0 [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_O] [get_bd_pins RX_REC_CLK_out_p_0_0]
  connect_bd_net -net everything_else_gt_reset_all [get_bd_pins xlconcat_gt_rest_all/dout] [get_bd_pins gt_reset_all_0]
  connect_bd_net -net everything_else_gt_reset_rx_datapath [get_bd_pins xlconcat_gt_rest_rx_datapath/dout] [get_bd_pins gt_reset_rx_datapath_0]
  connect_bd_net -net everything_else_gt_reset_tx_datapath [get_bd_pins xlconcat_gt_rest_tx_datapath/dout] [get_bd_pins gt_reset_tx_datapath_0]
  connect_bd_net -net gt_quad_base_ch0_rxmstresetdone [get_bd_pins gt_quad_base/ch0_rxmstresetdone] [get_bd_pins ch0_rxmstresetdone_1] [get_bd_pins conct_rx_mst_reset_done_out/In0]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk [get_bd_pins gt_quad_base/ch0_rxoutclk] [get_bd_pins mbufg_gt_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_rxpmaresetdone [get_bd_pins gt_quad_base/ch0_rxpmaresetdone] [get_bd_pins ch0_rxpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch0_txmstresetdone [get_bd_pins gt_quad_base/ch0_txmstresetdone] [get_bd_pins ch0_txmstresetdone_0] [get_bd_pins conct_tx_mst_reset_done_out/In0]
  connect_bd_net -net gt_quad_base_ch0_txoutclk [get_bd_pins gt_quad_base/ch0_txoutclk] [get_bd_pins mbufg_gt_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_txpmaresetdone [get_bd_pins gt_quad_base/ch0_txpmaresetdone] [get_bd_pins ch0_txpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch1_rxmstresetdone [get_bd_pins gt_quad_base/ch1_rxmstresetdone] [get_bd_pins ch1_rxmstresetdone_1] [get_bd_pins conct_rx_mst_reset_done_out/In1]
  connect_bd_net -net gt_quad_base_ch1_rxoutclk [get_bd_pins gt_quad_base/ch1_rxoutclk] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_rxpmaresetdone [get_bd_pins gt_quad_base/ch1_rxpmaresetdone] [get_bd_pins ch1_rxpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch1_txmstresetdone [get_bd_pins gt_quad_base/ch1_txmstresetdone] [get_bd_pins ch1_txmstresetdone_0] [get_bd_pins conct_tx_mst_reset_done_out/In1]
  connect_bd_net -net gt_quad_base_ch1_txoutclk [get_bd_pins gt_quad_base/ch1_txoutclk] [get_bd_pins mbufg_gt_0_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_txpmaresetdone [get_bd_pins gt_quad_base/ch1_txpmaresetdone] [get_bd_pins ch1_txpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch2_rxmstresetdone [get_bd_pins gt_quad_base/ch2_rxmstresetdone] [get_bd_pins ch2_rxmstresetdone_2] [get_bd_pins conct_rx_mst_reset_done_out/In2]
  connect_bd_net -net gt_quad_base_ch2_rxoutclk [get_bd_pins gt_quad_base/ch2_rxoutclk] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch2_rxpmaresetdone [get_bd_pins gt_quad_base/ch2_rxpmaresetdone] [get_bd_pins ch2_rxpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch2_txmstresetdone [get_bd_pins gt_quad_base/ch2_txmstresetdone] [get_bd_pins ch2_txmstresetdone_0] [get_bd_pins conct_tx_mst_reset_done_out/In2]
  connect_bd_net -net gt_quad_base_ch2_txoutclk [get_bd_pins gt_quad_base/ch2_txoutclk] [get_bd_pins mbufg_gt_0_2/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch2_txpmaresetdone [get_bd_pins gt_quad_base/ch2_txpmaresetdone] [get_bd_pins ch2_txpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch3_rxmstresetdone [get_bd_pins gt_quad_base/ch3_rxmstresetdone] [get_bd_pins ch3_rxmstresetdone_1] [get_bd_pins conct_rx_mst_reset_done_out/In3]
  connect_bd_net -net gt_quad_base_ch3_rxoutclk [get_bd_pins gt_quad_base/ch3_rxoutclk] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch3_rxpmaresetdone [get_bd_pins gt_quad_base/ch3_rxpmaresetdone] [get_bd_pins ch3_rxpmaresetdone_0]
  connect_bd_net -net gt_quad_base_ch3_txmstresetdone [get_bd_pins gt_quad_base/ch3_txmstresetdone] [get_bd_pins ch3_txmstresetdone_0] [get_bd_pins conct_tx_mst_reset_done_out/In3]
  connect_bd_net -net gt_quad_base_ch3_txoutclk [get_bd_pins gt_quad_base/ch3_txoutclk] [get_bd_pins mbufg_gt_0_3/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch3_txpmaresetdone [get_bd_pins gt_quad_base/ch3_txpmaresetdone] [get_bd_pins ch3_txpmaresetdone_0]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins gt_quad_base/gtpowergood] [get_bd_pins gtpowergood]
  connect_bd_net -net gt_quad_base_hsclk0_rxrecclkout0 [get_bd_pins gt_quad_base/hsclk0_rxrecclkout0] [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_I]
  connect_bd_net -net gt_quad_base_txn [get_bd_pins gt_quad_base/txn] [get_bd_pins gt_txn_out_0]
  connect_bd_net -net gt_quad_base_txp [get_bd_pins gt_quad_base/txp] [get_bd_pins gt_txp_out_0]
  connect_bd_net -net gt_rxn_in_0_1 [get_bd_pins gt_rxn_in_0] [get_bd_pins gt_quad_base/rxn]
  connect_bd_net -net gt_rxp_in_0_1 [get_bd_pins gt_rxp_in_0] [get_bd_pins gt_quad_base/rxp]
  connect_bd_net -net mbufg_gt_0_1_MBUFG_GT_O1 [get_bd_pins mbufg_gt_0_1/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch1_txusrclk] [get_bd_pins conct_tx_usr_clk/In1]
  connect_bd_net -net mbufg_gt_0_2_MBUFG_GT_O1 [get_bd_pins mbufg_gt_0_2/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch2_txusrclk] [get_bd_pins conct_tx_usr_clk/In2]
  connect_bd_net -net mbufg_gt_0_3_MBUFG_GT_O1 [get_bd_pins mbufg_gt_0_3/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch3_txusrclk] [get_bd_pins conct_tx_usr_clk/In3]
  connect_bd_net -net mbufg_gt_0_MBUFG_GT_O1 [get_bd_pins mbufg_gt_0/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins conct_tx_usr_clk/In0]
  connect_bd_net -net mbufg_gt_1_1_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_1/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch1_rxusrclk] [get_bd_pins conct_rx_usr_clk/In1]
  connect_bd_net -net mbufg_gt_1_2_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_2/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch2_rxusrclk] [get_bd_pins conct_rx_usr_clk/In2]
  connect_bd_net -net mbufg_gt_1_3_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1_3/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch3_rxusrclk] [get_bd_pins conct_rx_usr_clk/In3]
  connect_bd_net -net mbufg_gt_1_MBUFG_GT_O1 [get_bd_pins mbufg_gt_1/MBUFG_GT_O1] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins conct_rx_usr_clk/In0]
  connect_bd_net -net mrmac_0_core_rx_clr_out_0 [get_bd_pins MBUFG_GT_CLR4] [get_bd_pins mbufg_gt_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_rx_clr_out_1 [get_bd_pins MBUFG_GT_CLR5] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_rx_clr_out_2 [get_bd_pins MBUFG_GT_CLR6] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_rx_clr_out_3 [get_bd_pins MBUFG_GT_CLR7] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_0 [get_bd_pins MBUFG_GT_CLRB_LEAF4] [get_bd_pins mbufg_gt_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_1 [get_bd_pins MBUFG_GT_CLRB_LEAF5] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_2 [get_bd_pins MBUFG_GT_CLRB_LEAF6] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_3 [get_bd_pins MBUFG_GT_CLRB_LEAF7] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_tx_clr_out_0 [get_bd_pins MBUFG_GT_CLR] [get_bd_pins mbufg_gt_0/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_tx_clr_out_1 [get_bd_pins MBUFG_GT_CLR1] [get_bd_pins mbufg_gt_0_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_tx_clr_out_2 [get_bd_pins MBUFG_GT_CLR2] [get_bd_pins mbufg_gt_0_2/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_tx_clr_out_3 [get_bd_pins MBUFG_GT_CLR3] [get_bd_pins mbufg_gt_0_3/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_0 [get_bd_pins MBUFG_GT_CLRB_LEAF] [get_bd_pins mbufg_gt_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_1 [get_bd_pins MBUFG_GT_CLRB_LEAF1] [get_bd_pins mbufg_gt_0_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_2 [get_bd_pins MBUFG_GT_CLRB_LEAF2] [get_bd_pins mbufg_gt_0_2/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_3 [get_bd_pins MBUFG_GT_CLRB_LEAF3] [get_bd_pins mbufg_gt_0_3/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net rx_mst_reset_in_1 [get_bd_pins rx_mst_reset_in_0] [get_bd_pins xlslice_rx_mst_reset_1/Din] [get_bd_pins xlslice_rx_mst_reset_2/Din] [get_bd_pins xlslice_rx_mst_reset_3/Din] [get_bd_pins xlslice_rx_mst_reset_0/Din]
  connect_bd_net -net rx_userrdy_in_1 [get_bd_pins rx_userrdy_in_0] [get_bd_pins xlslice_rx_userrdy_1/Din] [get_bd_pins xlslice_rx_userrdy_2/Din] [get_bd_pins xlslice_rx_userrdy_3/Din] [get_bd_pins xlslice_rx_userrdy_0/Din]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins gt_quad_base/apb3presetn] [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aresetn] [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/s_axi_aresetn] [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/s_axi_aresetn] [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/s_axi_aresetn] [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aresetn]
  connect_bd_net -net tx_mst_reset_in_1 [get_bd_pins tx_mst_reset_in_0] [get_bd_pins xlslice_tx_mst_reset_1/Din] [get_bd_pins xlslice_tx_mst_reset_2/Din] [get_bd_pins xlslice_tx_mst_reset_3/Din] [get_bd_pins xlslice_tx_mst_reset_0/Din]
  connect_bd_net -net tx_userrdy_in_1 [get_bd_pins tx_userrdy_in_0] [get_bd_pins xlslice_tx_userrdy_1/Din] [get_bd_pins xlslice_tx_userrdy_2/Din] [get_bd_pins xlslice_tx_userrdy_3/Din] [get_bd_pins xlslice_tx_userrdy_0/Din]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins gt_quad_base/GT_REFCLK0] [get_bd_pins gt_quad_base/GT_REFCLK1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins axi_gpio_gt_reset_mask/gpio2_io_i]
  connect_bd_net -net xlconst_mbufg_0_dout [get_bd_pins xlconst_mbufg_0/dout] [get_bd_pins mbufg_gt_0/MBUFG_GT_CE] [get_bd_pins mbufg_gt_0_1/MBUFG_GT_CE] [get_bd_pins mbufg_gt_0_2/MBUFG_GT_CE] [get_bd_pins mbufg_gt_0_3/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CE] [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CE]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_CEB]
  connect_bd_net -net xlslice_gt_reset_all_0_Dout [get_bd_pins xlslice_gt_reset_all_0/Dout] [get_bd_pins xlconcat_gt_rest_all/In0]
  connect_bd_net -net xlslice_gt_reset_all_1_Dout [get_bd_pins xlslice_gt_reset_all_1/Dout] [get_bd_pins xlconcat_gt_rest_all/In1]
  connect_bd_net -net xlslice_gt_reset_all_2_Dout [get_bd_pins xlslice_gt_reset_all_2/Dout] [get_bd_pins xlconcat_gt_rest_all/In2]
  connect_bd_net -net xlslice_gt_reset_all_3_Dout [get_bd_pins xlslice_gt_reset_all_3/Dout] [get_bd_pins xlconcat_gt_rest_all/In3]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_0_Dout [get_bd_pins xlslice_gt_reset_rx_datapath_0/Dout] [get_bd_pins xlconcat_gt_rest_rx_datapath/In0]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_1_Dout [get_bd_pins xlslice_gt_reset_rx_datapath_1/Dout] [get_bd_pins xlconcat_gt_rest_rx_datapath/In1]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_2_Dout [get_bd_pins xlslice_gt_reset_rx_datapath_2/Dout] [get_bd_pins xlconcat_gt_rest_rx_datapath/In2]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_3_Dout [get_bd_pins xlslice_gt_reset_rx_datapath_3/Dout] [get_bd_pins xlconcat_gt_rest_rx_datapath/In3]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_0_Dout [get_bd_pins xlslice_gt_reset_tx_datapath_0/Dout] [get_bd_pins xlconcat_gt_rest_tx_datapath/In0]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_1_Dout [get_bd_pins xlslice_gt_reset_tx_datapath_1/Dout] [get_bd_pins xlconcat_gt_rest_tx_datapath/In1]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_2_Dout [get_bd_pins xlslice_gt_reset_tx_datapath_2/Dout] [get_bd_pins xlconcat_gt_rest_tx_datapath/In2]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_3_Dout [get_bd_pins xlslice_gt_reset_tx_datapath_3/Dout] [get_bd_pins xlconcat_gt_rest_tx_datapath/In3]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Four_MCDMA
proc create_hier_cell_Four_MCDMA { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Four_MCDMA() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_3


  # Create pins
  create_bd_pin -dir I -from 10 -to 0 s_axis_tkeep_0
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I rx_tlast
  create_bd_pin -dir I rx_tvalid
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata_0
  create_bd_pin -dir O -type intr mm2s_ch1_introut_0
  create_bd_pin -dir O -type intr s2mm_ch1_introut_0
  create_bd_pin -dir O -from 63 -to 0 m_axis_tdata_0
  create_bd_pin -dir O -from 7 -to 0 tx_tkeep
  create_bd_pin -dir O tx_tlast
  create_bd_pin -dir O tx_tvalid
  create_bd_pin -dir I m_axis_tready_1
  create_bd_pin -dir I -from 10 -to 0 s_axis_tkeep_1
  create_bd_pin -dir I rx_axis_tlast_1
  create_bd_pin -dir I rx_axis_tvalid_1
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata_1
  create_bd_pin -dir O -type intr mm2s_ch1_introut_1
  create_bd_pin -dir O -type intr s2mm_ch1_introut_1
  create_bd_pin -dir O -from 63 -to 0 m_axis_tdata_1
  create_bd_pin -dir O -from 7 -to 0 tx_tkeep1
  create_bd_pin -dir O tx_tlast1
  create_bd_pin -dir O tx_tvalid1
  create_bd_pin -dir I tx_axis_tready_1
  create_bd_pin -dir I -from 10 -to 0 s_axis_tkeep_2
  create_bd_pin -dir I rx_axis_tlast_2
  create_bd_pin -dir I rx_axis_tvalid_2
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata_2
  create_bd_pin -dir O -type intr mm2s_ch1_introut_2
  create_bd_pin -dir O -type intr s2mm_ch1_introut_2
  create_bd_pin -dir O -from 63 -to 0 m_axis_tdata_2
  create_bd_pin -dir O -from 7 -to 0 tx_tkeep2
  create_bd_pin -dir O tx_tlast2
  create_bd_pin -dir O tx_tvalid2
  create_bd_pin -dir I tx_axis_tready_2
  create_bd_pin -dir I -from 10 -to 0 s_axis_tkeep_3
  create_bd_pin -dir I rx_axis_tlast_3
  create_bd_pin -dir I rx_axis_tvalid_3
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata_3
  create_bd_pin -dir O -type intr mm2s_ch1_introut_3
  create_bd_pin -dir O -type intr s2mm_ch1_introut_3
  create_bd_pin -dir O -from 63 -to 0 m_axis_tdata_3
  create_bd_pin -dir O -from 7 -to 0 tx_tkeep3
  create_bd_pin -dir O tx_tlast3
  create_bd_pin -dir O tx_tvalid3
  create_bd_pin -dir I tx_axis_tready_3

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
  ] $axi_mcdma_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_1


  # Create instance: axi_mcdma_1, and set properties
  set axi_mcdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_1 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
  ] $axi_mcdma_1


  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_2


  # Create instance: axis_data_fifo_3, and set properties
  set axis_data_fifo_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_3 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_3


  # Create instance: axi_mcdma_2, and set properties
  set axi_mcdma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_2 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
  ] $axi_mcdma_2


  # Create instance: axis_data_fifo_4, and set properties
  set axis_data_fifo_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_4 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_4


  # Create instance: axis_data_fifo_5, and set properties
  set axis_data_fifo_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_5 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_5


  # Create instance: axi_mcdma_3, and set properties
  set axi_mcdma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_3 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
  ] $axi_mcdma_3


  # Create instance: axis_data_fifo_6, and set properties
  set axis_data_fifo_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_6 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_6


  # Create instance: axis_data_fifo_7, and set properties
  set axis_data_fifo_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_7 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_7


  # Create interface connections
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_MM2S_0 [get_bd_intf_pins M_AXI_MM2S_1] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_S2MM_0 [get_bd_intf_pins M_AXI_S2MM_1] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_SG_0 [get_bd_intf_pins M_AXI_SG_1] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_MM2S_0 [get_bd_intf_pins M_AXI_MM2S_2] [get_bd_intf_pins axi_mcdma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_S2MM_0 [get_bd_intf_pins M_AXI_S2MM_2] [get_bd_intf_pins axi_mcdma_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_SG_0 [get_bd_intf_pins M_AXI_SG_2] [get_bd_intf_pins axi_mcdma_1/M_AXI_SG]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_MM2S_0 [get_bd_intf_pins M_AXI_MM2S_3] [get_bd_intf_pins axi_mcdma_3/M_AXI_MM2S]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_S2MM_0 [get_bd_intf_pins M_AXI_S2MM_3] [get_bd_intf_pins axi_mcdma_3/M_AXI_S2MM]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_SG_0 [get_bd_intf_pins M_AXI_SG_3] [get_bd_intf_pins axi_mcdma_3/M_AXI_SG]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_MM2S_0 [get_bd_intf_pins M_AXI_MM2S_0] [get_bd_intf_pins axi_mcdma_2/M_AXI_MM2S]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_S2MM_0 [get_bd_intf_pins M_AXI_S2MM_0] [get_bd_intf_pins axi_mcdma_2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_SG_0 [get_bd_intf_pins M_AXI_SG_0] [get_bd_intf_pins axi_mcdma_2/M_AXI_SG]
  connect_bd_intf_net -intf_net S_AXI_LITE_0_1 [get_bd_intf_pins S_AXI_LITE_1] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net S_AXI_LITE_0_2 [get_bd_intf_pins S_AXI_LITE_2] [get_bd_intf_pins axi_mcdma_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S_1 [get_bd_intf_pins axi_mcdma_1/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_3/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S_2 [get_bd_intf_pins axi_mcdma_2/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_5/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S_3 [get_bd_intf_pins axi_mcdma_3/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS_1 [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins axi_mcdma_1/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS_2 [get_bd_intf_pins axis_data_fifo_4/M_AXIS] [get_bd_intf_pins axi_mcdma_2/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS_3 [get_bd_intf_pins axis_data_fifo_6/M_AXIS] [get_bd_intf_pins axi_mcdma_3/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins S_AXI_LITE_0] [get_bd_intf_pins axi_mcdma_2/S_AXI_LITE]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins S_AXI_LITE_3] [get_bd_intf_pins axi_mcdma_3/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net MCDMA1_m_axis_tdata_0 [get_bd_pins axis_data_fifo_1/m_axis_tdata] [get_bd_pins m_axis_tdata_1]
  connect_bd_net -net MCDMA1_mm2s_ch1_introut_0 [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] [get_bd_pins mm2s_ch1_introut_1]
  connect_bd_net -net MCDMA1_s2mm_ch1_introut_0 [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] [get_bd_pins s2mm_ch1_introut_1]
  connect_bd_net -net MCDMA1_tx_tkeep [get_bd_pins axis_data_fifo_1/m_axis_tkeep] [get_bd_pins tx_tkeep1]
  connect_bd_net -net MCDMA1_tx_tlast [get_bd_pins axis_data_fifo_1/m_axis_tlast] [get_bd_pins tx_tlast1]
  connect_bd_net -net MCDMA1_tx_tvalid [get_bd_pins axis_data_fifo_1/m_axis_tvalid] [get_bd_pins tx_tvalid1]
  connect_bd_net -net MCDMA2_m_axis_tdata_0 [get_bd_pins axis_data_fifo_3/m_axis_tdata] [get_bd_pins m_axis_tdata_2]
  connect_bd_net -net MCDMA2_mm2s_ch1_introut_0 [get_bd_pins axi_mcdma_1/mm2s_ch1_introut] [get_bd_pins mm2s_ch1_introut_2]
  connect_bd_net -net MCDMA2_s2mm_ch1_introut_0 [get_bd_pins axi_mcdma_1/s2mm_ch1_introut] [get_bd_pins s2mm_ch1_introut_2]
  connect_bd_net -net MCDMA2_tx_tkeep [get_bd_pins axis_data_fifo_3/m_axis_tkeep] [get_bd_pins tx_tkeep2]
  connect_bd_net -net MCDMA2_tx_tlast [get_bd_pins axis_data_fifo_3/m_axis_tlast] [get_bd_pins tx_tlast2]
  connect_bd_net -net MCDMA2_tx_tvalid [get_bd_pins axis_data_fifo_3/m_axis_tvalid] [get_bd_pins tx_tvalid2]
  connect_bd_net -net MCDMA3_m_axis_tdata_0 [get_bd_pins axis_data_fifo_7/m_axis_tdata] [get_bd_pins m_axis_tdata_3]
  connect_bd_net -net MCDMA3_mm2s_ch1_introut_0 [get_bd_pins axi_mcdma_3/mm2s_ch1_introut] [get_bd_pins mm2s_ch1_introut_3]
  connect_bd_net -net MCDMA3_s2mm_ch1_introut_0 [get_bd_pins axi_mcdma_3/s2mm_ch1_introut] [get_bd_pins s2mm_ch1_introut_3]
  connect_bd_net -net MCDMA3_tx_tkeep [get_bd_pins axis_data_fifo_7/m_axis_tkeep] [get_bd_pins tx_tkeep3]
  connect_bd_net -net MCDMA3_tx_tlast [get_bd_pins axis_data_fifo_7/m_axis_tlast] [get_bd_pins tx_tlast3]
  connect_bd_net -net MCDMA3_tx_tvalid [get_bd_pins axis_data_fifo_7/m_axis_tvalid] [get_bd_pins tx_tvalid3]
  connect_bd_net -net MCDMA_m_axis_tdata_0 [get_bd_pins axis_data_fifo_5/m_axis_tdata] [get_bd_pins m_axis_tdata_0]
  connect_bd_net -net MCDMA_mm2s_ch1_introut_0 [get_bd_pins axi_mcdma_2/mm2s_ch1_introut] [get_bd_pins mm2s_ch1_introut_0]
  connect_bd_net -net MCDMA_s2mm_ch1_introut_0 [get_bd_pins axi_mcdma_2/s2mm_ch1_introut] [get_bd_pins s2mm_ch1_introut_0]
  connect_bd_net -net MCDMA_tx_tkeep [get_bd_pins axis_data_fifo_5/m_axis_tkeep] [get_bd_pins tx_tkeep]
  connect_bd_net -net MCDMA_tx_tlast [get_bd_pins axis_data_fifo_5/m_axis_tlast] [get_bd_pins tx_tlast]
  connect_bd_net -net MCDMA_tx_tvalid [get_bd_pins axis_data_fifo_5/m_axis_tvalid] [get_bd_pins tx_tvalid]
  connect_bd_net -net m_axis_tready_1_1 [get_bd_pins m_axis_tready_1] [get_bd_pins axis_data_fifo_5/m_axis_tready]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata0 [get_bd_pins s_axis_tdata_0] [get_bd_pins axis_data_fifo_4/s_axis_tdata]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata2 [get_bd_pins s_axis_tdata_1] [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_0 [get_bd_pins rx_tlast] [get_bd_pins axis_data_fifo_4/s_axis_tlast]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_1 [get_bd_pins rx_axis_tlast_1] [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_2 [get_bd_pins rx_axis_tlast_2] [get_bd_pins axis_data_fifo_2/s_axis_tlast]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_3 [get_bd_pins rx_axis_tlast_3] [get_bd_pins axis_data_fifo_6/s_axis_tlast]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_0 [get_bd_pins rx_tvalid] [get_bd_pins axis_data_fifo_4/s_axis_tvalid]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_1 [get_bd_pins rx_axis_tvalid_1] [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_2 [get_bd_pins rx_axis_tvalid_2] [get_bd_pins axis_data_fifo_2/s_axis_tvalid]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_3 [get_bd_pins rx_axis_tvalid_3] [get_bd_pins axis_data_fifo_6/s_axis_tvalid]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_1 [get_bd_pins tx_axis_tready_1] [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_2 [get_bd_pins tx_axis_tready_2] [get_bd_pins axis_data_fifo_3/m_axis_tready]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_3 [get_bd_pins tx_axis_tready_3] [get_bd_pins axis_data_fifo_7/m_axis_tready]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axi_mcdma_0/s_axi_lite_aclk] [get_bd_pins axi_mcdma_0/s_axi_aclk] [get_bd_pins axis_data_fifo_2/s_axis_aclk] [get_bd_pins axis_data_fifo_3/s_axis_aclk] [get_bd_pins axi_mcdma_1/s_axi_lite_aclk] [get_bd_pins axi_mcdma_1/s_axi_aclk] [get_bd_pins axis_data_fifo_4/s_axis_aclk] [get_bd_pins axis_data_fifo_5/s_axis_aclk] [get_bd_pins axi_mcdma_2/s_axi_lite_aclk] [get_bd_pins axi_mcdma_2/s_axi_aclk] [get_bd_pins axis_data_fifo_6/s_axis_aclk] [get_bd_pins axis_data_fifo_7/s_axis_aclk] [get_bd_pins axi_mcdma_3/s_axi_lite_aclk] [get_bd_pins axi_mcdma_3/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn] [get_bd_pins axi_mcdma_0/axi_resetn] [get_bd_pins axis_data_fifo_2/s_axis_aresetn] [get_bd_pins axis_data_fifo_3/s_axis_aresetn] [get_bd_pins axi_mcdma_1/axi_resetn] [get_bd_pins axis_data_fifo_4/s_axis_aresetn] [get_bd_pins axis_data_fifo_5/s_axis_aresetn] [get_bd_pins axi_mcdma_2/axi_resetn] [get_bd_pins axis_data_fifo_6/s_axis_aresetn] [get_bd_pins axis_data_fifo_7/s_axis_aresetn] [get_bd_pins axi_mcdma_3/axi_resetn]
  connect_bd_net -net s_axis_tdata_0_1 [get_bd_pins s_axis_tdata_2] [get_bd_pins axis_data_fifo_2/s_axis_tdata]
  connect_bd_net -net s_axis_tdata_0_2 [get_bd_pins s_axis_tdata_3] [get_bd_pins axis_data_fifo_6/s_axis_tdata]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial ]

  set ch0_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c0 ]

  set ch1_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c0 ]

  set lpddr4_sma_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200321000} \
   ] $lpddr4_sma_clk1

  set ch0_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c1 ]

  set ch1_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c1 ]

  set lpddr4_sma_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200321000} \
   ] $lpddr4_sma_clk2


  # Create ports
  set gt_rxn_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxn_in_0 ]
  set gt_rxp_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxp_in_0 ]
  set gt_txn_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txn_out_0 ]
  set gt_txp_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txp_out_0 ]
  set RX_REC_CLK_out_p_0_0 [ create_bd_port -dir O -from 0 -to 0 -type clk RX_REC_CLK_out_p_0_0 ]
  set RX_REC_CLK_out_n_0_0 [ create_bd_port -dir O -from 0 -to 0 -type clk RX_REC_CLK_out_n_0_0 ]
  set gt_ref_clk_p [ create_bd_port -dir I -type clk gt_ref_clk_p ]
  set gt_ref_clk_n [ create_bd_port -dir I -type clk gt_ref_clk_n ]

  # Create instance: mrmac_0_core, and set properties
  set mrmac_0_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:mrmac:2.2 mrmac_0_core ]
  set_property -dict [list \
    CONFIG.FAST_SIM_MODE {0} \
    CONFIG.FEC_SLICE0_CFG_C0 {FEC Disabled (Bypass)} \
    CONFIG.FEC_SLICE1_CFG_C0 {FEC Disabled (Bypass)} \
    CONFIG.FEC_SLICE2_CFG_C0 {FEC Disabled (Bypass)} \
    CONFIG.FEC_SLICE3_CFG_C0 {FEC Disabled (Bypass)} \
    CONFIG.GT_PIPELINE_STAGES {0} \
    CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
    CONFIG.GT_TYPE_C0 {GTY} \
    CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT0_PREEMPTION_C0 {0} \
    CONFIG.MAC_PORT0_RATE_C0 {25GE} \
    CONFIG.MAC_PORT0_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT0_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT1_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT1_PREEMPTION_C0 {0} \
    CONFIG.MAC_PORT1_RATE_C0 {25GE} \
    CONFIG.MAC_PORT1_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT1_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT2_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT2_PREEMPTION_C0 {0} \
    CONFIG.MAC_PORT2_RATE_C0 {25GE} \
    CONFIG.MAC_PORT2_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT2_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT3_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT3_PREEMPTION_C0 {0} \
    CONFIG.MAC_PORT3_RATE_C0 {25GE} \
    CONFIG.MAC_PORT3_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT3_TX_FLOW_C0 {0} \
    CONFIG.MRMAC_CLIENTS_C0 {4} \
    CONFIG.MRMAC_CONFIGURATION_TYPE {Static Configuration} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT0_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT1_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT2_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT3_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_LOCATION_C0 {MRMAC_X0Y0} \
    CONFIG.MRMAC_MODE_C0 {MAC+PCS} \
    CONFIG.MRMAC_PRESET_C0 {4x25GE Wide} \
    CONFIG.MRMAC_SPEED_C0 {4x25GE} \
    CONFIG.NUM_GT_CHANNELS {4} \
    CONFIG.PORT0_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT0_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT1_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT1_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT2_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT2_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT3_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT3_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0000} \
  ] $mrmac_0_core


  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Enable} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      CLOCK_MODE {Custom} \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {200} \
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
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 1} {CH3 1} {CH4 1} {CH5 1} {CH6 1} {CH7 1} {CH8 0} {CH9 0}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_M_AXI_FPD_DATA_WIDTH {32} \
      PS_M_AXI_LPD_DATA_WIDTH {128} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE_EP_RESET1_IO {PMC_MIO 38} \
      PS_PCIE_EP_RESET2_IO {PMC_MIO 39} \
      PS_PCIE_RESET {{ENABLE 1}} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_M_AXI_LPD {0} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PSPL_IRQ_LPD {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_c0} \
    CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_c1} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_c0} \
    CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_c1} \
    CONFIG.MC_CHANNEL_INTERLEAVING {true} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_INTERLEAVE_SIZE {256} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.NUM_CLKS {8} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {18} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_sma_clk1} \
    CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_sma_clk2} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
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
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S10_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S11_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S12_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S13_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S14_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S15_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S16_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S17_AXI]

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
   CONFIG.ASSOCIATED_BUSIF {S06_AXI:S07_AXI:S08_AXI:S09_AXI:S10_AXI:S11_AXI:S12_AXI:S13_AXI:S14_AXI:S15_AXI:S16_AXI:S17_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {7} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {3} \
  ] $util_vector_logic_1


  # Create instance: Four_MCDMA
  create_hier_cell_Four_MCDMA [current_bd_instance .] Four_MCDMA

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
  ] $proc_sys_reset_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x555555555555d5} \
    CONFIG.CONST_WIDTH {56} \
  ] $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $xlconstant_1


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_1


  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_2


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {390.625,100.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
  ] $clk_wizard_0


  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_3


  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_4


  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_5


  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_6


  # Create instance: mrmac_0_gt_wrapper
  create_hier_cell_mrmac_0_gt_wrapper [current_bd_instance .] mrmac_0_gt_wrapper

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_LITE_0_1 [get_bd_intf_pins mrmac_0_gt_wrapper/AXI4_LITE_0] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_MM2S_0 [get_bd_intf_pins axi_noc_0/S10_AXI] [get_bd_intf_pins Four_MCDMA/M_AXI_MM2S_1]
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_S2MM_0 [get_bd_intf_pins Four_MCDMA/M_AXI_S2MM_1] [get_bd_intf_pins axi_noc_0/S11_AXI]
  connect_bd_intf_net -intf_net MCDMA1_M_AXI_SG_0 [get_bd_intf_pins Four_MCDMA/M_AXI_SG_1] [get_bd_intf_pins axi_noc_0/S09_AXI]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_MM2S_0 [get_bd_intf_pins axi_noc_0/S13_AXI] [get_bd_intf_pins Four_MCDMA/M_AXI_MM2S_2]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_S2MM_0 [get_bd_intf_pins axi_noc_0/S14_AXI] [get_bd_intf_pins Four_MCDMA/M_AXI_S2MM_2]
  connect_bd_intf_net -intf_net MCDMA2_M_AXI_SG_0 [get_bd_intf_pins axi_noc_0/S12_AXI] [get_bd_intf_pins Four_MCDMA/M_AXI_SG_2]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_MM2S_0 [get_bd_intf_pins Four_MCDMA/M_AXI_MM2S_3] [get_bd_intf_pins axi_noc_0/S16_AXI]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_S2MM_0 [get_bd_intf_pins Four_MCDMA/M_AXI_S2MM_3] [get_bd_intf_pins axi_noc_0/S17_AXI]
  connect_bd_intf_net -intf_net MCDMA3_M_AXI_SG_0 [get_bd_intf_pins Four_MCDMA/M_AXI_SG_3] [get_bd_intf_pins axi_noc_0/S15_AXI]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_MM2S_0 [get_bd_intf_pins Four_MCDMA/M_AXI_MM2S_0] [get_bd_intf_pins axi_noc_0/S07_AXI]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_S2MM_0 [get_bd_intf_pins Four_MCDMA/M_AXI_S2MM_0] [get_bd_intf_pins axi_noc_0/S08_AXI]
  connect_bd_intf_net -intf_net MCDMA_M_AXI_SG_0 [get_bd_intf_pins Four_MCDMA/M_AXI_SG_0] [get_bd_intf_pins axi_noc_0/S06_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_0_1 [get_bd_intf_pins Four_MCDMA/S_AXI_LITE_1] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_0_2 [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins Four_MCDMA/S_AXI_LITE_2]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports ch0_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports ch1_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_pins mrmac_0_gt_wrapper/GT_Serial] [get_bd_intf_ports GT_Serial]
  connect_bd_intf_net -intf_net lpddr4_sma_clk1_1 [get_bd_intf_ports lpddr4_sma_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_sma_clk2_1 [get_bd_intf_ports lpddr4_sma_clk2] [get_bd_intf_pins axi_noc_0/sys_clk1]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_0 [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_0] [get_bd_intf_pins mrmac_0_gt_wrapper/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_1 [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_1] [get_bd_intf_pins mrmac_0_gt_wrapper/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_2 [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_2] [get_bd_intf_pins mrmac_0_gt_wrapper/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_rx_serdes_interface_3 [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_3] [get_bd_intf_pins mrmac_0_gt_wrapper/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_0 [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_0] [get_bd_intf_pins mrmac_0_gt_wrapper/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_1 [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_1] [get_bd_intf_pins mrmac_0_gt_wrapper/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_2 [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_2] [get_bd_intf_pins mrmac_0_gt_wrapper/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_core_gt_tx_serdes_interface_3 [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_3] [get_bd_intf_pins mrmac_0_gt_wrapper/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins mrmac_0_core/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins Four_MCDMA/S_AXI_LITE_0]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins smartconnect_0/M04_AXI] [get_bd_intf_pins Four_MCDMA/S_AXI_LITE_3]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins smartconnect_0/M06_AXI] [get_bd_intf_pins mrmac_0_gt_wrapper/S00_AXI_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins versal_cips_0/M_AXI_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S05_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_D_clk_n_0_1 [get_bd_ports gt_ref_clk_n] [get_bd_pins mrmac_0_gt_wrapper/IBUF_DS_N_0]
  connect_bd_net -net CLK_IN_D_clk_p_0_1 [get_bd_ports gt_ref_clk_p] [get_bd_pins mrmac_0_gt_wrapper/IBUF_DS_P_0]
  connect_bd_net -net MCDMA1_m_axis_tdata_0 [get_bd_pins Four_MCDMA/m_axis_tdata_1] [get_bd_pins mrmac_0_core/tx_axis_tdata2]
  connect_bd_net -net MCDMA1_mm2s_ch1_introut_0 [get_bd_pins Four_MCDMA/mm2s_ch1_introut_1] [get_bd_pins versal_cips_0/pl_ps_irq2]
  connect_bd_net -net MCDMA1_s2mm_ch1_introut_0 [get_bd_pins Four_MCDMA/s2mm_ch1_introut_1] [get_bd_pins versal_cips_0/pl_ps_irq3]
  connect_bd_net -net MCDMA1_tx_tkeep [get_bd_pins Four_MCDMA/tx_tkeep1] [get_bd_pins mrmac_0_core/tx_axis_tkeep_user2]
  connect_bd_net -net MCDMA1_tx_tlast [get_bd_pins Four_MCDMA/tx_tlast1] [get_bd_pins mrmac_0_core/tx_axis_tlast_1]
  connect_bd_net -net MCDMA1_tx_tvalid [get_bd_pins Four_MCDMA/tx_tvalid1] [get_bd_pins mrmac_0_core/tx_axis_tvalid_1]
  connect_bd_net -net MCDMA2_m_axis_tdata_0 [get_bd_pins Four_MCDMA/m_axis_tdata_2] [get_bd_pins mrmac_0_core/tx_axis_tdata4]
  connect_bd_net -net MCDMA2_mm2s_ch1_introut_0 [get_bd_pins Four_MCDMA/mm2s_ch1_introut_2] [get_bd_pins versal_cips_0/pl_ps_irq4]
  connect_bd_net -net MCDMA2_s2mm_ch1_introut_0 [get_bd_pins Four_MCDMA/s2mm_ch1_introut_2] [get_bd_pins versal_cips_0/pl_ps_irq5]
  connect_bd_net -net MCDMA2_tx_tkeep [get_bd_pins Four_MCDMA/tx_tkeep2] [get_bd_pins mrmac_0_core/tx_axis_tkeep_user4]
  connect_bd_net -net MCDMA2_tx_tlast [get_bd_pins Four_MCDMA/tx_tlast2] [get_bd_pins mrmac_0_core/tx_axis_tlast_2]
  connect_bd_net -net MCDMA2_tx_tvalid [get_bd_pins Four_MCDMA/tx_tvalid2] [get_bd_pins mrmac_0_core/tx_axis_tvalid_2]
  connect_bd_net -net MCDMA3_m_axis_tdata_0 [get_bd_pins Four_MCDMA/m_axis_tdata_3] [get_bd_pins mrmac_0_core/tx_axis_tdata6]
  connect_bd_net -net MCDMA3_mm2s_ch1_introut_0 [get_bd_pins Four_MCDMA/mm2s_ch1_introut_3] [get_bd_pins versal_cips_0/pl_ps_irq6]
  connect_bd_net -net MCDMA3_s2mm_ch1_introut_0 [get_bd_pins Four_MCDMA/s2mm_ch1_introut_3] [get_bd_pins versal_cips_0/pl_ps_irq7]
  connect_bd_net -net MCDMA3_tx_tkeep [get_bd_pins Four_MCDMA/tx_tkeep3] [get_bd_pins mrmac_0_core/tx_axis_tkeep_user6]
  connect_bd_net -net MCDMA3_tx_tlast [get_bd_pins Four_MCDMA/tx_tlast3] [get_bd_pins mrmac_0_core/tx_axis_tlast_3]
  connect_bd_net -net MCDMA3_tx_tvalid [get_bd_pins Four_MCDMA/tx_tvalid3] [get_bd_pins mrmac_0_core/tx_axis_tvalid_3]
  connect_bd_net -net MCDMA_m_axis_tdata_0 [get_bd_pins Four_MCDMA/m_axis_tdata_0] [get_bd_pins mrmac_0_core/tx_axis_tdata0]
  connect_bd_net -net MCDMA_mm2s_ch1_introut_0 [get_bd_pins Four_MCDMA/mm2s_ch1_introut_0] [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net MCDMA_s2mm_ch1_introut_0 [get_bd_pins Four_MCDMA/s2mm_ch1_introut_0] [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net MCDMA_tx_tkeep [get_bd_pins Four_MCDMA/tx_tkeep] [get_bd_pins mrmac_0_core/tx_axis_tkeep_user0]
  connect_bd_net -net MCDMA_tx_tlast [get_bd_pins Four_MCDMA/tx_tlast] [get_bd_pins mrmac_0_core/tx_axis_tlast_0]
  connect_bd_net -net MCDMA_tx_tvalid [get_bd_pins Four_MCDMA/tx_tvalid] [get_bd_pins mrmac_0_core/tx_axis_tvalid_0]
  connect_bd_net -net Net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins mrmac_0_core/tx_core_reset] [get_bd_pins mrmac_0_core/tx_serdes_reset]
  connect_bd_net -net Net1 [get_bd_pins util_vector_logic_0/Res] [get_bd_pins mrmac_0_core/rx_core_reset] [get_bd_pins mrmac_0_core/rx_serdes_reset]
  connect_bd_net -net Net2 [get_bd_pins xlconstant_0/dout] [get_bd_pins mrmac_0_core/tx_preamblein_0] [get_bd_pins mrmac_0_core/tx_preamblein_1] [get_bd_pins mrmac_0_core/tx_preamblein_3] [get_bd_pins mrmac_0_core/tx_preamblein_2]
  connect_bd_net -net aresetn_0_1 [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins mrmac_0_gt_wrapper/aresetn_0]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins xlconcat_6/dout] [get_bd_pins mrmac_0_core/tx_axi_clk] [get_bd_pins mrmac_0_core/rx_axi_clk]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins xlconcat_6/In0] [get_bd_pins xlconcat_6/In1] [get_bd_pins xlconcat_6/In2] [get_bd_pins xlconcat_6/In3] [get_bd_pins axi_noc_0/aclk7]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins mrmac_0_gt_wrapper/gtpowergood] [get_bd_pins mrmac_0_core/gtpowergood_in]
  connect_bd_net -net gt_quad_base_txn [get_bd_pins mrmac_0_gt_wrapper/gt_txn_out_0] [get_bd_ports gt_txn_out_0]
  connect_bd_net -net gt_quad_base_txp [get_bd_pins mrmac_0_gt_wrapper/gt_txp_out_0] [get_bd_ports gt_txp_out_0]
  connect_bd_net -net gt_rxn_in_0_1 [get_bd_ports gt_rxn_in_0] [get_bd_pins mrmac_0_gt_wrapper/gt_rxn_in_0]
  connect_bd_net -net gt_rxp_in_0_1 [get_bd_ports gt_rxp_in_0] [get_bd_pins mrmac_0_gt_wrapper/gt_rxp_in_0]
  connect_bd_net -net m_axis_tready_1_1 [get_bd_pins mrmac_0_core/tx_axis_tready_0] [get_bd_pins Four_MCDMA/m_axis_tready_1]
  connect_bd_net -net mrmac_0_core_gt_rx_reset_done_out [get_bd_pins mrmac_0_core/gt_rx_reset_done_out] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_core_gt_tx_reset_done_out [get_bd_pins mrmac_0_core/gt_tx_reset_done_out] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_0 [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_0] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_1 [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_1] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_2 [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_2] [get_bd_pins xlconcat_4/In2]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_3 [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_3] [get_bd_pins xlconcat_4/In3]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_0 [get_bd_pins mrmac_0_core/mst_rx_reset_out_0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_1 [get_bd_pins mrmac_0_core/mst_rx_reset_out_1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_2 [get_bd_pins mrmac_0_core/mst_rx_reset_out_2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_3 [get_bd_pins mrmac_0_core/mst_rx_reset_out_3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_0 [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_1 [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_2 [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_2] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_3 [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_3] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_0 [get_bd_pins mrmac_0_core/mst_tx_reset_out_0] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_1 [get_bd_pins mrmac_0_core/mst_tx_reset_out_1] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_2 [get_bd_pins mrmac_0_core/mst_tx_reset_out_2] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_3 [get_bd_pins mrmac_0_core/mst_tx_reset_out_3] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata0 [get_bd_pins mrmac_0_core/rx_axis_tdata0] [get_bd_pins Four_MCDMA/s_axis_tdata_0]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata2 [get_bd_pins mrmac_0_core/rx_axis_tdata2] [get_bd_pins Four_MCDMA/s_axis_tdata_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tkeep_user0 [get_bd_pins mrmac_0_core/rx_axis_tkeep_user0] [get_bd_pins Four_MCDMA/s_axis_tkeep_0]
  connect_bd_net -net mrmac_0_core_rx_axis_tkeep_user2 [get_bd_pins mrmac_0_core/rx_axis_tkeep_user2] [get_bd_pins Four_MCDMA/s_axis_tkeep_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tkeep_user6 [get_bd_pins mrmac_0_core/rx_axis_tkeep_user6] [get_bd_pins Four_MCDMA/s_axis_tkeep_3]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_0 [get_bd_pins mrmac_0_core/rx_axis_tlast_0] [get_bd_pins Four_MCDMA/rx_tlast]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_1 [get_bd_pins mrmac_0_core/rx_axis_tlast_1] [get_bd_pins Four_MCDMA/rx_axis_tlast_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_2 [get_bd_pins mrmac_0_core/rx_axis_tlast_2] [get_bd_pins Four_MCDMA/rx_axis_tlast_2]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_3 [get_bd_pins mrmac_0_core/rx_axis_tlast_3] [get_bd_pins Four_MCDMA/rx_axis_tlast_3]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_0 [get_bd_pins mrmac_0_core/rx_axis_tvalid_0] [get_bd_pins Four_MCDMA/rx_tvalid]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_1 [get_bd_pins mrmac_0_core/rx_axis_tvalid_1] [get_bd_pins Four_MCDMA/rx_axis_tvalid_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_2 [get_bd_pins mrmac_0_core/rx_axis_tvalid_2] [get_bd_pins Four_MCDMA/rx_axis_tvalid_2]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_3 [get_bd_pins mrmac_0_core/rx_axis_tvalid_3] [get_bd_pins Four_MCDMA/rx_axis_tvalid_3]
  connect_bd_net -net mrmac_0_core_rx_clr_out_0 [get_bd_pins mrmac_0_core/rx_clr_out_0] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR4]
  connect_bd_net -net mrmac_0_core_rx_clr_out_1 [get_bd_pins mrmac_0_core/rx_clr_out_1] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR5]
  connect_bd_net -net mrmac_0_core_rx_clr_out_2 [get_bd_pins mrmac_0_core/rx_clr_out_2] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR6]
  connect_bd_net -net mrmac_0_core_rx_clr_out_3 [get_bd_pins mrmac_0_core/rx_clr_out_3] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR7]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_0 [get_bd_pins mrmac_0_core/rx_clrb_leaf_out_0] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF4]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_1 [get_bd_pins mrmac_0_core/rx_clrb_leaf_out_1] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF5]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_2 [get_bd_pins mrmac_0_core/rx_clrb_leaf_out_2] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF6]
  connect_bd_net -net mrmac_0_core_rx_clrb_leaf_out_3 [get_bd_pins mrmac_0_core/rx_clrb_leaf_out_3] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF7]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_0 [get_bd_pins mrmac_0_core/rxuserrdy_out_0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_1 [get_bd_pins mrmac_0_core/rxuserrdy_out_1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_2 [get_bd_pins mrmac_0_core/rxuserrdy_out_2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_3 [get_bd_pins mrmac_0_core/rxuserrdy_out_3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_1 [get_bd_pins mrmac_0_core/tx_axis_tready_1] [get_bd_pins Four_MCDMA/tx_axis_tready_1]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_2 [get_bd_pins mrmac_0_core/tx_axis_tready_2] [get_bd_pins Four_MCDMA/tx_axis_tready_2]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_3 [get_bd_pins mrmac_0_core/tx_axis_tready_3] [get_bd_pins Four_MCDMA/tx_axis_tready_3]
  connect_bd_net -net mrmac_0_core_tx_clr_out_0 [get_bd_pins mrmac_0_core/tx_clr_out_0] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_core_tx_clr_out_1 [get_bd_pins mrmac_0_core/tx_clr_out_1] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR1]
  connect_bd_net -net mrmac_0_core_tx_clr_out_2 [get_bd_pins mrmac_0_core/tx_clr_out_2] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR2]
  connect_bd_net -net mrmac_0_core_tx_clr_out_3 [get_bd_pins mrmac_0_core/tx_clr_out_3] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLR3]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_0 [get_bd_pins mrmac_0_core/tx_clrb_leaf_out_0] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_1 [get_bd_pins mrmac_0_core/tx_clrb_leaf_out_1] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF1]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_2 [get_bd_pins mrmac_0_core/tx_clrb_leaf_out_2] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF2]
  connect_bd_net -net mrmac_0_core_tx_clrb_leaf_out_3 [get_bd_pins mrmac_0_core/tx_clrb_leaf_out_3] [get_bd_pins mrmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF3]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_0 [get_bd_pins mrmac_0_core/txuserrdy_out_0] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_1 [get_bd_pins mrmac_0_core/txuserrdy_out_1] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_2 [get_bd_pins mrmac_0_core/txuserrdy_out_2] [get_bd_pins xlconcat_5/In2]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_3 [get_bd_pins mrmac_0_core/txuserrdy_out_3] [get_bd_pins xlconcat_5/In3]
  connect_bd_net -net mrmac_0_gt_wrapper_RX_REC_CLK_out_n_0_0 [get_bd_pins mrmac_0_gt_wrapper/RX_REC_CLK_out_n_0_0] [get_bd_ports RX_REC_CLK_out_n_0_0]
  connect_bd_net -net mrmac_0_gt_wrapper_RX_REC_CLK_out_p_0_0 [get_bd_pins mrmac_0_gt_wrapper/RX_REC_CLK_out_p_0_0] [get_bd_ports RX_REC_CLK_out_p_0_0]
  connect_bd_net -net mrmac_0_gt_wrapper_ch0_rxmstresetdone_1 [get_bd_pins mrmac_0_gt_wrapper/ch0_rxmstresetdone_1] [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_0]
  connect_bd_net -net mrmac_0_gt_wrapper_ch0_rxpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch0_rxpmaresetdone_0] [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_0]
  connect_bd_net -net mrmac_0_gt_wrapper_ch0_txmstresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch0_txmstresetdone_0] [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_0]
  connect_bd_net -net mrmac_0_gt_wrapper_ch0_txpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch0_txpmaresetdone_0] [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_0]
  connect_bd_net -net mrmac_0_gt_wrapper_ch1_rxmstresetdone_1 [get_bd_pins mrmac_0_gt_wrapper/ch1_rxmstresetdone_1] [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_1]
  connect_bd_net -net mrmac_0_gt_wrapper_ch1_rxpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch1_rxpmaresetdone_0] [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_1]
  connect_bd_net -net mrmac_0_gt_wrapper_ch1_txmstresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch1_txmstresetdone_0] [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_1]
  connect_bd_net -net mrmac_0_gt_wrapper_ch1_txpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch1_txpmaresetdone_0] [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_1]
  connect_bd_net -net mrmac_0_gt_wrapper_ch2_rxmstresetdone_2 [get_bd_pins mrmac_0_gt_wrapper/ch2_rxmstresetdone_2] [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_2]
  connect_bd_net -net mrmac_0_gt_wrapper_ch2_rxpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch2_rxpmaresetdone_0] [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_2]
  connect_bd_net -net mrmac_0_gt_wrapper_ch2_txmstresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch2_txmstresetdone_0] [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_2]
  connect_bd_net -net mrmac_0_gt_wrapper_ch2_txpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch2_txpmaresetdone_0] [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_2]
  connect_bd_net -net mrmac_0_gt_wrapper_ch3_rxmstresetdone_1 [get_bd_pins mrmac_0_gt_wrapper/ch3_rxmstresetdone_1] [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_3]
  connect_bd_net -net mrmac_0_gt_wrapper_ch3_rxpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch3_rxpmaresetdone_0] [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_3]
  connect_bd_net -net mrmac_0_gt_wrapper_ch3_txmstresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch3_txmstresetdone_0] [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_3]
  connect_bd_net -net mrmac_0_gt_wrapper_ch3_txpmaresetdone_0 [get_bd_pins mrmac_0_gt_wrapper/ch3_txpmaresetdone_0] [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_3]
  connect_bd_net -net mrmac_0_gt_wrapper_gt_reset_all_0 [get_bd_pins mrmac_0_gt_wrapper/gt_reset_all_0] [get_bd_pins mrmac_0_core/gt_reset_all_in]
  connect_bd_net -net mrmac_0_gt_wrapper_gt_reset_rx_datapath_0 [get_bd_pins mrmac_0_gt_wrapper/gt_reset_rx_datapath_0] [get_bd_pins mrmac_0_core/gt_reset_rx_datapath_in]
  connect_bd_net -net mrmac_0_gt_wrapper_gt_reset_tx_datapath_0 [get_bd_pins mrmac_0_gt_wrapper/gt_reset_tx_datapath_0] [get_bd_pins mrmac_0_core/gt_reset_tx_datapath_in]
  connect_bd_net -net mrmac_0_gt_wrapper_rx_usr_clk1_0 [get_bd_pins mrmac_0_gt_wrapper/rx_usr_clk1_0] [get_bd_pins mrmac_0_core/rx_core_clk] [get_bd_pins mrmac_0_core/rx_serdes_clk]
  connect_bd_net -net mrmac_0_gt_wrapper_tx_usr_clk_0 [get_bd_pins mrmac_0_gt_wrapper/tx_usr_clk_0] [get_bd_pins mrmac_0_core/tx_core_clk] [get_bd_pins mrmac_0_core/tx_alt_serdes_clk]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins proc_sys_reset_0/bus_struct_reset] [get_bd_pins mrmac_0_core/rx_flexif_reset]
  connect_bd_net -net rx_userrdy_in_0_1 [get_bd_pins xlconcat_5/dout] [get_bd_pins mrmac_0_gt_wrapper/rx_userrdy_in_0]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins mrmac_0_core/s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins Four_MCDMA/s_axi_aresetn] [get_bd_pins mrmac_0_gt_wrapper/s_axi_aresetn]
  connect_bd_net -net s_axis_tdata_0_1 [get_bd_pins mrmac_0_core/rx_axis_tdata4] [get_bd_pins Four_MCDMA/s_axis_tdata_2]
  connect_bd_net -net s_axis_tdata_0_2 [get_bd_pins mrmac_0_core/rx_axis_tdata6] [get_bd_pins Four_MCDMA/s_axis_tdata_3]
  connect_bd_net -net s_axis_tkeep_0_1 [get_bd_pins mrmac_0_core/rx_axis_tkeep_user4] [get_bd_pins Four_MCDMA/s_axis_tkeep_2]
  connect_bd_net -net tx_userrdy_in_0_1 [get_bd_pins xlconcat_1/dout] [get_bd_pins mrmac_0_gt_wrapper/tx_userrdy_in_0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins mrmac_0_core/s_axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins Four_MCDMA/s_axi_aclk] [get_bd_pins axi_noc_0/aclk6] [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins mrmac_0_gt_wrapper/apb3clk_quad]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins mrmac_0_gt_wrapper/rx_mst_reset_in_0]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins xlconcat_2/dout] [get_bd_pins mrmac_0_gt_wrapper/tx_mst_reset_in_0]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins xlconcat_3/dout] [get_bd_pins mrmac_0_gt_wrapper/TX_MST_DP_RESET_0]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins xlconcat_4/dout] [get_bd_pins mrmac_0_gt_wrapper/RX_MST_DP_RESET_0]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins mrmac_0_core/pm_tick] [get_bd_pins mrmac_0_core/rx_alt_serdes_clk] [get_bd_pins mrmac_0_core/rx_flexif_clk] [get_bd_pins mrmac_0_core/rx_ts_clk] [get_bd_pins mrmac_0_core/tx_flexif_clk] [get_bd_pins mrmac_0_core/tx_ts_clk]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0xA4060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/axi_gpio_gt_rate_reset_ctl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/axi_gpio_gt_rate_reset_ctl_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/axi_gpio_gt_rate_reset_ctl_2/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/axi_gpio_gt_rate_reset_ctl_3/S_AXI/Reg] -force
  assign_bd_address -offset 0xA40A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/axi_gpio_gt_reset_mask/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs Four_MCDMA/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs Four_MCDMA/axi_mcdma_1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs Four_MCDMA/axi_mcdma_2/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs Four_MCDMA/axi_mcdma_3/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_gt_wrapper/gt_quad_base/APB3_INTF/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_core/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S10_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S11_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S09_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_MM2S] [get_bd_addr_segs axi_noc_0/S13_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_S2MM] [get_bd_addr_segs axi_noc_0/S14_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_SG] [get_bd_addr_segs axi_noc_0/S12_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_SG] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_MM2S] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_S2MM] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_SG] [get_bd_addr_segs axi_noc_0/S15_AXI/C2_DDR_LOW0x2] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S10_AXI/C2_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S11_AXI/C2_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S09_AXI/C2_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_MM2S] [get_bd_addr_segs axi_noc_0/S13_AXI/C3_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_S2MM] [get_bd_addr_segs axi_noc_0/S14_AXI/C3_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_1/Data_SG] [get_bd_addr_segs axi_noc_0/S12_AXI/C3_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_2/Data_SG] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_MM2S] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_S2MM] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Four_MCDMA/axi_mcdma_3/Data_SG] [get_bd_addr_segs axi_noc_0/S15_AXI/C2_DDR_LOW1x2]


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


