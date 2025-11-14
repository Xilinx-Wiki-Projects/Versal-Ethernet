
################################################################
# This is a generated script based on design: vpk120_dcmac_1x100g
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
# source vpk120_dcmac_1x100g_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axis_seg_and_unseg_converter

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1202-vsva2785-2MP-e-S
   set_property BOARD_PART xilinx.com:vpk120:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name vpk120_dcmac_1x100g

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
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:bufg_gt:1.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:dcmac:2.3\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:axi_mcdma:1.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:axis_data_fifo:2.0\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axis_seg_and_unseg_converter\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
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


# Hierarchical cell: dataflow_0
proc create_hier_cell_dataflow_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dataflow_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type rst axis_rx_rstn_i
  create_bd_pin -dir I -type clk axis_rxtx_clk
  create_bd_pin -dir I -type rst axis_tx_rstn_i
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir I -type clk pl0_ref_clk_0
  create_bd_pin -dir O prog_empty_0
  create_bd_pin -dir O prog_full_0
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir O -from 255 -to 0 m_axis_tdata
  create_bd_pin -dir O -from 255 -to 0 m_axis_tdata1
  create_bd_pin -dir I -from 255 -to 0 s_axis_tdata
  create_bd_pin -dir I -from 31 -to 0 s_axis_tkeep
  create_bd_pin -dir I s_axis_tlast
  create_bd_pin -dir O s_axis_tready
  create_bd_pin -dir I s_axis_tvalid
  create_bd_pin -dir O -from 255 -to 0 m_axis_tdata2
  create_bd_pin -dir O -from 31 -to 0 m_axis_tkeep
  create_bd_pin -dir O m_axis_tlast
  create_bd_pin -dir O m_axis_tvalid
  create_bd_pin -dir I m_axis_tready

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {512} \
    CONFIG.c_m_axi_s2mm_data_width {512} \
    CONFIG.c_m_axis_mm2s_tdata_width {512} \
    CONFIG.c_mm2s_burst_size {64} \
    CONFIG.c_s2mm_burst_size {64} \
  ] $axi_mcdma_0


  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property CONFIG.REG_AR {7} $axi_register_slice_0


  # Create instance: axis_512to256width_conv, and set properties
  set axis_512to256width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_512to256width_conv ]
  set_property -dict [list \
    CONFIG.HAS_MI_TKEEP {0} \
    CONFIG.M_TDATA_NUM_BYTES {32} \
    CONFIG.S_TDATA_NUM_BYTES {64} \
  ] $axis_512to256width_conv


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {16384} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {1} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {0} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {0} \
    CONFIG.PROG_FULL_THRESH {16370} \
    CONFIG.TDATA_NUM_BYTES {32} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {16384} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {1} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {0} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {0} \
    CONFIG.PROG_FULL_THRESH {16379} \
    CONFIG.TDATA_NUM_BYTES {32} \
  ] $axis_data_fifo_1


  # Create instance: axis_256to512width_conv, and set properties
  set axis_256to512width_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_256to512width_conv ]
  set_property -dict [list \
    CONFIG.HAS_MI_TKEEP {1} \
    CONFIG.M_TDATA_NUM_BYTES {64} \
    CONFIG.S_TDATA_NUM_BYTES {32} \
  ] $axis_256to512width_conv


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins S_AXIS_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axis_data_fifo_1/M_AXIS] [get_bd_intf_pins M_AXIS_0]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_512to256width_conv/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  connect_bd_intf_net -intf_net axis_256to512width_conv_M_AXIS [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_256to512width_conv/M_AXIS]
  connect_bd_intf_net -intf_net axis_512to1kwidth_conv_M_AXIS [get_bd_intf_pins axis_512to256width_conv/M_AXIS] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axis_256to512width_conv/S_AXIS]
  connect_bd_intf_net -intf_net pl_blocks_M_AXI_S2MM_0 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net pl_blocks_M_AXI_SG_0 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net aclk8_0_1 [get_bd_pins axis_rxtx_clk] [get_bd_pins axi_mcdma_0/s_axi_aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axis_512to256width_conv/aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axis_256to512width_conv/aclk]
  connect_bd_net -net aresetn_0_1 [get_bd_pins axis_tx_rstn_i] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axis_512to256width_conv/aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tdata [get_bd_pins axi_mcdma_0/m_axis_mm2s_tdata] [get_bd_pins axis_512to256width_conv/s_axis_tdata]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tdest [get_bd_pins axi_mcdma_0/m_axis_mm2s_tdest] [get_bd_pins axis_512to256width_conv/s_axis_tdest]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tid [get_bd_pins axi_mcdma_0/m_axis_mm2s_tid] [get_bd_pins axis_512to256width_conv/s_axis_tid]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tkeep [get_bd_pins axi_mcdma_0/m_axis_mm2s_tkeep] [get_bd_pins axis_512to256width_conv/s_axis_tkeep]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tlast [get_bd_pins axi_mcdma_0/m_axis_mm2s_tlast] [get_bd_pins axis_512to256width_conv/s_axis_tlast]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tvalid [get_bd_pins axi_mcdma_0/m_axis_mm2s_tvalid] [get_bd_pins axis_512to256width_conv/s_axis_tvalid]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready [get_bd_pins axi_mcdma_0/s_axis_s2mm_tready] [get_bd_pins axis_256to512width_conv/m_axis_tready]
  connect_bd_net -net axis_256to512width_conv_m_axis_tdata [get_bd_pins axis_256to512width_conv/m_axis_tdata] [get_bd_pins axi_mcdma_0/s_axis_s2mm_tdata]
  connect_bd_net -net axis_256to512width_conv_m_axis_tkeep [get_bd_pins axis_256to512width_conv/m_axis_tkeep] [get_bd_pins axi_mcdma_0/s_axis_s2mm_tkeep]
  connect_bd_net -net axis_256to512width_conv_m_axis_tlast [get_bd_pins axis_256to512width_conv/m_axis_tlast] [get_bd_pins axi_mcdma_0/s_axis_s2mm_tlast]
  connect_bd_net -net axis_256to512width_conv_m_axis_tvalid [get_bd_pins axis_256to512width_conv/m_axis_tvalid] [get_bd_pins axi_mcdma_0/s_axis_s2mm_tvalid]
  connect_bd_net -net axis_256to512width_conv_s_axis_tready [get_bd_pins axis_256to512width_conv/s_axis_tready] [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net axis_512to256width_conv_m_axis_tdata [get_bd_pins axis_512to256width_conv/m_axis_tdata] [get_bd_pins axis_data_fifo_1/s_axis_tdata] [get_bd_pins m_axis_tdata]
  connect_bd_net -net axis_512to256width_conv_m_axis_tdest [get_bd_pins axis_512to256width_conv/m_axis_tdest] [get_bd_pins axis_data_fifo_1/s_axis_tdest]
  connect_bd_net -net axis_512to256width_conv_m_axis_tid [get_bd_pins axis_512to256width_conv/m_axis_tid] [get_bd_pins axis_data_fifo_1/s_axis_tid]
  connect_bd_net -net axis_512to256width_conv_m_axis_tkeep [get_bd_pins axis_512to256width_conv/m_axis_tkeep] [get_bd_pins axis_data_fifo_1/s_axis_tkeep]
  connect_bd_net -net axis_512to256width_conv_m_axis_tlast [get_bd_pins axis_512to256width_conv/m_axis_tlast] [get_bd_pins axis_data_fifo_1/s_axis_tlast]
  connect_bd_net -net axis_512to256width_conv_m_axis_tvalid [get_bd_pins axis_512to256width_conv/m_axis_tvalid] [get_bd_pins axis_data_fifo_1/s_axis_tvalid]
  connect_bd_net -net axis_512to256width_conv_s_axis_tready [get_bd_pins axis_512to256width_conv/s_axis_tready] [get_bd_pins axi_mcdma_0/m_axis_mm2s_tready]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata [get_bd_pins axis_data_fifo_0/m_axis_tdata] [get_bd_pins m_axis_tdata1] [get_bd_pins axis_256to512width_conv/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep [get_bd_pins axis_data_fifo_0/m_axis_tkeep] [get_bd_pins axis_256to512width_conv/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast [get_bd_pins axis_data_fifo_0/m_axis_tlast] [get_bd_pins axis_256to512width_conv/s_axis_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid [get_bd_pins axis_data_fifo_0/m_axis_tvalid] [get_bd_pins axis_256to512width_conv/s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_0_prog_full [get_bd_pins axis_data_fifo_0/prog_full] [get_bd_pins prog_full_0]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready [get_bd_pins axis_data_fifo_0/s_axis_tready] [get_bd_pins s_axis_tready]
  connect_bd_net -net axis_data_fifo_1_m_axis_tdata [get_bd_pins axis_data_fifo_1/m_axis_tdata] [get_bd_pins m_axis_tdata2]
  connect_bd_net -net axis_data_fifo_1_m_axis_tkeep [get_bd_pins axis_data_fifo_1/m_axis_tkeep] [get_bd_pins m_axis_tkeep]
  connect_bd_net -net axis_data_fifo_1_m_axis_tlast [get_bd_pins axis_data_fifo_1/m_axis_tlast] [get_bd_pins m_axis_tlast]
  connect_bd_net -net axis_data_fifo_1_m_axis_tvalid [get_bd_pins axis_data_fifo_1/m_axis_tvalid] [get_bd_pins m_axis_tvalid]
  connect_bd_net -net axis_data_fifo_1_prog_empty [get_bd_pins axis_data_fifo_1/prog_empty] [get_bd_pins prog_empty_0]
  connect_bd_net -net axis_data_fifo_1_s_axis_tready [get_bd_pins axis_data_fifo_1/s_axis_tready] [get_bd_pins axis_512to256width_conv/m_axis_tready]
  connect_bd_net -net m_axis_tready_1 [get_bd_pins m_axis_tready] [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net pl_blocks_mm2s_ch1_introut [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net pl_blocks_s2mm_ch1_introut [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_resetn] [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net s_axis_aresetn_0_1 [get_bd_pins axis_rx_rstn_i] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_256to512width_conv/aresetn]
  connect_bd_net -net s_axis_tdata_1 [get_bd_pins s_axis_tdata] [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net s_axis_tkeep_1 [get_bd_pins s_axis_tkeep] [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net s_axis_tlast_1 [get_bd_pins s_axis_tlast] [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net s_axis_tvalid_1 [get_bd_pins s_axis_tvalid] [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins pl0_ref_clk_0] [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dcmac_and_gt
proc create_hier_cell_dcmac_and_gt { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dcmac_and_gt() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:apb_rtl:1.0 APB3_INTF

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis0_pkt_out

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis0


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk MBUFG_GT_O1
  create_bd_pin -dir I -from 5 -to 0 -type gt_usrclk tx_alt_serdes_clk
  create_bd_pin -dir I -from 5 -to 0 -type gt_usrclk rx_alt_serdes_clk
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk MBUFG_GT_O2
  create_bd_pin -dir I -from 5 -to 0 -type gt_usrclk tx_serdes_clk
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk MBUFG_GT_O3
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk MBUFG_GT_O4
  create_bd_pin -dir I -from 5 -to 0 -type gt_usrclk rx_serdes_clk
  create_bd_pin -dir I -type clk tx_core_clk
  create_bd_pin -dir O -from 0 -to 0 -type clk IBUFDS_GTME5_ODIV2
  create_bd_pin -dir I -type clk tx_axi_clk
  create_bd_pin -dir I -from 2 -to 0 ch0_loopback
  create_bd_pin -dir I -from 7 -to 0 ch0_txrate
  create_bd_pin -dir I -from 5 -to 0 -type rst tx_serdes_reset
  create_bd_pin -dir I -from 5 -to 0 -type rst rx_serdes_reset
  create_bd_pin -dir I gt_reset_all_in
  create_bd_pin -dir I -from 23 -to 0 gt_reset_tx_datapath_in_0
  create_bd_pin -dir I ch0_rxcdrhold
  create_bd_pin -dir I -from 6 -to 0 ch0_txmaincursor
  create_bd_pin -dir I -from 5 -to 0 ch0_txpostcursor
  create_bd_pin -dir I -from 5 -to 0 ch0_txprecursor
  create_bd_pin -dir I -type rst tx_core_reset
  create_bd_pin -dir I -type rst rx_core_reset
  create_bd_pin -dir I -from 23 -to 0 gt_reset_rx_datapath_in_3
  create_bd_pin -dir O gt_tx_reset_done_out_0
  create_bd_pin -dir O gt_tx_reset_done_out_1
  create_bd_pin -dir O gt_tx_reset_done_out_2
  create_bd_pin -dir O gt_tx_reset_done_out_3
  create_bd_pin -dir O gt_rx_reset_done_out_0
  create_bd_pin -dir O gt_rx_reset_done_out_1
  create_bd_pin -dir O gt_rx_reset_done_out_2
  create_bd_pin -dir O gt_rx_reset_done_out_3
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type clk apb3clk
  create_bd_pin -dir I -type rst s_axi_aresetn1
  create_bd_pin -dir O -from 255 -to 0 m_axis0_tdata
  create_bd_pin -dir O -from 31 -to 0 m_axis0_tkeep
  create_bd_pin -dir O m_axis0_tlast
  create_bd_pin -dir I m_axis0_tready
  create_bd_pin -dir O m_axis0_tvalid
  create_bd_pin -dir I -from 255 -to 0 s_axis0_tdata1
  create_bd_pin -dir I -from 31 -to 0 s_axis0_tkeep1
  create_bd_pin -dir I s_axis0_tlast1
  create_bd_pin -dir I s_axis0_tvalid1
  create_bd_pin -dir O s_axis0_tready1
  create_bd_pin -dir I tx_axis_tvalid_0
  create_bd_pin -dir O Unseg2SegVal0_out
  create_bd_pin -dir O Unseg2SegVal1_out
  create_bd_pin -dir O -from 127 -to 0 Unseg2SegDat0_out
  create_bd_pin -dir O Unseg2SegEop0_out
  create_bd_pin -dir O Unseg2SegEop1_out
  create_bd_pin -dir O Unseg2SegSop0_out
  create_bd_pin -dir O Unseg2SegSop1_out
  create_bd_pin -dir O -from 127 -to 0 rx_axis_tdata0
  create_bd_pin -dir O rx_axis_tuser_eop0
  create_bd_pin -dir O rx_axis_tuser_eop1
  create_bd_pin -dir O rx_axis_tuser_sop0
  create_bd_pin -dir O rx_axis_tuser_sop1
  create_bd_pin -dir O rx_axis_tvalid_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $xlconstant_0


  # Create instance: util_ds_buf_mbufg_tx_0, and set properties
  set util_ds_buf_mbufg_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_mbufg_tx_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $util_ds_buf_mbufg_tx_0


  # Create instance: util_ds_buf_mbufg_rx_0, and set properties
  set util_ds_buf_mbufg_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_mbufg_rx_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $util_ds_buf_mbufg_rx_0


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDS_GTME5} $util_ds_buf_0


  # Create instance: dcmac_0_core, and set properties
  set dcmac_0_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:dcmac:2.3 dcmac_0_core ]
  set_property -dict [list \
    CONFIG.DCMAC_CONFIGURATION_TYPE {Static Configuration} \
    CONFIG.DCMAC_DATA_PATH_INTERFACE_C0 {391MHz Upto 6 Ports} \
    CONFIG.DCMAC_LOCATION_C0 {DCMAC_X0Y0} \
    CONFIG.DCMAC_MODE_C0 {Coupled MAC+PCS} \
    CONFIG.FAST_SIM_MODE {0} \
    CONFIG.FEC_SLICE0_CFG_C0 {RS(528) CL91} \
    CONFIG.GT_PIPELINE_STAGES {0} \
    CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
    CONFIG.GT_TYPE_C0 {GTM} \
    CONFIG.MAC_PORT0_CONFIG_C0 {100CAUI-4} \
    CONFIG.MAC_PORT0_ENABLE_C0 {1} \
    CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT0_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT0_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT0_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT0_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT1_ENABLE_C0 {0} \
    CONFIG.MAC_PORT2_ENABLE_C0 {0} \
    CONFIG.MAC_PORT3_ENABLE_C0 {0} \
    CONFIG.MAC_PORT4_ENABLE_C0 {0} \
    CONFIG.MAC_PORT5_ENABLE_C0 {0} \
    CONFIG.NUM_GT_CHANNELS {4} \
    CONFIG.PHY_OPERATING_MODE_C0 {N/A} \
    CONFIG.PORT0_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT0_1588v2_Operation_MODE_C0 {2-step} \
    CONFIG.PORT1_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT1_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT2_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT2_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT3_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT3_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT4_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT4_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT5_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT5_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0000} \
  ] $dcmac_0_core


  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {99.999901} \
    CONFIG.CHANNEL_ORDERING {/dcmac_0_core/gtm_tx_serdes_interface_0 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/TX0_GT_IP_Interface.0 /dcmac_0_core/gtm_tx_serdes_interface_1 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/TX1_GT_IP_Interface.1\
/dcmac_0_core/gtm_tx_serdes_interface_2 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/TX2_GT_IP_Interface.2 /dcmac_0_core/gtm_tx_serdes_interface_3 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/TX3_GT_IP_Interface.3\
/dcmac_0_core/gtm_rx_serdes_interface_0 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/RX0_GT_IP_Interface.0 /dcmac_0_core/gtm_rx_serdes_interface_1 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/RX1_GT_IP_Interface.1\
/dcmac_0_core/gtm_rx_serdes_interface_2 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/RX2_GT_IP_Interface.2 /dcmac_0_core/gtm_rx_serdes_interface_3 dcmac_0_exdes_support_dcmac_0_core_0./gt_quad_base/RX3_GT_IP_Interface.3}\
\
    CONFIG.GT_TYPE {GTM} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTM REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED true TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80\
TX_INT_DATA_WIDTH 64 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET GTM-NRZ_Ethernet_25G\
RX_PAM_SEL NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET NRZ_Ethernet_25G RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY\
156.25 RX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 RX_FRACN_ENABLED true RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 64 RX_BUFFER_MODE\
1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 14 RX_EQ_MODE AUTO RX_COUPLING\
AC RX_TERMINATION VCOM_VREF RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CB_K 00000000 RX_CB_DISP 00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1\
false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0\
0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2\
false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT\
0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0\
false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3\
false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000\
RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTM} \
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
    CONFIG.PROT0_NO_OF_LANES {4} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/gt_quad_base {/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/gt_quad_base {/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {{/gt_ref_clk0_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT0} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {PROT0} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT0} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {PROT0} \
  ] $gt_quad_base

  # Need to retain value_src of defaults
  # Enable this script to override value_src settings
  set_param bd.wbt.allow_value_src true
  set_property -dict [list \
    CONFIG.CHANNEL_ORDERING.VALUE_SRC {default} \
    CONFIG.GT_TYPE.VALUE_SRC {default} \
    CONFIG.PROT0_ENABLE.VALUE_SRC {default} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_SRC {default} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_SRC {default} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_SRC {default} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_SRC {default} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_SRC {default} \
    CONFIG.QUAD_USAGE.VALUE_SRC {default} \
    CONFIG.RX0_LANE_SEL.VALUE_SRC {default} \
    CONFIG.RX1_LANE_SEL.VALUE_SRC {default} \
    CONFIG.RX2_LANE_SEL.VALUE_SRC {default} \
    CONFIG.RX3_LANE_SEL.VALUE_SRC {default} \
    CONFIG.TX0_LANE_SEL.VALUE_SRC {default} \
    CONFIG.TX1_LANE_SEL.VALUE_SRC {default} \
    CONFIG.TX2_LANE_SEL.VALUE_SRC {default} \
    CONFIG.TX3_LANE_SEL.VALUE_SRC {default} \
  ] $gt_quad_base

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {manual} \
    CONFIG.GT_TYPE.VALUE_MODE {manual} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {manual} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_MODE {manual} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {manual} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_MODE {manual} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE {manual} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE {manual} \
    CONFIG.QUAD_USAGE.VALUE_MODE {manual} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {manual} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {manual} \
  ] $gt_quad_base


  # Create instance: axis_seg_and_unseg_c_0, and set properties
  set block_name axis_seg_and_unseg_converter
  set block_cell_name axis_seg_and_unseg_c_0
  if { [catch {set axis_seg_and_unseg_c_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_seg_and_unseg_c_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {391000600} \
 ] [get_bd_intf_pins /dcmac_and_gt/axis_seg_and_unseg_c_0/m_axis0_pkt_out]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins util_ds_buf_0/CLK_IN_D1] [get_bd_intf_pins CLK_IN_D_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gt_quad_base/GT_Serial] [get_bd_intf_pins GT_Serial]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins gt_quad_base/APB3_INTF] [get_bd_intf_pins APB3_INTF]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins dcmac_0_core/s_axi] [get_bd_intf_pins s_axi]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axis_seg_and_unseg_c_0/m_axis0_pkt_out] [get_bd_intf_pins m_axis0_pkt_out]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins axis_seg_and_unseg_c_0/s_axis0] [get_bd_intf_pins s_axis0]
  connect_bd_intf_net -intf_net dcmac_0_gtm_rx_serdes_interface_0 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_0] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_rx_serdes_interface_1 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_1] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_rx_serdes_interface_2 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_2] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_rx_serdes_interface_3 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_3] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_tx_serdes_interface_0 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_0] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_tx_serdes_interface_1 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_1] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_tx_serdes_interface_2 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_2] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_gtm_tx_serdes_interface_3 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_3] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins gt_reset_rx_datapath_in_3] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_0] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_1] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_2] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_3]
  connect_bd_net -net apb3clk_1 [get_bd_pins apb3clk] [get_bd_pins gt_quad_base/apb3clk] [get_bd_pins dcmac_0_core/s_axi_aclk]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegDat0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegDat0_out] [get_bd_pins dcmac_0_core/tx_axis_tdata0] [get_bd_pins Unseg2SegDat0_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegDat1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegDat1_out] [get_bd_pins dcmac_0_core/tx_axis_tdata1]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegEop0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegEop0_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop0] [get_bd_pins Unseg2SegEop0_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegEop1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegEop1_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop1] [get_bd_pins Unseg2SegEop1_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegErr0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegErr0_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_err0]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegErr1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegErr1_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_err1]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegMty0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegMty0_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty0]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegMty1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegMty1_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty1]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegSop0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegSop0_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop0] [get_bd_pins Unseg2SegSop0_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegSop1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegSop1_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop1] [get_bd_pins Unseg2SegSop1_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegVal0_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegVal0_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena0] [get_bd_pins Unseg2SegVal0_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_Unseg2SegVal1_out [get_bd_pins axis_seg_and_unseg_c_0/Unseg2SegVal1_out] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena1] [get_bd_pins Unseg2SegVal1_out]
  connect_bd_net -net axis_seg_and_unseg_c_0_m_axis0_tdata [get_bd_pins axis_seg_and_unseg_c_0/m_axis0_tdata] [get_bd_pins m_axis0_tdata]
  connect_bd_net -net axis_seg_and_unseg_c_0_m_axis0_tkeep [get_bd_pins axis_seg_and_unseg_c_0/m_axis0_tkeep] [get_bd_pins m_axis0_tkeep]
  connect_bd_net -net axis_seg_and_unseg_c_0_m_axis0_tlast [get_bd_pins axis_seg_and_unseg_c_0/m_axis0_tlast] [get_bd_pins m_axis0_tlast]
  connect_bd_net -net axis_seg_and_unseg_c_0_m_axis0_tvalid [get_bd_pins axis_seg_and_unseg_c_0/m_axis0_tvalid] [get_bd_pins m_axis0_tvalid]
  connect_bd_net -net axis_seg_and_unseg_c_0_s_axis0_tready [get_bd_pins axis_seg_and_unseg_c_0/s_axis0_tready] [get_bd_pins s_axis0_tready1]
  connect_bd_net -net ch0_loopback_1 [get_bd_pins ch0_loopback] [get_bd_pins gt_quad_base/ch0_loopback] [get_bd_pins gt_quad_base/ch1_loopback] [get_bd_pins gt_quad_base/ch2_loopback] [get_bd_pins gt_quad_base/ch3_loopback]
  connect_bd_net -net ch0_txrate_1 [get_bd_pins ch0_txrate] [get_bd_pins gt_quad_base/ch0_txrate] [get_bd_pins gt_quad_base/ch1_txrate] [get_bd_pins gt_quad_base/ch2_txrate] [get_bd_pins gt_quad_base/ch3_txrate]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata0 [get_bd_pins dcmac_0_core/rx_axis_tdata0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegDat0_in] [get_bd_pins rx_axis_tdata0]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata1 [get_bd_pins dcmac_0_core/rx_axis_tdata1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegDat1_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena0 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegVal0_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena1 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegVal1_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop0 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegEop0_in] [get_bd_pins rx_axis_tuser_eop0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop1 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegEop1_in] [get_bd_pins rx_axis_tuser_eop1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err0 [get_bd_pins dcmac_0_core/rx_axis_tuser_err0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegErr0_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err1 [get_bd_pins dcmac_0_core/rx_axis_tuser_err1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegErr1_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty0 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegMty0_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty1 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegMty1_in]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop0 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop0] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegSop0_in] [get_bd_pins rx_axis_tuser_sop0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop1 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop1] [get_bd_pins axis_seg_and_unseg_c_0/Seg2UnSegSop1_in] [get_bd_pins rx_axis_tuser_sop1]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_0 [get_bd_pins dcmac_0_core/rx_axis_tvalid_0] [get_bd_pins axis_seg_and_unseg_c_0/rx_axis_tvalid_i] [get_bd_pins rx_axis_tvalid_0]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_0 [get_bd_pins dcmac_0_core/tx_axis_tready_0] [get_bd_pins axis_seg_and_unseg_c_0/tx_axis_tready_i]
  connect_bd_net -net dcmac_0_gt_rx_reset_done_out_0 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_0] [get_bd_pins gt_rx_reset_done_out_0]
  connect_bd_net -net dcmac_0_gt_rx_reset_done_out_1 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_1] [get_bd_pins gt_rx_reset_done_out_1]
  connect_bd_net -net dcmac_0_gt_rx_reset_done_out_2 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_2] [get_bd_pins gt_rx_reset_done_out_2]
  connect_bd_net -net dcmac_0_gt_rx_reset_done_out_3 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_3] [get_bd_pins gt_rx_reset_done_out_3]
  connect_bd_net -net dcmac_0_gt_tx_reset_done_out_0 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_0] [get_bd_pins gt_tx_reset_done_out_0]
  connect_bd_net -net dcmac_0_gt_tx_reset_done_out_1 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_1] [get_bd_pins gt_tx_reset_done_out_1]
  connect_bd_net -net dcmac_0_gt_tx_reset_done_out_2 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_2] [get_bd_pins gt_tx_reset_done_out_2]
  connect_bd_net -net dcmac_0_gt_tx_reset_done_out_3 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_3] [get_bd_pins gt_tx_reset_done_out_3]
  connect_bd_net -net dcmac_0_iloreset_out_0 [get_bd_pins dcmac_0_core/iloreset_out_0] [get_bd_pins gt_quad_base/ch0_iloreset]
  connect_bd_net -net dcmac_0_iloreset_out_1 [get_bd_pins dcmac_0_core/iloreset_out_1] [get_bd_pins gt_quad_base/ch1_iloreset]
  connect_bd_net -net dcmac_0_iloreset_out_2 [get_bd_pins dcmac_0_core/iloreset_out_2] [get_bd_pins gt_quad_base/ch2_iloreset]
  connect_bd_net -net dcmac_0_iloreset_out_3 [get_bd_pins dcmac_0_core/iloreset_out_3] [get_bd_pins gt_quad_base/ch3_iloreset]
  connect_bd_net -net dcmac_0_pllreset_out_0 [get_bd_pins dcmac_0_core/pllreset_out_0] [get_bd_pins gt_quad_base/hsclk0_lcpllreset] [get_bd_pins gt_quad_base/hsclk0_rpllreset] [get_bd_pins gt_quad_base/hsclk1_lcpllreset] [get_bd_pins gt_quad_base/hsclk1_rpllreset]
  connect_bd_net -net dcmac_0_rx_clr_out_0 [get_bd_pins dcmac_0_core/rx_clr_out_0] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CLR]
  connect_bd_net -net dcmac_0_rx_clrb_leaf_out_0 [get_bd_pins dcmac_0_core/rx_clrb_leaf_out_0] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net dcmac_0_tx_clr_out_0 [get_bd_pins dcmac_0_core/tx_clr_out_0] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CLR]
  connect_bd_net -net dcmac_0_tx_clrb_leaf_out_0 [get_bd_pins dcmac_0_core/tx_clrb_leaf_out_0] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net gt_quad_base_ch0_iloresetdone [get_bd_pins gt_quad_base/ch0_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_0]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk [get_bd_pins gt_quad_base/ch0_rxoutclk] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_txoutclk [get_bd_pins gt_quad_base/ch0_txoutclk] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_iloresetdone [get_bd_pins gt_quad_base/ch1_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_1]
  connect_bd_net -net gt_quad_base_ch2_iloresetdone [get_bd_pins gt_quad_base/ch2_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_2]
  connect_bd_net -net gt_quad_base_ch3_iloresetdone [get_bd_pins gt_quad_base/ch3_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_3]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins gt_quad_base/gtpowergood] [get_bd_pins dcmac_0_core/gtpowergood_in]
  connect_bd_net -net gt_quad_base_hsclk0_lcplllock [get_bd_pins gt_quad_base/hsclk0_lcplllock] [get_bd_pins dcmac_0_core/plllock_in_0]
  connect_bd_net -net gt_reset_all_in_1 [get_bd_pins gt_reset_all_in] [get_bd_pins dcmac_0_core/gt_reset_all_in]
  connect_bd_net -net gt_reset_tx_datapath_in_0_1 [get_bd_pins gt_reset_tx_datapath_in_0] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_0] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_1] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_2] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_3]
  connect_bd_net -net gt_rxcdrhold_1 [get_bd_pins ch0_rxcdrhold] [get_bd_pins gt_quad_base/ch0_rxcdrhold] [get_bd_pins gt_quad_base/ch1_rxcdrhold] [get_bd_pins gt_quad_base/ch2_rxcdrhold] [get_bd_pins gt_quad_base/ch3_rxcdrhold]
  connect_bd_net -net gt_txmaincursor_1 [get_bd_pins ch0_txmaincursor] [get_bd_pins gt_quad_base/ch0_txmaincursor] [get_bd_pins gt_quad_base/ch1_txmaincursor] [get_bd_pins gt_quad_base/ch2_txmaincursor] [get_bd_pins gt_quad_base/ch3_txmaincursor]
  connect_bd_net -net gt_txpostcursor_1 [get_bd_pins ch0_txpostcursor] [get_bd_pins gt_quad_base/ch0_txpostcursor] [get_bd_pins gt_quad_base/ch1_txpostcursor] [get_bd_pins gt_quad_base/ch2_txpostcursor] [get_bd_pins gt_quad_base/ch3_txpostcursor]
  connect_bd_net -net gt_txprecursor_1 [get_bd_pins ch0_txprecursor] [get_bd_pins gt_quad_base/ch0_txprecursor] [get_bd_pins gt_quad_base/ch1_txprecursor] [get_bd_pins gt_quad_base/ch2_txprecursor] [get_bd_pins gt_quad_base/ch3_txprecursor]
  connect_bd_net -net m_axis0_tready_1 [get_bd_pins m_axis0_tready] [get_bd_pins axis_seg_and_unseg_c_0/m_axis0_tready]
  connect_bd_net -net rx_alt_serdes_clk_1 [get_bd_pins rx_alt_serdes_clk] [get_bd_pins dcmac_0_core/rx_alt_serdes_clk]
  connect_bd_net -net rx_core_reset_1 [get_bd_pins rx_core_reset] [get_bd_pins dcmac_0_core/rx_core_reset]
  connect_bd_net -net rx_serdes_clk_1 [get_bd_pins rx_serdes_clk] [get_bd_pins dcmac_0_core/rx_serdes_clk]
  connect_bd_net -net rx_serdes_reset_1 [get_bd_pins rx_serdes_reset] [get_bd_pins dcmac_0_core/rx_serdes_reset]
  connect_bd_net -net s_axi_aresetn1_1 [get_bd_pins s_axi_aresetn1] [get_bd_pins dcmac_0_core/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins gt_quad_base/apb3presetn] [get_bd_pins axis_seg_and_unseg_c_0/aresetn_rx_seg_in] [get_bd_pins axis_seg_and_unseg_c_0/aresetn_tx_seg_in] [get_bd_pins axis_seg_and_unseg_c_0/aresetn_axis_unseg_in]
  connect_bd_net -net s_axis0_tdata1_1 [get_bd_pins s_axis0_tdata1] [get_bd_pins axis_seg_and_unseg_c_0/s_axis0_tdata]
  connect_bd_net -net s_axis0_tkeep1_1 [get_bd_pins s_axis0_tkeep1] [get_bd_pins axis_seg_and_unseg_c_0/s_axis0_tkeep]
  connect_bd_net -net s_axis0_tlast1_1 [get_bd_pins s_axis0_tlast1] [get_bd_pins axis_seg_and_unseg_c_0/s_axis0_tlast]
  connect_bd_net -net s_axis0_tvalid1_1 [get_bd_pins s_axis0_tvalid1] [get_bd_pins axis_seg_and_unseg_c_0/s_axis0_tvalid]
  connect_bd_net -net tx_alt_serdes_clk_1 [get_bd_pins tx_alt_serdes_clk] [get_bd_pins dcmac_0_core/tx_alt_serdes_clk]
  connect_bd_net -net tx_axi_clk_1 [get_bd_pins tx_axi_clk] [get_bd_pins dcmac_0_core/rx_axi_clk] [get_bd_pins dcmac_0_core/tx_axi_clk] [get_bd_pins axis_seg_and_unseg_c_0/aclk_rx_seg_in] [get_bd_pins axis_seg_and_unseg_c_0/aclk_tx_seg_in] [get_bd_pins axis_seg_and_unseg_c_0/aclk_axis_unseg_in]
  connect_bd_net -net tx_axis_tvalid_0_1 [get_bd_pins tx_axis_tvalid_0] [get_bd_pins dcmac_0_core/tx_axis_tvalid_0]
  connect_bd_net -net tx_core_clk_1 [get_bd_pins tx_core_clk] [get_bd_pins dcmac_0_core/rx_core_clk] [get_bd_pins dcmac_0_core/rx_flexif_clk] [get_bd_pins dcmac_0_core/rx_macif_clk] [get_bd_pins dcmac_0_core/ts_clk] [get_bd_pins dcmac_0_core/tx_core_clk] [get_bd_pins dcmac_0_core/tx_flexif_clk] [get_bd_pins dcmac_0_core/tx_macif_clk]
  connect_bd_net -net tx_core_reset_1 [get_bd_pins tx_core_reset] [get_bd_pins dcmac_0_core/tx_core_reset]
  connect_bd_net -net tx_serdes_clk_1 [get_bd_pins tx_serdes_clk] [get_bd_pins dcmac_0_core/tx_serdes_clk]
  connect_bd_net -net tx_serdes_reset_1 [get_bd_pins tx_serdes_reset] [get_bd_pins dcmac_0_core/tx_serdes_reset]
  connect_bd_net -net util_ds_buf_0_IBUFDS_GTME5_O [get_bd_pins util_ds_buf_0/IBUFDS_GTME5_O] [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net util_ds_buf_0_IBUFDS_GTME5_ODIV2 [get_bd_pins util_ds_buf_0/IBUFDS_GTME5_ODIV2] [get_bd_pins IBUFDS_GTME5_ODIV2]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O1 [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_O1] [get_bd_pins MBUFG_GT_O1]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O2 [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_O2] [get_bd_pins MBUFG_GT_O4] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins gt_quad_base/ch1_rxusrclk] [get_bd_pins gt_quad_base/ch2_rxusrclk] [get_bd_pins gt_quad_base/ch3_rxusrclk]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O1 [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_O1] [get_bd_pins MBUFG_GT_O3]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O2 [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_O2] [get_bd_pins MBUFG_GT_O2] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/ch1_txusrclk] [get_bd_pins gt_quad_base/ch2_txusrclk] [get_bd_pins gt_quad_base/ch3_txusrclk]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CE] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CE]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk
proc create_hier_cell_clk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 In0
  create_bd_pin -dir O -from 5 -to 0 dout
  create_bd_pin -dir O -from 5 -to 0 dout1
  create_bd_pin -dir I -from 0 -to 0 In1
  create_bd_pin -dir O -from 5 -to 0 dout3
  create_bd_pin -dir I -from 0 -to 0 In2
  create_bd_pin -dir O -from 5 -to 0 dout2
  create_bd_pin -dir I -from 0 -to 0 In3
  create_bd_pin -dir O -type clk clk_out2
  create_bd_pin -dir O -type clk clk_out1
  create_bd_pin -dir I -type clk outclk

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_1


  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_2


  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_3


  # Create instance: bufg_gt_odiv2, and set properties
  set bufg_gt_odiv2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt_odiv2 ]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {782,390.625,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
  ] $clk_wizard_0


  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconcat_2/In1] [get_bd_pins xlconcat_2/In2] [get_bd_pins xlconcat_2/In3] [get_bd_pins xlconcat_2/In4] [get_bd_pins xlconcat_2/In5]
  connect_bd_net -net Net [get_bd_pins In3] [get_bd_pins xlconcat_3/In0] [get_bd_pins xlconcat_3/In1] [get_bd_pins xlconcat_3/In2] [get_bd_pins xlconcat_3/In3] [get_bd_pins xlconcat_3/In4] [get_bd_pins xlconcat_3/In5]
  connect_bd_net -net bufg_gt_odiv2_usrclk [get_bd_pins bufg_gt_odiv2/usrclk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins clk_out1]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins clk_out2]
  connect_bd_net -net outclk_1 [get_bd_pins outclk] [get_bd_pins bufg_gt_odiv2/outclk]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins dout1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins xlconcat_2/dout] [get_bd_pins dout2]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins xlconcat_3/dout] [get_bd_pins dout3]

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

  set gt_ref_clk0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_ref_clk0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $gt_ref_clk0

  set ch0_lpddr4_trip1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_trip1 ]

  set ch1_lpddr4_trip1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_trip1 ]

  set lpddr4_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200321000} \
   ] $lpddr4_clk1

  set ch0_lpddr4_trip2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_trip2 ]

  set ch1_lpddr4_trip2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_trip2 ]

  set lpddr4_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200321000} \
   ] $lpddr4_clk2


  # Create ports

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      CLOCK_MODE {Custom} \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      DEVICE_INTEGRITY_MODE {Sysmon temperature voltage and external IO monitoring} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_PL1_REF_CTRL_FREQMHZ {350} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
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
      PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 39 .. 40}}} \
      PS_IRQ_USAGE {{CH0 0} {CH1 0} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 1} {CH9 1}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE_EP_RESET1_IO {PS_MIO 18} \
      PS_PCIE_EP_RESET2_IO {PS_MIO 19} \
      PS_PCIE_RESET {{ENABLE 1}} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {1} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_INTERFACE_TO_USE {I2C} \
      SMON_PMBUS_ADDRESS {0x18} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_trip1} \
    CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_trip2} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_trip1} \
    CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_trip2} \
    CONFIG.MC_CHANNEL_INTERLEAVING {true} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_INTERLEAVE_SIZE {256} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.NUM_CLKS {10} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {10} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_clk1} \
    CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_clk2} \
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
   CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
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
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
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
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M00_AXI:0x0} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

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
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI:S08_AXI:S09_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk9]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {14} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: clk
  create_hier_cell_clk [current_bd_instance .] clk

  # Create instance: dcmac_and_gt
  create_hier_cell_dcmac_and_gt [current_bd_instance .] dcmac_and_gt

  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {1} $axi_apb_bridge_0


  # Create instance: axi_gpio_gt_ctl, and set properties
  set axi_gpio_gt_ctl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_ctl ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_gt_ctl


  # Create instance: axi_gpio_rx_datapath, and set properties
  set axi_gpio_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_rx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_rx_datapath


  # Create instance: axi_gpio_tx_datapath, and set properties
  set axi_gpio_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_tx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_tx_datapath


  # Create instance: axi_reset_done_dyn, and set properties
  set axi_reset_done_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_reset_done_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {24} \
    CONFIG.C_GPIO_WIDTH {24} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_reset_done_dyn


  # Create instance: axi_resets_dyn, and set properties
  set axi_resets_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_resets_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {14} \
  ] $axi_resets_dyn


  # Create instance: xlslice_gt_line_rate, and set properties
  set xlslice_gt_line_rate [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_line_rate ]
  set_property -dict [list \
    CONFIG.DIN_FROM {8} \
    CONFIG.DIN_TO {1} \
    CONFIG.DOUT_WIDTH {8} \
  ] $xlslice_gt_line_rate


  # Create instance: xlslice_gt_loopback, and set properties
  set xlslice_gt_loopback [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_loopback ]
  set_property -dict [list \
    CONFIG.DIN_FROM {11} \
    CONFIG.DIN_TO {9} \
    CONFIG.DOUT_WIDTH {3} \
  ] $xlslice_gt_loopback


  # Create instance: xlslice_gt_reset1, and set properties
  set xlslice_gt_reset1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset1


  # Create instance: xlslice_gt_rxcdrhold, and set properties
  set xlslice_gt_rxcdrhold [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_rxcdrhold ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {31} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_rxcdrhold


  # Create instance: xlslice_gt_txmaincursor, and set properties
  set xlslice_gt_txmaincursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txmaincursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {30} \
    CONFIG.DIN_TO {24} \
    CONFIG.DOUT_WIDTH {7} \
  ] $xlslice_gt_txmaincursor


  # Create instance: xlslice_gt_txpostcursor, and set properties
  set xlslice_gt_txpostcursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txpostcursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {18} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txpostcursor


  # Create instance: xlslice_gt_txprecursor, and set properties
  set xlslice_gt_txprecursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txprecursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {17} \
    CONFIG.DIN_TO {12} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txprecursor


  # Create instance: xlslice_rx_core_rst, and set properties
  set xlslice_rx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_core_rst


  # Create instance: xlslice_rx_datapath, and set properties
  set xlslice_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_rx_datapath


  # Create instance: xlslice_rx_serdes_rst, and set properties
  set xlslice_rx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {13} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_rx_serdes_rst


  # Create instance: xlslice_tx_core_rst, and set properties
  set xlslice_tx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_core_rst


  # Create instance: xlslice_tx_datapath, and set properties
  set xlslice_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_tx_datapath


  # Create instance: xlslice_tx_serdes_rst, and set properties
  set xlslice_tx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_tx_serdes_rst


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {24} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {24} $xlconcat_1


  # Create instance: rst_clk_wizard_0_782M, and set properties
  set rst_clk_wizard_0_782M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wizard_0_782M ]

  # Create instance: dataflow_0
  create_hier_cell_dataflow_0 [current_bd_instance .] dataflow_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create interface connections
  connect_bd_intf_net -intf_net APB3_INTF_1 [get_bd_intf_pins dcmac_and_gt/APB3_INTF] [get_bd_intf_pins axi_apb_bridge_0/APB_M]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports gt_ref_clk0] [get_bd_intf_pins dcmac_and_gt/CLK_IN_D_0]
  connect_bd_intf_net -intf_net S_AXIS_0_1 [get_bd_intf_pins dataflow_0/S_AXIS_0] [get_bd_intf_pins dcmac_and_gt/m_axis0_pkt_out]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_trip1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports ch0_lpddr4_trip2] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_trip1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports ch1_lpddr4_trip2] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net dataflow_0_M_AXI [get_bd_intf_pins dataflow_0/M_AXI] [get_bd_intf_pins axi_noc_0/S07_AXI]
  connect_bd_intf_net -intf_net dataflow_0_M_AXIS_0 [get_bd_intf_pins dataflow_0/M_AXIS_0] [get_bd_intf_pins dcmac_and_gt/s_axis0]
  connect_bd_intf_net -intf_net dataflow_0_M_AXI_S2MM [get_bd_intf_pins dataflow_0/M_AXI_S2MM] [get_bd_intf_pins axi_noc_0/S08_AXI]
  connect_bd_intf_net -intf_net dataflow_0_M_AXI_SG [get_bd_intf_pins axi_noc_0/S09_AXI] [get_bd_intf_pins dataflow_0/M_AXI_SG]
  connect_bd_intf_net -intf_net dcmac_and_gt_GT_Serial [get_bd_intf_ports GT_Serial] [get_bd_intf_pins dcmac_and_gt/GT_Serial]
  connect_bd_intf_net -intf_net lpddr4_clk1_1 [get_bd_intf_ports lpddr4_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_clk2_1 [get_bd_intf_ports lpddr4_clk2] [get_bd_intf_pins axi_noc_0/sys_clk1]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI1 [get_bd_intf_pins axi_gpio_rx_datapath/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_gt_ctl/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI1 [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_gpio_tx_datapath/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI1 [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins axi_resets_dyn/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI1 [get_bd_intf_pins axi_reset_done_dyn/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins smartconnect_0/M05_AXI] [get_bd_intf_pins dcmac_and_gt/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins smartconnect_0/M06_AXI] [get_bd_intf_pins dataflow_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S06_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins versal_cips_0/M_AXI_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S05_AXI]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins dcmac_and_gt/MBUFG_GT_O3] [get_bd_pins clk/In0]
  connect_bd_net -net In1_1 [get_bd_pins dcmac_and_gt/MBUFG_GT_O2] [get_bd_pins clk/In1]
  connect_bd_net -net In2_1 [get_bd_pins dcmac_and_gt/MBUFG_GT_O1] [get_bd_pins clk/In2]
  connect_bd_net -net In3_1 [get_bd_pins dcmac_and_gt/MBUFG_GT_O4] [get_bd_pins clk/In3]
  connect_bd_net -net axi_gpio_gt_ctl_gpio_io_o [get_bd_pins axi_gpio_gt_ctl/gpio_io_o] [get_bd_pins xlslice_gt_reset1/Din] [get_bd_pins xlslice_gt_line_rate/Din] [get_bd_pins xlslice_gt_loopback/Din] [get_bd_pins xlslice_gt_txprecursor/Din] [get_bd_pins xlslice_gt_txpostcursor/Din] [get_bd_pins xlslice_gt_txmaincursor/Din] [get_bd_pins xlslice_gt_rxcdrhold/Din]
  connect_bd_net -net axi_gpio_rx_datapath_gpio_io_o [get_bd_pins axi_gpio_rx_datapath/gpio_io_o] [get_bd_pins xlslice_rx_datapath/Din]
  connect_bd_net -net axi_gpio_tx_datapath_gpio_io_o [get_bd_pins axi_gpio_tx_datapath/gpio_io_o] [get_bd_pins xlslice_tx_datapath/Din]
  connect_bd_net -net axi_resets_dyn_gpio_io_o [get_bd_pins axi_resets_dyn/gpio_io_o] [get_bd_pins xlslice_tx_serdes_rst/Din] [get_bd_pins xlslice_rx_serdes_rst/Din] [get_bd_pins xlslice_rx_core_rst/Din] [get_bd_pins xlslice_tx_core_rst/Din]
  connect_bd_net -net clk_clk_out1 [get_bd_pins clk/clk_out1] [get_bd_pins dcmac_and_gt/tx_core_clk] [get_bd_pins axi_noc_0/aclk7] [get_bd_pins smartconnect_0/aclk1]
  connect_bd_net -net clk_clk_out2 [get_bd_pins clk/clk_out2] [get_bd_pins dcmac_and_gt/tx_axi_clk] [get_bd_pins dataflow_0/axis_rxtx_clk] [get_bd_pins axi_noc_0/aclk8] [get_bd_pins rst_clk_wizard_0_782M/slowest_sync_clk]
  connect_bd_net -net clk_dout [get_bd_pins clk/dout] [get_bd_pins dcmac_and_gt/tx_serdes_clk]
  connect_bd_net -net clk_dout1 [get_bd_pins clk/dout1] [get_bd_pins dcmac_and_gt/tx_alt_serdes_clk]
  connect_bd_net -net clk_dout2 [get_bd_pins clk/dout2] [get_bd_pins dcmac_and_gt/rx_serdes_clk]
  connect_bd_net -net clk_dout3 [get_bd_pins clk/dout3] [get_bd_pins dcmac_and_gt/rx_alt_serdes_clk]
  connect_bd_net -net dataflow_0_m_axis_tlast [get_bd_pins dataflow_0/m_axis_tlast] [get_bd_pins dcmac_and_gt/s_axis0_tlast1]
  connect_bd_net -net dataflow_0_mm2s_ch1_introut [get_bd_pins dataflow_0/mm2s_ch1_introut] [get_bd_pins versal_cips_0/pl_ps_irq8]
  connect_bd_net -net dataflow_0_s2mm_ch1_introut [get_bd_pins dataflow_0/s2mm_ch1_introut] [get_bd_pins versal_cips_0/pl_ps_irq9]
  connect_bd_net -net dataflow_0_s_axis_tready [get_bd_pins dataflow_0/s_axis_tready] [get_bd_pins dcmac_and_gt/m_axis0_tready]
  connect_bd_net -net dcmac_and_gt_Unseg2SegVal0_out [get_bd_pins dcmac_and_gt/Unseg2SegVal0_out] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net dcmac_and_gt_Unseg2SegVal1_out [get_bd_pins dcmac_and_gt/Unseg2SegVal1_out] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net dcmac_and_gt_gt_rx_reset_done_out_0 [get_bd_pins dcmac_and_gt/gt_rx_reset_done_out_0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net dcmac_and_gt_gt_rx_reset_done_out_1 [get_bd_pins dcmac_and_gt/gt_rx_reset_done_out_1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net dcmac_and_gt_gt_rx_reset_done_out_2 [get_bd_pins dcmac_and_gt/gt_rx_reset_done_out_2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net dcmac_and_gt_gt_rx_reset_done_out_3 [get_bd_pins dcmac_and_gt/gt_rx_reset_done_out_3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net dcmac_and_gt_gt_tx_reset_done_out_0 [get_bd_pins dcmac_and_gt/gt_tx_reset_done_out_0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net dcmac_and_gt_gt_tx_reset_done_out_1 [get_bd_pins dcmac_and_gt/gt_tx_reset_done_out_1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net dcmac_and_gt_gt_tx_reset_done_out_2 [get_bd_pins dcmac_and_gt/gt_tx_reset_done_out_2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net dcmac_and_gt_gt_tx_reset_done_out_3 [get_bd_pins dcmac_and_gt/gt_tx_reset_done_out_3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net dcmac_and_gt_m_axis0_tdata [get_bd_pins dcmac_and_gt/m_axis0_tdata] [get_bd_pins dataflow_0/s_axis_tdata]
  connect_bd_net -net dcmac_and_gt_m_axis0_tlast [get_bd_pins dcmac_and_gt/m_axis0_tlast] [get_bd_pins dataflow_0/s_axis_tlast]
  connect_bd_net -net dcmac_and_gt_m_axis0_tvalid [get_bd_pins dcmac_and_gt/m_axis0_tvalid] [get_bd_pins dataflow_0/s_axis_tvalid]
  connect_bd_net -net m_axis_tready_1 [get_bd_pins dcmac_and_gt/s_axis0_tready1] [get_bd_pins dataflow_0/m_axis_tready]
  connect_bd_net -net outclk_1 [get_bd_pins dcmac_and_gt/IBUFDS_GTME5_ODIV2] [get_bd_pins clk/outclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins axi_gpio_gt_ctl/s_axi_aresetn] [get_bd_pins axi_gpio_tx_datapath/s_axi_aresetn] [get_bd_pins axi_gpio_rx_datapath/s_axi_aresetn] [get_bd_pins axi_resets_dyn/s_axi_aresetn] [get_bd_pins axi_reset_done_dyn/s_axi_aresetn] [get_bd_pins dcmac_and_gt/s_axi_aresetn1] [get_bd_pins dataflow_0/axi_resetn]
  connect_bd_net -net rst_clk_wizard_0_782M_peripheral_aresetn [get_bd_pins rst_clk_wizard_0_782M/peripheral_aresetn] [get_bd_pins dcmac_and_gt/s_axi_aresetn] [get_bd_pins dataflow_0/axis_rx_rstn_i] [get_bd_pins dataflow_0/axis_tx_rstn_i]
  connect_bd_net -net rx_reset_done [get_bd_pins xlconcat_1/dout] [get_bd_pins axi_reset_done_dyn/gpio2_io_i]
  connect_bd_net -net s_axis0_tdata1_1 [get_bd_pins dataflow_0/m_axis_tdata2] [get_bd_pins dcmac_and_gt/s_axis0_tdata1]
  connect_bd_net -net s_axis0_tkeep1_1 [get_bd_pins dataflow_0/m_axis_tkeep] [get_bd_pins dcmac_and_gt/s_axis0_tkeep1]
  connect_bd_net -net s_axis0_tvalid1_1 [get_bd_pins dataflow_0/m_axis_tvalid] [get_bd_pins dcmac_and_gt/s_axis0_tvalid1]
  connect_bd_net -net s_axis_tkeep_1 [get_bd_pins dcmac_and_gt/m_axis0_tkeep] [get_bd_pins dataflow_0/s_axis_tkeep]
  connect_bd_net -net tx_reset_done [get_bd_pins xlconcat_0/dout] [get_bd_pins axi_reset_done_dyn/gpio_io_i]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins dcmac_and_gt/tx_axis_tvalid_0]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk6]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins axi_gpio_gt_ctl/s_axi_aclk] [get_bd_pins axi_gpio_tx_datapath/s_axi_aclk] [get_bd_pins axi_gpio_rx_datapath/s_axi_aclk] [get_bd_pins axi_resets_dyn/s_axi_aclk] [get_bd_pins axi_reset_done_dyn/s_axi_aclk] [get_bd_pins dcmac_and_gt/apb3clk] [get_bd_pins dataflow_0/pl0_ref_clk_0] [get_bd_pins axi_noc_0/aclk9]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins rst_clk_wizard_0_782M/ext_reset_in]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10] [get_bd_pins xlconcat_1/In11] [get_bd_pins xlconcat_1/In12] [get_bd_pins xlconcat_1/In13] [get_bd_pins xlconcat_1/In15] [get_bd_pins xlconcat_1/In16] [get_bd_pins xlconcat_1/In14] [get_bd_pins xlconcat_1/In17] [get_bd_pins xlconcat_1/In18] [get_bd_pins xlconcat_1/In19] [get_bd_pins xlconcat_1/In20] [get_bd_pins xlconcat_1/In21] [get_bd_pins xlconcat_1/In22] [get_bd_pins xlconcat_1/In23] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10] [get_bd_pins xlconcat_0/In11] [get_bd_pins xlconcat_0/In12] [get_bd_pins xlconcat_0/In13] [get_bd_pins xlconcat_0/In14] [get_bd_pins xlconcat_0/In15] [get_bd_pins xlconcat_0/In16] [get_bd_pins xlconcat_0/In17] [get_bd_pins xlconcat_0/In18] [get_bd_pins xlconcat_0/In19] [get_bd_pins xlconcat_0/In20] [get_bd_pins xlconcat_0/In21] [get_bd_pins xlconcat_0/In22] [get_bd_pins xlconcat_0/In23]
  connect_bd_net -net xlslice_gt_line_rate_Dout [get_bd_pins xlslice_gt_line_rate/Dout] [get_bd_pins dcmac_and_gt/ch0_txrate]
  connect_bd_net -net xlslice_gt_loopback_Dout [get_bd_pins xlslice_gt_loopback/Dout] [get_bd_pins dcmac_and_gt/ch0_loopback]
  connect_bd_net -net xlslice_gt_reset_Dout [get_bd_pins xlslice_gt_reset1/Dout] [get_bd_pins dcmac_and_gt/gt_reset_all_in]
  connect_bd_net -net xlslice_gt_rxcdrhold_Dout [get_bd_pins xlslice_gt_rxcdrhold/Dout] [get_bd_pins dcmac_and_gt/ch0_rxcdrhold]
  connect_bd_net -net xlslice_gt_txmaincursor_Dout [get_bd_pins xlslice_gt_txmaincursor/Dout] [get_bd_pins dcmac_and_gt/ch0_txmaincursor]
  connect_bd_net -net xlslice_gt_txpostcursor_Dout [get_bd_pins xlslice_gt_txpostcursor/Dout] [get_bd_pins dcmac_and_gt/ch0_txpostcursor]
  connect_bd_net -net xlslice_gt_txprecursor_Dout [get_bd_pins xlslice_gt_txprecursor/Dout] [get_bd_pins dcmac_and_gt/ch0_txprecursor]
  connect_bd_net -net xlslice_rx_core_rst_Dout [get_bd_pins xlslice_rx_core_rst/Dout] [get_bd_pins dcmac_and_gt/rx_core_reset]
  connect_bd_net -net xlslice_rx_datapath_Dout [get_bd_pins xlslice_rx_datapath/Dout] [get_bd_pins dcmac_and_gt/gt_reset_rx_datapath_in_3]
  connect_bd_net -net xlslice_rx_serdes_rst_Dout [get_bd_pins xlslice_rx_serdes_rst/Dout] [get_bd_pins dcmac_and_gt/rx_serdes_reset]
  connect_bd_net -net xlslice_tx_core_rst_Dout [get_bd_pins xlslice_tx_core_rst/Dout] [get_bd_pins dcmac_and_gt/tx_core_reset]
  connect_bd_net -net xlslice_tx_datapath_Dout [get_bd_pins xlslice_tx_datapath/Dout] [get_bd_pins dcmac_and_gt/gt_reset_tx_datapath_in_0]
  connect_bd_net -net xlslice_tx_serdes_rst_Dout [get_bd_pins xlslice_tx_serdes_rst/Dout] [get_bd_pins dcmac_and_gt/tx_serdes_reset]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S06_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S06_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_gt_ctl/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_rx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_tx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs dataflow_0/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_reset_done_dyn/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_resets_dyn/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -with_name SEG_dcmac_0_Reg -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs dcmac_and_gt/dcmac_0_core/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S09_AXI/C3_DDR_LOW0x2] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S07_AXI/C3_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S08_AXI/C3_DDR_LOW1x2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces dataflow_0/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S09_AXI/C3_DDR_LOW1x2]


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

