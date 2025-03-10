
################################################################
# This is a generated script based on design: mrmac_subsys
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
set scripts_vivado_version 2024.2
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
# source mrmac_subsys_script.tcl

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
set design_name vck190_mrmac_1x100g

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

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: TX_AXIS_DATAPATH
proc create_hier_cell_TX_AXIS_DATAPATH { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TX_AXIS_DATAPATH() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 3 -to 0 tx_axis_clk
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir O tx_axis_tvalid_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata1
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata2
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata3
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata4
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata5
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user1
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user2
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user3
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user4
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user5
  create_bd_pin -dir I -from 255 -to 0 s_axis_tdata1
  create_bd_pin -dir I -from 31 -to 0 s_axis_tkeep1
  create_bd_pin -dir I s_axis_tlast1
  create_bd_pin -dir O s_axis_tready1
  create_bd_pin -dir I -from 15 -to 0 s_axis_tuser1
  create_bd_pin -dir I s_axis_tvalid1
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0

  # Create instance: xlslice_tx_data_0, and set properties
  set xlslice_tx_data_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {63} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_0


  # Create instance: xlslice_tx_data_1, and set properties
  set xlslice_tx_data_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {127} \
    CONFIG.DIN_TO {64} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_1


  # Create instance: axis_data_fifo_384b, and set properties
  set axis_data_fifo_384b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo axis_data_fifo_384b ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {256} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.TDATA_NUM_BYTES {48} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_WIDTH {0} \
  ] $axis_data_fifo_384b


  # Create instance: xlslice_tx_data_2, and set properties
  set xlslice_tx_data_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {191} \
    CONFIG.DIN_TO {128} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_2


  # Create instance: xlslice_tx_data_3, and set properties
  set xlslice_tx_data_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {255} \
    CONFIG.DIN_TO {192} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_3


  # Create instance: xlslice_tx_data_4, and set properties
  set xlslice_tx_data_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {319} \
    CONFIG.DIN_TO {256} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_4


  # Create instance: axis_data_fifo_tx_256b, and set properties
  set axis_data_fifo_tx_256b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo axis_data_fifo_tx_256b ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {512} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.TDATA_NUM_BYTES {32} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_WIDTH {0} \
  ] $axis_data_fifo_tx_256b


  # Create instance: xlslice_tx_data_5, and set properties
  set xlslice_tx_data_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_data_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {383} \
    CONFIG.DIN_TO {320} \
    CONFIG.DIN_WIDTH {384} \
    CONFIG.DOUT_WIDTH {64} \
  ] $xlslice_tx_data_5


  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter axis_dwidth_converter_0 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {48} \
    CONFIG.S_TDATA_NUM_BYTES {32} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_BITS_PER_BYTE {0} \
  ] $axis_dwidth_converter_0


  # Create instance: xlslice_axis_tx_clk, and set properties
  set xlslice_axis_tx_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_axis_tx_clk ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_axis_tx_clk


  # Create instance: xlslice_axis_tx_resetn, and set properties
  set xlslice_axis_tx_resetn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_axis_tx_resetn ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_axis_tx_resetn


  # Create instance: xlslice_tx_takeep_0, and set properties
  set xlslice_tx_takeep_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_0


  # Create instance: xlslice_tx_takeep_1, and set properties
  set xlslice_tx_takeep_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {15} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_1


  # Create instance: xlslice_tx_takeep_2, and set properties
  set xlslice_tx_takeep_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {16} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_2


  # Create instance: xlslice_tx_takeep_3, and set properties
  set xlslice_tx_takeep_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {24} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_3


  # Create instance: xlslice_tx_takeep_4, and set properties
  set xlslice_tx_takeep_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {39} \
    CONFIG.DIN_TO {32} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_4


  # Create instance: xlslice_tx_takeep_5, and set properties
  set xlslice_tx_takeep_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_takeep_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {47} \
    CONFIG.DIN_TO {40} \
    CONFIG.DIN_WIDTH {48} \
  ] $xlslice_tx_takeep_5


  # Create instance: xlconcat_tkeep_0, and set properties
  set xlconcat_tkeep_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_0 ]

  # Create instance: xlconcat_tkeep_1, and set properties
  set xlconcat_tkeep_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_1 ]

  # Create instance: xlconcat_tkeep_2, and set properties
  set xlconcat_tkeep_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_2 ]

  # Create instance: xlconcat_tkeep_3, and set properties
  set xlconcat_tkeep_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_3 ]

  # Create instance: xlconcat_tkeep_4, and set properties
  set xlconcat_tkeep_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_4 ]

  # Create instance: xlconcat_tkeep_5, and set properties
  set xlconcat_tkeep_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tkeep_5 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $xlconstant_0


  # Create port connections
  connect_bd_net -net axis_data_fifo_384b_m_axis_tdata  [get_bd_pins axis_data_fifo_384b/m_axis_tdata] \
  [get_bd_pins xlslice_tx_data_0/Din] \
  [get_bd_pins xlslice_tx_data_1/Din] \
  [get_bd_pins xlslice_tx_data_3/Din] \
  [get_bd_pins xlslice_tx_data_5/Din] \
  [get_bd_pins xlslice_tx_data_4/Din] \
  [get_bd_pins xlslice_tx_data_2/Din]
  connect_bd_net -net axis_data_fifo_384b_m_axis_tkeep  [get_bd_pins axis_data_fifo_384b/m_axis_tkeep] \
  [get_bd_pins xlslice_tx_takeep_0/Din] \
  [get_bd_pins xlslice_tx_takeep_1/Din] \
  [get_bd_pins xlslice_tx_takeep_2/Din] \
  [get_bd_pins xlslice_tx_takeep_3/Din] \
  [get_bd_pins xlslice_tx_takeep_4/Din] \
  [get_bd_pins xlslice_tx_takeep_5/Din]
  connect_bd_net -net axis_data_fifo_384b_m_axis_tlast  [get_bd_pins axis_data_fifo_384b/m_axis_tlast] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_384b_m_axis_tvalid  [get_bd_pins axis_data_fifo_384b/m_axis_tvalid] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net axis_data_fifo_384b_s_axis_tready  [get_bd_pins axis_data_fifo_384b/s_axis_tready] \
  [get_bd_pins axis_dwidth_converter_0/m_axis_tready]
  connect_bd_net -net axis_data_fifo_tx_256b_m_axis_tdata  [get_bd_pins axis_data_fifo_tx_256b/m_axis_tdata] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_tx_256b_m_axis_tkeep  [get_bd_pins axis_data_fifo_tx_256b/m_axis_tkeep] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_tx_256b_m_axis_tlast  [get_bd_pins axis_data_fifo_tx_256b/m_axis_tlast] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tlast]
  connect_bd_net -net axis_data_fifo_tx_256b_m_axis_tvalid  [get_bd_pins axis_data_fifo_tx_256b/m_axis_tvalid] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_tx_256b_s_axis_tready  [get_bd_pins axis_data_fifo_tx_256b/s_axis_tready] \
  [get_bd_pins s_axis_tready1]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tdata  [get_bd_pins axis_dwidth_converter_0/m_axis_tdata] \
  [get_bd_pins axis_data_fifo_384b/s_axis_tdata]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tkeep  [get_bd_pins axis_dwidth_converter_0/m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_384b/s_axis_tkeep]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tlast  [get_bd_pins axis_dwidth_converter_0/m_axis_tlast] \
  [get_bd_pins axis_data_fifo_384b/s_axis_tlast]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tvalid  [get_bd_pins axis_dwidth_converter_0/m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_384b/s_axis_tvalid]
  connect_bd_net -net axis_dwidth_converter_0_s_axis_tready  [get_bd_pins axis_dwidth_converter_0/s_axis_tready] \
  [get_bd_pins axis_data_fifo_tx_256b/m_axis_tready]
  connect_bd_net -net s_axis_tdata1_1  [get_bd_pins s_axis_tdata1] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_tdata]
  connect_bd_net -net s_axis_tkeep1_1  [get_bd_pins s_axis_tkeep1] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_tkeep]
  connect_bd_net -net s_axis_tlast1_1  [get_bd_pins s_axis_tlast1] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_tlast]
  connect_bd_net -net s_axis_tvalid1_1  [get_bd_pins s_axis_tvalid1] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_tvalid]
  connect_bd_net -net tx_axis_clk_1  [get_bd_pins tx_axis_clk] \
  [get_bd_pins xlslice_axis_tx_clk/Din]
  connect_bd_net -net tx_axis_rstn_1  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_axis_tx_resetn/Din]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins axis_data_fifo_384b/m_axis_tready]
  connect_bd_net -net xlconcat_tkeep_0_dout  [get_bd_pins xlconcat_tkeep_0/dout] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_tkeep_1_dout  [get_bd_pins xlconcat_tkeep_1/dout] \
  [get_bd_pins tx_axis_tkeep_user1]
  connect_bd_net -net xlconcat_tkeep_2_dout  [get_bd_pins xlconcat_tkeep_2/dout] \
  [get_bd_pins tx_axis_tkeep_user2]
  connect_bd_net -net xlconcat_tkeep_3_dout  [get_bd_pins xlconcat_tkeep_3/dout] \
  [get_bd_pins tx_axis_tkeep_user3]
  connect_bd_net -net xlconcat_tkeep_4_dout  [get_bd_pins xlconcat_tkeep_4/dout] \
  [get_bd_pins tx_axis_tkeep_user4]
  connect_bd_net -net xlconcat_tkeep_5_dout  [get_bd_pins xlconcat_tkeep_5/dout] \
  [get_bd_pins tx_axis_tkeep_user5]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins xlconcat_tkeep_4/In1] \
  [get_bd_pins xlconcat_tkeep_5/In1] \
  [get_bd_pins xlconcat_tkeep_3/In1] \
  [get_bd_pins xlconcat_tkeep_2/In1] \
  [get_bd_pins xlconcat_tkeep_1/In1] \
  [get_bd_pins xlconcat_tkeep_0/In1]
  connect_bd_net -net xlslice_axis_tx_clk_Dout  [get_bd_pins xlslice_axis_tx_clk/Dout] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter_0/aclk] \
  [get_bd_pins axis_data_fifo_384b/s_axis_aclk]
  connect_bd_net -net xlslice_axis_tx_resetn_Dout  [get_bd_pins xlslice_axis_tx_resetn/Dout] \
  [get_bd_pins axis_data_fifo_tx_256b/s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter_0/aresetn] \
  [get_bd_pins axis_data_fifo_384b/s_axis_aresetn]
  connect_bd_net -net xlslice_tx_data_0_Dout  [get_bd_pins xlslice_tx_data_0/Dout] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net xlslice_tx_data_1_Dout  [get_bd_pins xlslice_tx_data_1/Dout] \
  [get_bd_pins tx_axis_tdata1]
  connect_bd_net -net xlslice_tx_data_2_Dout  [get_bd_pins xlslice_tx_data_2/Dout] \
  [get_bd_pins tx_axis_tdata2]
  connect_bd_net -net xlslice_tx_data_3_Dout  [get_bd_pins xlslice_tx_data_3/Dout] \
  [get_bd_pins tx_axis_tdata3]
  connect_bd_net -net xlslice_tx_data_4_Dout  [get_bd_pins xlslice_tx_data_4/Dout] \
  [get_bd_pins tx_axis_tdata4]
  connect_bd_net -net xlslice_tx_data_5_Dout  [get_bd_pins xlslice_tx_data_5/Dout] \
  [get_bd_pins tx_axis_tdata5]
  connect_bd_net -net xlslice_tx_takeep_0_Dout  [get_bd_pins xlslice_tx_takeep_0/Dout] \
  [get_bd_pins xlconcat_tkeep_0/In0]
  connect_bd_net -net xlslice_tx_takeep_1_Dout  [get_bd_pins xlslice_tx_takeep_1/Dout] \
  [get_bd_pins xlconcat_tkeep_1/In0]
  connect_bd_net -net xlslice_tx_takeep_2_Dout  [get_bd_pins xlslice_tx_takeep_2/Dout] \
  [get_bd_pins xlconcat_tkeep_2/In0]
  connect_bd_net -net xlslice_tx_takeep_3_Dout  [get_bd_pins xlslice_tx_takeep_3/Dout] \
  [get_bd_pins xlconcat_tkeep_3/In0]
  connect_bd_net -net xlslice_tx_takeep_4_Dout  [get_bd_pins xlslice_tx_takeep_4/Dout] \
  [get_bd_pins xlconcat_tkeep_4/In0]
  connect_bd_net -net xlslice_tx_takeep_5_Dout  [get_bd_pins xlslice_tx_takeep_5/Dout] \
  [get_bd_pins xlconcat_tkeep_5/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RX_AXIS_DATAPATH
proc create_hier_cell_RX_AXIS_DATAPATH { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_RX_AXIS_DATAPATH() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_0


  # Create pins
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user1
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user2
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user3
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user4
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata1
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata2
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata3
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata4
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata5
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user5
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I -type clk mcdma_clk

  # Create instance: slice_rx_tkeep_0, and set properties
  set slice_rx_tkeep_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_rx_tkeep_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_rx_tkeep_0


  # Create instance: slice_rx_tkeep_1, and set properties
  set slice_rx_tkeep_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_rx_tkeep_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_rx_tkeep_1


  # Create instance: slice_rx_tkeep_2, and set properties
  set slice_rx_tkeep_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_rx_tkeep_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_rx_tkeep_2


  # Create instance: slice_rx_tkeep_3, and set properties
  set slice_rx_tkeep_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_rx_tkeep_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_rx_tkeep_3


  # Create instance: slice_rx_tkeep_4, and set properties
  set slice_rx_tkeep_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_rx_tkeep_4 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_rx_tkeep_4


  # Create instance: xlconcat_rx_axis_data, and set properties
  set xlconcat_rx_axis_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_rx_axis_data ]
  set_property CONFIG.NUM_PORTS {6} $xlconcat_rx_axis_data


  # Create instance: rx_tkeep_axis_data, and set properties
  set rx_tkeep_axis_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat rx_tkeep_axis_data ]
  set_property CONFIG.NUM_PORTS {6} $rx_tkeep_axis_data


  # Create instance: slice_tkeep_5, and set properties
  set slice_tkeep_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice slice_tkeep_5 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {11} \
  ] $slice_tkeep_5


  # Create instance: xlslice_axis_rx_resetn, and set properties
  set xlslice_axis_rx_resetn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_axis_rx_resetn ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_axis_rx_resetn


  # Create instance: axis_data_fifo_rx_384b, and set properties
  set axis_data_fifo_rx_384b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo axis_data_fifo_rx_384b ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {256} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.TDATA_NUM_BYTES {48} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_WIDTH {0} \
  ] $axis_data_fifo_rx_384b


  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter axis_dwidth_converter_0 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {32} \
    CONFIG.S_TDATA_NUM_BYTES {48} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_BITS_PER_BYTE {0} \
  ] $axis_dwidth_converter_0


  # Create instance: axis_data_fifo_rx_256b, and set properties
  set axis_data_fifo_rx_256b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo axis_data_fifo_rx_256b ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {512} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.TDATA_NUM_BYTES {32} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
    CONFIG.TUSER_WIDTH {0} \
  ] $axis_data_fifo_rx_256b


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axis_data_fifo_rx_256b/M_AXIS] [get_bd_intf_pins M_AXIS_0]

  # Create port connections
  connect_bd_net -net axis_data_fifo_rx_256b_s_axis_tready  [get_bd_pins axis_data_fifo_rx_256b/s_axis_tready] \
  [get_bd_pins axis_dwidth_converter_0/m_axis_tready]
  connect_bd_net -net axis_data_fifo_rx_384b_m_axis_tdata  [get_bd_pins axis_data_fifo_rx_384b/m_axis_tdata] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_384b_m_axis_tkeep  [get_bd_pins axis_data_fifo_rx_384b/m_axis_tkeep] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_384b_m_axis_tlast  [get_bd_pins axis_data_fifo_rx_384b/m_axis_tlast] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tlast]
  connect_bd_net -net axis_data_fifo_rx_384b_m_axis_tvalid  [get_bd_pins axis_data_fifo_rx_384b/m_axis_tvalid] \
  [get_bd_pins axis_dwidth_converter_0/s_axis_tvalid]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tdata  [get_bd_pins axis_dwidth_converter_0/m_axis_tdata] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_tdata]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tkeep  [get_bd_pins axis_dwidth_converter_0/m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_tkeep]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tlast  [get_bd_pins axis_dwidth_converter_0/m_axis_tlast] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_tlast]
  connect_bd_net -net axis_dwidth_converter_0_m_axis_tvalid  [get_bd_pins axis_dwidth_converter_0/m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_tvalid]
  connect_bd_net -net axis_dwidth_converter_0_s_axis_tready  [get_bd_pins axis_dwidth_converter_0/s_axis_tready] \
  [get_bd_pins axis_data_fifo_rx_384b/m_axis_tready]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter_0/aclk] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_aclk]
  connect_bd_net -net rx_axis_rstn_1  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_axis_rx_resetn/Din]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins xlconcat_rx_axis_data/In0]
  connect_bd_net -net rx_axis_tdata1_1  [get_bd_pins rx_axis_tdata1] \
  [get_bd_pins xlconcat_rx_axis_data/In1]
  connect_bd_net -net rx_axis_tdata2_1  [get_bd_pins rx_axis_tdata2] \
  [get_bd_pins xlconcat_rx_axis_data/In2]
  connect_bd_net -net rx_axis_tdata3_1  [get_bd_pins rx_axis_tdata3] \
  [get_bd_pins xlconcat_rx_axis_data/In3]
  connect_bd_net -net rx_axis_tdata4_1  [get_bd_pins rx_axis_tdata4] \
  [get_bd_pins xlconcat_rx_axis_data/In4]
  connect_bd_net -net rx_axis_tdata5_1  [get_bd_pins rx_axis_tdata5] \
  [get_bd_pins xlconcat_rx_axis_data/In5]
  connect_bd_net -net rx_axis_tkeep_user0_1  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins slice_rx_tkeep_0/Din]
  connect_bd_net -net rx_axis_tkeep_user1_1  [get_bd_pins rx_axis_tkeep_user1] \
  [get_bd_pins slice_rx_tkeep_1/Din]
  connect_bd_net -net rx_axis_tkeep_user2_1  [get_bd_pins rx_axis_tkeep_user2] \
  [get_bd_pins slice_rx_tkeep_2/Din]
  connect_bd_net -net rx_axis_tkeep_user3_1  [get_bd_pins rx_axis_tkeep_user3] \
  [get_bd_pins slice_rx_tkeep_3/Din]
  connect_bd_net -net rx_axis_tkeep_user4_1  [get_bd_pins rx_axis_tkeep_user4] \
  [get_bd_pins slice_rx_tkeep_4/Din]
  connect_bd_net -net rx_axis_tkeep_user5_1  [get_bd_pins rx_axis_tkeep_user5] \
  [get_bd_pins slice_tkeep_5/Din]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_tvalid]
  connect_bd_net -net rx_tkeep_axis_data_dout  [get_bd_pins rx_tkeep_axis_data/dout] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_tkeep]
  connect_bd_net -net slice_rx_tkeep_0_Dout  [get_bd_pins slice_rx_tkeep_0/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In0]
  connect_bd_net -net slice_rx_tkeep_1_Dout  [get_bd_pins slice_rx_tkeep_1/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In1]
  connect_bd_net -net slice_rx_tkeep_2_Dout  [get_bd_pins slice_rx_tkeep_2/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In2]
  connect_bd_net -net slice_rx_tkeep_3_Dout  [get_bd_pins slice_rx_tkeep_3/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In3]
  connect_bd_net -net slice_rx_tkeep_4_Dout  [get_bd_pins slice_rx_tkeep_4/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In4]
  connect_bd_net -net slice_tkeep_5_Dout  [get_bd_pins slice_tkeep_5/Dout] \
  [get_bd_pins rx_tkeep_axis_data/In5]
  connect_bd_net -net xlconcat_rx_axis_data_dout  [get_bd_pins xlconcat_rx_axis_data/dout] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_tdata]
  connect_bd_net -net xlslice_axis_rx_resetn_Dout  [get_bd_pins xlslice_axis_rx_resetn/Dout] \
  [get_bd_pins axis_data_fifo_rx_384b/s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter_0/aresetn] \
  [get_bd_pins axis_data_fifo_rx_256b/s_axis_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_HIER
proc create_hier_cell_DATAPATH_MCDMA_HIER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_HIER() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata1
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata2
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata3
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata4
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata5
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user1
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user2
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user3
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user4
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user5
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata1
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata2
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata3
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata4
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata5
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir I -from 3 -to 0 rx_axis_clk
  create_bd_pin -dir I -from 3 -to 0 tx_axis_clk
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user1
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user2
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user3
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user4
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user5
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {256} \
    CONFIG.c_m_axi_s2mm_data_width {256} \
    CONFIG.c_m_axis_mm2s_tdata_width {256} \
    CONFIG.c_mm2s_burst_size {128} \
    CONFIG.c_s2mm_burst_size {128} \
  ] $axi_mcdma_0


  # Create instance: RX_AXIS_DATAPATH
  create_hier_cell_RX_AXIS_DATAPATH $hier_obj RX_AXIS_DATAPATH

  # Create instance: TX_AXIS_DATAPATH
  create_hier_cell_TX_AXIS_DATAPATH $hier_obj TX_AXIS_DATAPATH

  # Create interface connections
  connect_bd_intf_net -intf_net RX_AXIS_DATAPATH_M_AXIS_0 [get_bd_intf_pins RX_AXIS_DATAPATH/M_AXIS_0] [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]

  # Create port connections
  connect_bd_net -net TX_AXIS_DATAPATH_s_axis_tready1  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tready1] \
  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tready]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata0  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata0] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata1  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata1] \
  [get_bd_pins tx_axis_tdata1]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata2  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata2] \
  [get_bd_pins tx_axis_tdata2]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata3  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata3] \
  [get_bd_pins tx_axis_tdata3]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata4  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata4] \
  [get_bd_pins tx_axis_tdata4]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tdata5  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tdata5] \
  [get_bd_pins tx_axis_tdata5]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user0  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user0] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user1  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user1] \
  [get_bd_pins tx_axis_tkeep_user1]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user2  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user2] \
  [get_bd_pins tx_axis_tkeep_user2]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user3  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user3] \
  [get_bd_pins tx_axis_tkeep_user3]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user4  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user4] \
  [get_bd_pins tx_axis_tkeep_user4]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tkeep_user5  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tkeep_user5] \
  [get_bd_pins tx_axis_tkeep_user5]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tlast_0  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tlast_0] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net TX_AXIS_DATAPATH_tx_axis_tvalid_0  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tvalid_0] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tdata  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tdata] \
  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tdata1]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tkeep  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tkeep] \
  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tkeep1]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tlast  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tlast] \
  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tlast1]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tuser  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tuser] \
  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tuser1]
  connect_bd_net -net axi_mcdma_0_m_axis_mm2s_tvalid  [get_bd_pins axi_mcdma_0/m_axis_mm2s_tvalid] \
  [get_bd_pins TX_AXIS_DATAPATH/s_axis_tvalid1]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_introut]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins axi_mcdma_0/s_axi_aclk] \
  [get_bd_pins RX_AXIS_DATAPATH/mcdma_clk]
  connect_bd_net -net rx_axis_rstn_1  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_rstn]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata0]
  connect_bd_net -net rx_axis_tdata1_1  [get_bd_pins rx_axis_tdata1] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata1]
  connect_bd_net -net rx_axis_tdata2_1  [get_bd_pins rx_axis_tdata2] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata2]
  connect_bd_net -net rx_axis_tdata3_1  [get_bd_pins rx_axis_tdata3] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata3]
  connect_bd_net -net rx_axis_tdata4_1  [get_bd_pins rx_axis_tdata4] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata4]
  connect_bd_net -net rx_axis_tdata5_1  [get_bd_pins rx_axis_tdata5] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tdata5]
  connect_bd_net -net rx_axis_tkeep_user0_1  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user0]
  connect_bd_net -net rx_axis_tkeep_user1_1  [get_bd_pins rx_axis_tkeep_user1] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user1]
  connect_bd_net -net rx_axis_tkeep_user2_1  [get_bd_pins rx_axis_tkeep_user2] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user2]
  connect_bd_net -net rx_axis_tkeep_user3_1  [get_bd_pins rx_axis_tkeep_user3] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user3]
  connect_bd_net -net rx_axis_tkeep_user4_1  [get_bd_pins rx_axis_tkeep_user4] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user4]
  connect_bd_net -net rx_axis_tkeep_user5_1  [get_bd_pins rx_axis_tkeep_user5] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tkeep_user5]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins RX_AXIS_DATAPATH/rx_axis_tvalid_0]
  connect_bd_net -net s_axi_lite_aclk_1  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net tx_axis_clk_1  [get_bd_pins tx_axis_clk] \
  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_clk]
  connect_bd_net -net tx_axis_rstn_1  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_rstn]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins TX_AXIS_DATAPATH/tx_axis_tready_0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CLK_RST_WRAPPER
proc create_hier_cell_CLK_RST_WRAPPER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CLK_RST_WRAPPER() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 0 -to 3 -type rst axi_lite_bus_struct_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst axi_lite_interconnect_resetn
  create_bd_pin -dir O -from 0 -to 0 -type rst axi_lite_perpheral_resetn
  create_bd_pin -dir O -from 3 -to 0 axis_clk_rx_out
  create_bd_pin -dir O -from 3 -to 0 axis_clk_tx_out
  create_bd_pin -dir O axis_tx_rx_clk
  create_bd_pin -dir O mcdma_clk
  create_bd_pin -dir O -from 0 -to 0 mcdma_resetn
  create_bd_pin -dir I -type rst pl0_resetn
  create_bd_pin -dir O -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I -from 3 -to 0 rx_mst_reset_done
  create_bd_pin -dir O -from 3 -to 0 rx_reset
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir O -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir I -from 3 -to 0 tx_mst_reset_done
  create_bd_pin -dir O -from 3 -to 0 tx_reset
  create_bd_pin -dir O -from 3 -to 0 ts_clk

  # Create instance: clk_wizard_tx_rx_axis, and set properties
  set clk_wizard_tx_rx_axis [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard clk_wizard_tx_rx_axis ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {DPLL} \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {390.625,250.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
    CONFIG.PRIMITIVE_TYPE {MMCM} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_PHASE_ALIGNMENT {false} \
  ] $clk_wizard_tx_rx_axis


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
    CONFIG.C_NUM_PERP_RST {1} \
  ] $proc_sys_reset_0


  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_3 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
    CONFIG.C_NUM_PERP_RST {1} \
  ] $proc_sys_reset_3


  # Create instance: util_vector_logic_rx_rst, and set properties
  set util_vector_logic_rx_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_rx_rst ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_rx_rst


  # Create instance: util_vector_logic_tx_rst, and set properties
  set util_vector_logic_tx_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_tx_rst ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_tx_rst


  # Create instance: xlconcat_tx_rx_axis_clk, and set properties
  set xlconcat_tx_rx_axis_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tx_rx_axis_clk ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_clk


  # Create instance: xlconcat_tx_rx_axis_rst, and set properties
  set xlconcat_tx_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tx_rx_axis_rst ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_rst


  # Create instance: xlconcat_tx_rx_axis_rstn, and set properties
  set xlconcat_tx_rx_axis_rstn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tx_rx_axis_rstn ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_rstn


  # Create instance: xlconcat_tx_rx_axis_clk1, and set properties
  set xlconcat_tx_rx_axis_clk1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_tx_rx_axis_clk1 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_clk1


  # Create port connections
  connect_bd_net -net GT_WRAPPER_rx_mst_reset_done_out  [get_bd_pins rx_mst_reset_done] \
  [get_bd_pins util_vector_logic_rx_rst/Op1]
  connect_bd_net -net GT_WRAPPER_tx_mst_reset_done_out  [get_bd_pins tx_mst_reset_done] \
  [get_bd_pins util_vector_logic_tx_rst/Op1]
  connect_bd_net -net clk_wizard_tx_rx_axis_clk_out1  [get_bd_pins clk_wizard_tx_rx_axis/clk_out1] \
  [get_bd_pins axis_tx_rx_clk] \
  [get_bd_pins mcdma_clk] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In3] \
  [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset  [get_bd_pins proc_sys_reset_0/bus_struct_reset] \
  [get_bd_pins axi_lite_bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn  [get_bd_pins proc_sys_reset_0/interconnect_aresetn] \
  [get_bd_pins axi_lite_interconnect_resetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins axi_lite_perpheral_resetn] \
  [get_bd_pins proc_sys_reset_3/ext_reset_in]
  connect_bd_net -net proc_sys_reset_3_peripheral_aresetn  [get_bd_pins proc_sys_reset_3/peripheral_aresetn] \
  [get_bd_pins mcdma_resetn] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In3]
  connect_bd_net -net proc_sys_reset_3_peripheral_reset  [get_bd_pins proc_sys_reset_3/peripheral_reset] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In3]
  connect_bd_net -net util_vector_logic_rx_rst_Res  [get_bd_pins util_vector_logic_rx_rst/Res] \
  [get_bd_pins rx_reset]
  connect_bd_net -net util_vector_logic_tx_rst_Res  [get_bd_pins util_vector_logic_tx_rst/Res] \
  [get_bd_pins tx_reset]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins clk_wizard_tx_rx_axis/clk_in1] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins xlconcat_tx_rx_axis_clk1/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_clk1/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_clk1/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_clk1/In3]
  connect_bd_net -net versal_cips_0_pl_resetn0  [get_bd_pins pl0_resetn] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconcat_tx_rx_axis_clk1_dout  [get_bd_pins xlconcat_tx_rx_axis_clk1/dout] \
  [get_bd_pins ts_clk]
  connect_bd_net -net xlconcat_tx_rx_axis_clk_dout  [get_bd_pins xlconcat_tx_rx_axis_clk/dout] \
  [get_bd_pins axis_clk_rx_out] \
  [get_bd_pins axis_clk_tx_out]
  connect_bd_net -net xlconcat_tx_rx_axis_rst_dout  [get_bd_pins xlconcat_tx_rx_axis_rst/dout] \
  [get_bd_pins rx_axis_rst] \
  [get_bd_pins tx_axis_rst]
  connect_bd_net -net xlconcat_tx_rx_axis_rstn_dout  [get_bd_pins xlconcat_tx_rx_axis_rstn/dout] \
  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins tx_axis_rstn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: GT_WRAPPER
proc create_hier_cell_GT_WRAPPER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_GT_WRAPPER() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O gtpowergood
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR1
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF1
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR2
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF2
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR3
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF3
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR4
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF4
  create_bd_pin -dir I -type clk s_axi_aclk_0
  create_bd_pin -dir I -type rst s_axi_aresetn_0
  create_bd_pin -dir O -from 3 -to 0 rx_usrclk2
  create_bd_pin -dir O -from 3 -to 0 rx_usrclk
  create_bd_pin -dir O -from 3 -to 0 tx_usrclk
  create_bd_pin -dir O -from 3 -to 0 tx_usrclk2
  create_bd_pin -dir O -from 3 -to 0 gt_reset_all
  create_bd_pin -dir O -from 3 -to 0 gt_reset_tx_datapath
  create_bd_pin -dir O -from 3 -to 0 gt_reset_rx_datapath
  create_bd_pin -dir I -from 3 -to 0 gt_rxp_in_0
  create_bd_pin -dir O -from 3 -to 0 gt_txn_out_0
  create_bd_pin -dir I -from 3 -to 0 gt_rxn_in_0
  create_bd_pin -dir O -from 3 -to 0 gt_txp_out_0
  create_bd_pin -dir I -from 3 -to 0 gt_rx_reset_done
  create_bd_pin -dir I -from 3 -to 0 gt_tx_reset_done
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir O -from 2 -to 0 Dout1

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base gt_quad_base ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {99.999908} \
    CONFIG.CHANNEL_ORDERING {/GT_WRAPPER/gt_quad_base/TX0_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_tx_serdes_interface_0.0 /GT_WRAPPER/gt_quad_base/TX1_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_tx_serdes_interface_1.1\
/GT_WRAPPER/gt_quad_base/TX2_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_tx_serdes_interface_2.2 /GT_WRAPPER/gt_quad_base/TX3_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_tx_serdes_interface_3.3\
/GT_WRAPPER/gt_quad_base/RX0_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_rx_serdes_interface_0.0 /GT_WRAPPER/gt_quad_base/RX1_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_rx_serdes_interface_1.1\
/GT_WRAPPER/gt_quad_base/RX2_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_rx_serdes_interface_2.2 /GT_WRAPPER/gt_quad_base/RX3_GT_IP_Interface vck190_mrmac_1x100g_mrmac_0_0_0./mrmac_0/gt_rx_serdes_interface_3.3}\
\
    CONFIG.GT_TYPE {GTY} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTY REG_CONF_INTF AXI_LITE BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL NRZ TX_HD_EN 0 TX_GRAY_BYP true TX_GRAY_LITTLEENDIAN true TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 25.78125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH\
80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY\
322.265625000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
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
LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH\
80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY\
322.265625000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
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
LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH\
80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET None RX_PAM_SEL\
NRZ RX_HD_EN 0 RX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY\
322.265625000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK\
RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 RXRECCLK_FREQ_ENABLE true RXRECCLK_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION PROGRAMMABLE\
RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
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
    CONFIG.PROT0_NO_OF_LANES {4} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/GT_WRAPPER/gt_quad_base {/GT_WRAPPER/gt_quad_base vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH0,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH1,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH2,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/GT_WRAPPER/gt_quad_base {/GT_WRAPPER/gt_quad_base vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH0,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH1,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH2,vck190_mrmac_1x100g_mrmac_0_0_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {{/CLK_IN_D_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_322.265625_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_322.265625_MHz_unique1} \
    CONFIG.REG_CONF_INTF {AXI_LITE} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT0} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {PROT0} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT0} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {PROT0} \
  ] $gt_quad_base

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
    CONFIG.REFCLK_LIST.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_base


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: mbufg_gt_1_3, and set properties
  set mbufg_gt_1_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf mbufg_gt_1_3 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_3


  # Create instance: mbufg_gt_1_1, and set properties
  set mbufg_gt_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf mbufg_gt_1_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_1


  # Create instance: mbufg_gt_0, and set properties
  set mbufg_gt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf mbufg_gt_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_0


  # Create instance: xlconst_mbufg_0, and set properties
  set xlconst_mbufg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconst_mbufg_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $xlconst_mbufg_0


  # Create instance: mbufg_gt_1_2, and set properties
  set mbufg_gt_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf mbufg_gt_1_2 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1_2


  # Create instance: mbufg_gt_1, and set properties
  set mbufg_gt_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf mbufg_gt_1 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $mbufg_gt_1


  # Create instance: axi_gpio_gt_rate_reset_ctl_0, and set properties
  set axi_gpio_gt_rate_reset_ctl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_gt_rate_reset_ctl_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {8} \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_0


  # Create instance: xlslice_gt_reset_all_0, and set properties
  set xlslice_gt_reset_all_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_reset_all_0 ]
  set_property CONFIG.DIN_WIDTH {8} $xlslice_gt_reset_all_0


  # Create instance: xlslice_gt_reset_tx_datapath_0, and set properties
  set xlslice_gt_reset_tx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_reset_tx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {8} \
  ] $xlslice_gt_reset_tx_datapath_0


  # Create instance: xlslice_gt_reset_rx_datapath_0, and set properties
  set xlslice_gt_reset_rx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_reset_rx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {8} \
  ] $xlslice_gt_reset_rx_datapath_0


  # Create instance: xlconcat_TX_USR_CLK, and set properties
  set xlconcat_TX_USR_CLK [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_TX_USR_CLK ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_TX_USR_CLK


  # Create instance: xlconcat_TX_USR_CLK2, and set properties
  set xlconcat_TX_USR_CLK2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_TX_USR_CLK2 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_TX_USR_CLK2


  # Create instance: xlconcat_RX_USR_CLK, and set properties
  set xlconcat_RX_USR_CLK [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_RX_USR_CLK ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_RX_USR_CLK


  # Create instance: xlconcat_RX_USR_CLK2, and set properties
  set xlconcat_RX_USR_CLK2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_RX_USR_CLK2 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_RX_USR_CLK2


  # Create instance: xlconcat_gt_reset_all, and set properties
  set xlconcat_gt_reset_all [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_gt_reset_all ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_reset_all


  # Create instance: xlconcat_gt_reset_rx_datapath, and set properties
  set xlconcat_gt_reset_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_gt_reset_rx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_reset_rx_datapath


  # Create instance: xlconcat_gt_reset_tx_datapath, and set properties
  set xlconcat_gt_reset_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_gt_reset_tx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_reset_tx_datapath


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: axi_gpio_gt_reset_mask, and set properties
  set axi_gpio_gt_reset_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_gt_reset_mask ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {8} \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_reset_mask


  # Create instance: xlconcat_reset_status, and set properties
  set xlconcat_reset_status [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_reset_status ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {4} \
    CONFIG.IN1_WIDTH {4} \
    CONFIG.NUM_PORTS {2} \
  ] $xlconcat_reset_status


  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary c_counter_binary_0 ]
  set_property CONFIG.Output_Width {28} $c_counter_binary_0


  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {27} \
    CONFIG.DIN_WIDTH {28} \
  ] $xlslice_0


  # Create instance: xlslice_loopback, and set properties
  set xlslice_loopback [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_loopback ]
  set_property -dict [list \
    CONFIG.DIN_FROM {6} \
    CONFIG.DIN_TO {4} \
    CONFIG.DIN_WIDTH {8} \
  ] $xlslice_loopback


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_pins CLK_IN_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins gt_quad_base/AXI_LITE] [get_bd_intf_pins AXI_LITE]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_0 [get_bd_intf_pins RX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_1 [get_bd_intf_pins RX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_2 [get_bd_intf_pins RX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_3 [get_bd_intf_pins RX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_0 [get_bd_intf_pins TX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_1 [get_bd_intf_pins TX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_2 [get_bd_intf_pins TX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_3 [get_bd_intf_pins TX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_gpio_gt_reset_mask/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]

  # Create port connections
  connect_bd_net -net In0_1  [get_bd_pins gt_rx_reset_done] \
  [get_bd_pins xlconcat_reset_status/In0]
  connect_bd_net -net In1_1  [get_bd_pins gt_tx_reset_done] \
  [get_bd_pins xlconcat_reset_status/In1]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_0_gpio2_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio2_io_o] \
  [get_bd_pins xlslice_gt_reset_all_0/Din] \
  [get_bd_pins xlslice_gt_reset_tx_datapath_0/Din] \
  [get_bd_pins xlslice_gt_reset_rx_datapath_0/Din] \
  [get_bd_pins xlslice_loopback/Din]
  connect_bd_net -net c_counter_binary_0_Q  [get_bd_pins c_counter_binary_0/Q] \
  [get_bd_pins xlslice_0/Din]
  connect_bd_net -net ch0_txrate_1  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio_io_o] \
  [get_bd_pins gt_quad_base/ch0_txrate] \
  [get_bd_pins gt_quad_base/ch1_txrate] \
  [get_bd_pins gt_quad_base/ch2_txrate] \
  [get_bd_pins gt_quad_base/ch3_txrate] \
  [get_bd_pins gt_quad_base/ch0_rxrate] \
  [get_bd_pins gt_quad_base/ch1_rxrate] \
  [get_bd_pins gt_quad_base/ch2_rxrate] \
  [get_bd_pins gt_quad_base/ch3_rxrate]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk  [get_bd_pins gt_quad_base/ch0_rxoutclk] \
  [get_bd_pins mbufg_gt_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_txoutclk  [get_bd_pins gt_quad_base/ch0_txoutclk] \
  [get_bd_pins mbufg_gt_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_rxoutclk  [get_bd_pins gt_quad_base/ch1_rxoutclk] \
  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch2_rxoutclk  [get_bd_pins gt_quad_base/ch2_rxoutclk] \
  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch3_rxoutclk  [get_bd_pins gt_quad_base/ch3_rxoutclk] \
  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_gtpowergood  [get_bd_pins gt_quad_base/gtpowergood] \
  [get_bd_pins gtpowergood]
  connect_bd_net -net gt_quad_base_txn  [get_bd_pins gt_quad_base/txn] \
  [get_bd_pins gt_txn_out_0]
  connect_bd_net -net gt_quad_base_txp  [get_bd_pins gt_quad_base/txp] \
  [get_bd_pins gt_txp_out_0]
  connect_bd_net -net gt_reset_tx_datapath_dout  [get_bd_pins xlconcat_gt_reset_tx_datapath/dout] \
  [get_bd_pins gt_reset_tx_datapath]
  connect_bd_net -net mbufg_gt_0_MBUFG_GT_O1  [get_bd_pins mbufg_gt_0/MBUFG_GT_O1] \
  [get_bd_pins xlconcat_TX_USR_CLK/In0] \
  [get_bd_pins xlconcat_TX_USR_CLK/In1] \
  [get_bd_pins xlconcat_TX_USR_CLK/In2] \
  [get_bd_pins xlconcat_TX_USR_CLK/In3] \
  [get_bd_pins c_counter_binary_0/CLK]
  connect_bd_net -net mbufg_gt_0_MBUFG_GT_O2  [get_bd_pins mbufg_gt_0/MBUFG_GT_O2] \
  [get_bd_pins gt_quad_base/ch0_txusrclk] \
  [get_bd_pins gt_quad_base/ch1_txusrclk] \
  [get_bd_pins gt_quad_base/ch2_txusrclk] \
  [get_bd_pins gt_quad_base/ch3_txusrclk] \
  [get_bd_pins xlconcat_TX_USR_CLK2/In0] \
  [get_bd_pins xlconcat_TX_USR_CLK2/In1] \
  [get_bd_pins xlconcat_TX_USR_CLK2/In2] \
  [get_bd_pins xlconcat_TX_USR_CLK2/In3]
  connect_bd_net -net mbufg_gt_1_1_MBUFG_GT_O1  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_O1] \
  [get_bd_pins xlconcat_RX_USR_CLK/In1]
  connect_bd_net -net mbufg_gt_1_1_MBUFG_GT_O2  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_O2] \
  [get_bd_pins gt_quad_base/ch1_rxusrclk] \
  [get_bd_pins xlconcat_RX_USR_CLK2/In1]
  connect_bd_net -net mbufg_gt_1_2_MBUFG_GT_O1  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_O1] \
  [get_bd_pins xlconcat_RX_USR_CLK/In2]
  connect_bd_net -net mbufg_gt_1_2_MBUFG_GT_O2  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_O2] \
  [get_bd_pins gt_quad_base/ch2_rxusrclk] \
  [get_bd_pins xlconcat_RX_USR_CLK2/In2]
  connect_bd_net -net mbufg_gt_1_3_MBUFG_GT_O1  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_O1] \
  [get_bd_pins xlconcat_RX_USR_CLK/In3]
  connect_bd_net -net mbufg_gt_1_3_MBUFG_GT_O2  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_O2] \
  [get_bd_pins gt_quad_base/ch3_rxusrclk] \
  [get_bd_pins xlconcat_RX_USR_CLK2/In3]
  connect_bd_net -net mbufg_gt_1_MBUFG_GT_O1  [get_bd_pins mbufg_gt_1/MBUFG_GT_O1] \
  [get_bd_pins xlconcat_RX_USR_CLK/In0]
  connect_bd_net -net mbufg_gt_1_MBUFG_GT_O2  [get_bd_pins mbufg_gt_1/MBUFG_GT_O2] \
  [get_bd_pins gt_quad_base/ch0_rxusrclk] \
  [get_bd_pins xlconcat_RX_USR_CLK2/In0]
  connect_bd_net -net mrmac_0_rx_clr_out_0  [get_bd_pins MBUFG_GT_CLR4] \
  [get_bd_pins mbufg_gt_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_1  [get_bd_pins MBUFG_GT_CLR1] \
  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_2  [get_bd_pins MBUFG_GT_CLR3] \
  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clr_out_3  [get_bd_pins MBUFG_GT_CLR] \
  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_0  [get_bd_pins MBUFG_GT_CLRB_LEAF4] \
  [get_bd_pins mbufg_gt_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_1  [get_bd_pins MBUFG_GT_CLRB_LEAF1] \
  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_2  [get_bd_pins MBUFG_GT_CLRB_LEAF3] \
  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_3  [get_bd_pins MBUFG_GT_CLRB_LEAF] \
  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net mrmac_0_tx_clr_out_0  [get_bd_pins MBUFG_GT_CLR2] \
  [get_bd_pins mbufg_gt_0/MBUFG_GT_CLR]
  connect_bd_net -net mrmac_0_tx_clrb_leaf_out_0  [get_bd_pins MBUFG_GT_CLRB_LEAF2] \
  [get_bd_pins mbufg_gt_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net rxn_0_1  [get_bd_pins gt_rxn_in_0] \
  [get_bd_pins gt_quad_base/rxn]
  connect_bd_net -net rxp_0_1  [get_bd_pins gt_rxp_in_0] \
  [get_bd_pins gt_quad_base/rxp]
  connect_bd_net -net s_axi_aclk_0_1  [get_bd_pins s_axi_aclk_0] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aclk] \
  [get_bd_pins gt_quad_base/s_axi_lite_clk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1  [get_bd_pins s_axi_aresetn_0] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aresetn] \
  [get_bd_pins gt_quad_base/s_axi_lite_resetn] \
  [get_bd_pins smartconnect_0/aresetn] \
  [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aresetn]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT  [get_bd_pins util_ds_buf_0/IBUF_OUT] \
  [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net xlconcat_RX_USR_CLK2_dout  [get_bd_pins xlconcat_RX_USR_CLK2/dout] \
  [get_bd_pins rx_usrclk2]
  connect_bd_net -net xlconcat_RX_USR_CLK_dout  [get_bd_pins xlconcat_RX_USR_CLK/dout] \
  [get_bd_pins rx_usrclk]
  connect_bd_net -net xlconcat_TX_USR_CLK2_dout  [get_bd_pins xlconcat_TX_USR_CLK2/dout] \
  [get_bd_pins tx_usrclk2]
  connect_bd_net -net xlconcat_TX_USR_CLK_dout  [get_bd_pins xlconcat_TX_USR_CLK/dout] \
  [get_bd_pins tx_usrclk]
  connect_bd_net -net xlconcat_gt_reset_all_dout  [get_bd_pins xlconcat_gt_reset_all/dout] \
  [get_bd_pins gt_reset_all]
  connect_bd_net -net xlconcat_gt_reset_rx_datapath_dout  [get_bd_pins xlconcat_gt_reset_rx_datapath/dout] \
  [get_bd_pins gt_reset_rx_datapath]
  connect_bd_net -net xlconcat_reset_status_dout  [get_bd_pins xlconcat_reset_status/dout] \
  [get_bd_pins axi_gpio_gt_reset_mask/gpio2_io_i]
  connect_bd_net -net xlconst_mbufg_0_dout  [get_bd_pins xlconst_mbufg_0/dout] \
  [get_bd_pins mbufg_gt_0/MBUFG_GT_CE] \
  [get_bd_pins mbufg_gt_1/MBUFG_GT_CE] \
  [get_bd_pins mbufg_gt_1_1/MBUFG_GT_CE] \
  [get_bd_pins mbufg_gt_1_2/MBUFG_GT_CE] \
  [get_bd_pins mbufg_gt_1_3/MBUFG_GT_CE]
  connect_bd_net -net xlslice_0_Dout  [get_bd_pins xlslice_0/Dout] \
  [get_bd_pins Dout]
  connect_bd_net -net xlslice_gt_reset_all_0_Dout  [get_bd_pins xlslice_gt_reset_all_0/Dout] \
  [get_bd_pins xlconcat_gt_reset_all/In0] \
  [get_bd_pins xlconcat_gt_reset_all/In1] \
  [get_bd_pins xlconcat_gt_reset_all/In2] \
  [get_bd_pins xlconcat_gt_reset_all/In3]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_0_Dout  [get_bd_pins xlslice_gt_reset_rx_datapath_0/Dout] \
  [get_bd_pins xlconcat_gt_reset_rx_datapath/In0] \
  [get_bd_pins xlconcat_gt_reset_rx_datapath/In1] \
  [get_bd_pins xlconcat_gt_reset_rx_datapath/In2] \
  [get_bd_pins xlconcat_gt_reset_rx_datapath/In3]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_1_Dout  [get_bd_pins xlslice_loopback/Dout] \
  [get_bd_pins gt_quad_base/ch0_loopback] \
  [get_bd_pins gt_quad_base/ch1_loopback] \
  [get_bd_pins gt_quad_base/ch2_loopback] \
  [get_bd_pins gt_quad_base/ch3_loopback] \
  [get_bd_pins Dout1]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_0_Dout  [get_bd_pins xlslice_gt_reset_tx_datapath_0/Dout] \
  [get_bd_pins xlconcat_gt_reset_tx_datapath/In0] \
  [get_bd_pins xlconcat_gt_reset_tx_datapath/In1] \
  [get_bd_pins xlconcat_gt_reset_tx_datapath/In2] \
  [get_bd_pins xlconcat_gt_reset_tx_datapath/In3]

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
  set CLK_IN_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $CLK_IN_D

  set ch0_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c0 ]

  set ch0_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c1 ]

  set ch1_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c0 ]

  set ch1_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c1 ]

  set lpddr4_sma_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk1

  set lpddr4_sma_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk2


  # Create ports
  set gt_txn_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txn_out_0 ]
  set gt_txp_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txp_out_0 ]
  set gt_rxp_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxp_in_0 ]
  set gt_rxn_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxn_in_0 ]
  set GPIO_LED_0_LS [ create_bd_port -dir O -from 0 -to 0 GPIO_LED_0_LS ]

  # Create instance: mrmac_0, and set properties
  set mrmac_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mrmac mrmac_0 ]

  # Create instance: GT_WRAPPER
  create_hier_cell_GT_WRAPPER [current_bd_instance .] GT_WRAPPER

  # Create instance: mrmac_pm_tick_drive_zero, and set properties
  set mrmac_pm_tick_drive_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant mrmac_pm_tick_drive_zero ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $mrmac_pm_tick_drive_zero


  # Create instance: mrmac_tx_preamble_value, and set properties
  set mrmac_tx_preamble_value [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant mrmac_tx_preamble_value ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x555555555555d5} \
    CONFIG.CONST_WIDTH {56} \
  ] $mrmac_tx_preamble_value


  # Create instance: mrmac_constant_drive_zero, and set properties
  set mrmac_constant_drive_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant mrmac_constant_drive_zero ]
  set_property CONFIG.CONST_VAL {0} $mrmac_constant_drive_zero


  # Create instance: mrmac_constant_drive_zero_8bit, and set properties
  set mrmac_constant_drive_zero_8bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant mrmac_constant_drive_zero_8bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {8} \
  ] $mrmac_constant_drive_zero_8bit


  # Create instance: mrmac_constant_drive_zero_66bit, and set properties
  set mrmac_constant_drive_zero_66bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant mrmac_constant_drive_zero_66bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {66} \
  ] $mrmac_constant_drive_zero_66bit


  # Create instance: CLK_RST_WRAPPER
  create_hier_cell_CLK_RST_WRAPPER [current_bd_instance .] CLK_RST_WRAPPER

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CPM_CONFIG { \
      AURORA_LINE_RATE_GPBS {10.0} \
      BOOT_SECONDARY_PCIE_ENABLE {0} \
      CPM_A0_REFCLK {0} \
      CPM_A1_REFCLK {0} \
      CPM_AUX0_REF_CTRL_ACT_FREQMHZ {899.991028} \
      CPM_AUX0_REF_CTRL_DIVISOR0 {2} \
      CPM_AUX0_REF_CTRL_FREQMHZ {900} \
      CPM_AUX1_REF_CTRL_ACT_FREQMHZ {899.991028} \
      CPM_AUX1_REF_CTRL_DIVISOR0 {2} \
      CPM_AUX1_REF_CTRL_FREQMHZ {900} \
      CPM_AXI_SLV_BRIDGE_BASE_ADDRR_H {0x00000006} \
      CPM_AXI_SLV_BRIDGE_BASE_ADDRR_L {0x00000000} \
      CPM_AXI_SLV_MULTQ_BASE_ADDRR_H {0x00000006} \
      CPM_AXI_SLV_MULTQ_BASE_ADDRR_L {0x10000000} \
      CPM_AXI_SLV_XDMA_BASE_ADDRR_H {0x00000006} \
      CPM_AXI_SLV_XDMA_BASE_ADDRR_L {0x11000000} \
      CPM_CCIX_IS_MM_ONLY {0} \
      CPM_CCIX_PARTIAL_CACHELINE_SUPPORT {0} \
      CPM_CCIX_PORT_AGGREGATION_ENABLE {0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_0 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_1 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_2 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_3 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_4 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_5 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_6 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_AGENT_TYPE_7 {HA0} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_0 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_1 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_2 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_3 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_4 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_5 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_6 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_ATTRIB_7 {Normal_Non_Cacheable_Memory} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_0 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_1 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_2 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_3 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_4 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_5 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_6 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_BASEADDRESS_7 {0x00000000} \
      CPM_CCIX_RSVRD_MEMORY_REGION_0 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_1 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_2 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_3 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_4 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_5 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_6 {0} \
      CPM_CCIX_RSVRD_MEMORY_REGION_7 {0} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_0 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_1 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_2 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_3 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_4 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_5 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_6 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_SIZE_7 {4GB} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_0 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_1 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_2 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_3 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_4 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_5 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_6 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_RSVRD_MEMORY_TYPE_7 {Other_or_Non_Specified_Memory_Type} \
      CPM_CCIX_SELECT_AGENT {None} \
      CPM_CDO_EN {0} \
      CPM_CLRERR_LANE_MARGIN {0} \
      CPM_CORE_REF_CTRL_ACT_FREQMHZ {899.991028} \
      CPM_CORE_REF_CTRL_DIVISOR0 {2} \
      CPM_CORE_REF_CTRL_FREQMHZ {900} \
      CPM_CPLL_CTRL_FBDIV {108} \
      CPM_CPLL_CTRL_SRCSEL {REF_CLK} \
      CPM_DBG_REF_CTRL_ACT_FREQMHZ {299.997009} \
      CPM_DBG_REF_CTRL_DIVISOR0 {6} \
      CPM_DBG_REF_CTRL_FREQMHZ {300} \
      CPM_DESIGN_USE_MODE {0} \
      CPM_DMA_CREDIT_INIT_DEMUX {1} \
      CPM_DMA_IS_MM_ONLY {0} \
      CPM_LSBUS_REF_CTRL_ACT_FREQMHZ {149.998505} \
      CPM_LSBUS_REF_CTRL_DIVISOR0 {12} \
      CPM_LSBUS_REF_CTRL_FREQMHZ {150} \
      CPM_NUM_CCIX_CREDIT_LINKS {0} \
      CPM_NUM_HNF_AGENTS {0} \
      CPM_NUM_HOME_OR_SLAVE_AGENTS {0} \
      CPM_NUM_REQ_AGENTS {0} \
      CPM_NUM_SLAVE_AGENTS {0} \
      CPM_PCIE0_AER_CAP_ENABLED {1} \
      CPM_PCIE0_ARI_CAP_ENABLED {1} \
      CPM_PCIE0_ASYNC_MODE {SRNS} \
      CPM_PCIE0_ATS_PRI_CAP_ON {0} \
      CPM_PCIE0_AXIBAR_NUM {1} \
      CPM_PCIE0_AXISTEN_IF_CC_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE0_AXISTEN_IF_COMPL_TIMEOUT_REG0 {BEBC20} \
      CPM_PCIE0_AXISTEN_IF_COMPL_TIMEOUT_REG1 {2FAF080} \
      CPM_PCIE0_AXISTEN_IF_CQ_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_256_TAGS {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_CLIENT_TAG {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_INTERNAL_MSIX_TABLE {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_MESSAGE_RID_CHECK {1} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_MSG_ROUTE {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_RX_MSG_INTFC {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_RX_TAG_SCALING {0} \
      CPM_PCIE0_AXISTEN_IF_ENABLE_TX_TAG_SCALING {0} \
      CPM_PCIE0_AXISTEN_IF_EXTEND_CPL_TIMEOUT {16ms_to_1s} \
      CPM_PCIE0_AXISTEN_IF_EXT_512 {0} \
      CPM_PCIE0_AXISTEN_IF_EXT_512_CC_STRADDLE {0} \
      CPM_PCIE0_AXISTEN_IF_EXT_512_CQ_STRADDLE {0} \
      CPM_PCIE0_AXISTEN_IF_EXT_512_RC_4TLP_STRADDLE {0} \
      CPM_PCIE0_AXISTEN_IF_EXT_512_RC_STRADDLE {1} \
      CPM_PCIE0_AXISTEN_IF_EXT_512_RQ_STRADDLE {0} \
      CPM_PCIE0_AXISTEN_IF_RC_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE0_AXISTEN_IF_RC_STRADDLE {0} \
      CPM_PCIE0_AXISTEN_IF_RQ_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE0_AXISTEN_IF_RX_PARITY_EN {1} \
      CPM_PCIE0_AXISTEN_IF_SIM_SHORT_CPL_TIMEOUT {0} \
      CPM_PCIE0_AXISTEN_IF_TX_PARITY_EN {0} \
      CPM_PCIE0_AXISTEN_IF_WIDTH {64} \
      CPM_PCIE0_AXISTEN_MSIX_VECTORS_PER_FUNCTION {8} \
      CPM_PCIE0_AXISTEN_USER_SPARE {0} \
      CPM_PCIE0_BRIDGE_AXI_SLAVE_IF {0} \
      CPM_PCIE0_CCIX_EN {0} \
      CPM_PCIE0_CCIX_OPT_TLP_GEN_AND_RECEPT_EN_CONTROL_INTERNAL {0} \
      CPM_PCIE0_CCIX_VENDOR_ID {0} \
      CPM_PCIE0_CFG_CTL_IF {0} \
      CPM_PCIE0_CFG_EXT_IF {0} \
      CPM_PCIE0_CFG_FC_IF {0} \
      CPM_PCIE0_CFG_MGMT_IF {0} \
      CPM_PCIE0_CFG_SPEC_4_0 {0} \
      CPM_PCIE0_CFG_STS_IF {0} \
      CPM_PCIE0_CFG_VEND_ID {10EE} \
      CPM_PCIE0_CONTROLLER_ENABLE {0} \
      CPM_PCIE0_COPY_PF0_ENABLED {0} \
      CPM_PCIE0_COPY_PF0_QDMA_ENABLED {1} \
      CPM_PCIE0_COPY_PF0_SRIOV_QDMA_ENABLED {1} \
      CPM_PCIE0_COPY_SRIOV_PF0_ENABLED {1} \
      CPM_PCIE0_COPY_XDMA_PF0_ENABLED {0} \
      CPM_PCIE0_CORE_CLK_FREQ {500} \
      CPM_PCIE0_CORE_EDR_CLK_FREQ {625} \
      CPM_PCIE0_DMA_DATA_WIDTH {256bits} \
      CPM_PCIE0_DMA_ENABLE_SECURE {0} \
      CPM_PCIE0_DMA_INTF {AXI4} \
      CPM_PCIE0_DMA_MASK {256bits} \
      CPM_PCIE0_DMA_METERING_ENABLE {1} \
      CPM_PCIE0_DMA_MSI_RX_PIN_ENABLED {FALSE} \
      CPM_PCIE0_DMA_ROOT_PORT {0} \
      CPM_PCIE0_DSC_BYPASS_RD {0} \
      CPM_PCIE0_DSC_BYPASS_WR {0} \
      CPM_PCIE0_EDR_IF {0} \
      CPM_PCIE0_EDR_LINK_SPEED {None} \
      CPM_PCIE0_EN_PARITY {0} \
      CPM_PCIE0_EXT_PCIE_CFG_SPACE_ENABLED {None} \
      CPM_PCIE0_FUNCTIONAL_MODE {None} \
      CPM_PCIE0_LANE_REVERSAL_EN {0} \
      CPM_PCIE0_LEGACY_EXT_PCIE_CFG_SPACE_ENABLED {0} \
      CPM_PCIE0_LINK_DEBUG_AXIST_EN {0} \
      CPM_PCIE0_LINK_DEBUG_EN {0} \
      CPM_PCIE0_LINK_SPEED0_FOR_POWER {GEN1} \
      CPM_PCIE0_LINK_WIDTH0_FOR_POWER {0} \
      CPM_PCIE0_MAILBOX_ENABLE {0} \
      CPM_PCIE0_MAX_LINK_SPEED {2.5_GT/s} \
      CPM_PCIE0_MCAP_ENABLE {0} \
      CPM_PCIE0_MESG_RSVD_IF {0} \
      CPM_PCIE0_MESG_TRANSMIT_IF {0} \
      CPM_PCIE0_MODE0_FOR_POWER {NONE} \
      CPM_PCIE0_MODES {None} \
      CPM_PCIE0_MODE_SELECTION {Basic} \
      CPM_PCIE0_MSIX_RP_ENABLED {1} \
      CPM_PCIE0_MSI_X_OPTIONS {None} \
      CPM_PCIE0_NUM_USR_IRQ {1} \
      CPM_PCIE0_PASID_IF {0} \
      CPM_PCIE0_PF0_AER_CAP_ECRC_GEN_AND_CHECK_CAPABLE {0} \
      CPM_PCIE0_PF0_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE0_PF0_ARI_CAP_VER {1} \
      CPM_PCIE0_PF0_ATS_CAP_ON {0} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BASEADDR_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_BRIDGE_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXIBAR2PCIE_HIGHADDR_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE0_PF0_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE0_PF0_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE0_PF0_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE0_PF0_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE0_PF0_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE0_PF0_BAR0_64BIT {0} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_64BIT {0} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR0_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR0_ENABLED {1} \
      CPM_PCIE0_PF0_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR0_QDMA_64BIT {1} \
      CPM_PCIE0_PF0_BAR0_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR0_QDMA_ENABLED {1} \
      CPM_PCIE0_PF0_BAR0_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF0_BAR0_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR0_QDMA_SIZE {128} \
      CPM_PCIE0_PF0_BAR0_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF0_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR0_SIZE {128} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_64BIT {1} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_ENABLED {1} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_SIZE {16} \
      CPM_PCIE0_PF0_BAR0_SRIOV_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF0_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR0_XDMA_64BIT {1} \
      CPM_PCIE0_PF0_BAR0_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR0_XDMA_ENABLED {1} \
      CPM_PCIE0_PF0_BAR0_XDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF0_BAR0_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR0_XDMA_SIZE {64} \
      CPM_PCIE0_PF0_BAR0_XDMA_TYPE {DMA} \
      CPM_PCIE0_PF0_BAR1_64BIT {0} \
      CPM_PCIE0_PF0_BAR1_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR1_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR1_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR1_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR1_ENABLED {0} \
      CPM_PCIE0_PF0_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR1_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR1_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR1_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR1_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR1_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR1_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR1_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR1_SIZE {4} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR1_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR1_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR1_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR1_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR1_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR1_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR1_XDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR1_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR2_64BIT {0} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_64BIT {0} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR2_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR2_ENABLED {0} \
      CPM_PCIE0_PF0_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR2_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR2_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR2_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR2_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR2_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR2_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR2_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR2_SIZE {4} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR2_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR2_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR2_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR2_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR2_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR2_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR2_XDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR2_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR3_64BIT {0} \
      CPM_PCIE0_PF0_BAR3_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR3_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR3_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR3_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR3_ENABLED {0} \
      CPM_PCIE0_PF0_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR3_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR3_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR3_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR3_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR3_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR3_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR3_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR3_SIZE {4} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR3_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR3_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR3_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR3_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR3_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR3_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR3_XDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR3_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR4_64BIT {0} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_64BIT {0} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR4_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR4_ENABLED {0} \
      CPM_PCIE0_PF0_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR4_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR4_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR4_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR4_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR4_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR4_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR4_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR4_SIZE {4} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR4_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR4_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR4_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR4_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR4_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR4_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR4_XDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR4_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR5_64BIT {0} \
      CPM_PCIE0_PF0_BAR5_BRIDGE_ENABLED {0} \
      CPM_PCIE0_PF0_BAR5_BRIDGE_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR5_BRIDGE_SIZE {4} \
      CPM_PCIE0_PF0_BAR5_BRIDGE_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR5_ENABLED {0} \
      CPM_PCIE0_PF0_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR5_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR5_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR5_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR5_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR5_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR5_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR5_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR5_SIZE {4} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR5_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF0_BAR5_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_BAR5_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF0_BAR5_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_BAR5_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_BAR5_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_BAR5_XDMA_SIZE {4} \
      CPM_PCIE0_PF0_BAR5_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF0_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE0_PF0_BASE_CLASS_VALUE {05} \
      CPM_PCIE0_PF0_CAPABILITY_POINTER {80} \
      CPM_PCIE0_PF0_CFG_DEV_ID {B03F} \
      CPM_PCIE0_PF0_CFG_REV_ID {0} \
      CPM_PCIE0_PF0_CFG_SUBSYS_ID {7} \
      CPM_PCIE0_PF0_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE0_PF0_CLASS_CODE {0} \
      CPM_PCIE0_PF0_DEV_CAP_10B_TAG_EN {0} \
      CPM_PCIE0_PF0_DEV_CAP_ENDPOINT_L0S_LATENCY {less_than_64ns} \
      CPM_PCIE0_PF0_DEV_CAP_ENDPOINT_L1S_LATENCY {less_than_1us} \
      CPM_PCIE0_PF0_DEV_CAP_EXT_TAG_EN {0} \
      CPM_PCIE0_PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE {0} \
      CPM_PCIE0_PF0_DEV_CAP_MAX_PAYLOAD {1024_bytes} \
      CPM_PCIE0_PF0_DLL_FEATURE_CAP_ID {0x0025} \
      CPM_PCIE0_PF0_DLL_FEATURE_CAP_ON {1} \
      CPM_PCIE0_PF0_DLL_FEATURE_CAP_VER {1} \
      CPM_PCIE0_PF0_DSN_CAP_ENABLE {0} \
      CPM_PCIE0_PF0_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE0_PF0_EXPANSION_ROM_QDMA_ENABLED {0} \
      CPM_PCIE0_PF0_EXPANSION_ROM_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_EXPANSION_ROM_QDMA_SIZE {2} \
      CPM_PCIE0_PF0_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE0_PF0_INTERFACE_VALUE {0} \
      CPM_PCIE0_PF0_INTERRUPT_PIN {NONE} \
      CPM_PCIE0_PF0_LINK_CAP_ASPM_SUPPORT {No_ASPM} \
      CPM_PCIE0_PF0_LINK_STATUS_SLOT_CLOCK_CONFIG {1} \
      CPM_PCIE0_PF0_MARGINING_CAP_ID {0} \
      CPM_PCIE0_PF0_MARGINING_CAP_ON {0} \
      CPM_PCIE0_PF0_MARGINING_CAP_VER {1} \
      CPM_PCIE0_PF0_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_PF0_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_PF0_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_PF0_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_PF0_MSIX_CAP_TABLE_SIZE {007} \
      CPM_PCIE0_PF0_MSIX_ENABLED {1} \
      CPM_PCIE0_PF0_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE0_PF0_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE0_PF0_MSI_ENABLED {1} \
      CPM_PCIE0_PF0_PASID_CAP_MAX_PASID_WIDTH {1} \
      CPM_PCIE0_PF0_PASID_CAP_ON {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_BRIDGE_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_SRIOV_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_0 {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_1 {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_2 {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_3 {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_4 {0} \
      CPM_PCIE0_PF0_PCIEBAR2AXIBAR_XDMA_5 {0} \
      CPM_PCIE0_PF0_PL16_CAP_ID {0} \
      CPM_PCIE0_PF0_PL16_CAP_ON {0} \
      CPM_PCIE0_PF0_PL16_CAP_VER {1} \
      CPM_PCIE0_PF0_PM_CAP_ID {0} \
      CPM_PCIE0_PF0_PM_CAP_PMESUPPORT_D0 {1} \
      CPM_PCIE0_PF0_PM_CAP_PMESUPPORT_D1 {1} \
      CPM_PCIE0_PF0_PM_CAP_PMESUPPORT_D3COLD {1} \
      CPM_PCIE0_PF0_PM_CAP_PMESUPPORT_D3HOT {1} \
      CPM_PCIE0_PF0_PM_CAP_SUPP_D1_STATE {1} \
      CPM_PCIE0_PF0_PM_CAP_VER_ID {3} \
      CPM_PCIE0_PF0_PM_CSR_NOSOFTRESET {1} \
      CPM_PCIE0_PF0_PRI_CAP_ON {0} \
      CPM_PCIE0_PF0_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE0_PF0_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE0_PF0_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE0_PF0_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE0_PF0_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF0_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE0_PF0_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE0_PF0_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE0_PF0_SRIOV_CAP_VER {1} \
      CPM_PCIE0_PF0_SRIOV_FIRST_VF_OFFSET {4} \
      CPM_PCIE0_PF0_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE0_PF0_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE0_PF0_SRIOV_VF_DEVICE_ID {C03F} \
      CPM_PCIE0_PF0_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE0_PF0_SUB_CLASS_VALUE {80} \
      CPM_PCIE0_PF0_TPHR_CAP_DEV_SPECIFIC_MODE {1} \
      CPM_PCIE0_PF0_TPHR_CAP_ENABLE {0} \
      CPM_PCIE0_PF0_TPHR_CAP_INT_VEC_MODE {1} \
      CPM_PCIE0_PF0_TPHR_CAP_ST_TABLE_LOC {ST_Table_not_present} \
      CPM_PCIE0_PF0_TPHR_CAP_ST_TABLE_SIZE {16} \
      CPM_PCIE0_PF0_TPHR_CAP_VER {1} \
      CPM_PCIE0_PF0_TPHR_ENABLE {0} \
      CPM_PCIE0_PF0_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE0_PF0_VC_ARB_CAPABILITY {0} \
      CPM_PCIE0_PF0_VC_ARB_TBL_OFFSET {0} \
      CPM_PCIE0_PF0_VC_CAP_ENABLED {0} \
      CPM_PCIE0_PF0_VC_CAP_VER {1} \
      CPM_PCIE0_PF0_VC_EXTENDED_COUNT {0} \
      CPM_PCIE0_PF0_VC_LOW_PRIORITY_EXTENDED_COUNT {0} \
      CPM_PCIE0_PF0_XDMA_64BIT {0} \
      CPM_PCIE0_PF0_XDMA_ENABLED {0} \
      CPM_PCIE0_PF0_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF0_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF0_XDMA_SIZE {128} \
      CPM_PCIE0_PF1_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE0_PF1_ATS_CAP_ON {0} \
      CPM_PCIE0_PF1_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE0_PF1_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE0_PF1_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE0_PF1_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE0_PF1_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE0_PF1_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE0_PF1_BAR0_64BIT {0} \
      CPM_PCIE0_PF1_BAR0_ENABLED {1} \
      CPM_PCIE0_PF1_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR0_QDMA_64BIT {1} \
      CPM_PCIE0_PF1_BAR0_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR0_QDMA_ENABLED {1} \
      CPM_PCIE0_PF1_BAR0_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF1_BAR0_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR0_QDMA_SIZE {128} \
      CPM_PCIE0_PF1_BAR0_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF1_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR0_SIZE {128} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_64BIT {1} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_ENABLED {1} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_SIZE {16} \
      CPM_PCIE0_PF1_BAR0_SRIOV_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF1_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR0_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR0_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR0_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR0_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR0_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR0_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR0_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR1_64BIT {0} \
      CPM_PCIE0_PF1_BAR1_ENABLED {0} \
      CPM_PCIE0_PF1_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR1_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR1_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR1_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR1_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR1_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR1_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR1_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR1_SIZE {4} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR1_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR1_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR1_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR1_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR1_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR1_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR1_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR1_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR2_64BIT {0} \
      CPM_PCIE0_PF1_BAR2_ENABLED {0} \
      CPM_PCIE0_PF1_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR2_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR2_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR2_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR2_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR2_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR2_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR2_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR2_SIZE {4} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR2_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR2_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR2_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR2_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR2_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR2_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR2_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR2_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR3_64BIT {0} \
      CPM_PCIE0_PF1_BAR3_ENABLED {0} \
      CPM_PCIE0_PF1_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR3_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR3_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR3_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR3_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR3_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR3_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR3_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR3_SIZE {4} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR3_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR3_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR3_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR3_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR3_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR3_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR3_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR3_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR4_64BIT {0} \
      CPM_PCIE0_PF1_BAR4_ENABLED {0} \
      CPM_PCIE0_PF1_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR4_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR4_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR4_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR4_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR4_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR4_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR4_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR4_SIZE {4} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR4_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR4_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR4_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR4_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR4_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR4_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR4_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR4_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR5_64BIT {0} \
      CPM_PCIE0_PF1_BAR5_ENABLED {0} \
      CPM_PCIE0_PF1_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR5_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR5_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR5_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR5_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR5_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR5_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR5_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR5_SIZE {4} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR5_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF1_BAR5_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_BAR5_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF1_BAR5_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_BAR5_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_BAR5_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_BAR5_XDMA_SIZE {4} \
      CPM_PCIE0_PF1_BAR5_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF1_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE0_PF1_BASE_CLASS_VALUE {05} \
      CPM_PCIE0_PF1_CAPABILITY_POINTER {80} \
      CPM_PCIE0_PF1_CFG_DEV_ID {B13F} \
      CPM_PCIE0_PF1_CFG_REV_ID {0} \
      CPM_PCIE0_PF1_CFG_SUBSYS_ID {7} \
      CPM_PCIE0_PF1_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE0_PF1_CLASS_CODE {0x058000} \
      CPM_PCIE0_PF1_DSN_CAP_ENABLE {0} \
      CPM_PCIE0_PF1_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE0_PF1_EXPANSION_ROM_QDMA_ENABLED {0} \
      CPM_PCIE0_PF1_EXPANSION_ROM_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_EXPANSION_ROM_QDMA_SIZE {2} \
      CPM_PCIE0_PF1_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE0_PF1_INTERFACE_VALUE {00} \
      CPM_PCIE0_PF1_INTERRUPT_PIN {NONE} \
      CPM_PCIE0_PF1_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_PF1_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_PF1_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_PF1_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_PF1_MSIX_CAP_TABLE_SIZE {007} \
      CPM_PCIE0_PF1_MSIX_ENABLED {1} \
      CPM_PCIE0_PF1_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE0_PF1_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE0_PF1_MSI_ENABLED {1} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_SRIOV_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_0 {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_1 {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_2 {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_3 {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_4 {0} \
      CPM_PCIE0_PF1_PCIEBAR2AXIBAR_XDMA_5 {0} \
      CPM_PCIE0_PF1_PRI_CAP_ON {0} \
      CPM_PCIE0_PF1_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE0_PF1_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE0_PF1_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE0_PF1_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE0_PF1_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF1_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE0_PF1_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE0_PF1_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE0_PF1_SRIOV_CAP_VER {1} \
      CPM_PCIE0_PF1_SRIOV_FIRST_VF_OFFSET {7} \
      CPM_PCIE0_PF1_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE0_PF1_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE0_PF1_SRIOV_VF_DEVICE_ID {C13F} \
      CPM_PCIE0_PF1_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE0_PF1_SUB_CLASS_VALUE {80} \
      CPM_PCIE0_PF1_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE0_PF1_VEND_ID {10EE} \
      CPM_PCIE0_PF1_XDMA_64BIT {0} \
      CPM_PCIE0_PF1_XDMA_ENABLED {0} \
      CPM_PCIE0_PF1_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF1_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF1_XDMA_SIZE {128} \
      CPM_PCIE0_PF2_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE0_PF2_ATS_CAP_ON {0} \
      CPM_PCIE0_PF2_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE0_PF2_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE0_PF2_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE0_PF2_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE0_PF2_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE0_PF2_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE0_PF2_BAR0_64BIT {0} \
      CPM_PCIE0_PF2_BAR0_ENABLED {1} \
      CPM_PCIE0_PF2_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR0_QDMA_64BIT {1} \
      CPM_PCIE0_PF2_BAR0_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR0_QDMA_ENABLED {1} \
      CPM_PCIE0_PF2_BAR0_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF2_BAR0_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR0_QDMA_SIZE {128} \
      CPM_PCIE0_PF2_BAR0_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF2_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR0_SIZE {128} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_64BIT {1} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_ENABLED {1} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_SIZE {16} \
      CPM_PCIE0_PF2_BAR0_SRIOV_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF2_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR0_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR0_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR0_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR0_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR0_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR0_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR0_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR1_64BIT {0} \
      CPM_PCIE0_PF2_BAR1_ENABLED {0} \
      CPM_PCIE0_PF2_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR1_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR1_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR1_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR1_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR1_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR1_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR1_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR1_SIZE {4} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR1_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR1_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR1_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR1_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR1_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR1_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR1_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR1_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR2_64BIT {0} \
      CPM_PCIE0_PF2_BAR2_ENABLED {0} \
      CPM_PCIE0_PF2_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR2_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR2_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR2_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR2_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR2_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR2_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR2_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR2_SIZE {4} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR2_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR2_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR2_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR2_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR2_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR2_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR2_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR2_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR3_64BIT {0} \
      CPM_PCIE0_PF2_BAR3_ENABLED {0} \
      CPM_PCIE0_PF2_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR3_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR3_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR3_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR3_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR3_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR3_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR3_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR3_SIZE {4} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR3_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR3_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR3_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR3_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR3_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR3_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR3_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR3_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR4_64BIT {0} \
      CPM_PCIE0_PF2_BAR4_ENABLED {0} \
      CPM_PCIE0_PF2_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR4_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR4_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR4_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR4_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR4_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR4_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR4_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR4_SIZE {4} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR4_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR4_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR4_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR4_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR4_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR4_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR4_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR4_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR5_64BIT {0} \
      CPM_PCIE0_PF2_BAR5_ENABLED {0} \
      CPM_PCIE0_PF2_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR5_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR5_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR5_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR5_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR5_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR5_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR5_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR5_SIZE {4} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR5_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF2_BAR5_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_BAR5_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF2_BAR5_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_BAR5_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_BAR5_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_BAR5_XDMA_SIZE {4} \
      CPM_PCIE0_PF2_BAR5_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF2_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE0_PF2_BASE_CLASS_VALUE {05} \
      CPM_PCIE0_PF2_CAPABILITY_POINTER {80} \
      CPM_PCIE0_PF2_CFG_DEV_ID {B23F} \
      CPM_PCIE0_PF2_CFG_REV_ID {0} \
      CPM_PCIE0_PF2_CFG_SUBSYS_ID {7} \
      CPM_PCIE0_PF2_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE0_PF2_CLASS_CODE {0x058000} \
      CPM_PCIE0_PF2_DSN_CAP_ENABLE {0} \
      CPM_PCIE0_PF2_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE0_PF2_EXPANSION_ROM_QDMA_ENABLED {0} \
      CPM_PCIE0_PF2_EXPANSION_ROM_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_EXPANSION_ROM_QDMA_SIZE {2} \
      CPM_PCIE0_PF2_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE0_PF2_INTERFACE_VALUE {00} \
      CPM_PCIE0_PF2_INTERRUPT_PIN {NONE} \
      CPM_PCIE0_PF2_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_PF2_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_PF2_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_PF2_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_PF2_MSIX_CAP_TABLE_SIZE {007} \
      CPM_PCIE0_PF2_MSIX_ENABLED {1} \
      CPM_PCIE0_PF2_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE0_PF2_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE0_PF2_MSI_ENABLED {1} \
      CPM_PCIE0_PF2_PASID_CAP_MAX_PASID_WIDTH {1} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_SRIOV_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_0 {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_1 {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_2 {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_3 {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_4 {0} \
      CPM_PCIE0_PF2_PCIEBAR2AXIBAR_XDMA_5 {0} \
      CPM_PCIE0_PF2_PRI_CAP_ON {0} \
      CPM_PCIE0_PF2_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE0_PF2_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE0_PF2_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE0_PF2_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE0_PF2_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF2_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE0_PF2_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE0_PF2_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE0_PF2_SRIOV_CAP_VER {1} \
      CPM_PCIE0_PF2_SRIOV_FIRST_VF_OFFSET {10} \
      CPM_PCIE0_PF2_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE0_PF2_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE0_PF2_SRIOV_VF_DEVICE_ID {C23F} \
      CPM_PCIE0_PF2_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE0_PF2_SUB_CLASS_VALUE {80} \
      CPM_PCIE0_PF2_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE0_PF2_VEND_ID {10EE} \
      CPM_PCIE0_PF2_XDMA_64BIT {0} \
      CPM_PCIE0_PF2_XDMA_ENABLED {0} \
      CPM_PCIE0_PF2_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF2_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF2_XDMA_SIZE {128} \
      CPM_PCIE0_PF3_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE0_PF3_ATS_CAP_ON {0} \
      CPM_PCIE0_PF3_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE0_PF3_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE0_PF3_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE0_PF3_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE0_PF3_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE0_PF3_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE0_PF3_BAR0_64BIT {0} \
      CPM_PCIE0_PF3_BAR0_ENABLED {1} \
      CPM_PCIE0_PF3_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR0_QDMA_64BIT {1} \
      CPM_PCIE0_PF3_BAR0_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR0_QDMA_ENABLED {1} \
      CPM_PCIE0_PF3_BAR0_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF3_BAR0_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR0_QDMA_SIZE {128} \
      CPM_PCIE0_PF3_BAR0_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF3_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR0_SIZE {128} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_64BIT {1} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_ENABLED {1} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_PREFETCHABLE {1} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_SIZE {16} \
      CPM_PCIE0_PF3_BAR0_SRIOV_QDMA_TYPE {DMA} \
      CPM_PCIE0_PF3_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR0_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR0_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR0_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR0_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR0_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR0_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR0_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR1_64BIT {0} \
      CPM_PCIE0_PF3_BAR1_ENABLED {0} \
      CPM_PCIE0_PF3_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR1_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR1_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR1_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR1_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR1_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR1_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR1_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR1_SIZE {4} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR1_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR1_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR1_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR1_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR1_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR1_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR1_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR1_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR2_64BIT {0} \
      CPM_PCIE0_PF3_BAR2_ENABLED {0} \
      CPM_PCIE0_PF3_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR2_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR2_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR2_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR2_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR2_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR2_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR2_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR2_SIZE {4} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR2_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR2_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR2_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR2_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR2_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR2_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR2_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR2_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR3_64BIT {0} \
      CPM_PCIE0_PF3_BAR3_ENABLED {0} \
      CPM_PCIE0_PF3_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR3_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR3_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR3_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR3_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR3_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR3_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR3_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR3_SIZE {4} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR3_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR3_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR3_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR3_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR3_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR3_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR3_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR3_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR4_64BIT {0} \
      CPM_PCIE0_PF3_BAR4_ENABLED {0} \
      CPM_PCIE0_PF3_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR4_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR4_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR4_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR4_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR4_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR4_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR4_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR4_SIZE {4} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR4_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR4_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR4_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR4_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR4_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR4_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR4_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR4_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR5_64BIT {0} \
      CPM_PCIE0_PF3_BAR5_ENABLED {0} \
      CPM_PCIE0_PF3_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR5_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR5_QDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR5_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR5_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR5_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR5_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR5_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR5_SIZE {4} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR5_SRIOV_QDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF3_BAR5_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_BAR5_XDMA_AXCACHE {0} \
      CPM_PCIE0_PF3_BAR5_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_BAR5_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_BAR5_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_BAR5_XDMA_SIZE {4} \
      CPM_PCIE0_PF3_BAR5_XDMA_TYPE {AXI_Bridge_Master} \
      CPM_PCIE0_PF3_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE0_PF3_BASE_CLASS_VALUE {05} \
      CPM_PCIE0_PF3_CAPABILITY_POINTER {80} \
      CPM_PCIE0_PF3_CFG_DEV_ID {B33F} \
      CPM_PCIE0_PF3_CFG_REV_ID {0} \
      CPM_PCIE0_PF3_CFG_SUBSYS_ID {7} \
      CPM_PCIE0_PF3_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE0_PF3_CLASS_CODE {0x058000} \
      CPM_PCIE0_PF3_DSN_CAP_ENABLE {0} \
      CPM_PCIE0_PF3_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE0_PF3_EXPANSION_ROM_QDMA_ENABLED {0} \
      CPM_PCIE0_PF3_EXPANSION_ROM_QDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_EXPANSION_ROM_QDMA_SIZE {2} \
      CPM_PCIE0_PF3_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE0_PF3_INTERFACE_VALUE {00} \
      CPM_PCIE0_PF3_INTERRUPT_PIN {NONE} \
      CPM_PCIE0_PF3_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_PF3_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_PF3_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_PF3_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_PF3_MSIX_CAP_TABLE_SIZE {007} \
      CPM_PCIE0_PF3_MSIX_ENABLED {1} \
      CPM_PCIE0_PF3_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE0_PF3_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE0_PF3_MSI_ENABLED {1} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_0 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_1 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_2 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_3 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_4 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_SRIOV_QDMA_5 {0x0000000000000000} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_0 {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_1 {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_2 {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_3 {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_4 {0} \
      CPM_PCIE0_PF3_PCIEBAR2AXIBAR_XDMA_5 {0} \
      CPM_PCIE0_PF3_PRI_CAP_ON {0} \
      CPM_PCIE0_PF3_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE0_PF3_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE0_PF3_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE0_PF3_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE0_PF3_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE0_PF3_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE0_PF3_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE0_PF3_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE0_PF3_SRIOV_CAP_VER {1} \
      CPM_PCIE0_PF3_SRIOV_FIRST_VF_OFFSET {13} \
      CPM_PCIE0_PF3_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE0_PF3_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE0_PF3_SRIOV_VF_DEVICE_ID {C33F} \
      CPM_PCIE0_PF3_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE0_PF3_SUB_CLASS_VALUE {80} \
      CPM_PCIE0_PF3_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE0_PF3_VEND_ID {10EE} \
      CPM_PCIE0_PF3_XDMA_64BIT {0} \
      CPM_PCIE0_PF3_XDMA_ENABLED {0} \
      CPM_PCIE0_PF3_XDMA_PREFETCHABLE {0} \
      CPM_PCIE0_PF3_XDMA_SCALE {Kilobytes} \
      CPM_PCIE0_PF3_XDMA_SIZE {128} \
      CPM_PCIE0_PL_LINK_CAP_MAX_LINK_SPEED {Gen3} \
      CPM_PCIE0_PL_LINK_CAP_MAX_LINK_WIDTH {NONE} \
      CPM_PCIE0_PL_UPSTREAM_FACING {1} \
      CPM_PCIE0_PL_USER_SPARE {0} \
      CPM_PCIE0_PM_ASPML0S_TIMEOUT {0} \
      CPM_PCIE0_PM_ASPML1_ENTRY_DELAY {0} \
      CPM_PCIE0_PM_ENABLE_L23_ENTRY {0} \
      CPM_PCIE0_PM_ENABLE_SLOT_POWER_CAPTURE {1} \
      CPM_PCIE0_PM_L1_REENTRY_DELAY {0} \
      CPM_PCIE0_PM_PME_TURNOFF_ACK_DELAY {0} \
      CPM_PCIE0_PORT_TYPE {PCI_Express_Endpoint_device} \
      CPM_PCIE0_QDMA_MULTQ_MAX {2048} \
      CPM_PCIE0_QDMA_PARITY_SETTINGS {None} \
      CPM_PCIE0_REF_CLK_FREQ {100_MHz} \
      CPM_PCIE0_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE0_SRIOV_FIRST_VF_OFFSET {4} \
      CPM_PCIE0_TL2CFG_IF_PARITY_CHK {0} \
      CPM_PCIE0_TL_PF_ENABLE_REG {1} \
      CPM_PCIE0_TL_USER_SPARE {0} \
      CPM_PCIE0_TX_FC_IF {0} \
      CPM_PCIE0_TYPE1_MEMBASE_MEMLIMIT_BRIDGE_ENABLE {Disabled} \
      CPM_PCIE0_TYPE1_MEMBASE_MEMLIMIT_ENABLE {Disabled} \
      CPM_PCIE0_TYPE1_PREFETCHABLE_MEMBASE_BRIDGE_MEMLIMIT {Disabled} \
      CPM_PCIE0_TYPE1_PREFETCHABLE_MEMBASE_MEMLIMIT {Disabled} \
      CPM_PCIE0_USER_CLK2_FREQ {125_MHz} \
      CPM_PCIE0_USER_CLK_FREQ {125_MHz} \
      CPM_PCIE0_USER_EDR_CLK2_FREQ {312.5_MHz} \
      CPM_PCIE0_USER_EDR_CLK_FREQ {312.5_MHz} \
      CPM_PCIE0_VC0_CAPABILITY_POINTER {80} \
      CPM_PCIE0_VC1_BASE_DISABLE {0} \
      CPM_PCIE0_VFG0_ATS_CAP_ON {0} \
      CPM_PCIE0_VFG0_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_VFG0_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_VFG0_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_VFG0_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_VFG0_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE0_VFG0_MSIX_ENABLED {1} \
      CPM_PCIE0_VFG0_PRI_CAP_ON {0} \
      CPM_PCIE0_VFG1_ATS_CAP_ON {0} \
      CPM_PCIE0_VFG1_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_VFG1_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_VFG1_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_VFG1_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_VFG1_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE0_VFG1_MSIX_ENABLED {1} \
      CPM_PCIE0_VFG1_PRI_CAP_ON {0} \
      CPM_PCIE0_VFG2_ATS_CAP_ON {0} \
      CPM_PCIE0_VFG2_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_VFG2_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_VFG2_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_VFG2_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_VFG2_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE0_VFG2_MSIX_ENABLED {1} \
      CPM_PCIE0_VFG2_PRI_CAP_ON {0} \
      CPM_PCIE0_VFG3_ATS_CAP_ON {0} \
      CPM_PCIE0_VFG3_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE0_VFG3_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE0_VFG3_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE0_VFG3_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE0_VFG3_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE0_VFG3_MSIX_ENABLED {1} \
      CPM_PCIE0_VFG3_PRI_CAP_ON {0} \
      CPM_PCIE0_XDMA_AXILITE_SLAVE_IF {0} \
      CPM_PCIE0_XDMA_AXI_ID_WIDTH {2} \
      CPM_PCIE0_XDMA_DSC_BYPASS_RD {0000} \
      CPM_PCIE0_XDMA_DSC_BYPASS_WR {0000} \
      CPM_PCIE0_XDMA_IRQ {1} \
      CPM_PCIE0_XDMA_PARITY_SETTINGS {None} \
      CPM_PCIE0_XDMA_RNUM_CHNL {1} \
      CPM_PCIE0_XDMA_RNUM_RIDS {2} \
      CPM_PCIE0_XDMA_STS_PORTS {0} \
      CPM_PCIE0_XDMA_WNUM_CHNL {1} \
      CPM_PCIE0_XDMA_WNUM_RIDS {2} \
      CPM_PCIE1_AER_CAP_ENABLED {0} \
      CPM_PCIE1_ARI_CAP_ENABLED {1} \
      CPM_PCIE1_ASYNC_MODE {SRNS} \
      CPM_PCIE1_ATS_PRI_CAP_ON {0} \
      CPM_PCIE1_AXIBAR_NUM {1} \
      CPM_PCIE1_AXISTEN_IF_CC_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE1_AXISTEN_IF_COMPL_TIMEOUT_REG0 {BEBC20} \
      CPM_PCIE1_AXISTEN_IF_COMPL_TIMEOUT_REG1 {2FAF080} \
      CPM_PCIE1_AXISTEN_IF_CQ_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_256_TAGS {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_CLIENT_TAG {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_INTERNAL_MSIX_TABLE {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_MESSAGE_RID_CHECK {1} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_MSG_ROUTE {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_RX_MSG_INTFC {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_RX_TAG_SCALING {0} \
      CPM_PCIE1_AXISTEN_IF_ENABLE_TX_TAG_SCALING {0} \
      CPM_PCIE1_AXISTEN_IF_EXTEND_CPL_TIMEOUT {16ms_to_1s} \
      CPM_PCIE1_AXISTEN_IF_EXT_512 {0} \
      CPM_PCIE1_AXISTEN_IF_EXT_512_CC_STRADDLE {0} \
      CPM_PCIE1_AXISTEN_IF_EXT_512_CQ_STRADDLE {0} \
      CPM_PCIE1_AXISTEN_IF_EXT_512_RC_4TLP_STRADDLE {1} \
      CPM_PCIE1_AXISTEN_IF_EXT_512_RC_STRADDLE {1} \
      CPM_PCIE1_AXISTEN_IF_EXT_512_RQ_STRADDLE {1} \
      CPM_PCIE1_AXISTEN_IF_RC_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE1_AXISTEN_IF_RC_STRADDLE {0} \
      CPM_PCIE1_AXISTEN_IF_RQ_ALIGNMENT_MODE {DWORD_Aligned} \
      CPM_PCIE1_AXISTEN_IF_RX_PARITY_EN {1} \
      CPM_PCIE1_AXISTEN_IF_SIM_SHORT_CPL_TIMEOUT {0} \
      CPM_PCIE1_AXISTEN_IF_TX_PARITY_EN {0} \
      CPM_PCIE1_AXISTEN_IF_WIDTH {64} \
      CPM_PCIE1_AXISTEN_MSIX_VECTORS_PER_FUNCTION {8} \
      CPM_PCIE1_AXISTEN_USER_SPARE {0} \
      CPM_PCIE1_CCIX_EN {0} \
      CPM_PCIE1_CCIX_OPT_TLP_GEN_AND_RECEPT_EN_CONTROL_INTERNAL {0} \
      CPM_PCIE1_CCIX_VENDOR_ID {0} \
      CPM_PCIE1_CFG_CTL_IF {0} \
      CPM_PCIE1_CFG_EXT_IF {0} \
      CPM_PCIE1_CFG_FC_IF {0} \
      CPM_PCIE1_CFG_MGMT_IF {0} \
      CPM_PCIE1_CFG_SPEC_4_0 {0} \
      CPM_PCIE1_CFG_STS_IF {0} \
      CPM_PCIE1_CFG_VEND_ID {10EE} \
      CPM_PCIE1_CONTROLLER_ENABLE {0} \
      CPM_PCIE1_COPY_PF0_ENABLED {0} \
      CPM_PCIE1_COPY_SRIOV_PF0_ENABLED {1} \
      CPM_PCIE1_CORE_CLK_FREQ {500} \
      CPM_PCIE1_CORE_EDR_CLK_FREQ {625} \
      CPM_PCIE1_DSC_BYPASS_RD {0} \
      CPM_PCIE1_DSC_BYPASS_WR {0} \
      CPM_PCIE1_EDR_IF {0} \
      CPM_PCIE1_EDR_LINK_SPEED {None} \
      CPM_PCIE1_EN_PARITY {0} \
      CPM_PCIE1_EXT_PCIE_CFG_SPACE_ENABLED {None} \
      CPM_PCIE1_FUNCTIONAL_MODE {None} \
      CPM_PCIE1_LANE_REVERSAL_EN {0} \
      CPM_PCIE1_LEGACY_EXT_PCIE_CFG_SPACE_ENABLED {0} \
      CPM_PCIE1_LINK_DEBUG_AXIST_EN {0} \
      CPM_PCIE1_LINK_DEBUG_EN {0} \
      CPM_PCIE1_LINK_SPEED1_FOR_POWER {GEN1} \
      CPM_PCIE1_LINK_WIDTH1_FOR_POWER {0} \
      CPM_PCIE1_MAX_LINK_SPEED {2.5_GT/s} \
      CPM_PCIE1_MCAP_ENABLE {0} \
      CPM_PCIE1_MESG_RSVD_IF {0} \
      CPM_PCIE1_MESG_TRANSMIT_IF {0} \
      CPM_PCIE1_MODE1_FOR_POWER {NONE} \
      CPM_PCIE1_MODES {None} \
      CPM_PCIE1_MODE_SELECTION {Basic} \
      CPM_PCIE1_MSIX_RP_ENABLED {1} \
      CPM_PCIE1_MSI_X_OPTIONS {None} \
      CPM_PCIE1_PASID_IF {0} \
      CPM_PCIE1_PF0_AER_CAP_ECRC_GEN_AND_CHECK_CAPABLE {0} \
      CPM_PCIE1_PF0_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE1_PF0_ARI_CAP_VER {1} \
      CPM_PCIE1_PF0_ATS_CAP_ON {0} \
      CPM_PCIE1_PF0_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE1_PF0_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE1_PF0_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE1_PF0_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE1_PF0_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE1_PF0_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE1_PF0_BAR0_64BIT {0} \
      CPM_PCIE1_PF0_BAR0_ENABLED {1} \
      CPM_PCIE1_PF0_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR0_SIZE {128} \
      CPM_PCIE1_PF0_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF0_BAR1_64BIT {0} \
      CPM_PCIE1_PF0_BAR1_ENABLED {0} \
      CPM_PCIE1_PF0_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR1_SIZE {4} \
      CPM_PCIE1_PF0_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF0_BAR2_64BIT {0} \
      CPM_PCIE1_PF0_BAR2_ENABLED {0} \
      CPM_PCIE1_PF0_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR2_SIZE {4} \
      CPM_PCIE1_PF0_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF0_BAR3_64BIT {0} \
      CPM_PCIE1_PF0_BAR3_ENABLED {0} \
      CPM_PCIE1_PF0_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR3_SIZE {4} \
      CPM_PCIE1_PF0_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF0_BAR4_64BIT {0} \
      CPM_PCIE1_PF0_BAR4_ENABLED {0} \
      CPM_PCIE1_PF0_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR4_SIZE {4} \
      CPM_PCIE1_PF0_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF0_BAR5_64BIT {0} \
      CPM_PCIE1_PF0_BAR5_ENABLED {0} \
      CPM_PCIE1_PF0_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_BAR5_SIZE {4} \
      CPM_PCIE1_PF0_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF0_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE1_PF0_BASE_CLASS_VALUE {05} \
      CPM_PCIE1_PF0_CAPABILITY_POINTER {80} \
      CPM_PCIE1_PF0_CFG_DEV_ID {B034} \
      CPM_PCIE1_PF0_CFG_REV_ID {0} \
      CPM_PCIE1_PF0_CFG_SUBSYS_ID {7} \
      CPM_PCIE1_PF0_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE1_PF0_CLASS_CODE {58000} \
      CPM_PCIE1_PF0_DEV_CAP_10B_TAG_EN {0} \
      CPM_PCIE1_PF0_DEV_CAP_ENDPOINT_L0S_LATENCY {less_than_64ns} \
      CPM_PCIE1_PF0_DEV_CAP_ENDPOINT_L1S_LATENCY {less_than_1us} \
      CPM_PCIE1_PF0_DEV_CAP_EXT_TAG_EN {0} \
      CPM_PCIE1_PF0_DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE {0} \
      CPM_PCIE1_PF0_DEV_CAP_MAX_PAYLOAD {1024_bytes} \
      CPM_PCIE1_PF0_DLL_FEATURE_CAP_ID {0} \
      CPM_PCIE1_PF0_DLL_FEATURE_CAP_ON {0} \
      CPM_PCIE1_PF0_DLL_FEATURE_CAP_VER {1} \
      CPM_PCIE1_PF0_DSN_CAP_ENABLE {0} \
      CPM_PCIE1_PF0_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE1_PF0_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE1_PF0_INTERFACE_VALUE {0} \
      CPM_PCIE1_PF0_INTERRUPT_PIN {NONE} \
      CPM_PCIE1_PF0_LINK_CAP_ASPM_SUPPORT {No_ASPM} \
      CPM_PCIE1_PF0_LINK_STATUS_SLOT_CLOCK_CONFIG {1} \
      CPM_PCIE1_PF0_MARGINING_CAP_ID {0} \
      CPM_PCIE1_PF0_MARGINING_CAP_ON {0} \
      CPM_PCIE1_PF0_MARGINING_CAP_VER {1} \
      CPM_PCIE1_PF0_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_PF0_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_PF0_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_PF0_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_PF0_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_PF0_MSIX_ENABLED {1} \
      CPM_PCIE1_PF0_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE1_PF0_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE1_PF0_MSI_ENABLED {1} \
      CPM_PCIE1_PF0_PASID_CAP_MAX_PASID_WIDTH {1} \
      CPM_PCIE1_PF0_PASID_CAP_ON {0} \
      CPM_PCIE1_PF0_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE1_PF0_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE1_PF0_PL16_CAP_ID {0} \
      CPM_PCIE1_PF0_PL16_CAP_ON {0} \
      CPM_PCIE1_PF0_PL16_CAP_VER {1} \
      CPM_PCIE1_PF0_PM_CAP_ID {0} \
      CPM_PCIE1_PF0_PM_CAP_PMESUPPORT_D0 {1} \
      CPM_PCIE1_PF0_PM_CAP_PMESUPPORT_D1 {1} \
      CPM_PCIE1_PF0_PM_CAP_PMESUPPORT_D3COLD {1} \
      CPM_PCIE1_PF0_PM_CAP_PMESUPPORT_D3HOT {1} \
      CPM_PCIE1_PF0_PM_CAP_SUPP_D1_STATE {1} \
      CPM_PCIE1_PF0_PM_CAP_VER_ID {3} \
      CPM_PCIE1_PF0_PM_CSR_NOSOFTRESET {1} \
      CPM_PCIE1_PF0_PRI_CAP_ON {0} \
      CPM_PCIE1_PF0_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE1_PF0_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE1_PF0_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE1_PF0_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF0_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF0_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE1_PF0_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF0_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE1_PF0_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE1_PF0_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE1_PF0_SRIOV_CAP_VER {1} \
      CPM_PCIE1_PF0_SRIOV_FIRST_VF_OFFSET {4} \
      CPM_PCIE1_PF0_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE1_PF0_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE1_PF0_SRIOV_VF_DEVICE_ID {C034} \
      CPM_PCIE1_PF0_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE1_PF0_SUB_CLASS_VALUE {80} \
      CPM_PCIE1_PF0_TPHR_CAP_DEV_SPECIFIC_MODE {1} \
      CPM_PCIE1_PF0_TPHR_CAP_ENABLE {0} \
      CPM_PCIE1_PF0_TPHR_CAP_INT_VEC_MODE {1} \
      CPM_PCIE1_PF0_TPHR_CAP_ST_TABLE_LOC {ST_Table_not_present} \
      CPM_PCIE1_PF0_TPHR_CAP_ST_TABLE_SIZE {16} \
      CPM_PCIE1_PF0_TPHR_CAP_VER {1} \
      CPM_PCIE1_PF0_TPHR_ENABLE {0} \
      CPM_PCIE1_PF0_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE1_PF0_VC_ARB_CAPABILITY {0} \
      CPM_PCIE1_PF0_VC_ARB_TBL_OFFSET {0} \
      CPM_PCIE1_PF0_VC_CAP_ENABLED {0} \
      CPM_PCIE1_PF0_VC_CAP_VER {1} \
      CPM_PCIE1_PF0_VC_EXTENDED_COUNT {0} \
      CPM_PCIE1_PF0_VC_LOW_PRIORITY_EXTENDED_COUNT {0} \
      CPM_PCIE1_PF1_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE1_PF1_ATS_CAP_ON {0} \
      CPM_PCIE1_PF1_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE1_PF1_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE1_PF1_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE1_PF1_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE1_PF1_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE1_PF1_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE1_PF1_BAR0_64BIT {0} \
      CPM_PCIE1_PF1_BAR0_ENABLED {1} \
      CPM_PCIE1_PF1_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR0_SIZE {128} \
      CPM_PCIE1_PF1_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF1_BAR1_64BIT {0} \
      CPM_PCIE1_PF1_BAR1_ENABLED {0} \
      CPM_PCIE1_PF1_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR1_SIZE {4} \
      CPM_PCIE1_PF1_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF1_BAR2_64BIT {0} \
      CPM_PCIE1_PF1_BAR2_ENABLED {0} \
      CPM_PCIE1_PF1_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR2_SIZE {4} \
      CPM_PCIE1_PF1_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF1_BAR3_64BIT {0} \
      CPM_PCIE1_PF1_BAR3_ENABLED {0} \
      CPM_PCIE1_PF1_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR3_SIZE {4} \
      CPM_PCIE1_PF1_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF1_BAR4_64BIT {0} \
      CPM_PCIE1_PF1_BAR4_ENABLED {0} \
      CPM_PCIE1_PF1_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR4_SIZE {4} \
      CPM_PCIE1_PF1_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF1_BAR5_64BIT {0} \
      CPM_PCIE1_PF1_BAR5_ENABLED {0} \
      CPM_PCIE1_PF1_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_BAR5_SIZE {4} \
      CPM_PCIE1_PF1_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF1_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE1_PF1_BASE_CLASS_VALUE {05} \
      CPM_PCIE1_PF1_CAPABILITY_POINTER {80} \
      CPM_PCIE1_PF1_CFG_DEV_ID {B134} \
      CPM_PCIE1_PF1_CFG_REV_ID {0} \
      CPM_PCIE1_PF1_CFG_SUBSYS_ID {7} \
      CPM_PCIE1_PF1_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE1_PF1_CLASS_CODE {0x058000} \
      CPM_PCIE1_PF1_DSN_CAP_ENABLE {0} \
      CPM_PCIE1_PF1_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE1_PF1_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE1_PF1_INTERFACE_VALUE {00} \
      CPM_PCIE1_PF1_INTERRUPT_PIN {NONE} \
      CPM_PCIE1_PF1_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_PF1_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_PF1_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_PF1_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_PF1_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_PF1_MSIX_ENABLED {1} \
      CPM_PCIE1_PF1_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE1_PF1_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE1_PF1_MSI_ENABLED {1} \
      CPM_PCIE1_PF1_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE1_PF1_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE1_PF1_PRI_CAP_ON {0} \
      CPM_PCIE1_PF1_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE1_PF1_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE1_PF1_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE1_PF1_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF1_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF1_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE1_PF1_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF1_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE1_PF1_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE1_PF1_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE1_PF1_SRIOV_CAP_VER {1} \
      CPM_PCIE1_PF1_SRIOV_FIRST_VF_OFFSET {7} \
      CPM_PCIE1_PF1_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE1_PF1_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE1_PF1_SRIOV_VF_DEVICE_ID {C134} \
      CPM_PCIE1_PF1_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE1_PF1_SUB_CLASS_VALUE {80} \
      CPM_PCIE1_PF1_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE1_PF1_VEND_ID {10EE} \
      CPM_PCIE1_PF2_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE1_PF2_ATS_CAP_ON {0} \
      CPM_PCIE1_PF2_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE1_PF2_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE1_PF2_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE1_PF2_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE1_PF2_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE1_PF2_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE1_PF2_BAR0_64BIT {0} \
      CPM_PCIE1_PF2_BAR0_ENABLED {1} \
      CPM_PCIE1_PF2_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR0_SIZE {128} \
      CPM_PCIE1_PF2_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF2_BAR1_64BIT {0} \
      CPM_PCIE1_PF2_BAR1_ENABLED {0} \
      CPM_PCIE1_PF2_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR1_SIZE {4} \
      CPM_PCIE1_PF2_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF2_BAR2_64BIT {0} \
      CPM_PCIE1_PF2_BAR2_ENABLED {0} \
      CPM_PCIE1_PF2_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR2_SIZE {4} \
      CPM_PCIE1_PF2_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF2_BAR3_64BIT {0} \
      CPM_PCIE1_PF2_BAR3_ENABLED {0} \
      CPM_PCIE1_PF2_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR3_SIZE {4} \
      CPM_PCIE1_PF2_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF2_BAR4_64BIT {0} \
      CPM_PCIE1_PF2_BAR4_ENABLED {0} \
      CPM_PCIE1_PF2_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR4_SIZE {4} \
      CPM_PCIE1_PF2_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF2_BAR5_64BIT {0} \
      CPM_PCIE1_PF2_BAR5_ENABLED {0} \
      CPM_PCIE1_PF2_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_BAR5_SIZE {4} \
      CPM_PCIE1_PF2_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF2_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE1_PF2_BASE_CLASS_VALUE {05} \
      CPM_PCIE1_PF2_CAPABILITY_POINTER {80} \
      CPM_PCIE1_PF2_CFG_DEV_ID {B234} \
      CPM_PCIE1_PF2_CFG_REV_ID {0} \
      CPM_PCIE1_PF2_CFG_SUBSYS_ID {7} \
      CPM_PCIE1_PF2_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE1_PF2_CLASS_CODE {0x058000} \
      CPM_PCIE1_PF2_DSN_CAP_ENABLE {0} \
      CPM_PCIE1_PF2_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE1_PF2_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE1_PF2_INTERFACE_VALUE {00} \
      CPM_PCIE1_PF2_INTERRUPT_PIN {NONE} \
      CPM_PCIE1_PF2_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_PF2_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_PF2_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_PF2_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_PF2_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_PF2_MSIX_ENABLED {1} \
      CPM_PCIE1_PF2_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE1_PF2_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE1_PF2_MSI_ENABLED {1} \
      CPM_PCIE1_PF2_PASID_CAP_MAX_PASID_WIDTH {1} \
      CPM_PCIE1_PF2_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE1_PF2_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE1_PF2_PRI_CAP_ON {0} \
      CPM_PCIE1_PF2_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE1_PF2_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE1_PF2_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE1_PF2_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF2_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF2_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE1_PF2_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF2_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE1_PF2_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE1_PF2_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE1_PF2_SRIOV_CAP_VER {1} \
      CPM_PCIE1_PF2_SRIOV_FIRST_VF_OFFSET {10} \
      CPM_PCIE1_PF2_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE1_PF2_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE1_PF2_SRIOV_VF_DEVICE_ID {C234} \
      CPM_PCIE1_PF2_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE1_PF2_SUB_CLASS_VALUE {80} \
      CPM_PCIE1_PF2_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE1_PF2_VEND_ID {10EE} \
      CPM_PCIE1_PF3_ARI_CAP_NEXT_FUNC {0} \
      CPM_PCIE1_PF3_ATS_CAP_ON {0} \
      CPM_PCIE1_PF3_AXILITE_MASTER_64BIT {0} \
      CPM_PCIE1_PF3_AXILITE_MASTER_ENABLED {0} \
      CPM_PCIE1_PF3_AXILITE_MASTER_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_AXILITE_MASTER_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_AXILITE_MASTER_SIZE {128} \
      CPM_PCIE1_PF3_AXIST_BYPASS_64BIT {0} \
      CPM_PCIE1_PF3_AXIST_BYPASS_ENABLED {0} \
      CPM_PCIE1_PF3_AXIST_BYPASS_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_AXIST_BYPASS_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_AXIST_BYPASS_SIZE {128} \
      CPM_PCIE1_PF3_BAR0_64BIT {0} \
      CPM_PCIE1_PF3_BAR0_ENABLED {1} \
      CPM_PCIE1_PF3_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR0_SIZE {128} \
      CPM_PCIE1_PF3_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF3_BAR1_64BIT {0} \
      CPM_PCIE1_PF3_BAR1_ENABLED {0} \
      CPM_PCIE1_PF3_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR1_SIZE {4} \
      CPM_PCIE1_PF3_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF3_BAR2_64BIT {0} \
      CPM_PCIE1_PF3_BAR2_ENABLED {0} \
      CPM_PCIE1_PF3_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR2_SIZE {4} \
      CPM_PCIE1_PF3_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF3_BAR3_64BIT {0} \
      CPM_PCIE1_PF3_BAR3_ENABLED {0} \
      CPM_PCIE1_PF3_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR3_SIZE {4} \
      CPM_PCIE1_PF3_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF3_BAR4_64BIT {0} \
      CPM_PCIE1_PF3_BAR4_ENABLED {0} \
      CPM_PCIE1_PF3_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR4_SIZE {4} \
      CPM_PCIE1_PF3_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF3_BAR5_64BIT {0} \
      CPM_PCIE1_PF3_BAR5_ENABLED {0} \
      CPM_PCIE1_PF3_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_BAR5_SIZE {4} \
      CPM_PCIE1_PF3_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF3_BASE_CLASS_MENU {Memory_controller} \
      CPM_PCIE1_PF3_BASE_CLASS_VALUE {05} \
      CPM_PCIE1_PF3_CAPABILITY_POINTER {80} \
      CPM_PCIE1_PF3_CFG_DEV_ID {B334} \
      CPM_PCIE1_PF3_CFG_REV_ID {0} \
      CPM_PCIE1_PF3_CFG_SUBSYS_ID {7} \
      CPM_PCIE1_PF3_CFG_SUBSYS_VEND_ID {10EE} \
      CPM_PCIE1_PF3_CLASS_CODE {0x058000} \
      CPM_PCIE1_PF3_DSN_CAP_ENABLE {0} \
      CPM_PCIE1_PF3_EXPANSION_ROM_ENABLED {0} \
      CPM_PCIE1_PF3_EXPANSION_ROM_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_EXPANSION_ROM_SIZE {2} \
      CPM_PCIE1_PF3_INTERFACE_VALUE {00} \
      CPM_PCIE1_PF3_INTERRUPT_PIN {NONE} \
      CPM_PCIE1_PF3_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_PF3_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_PF3_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_PF3_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_PF3_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_PF3_MSIX_ENABLED {1} \
      CPM_PCIE1_PF3_MSI_CAP_MULTIMSGCAP {1_vector} \
      CPM_PCIE1_PF3_MSI_CAP_PERVECMASKCAP {0} \
      CPM_PCIE1_PF3_MSI_ENABLED {1} \
      CPM_PCIE1_PF3_PCIEBAR2AXIBAR_AXIL_MASTER {0} \
      CPM_PCIE1_PF3_PCIEBAR2AXIBAR_AXIST_BYPASS {0} \
      CPM_PCIE1_PF3_PRI_CAP_ON {0} \
      CPM_PCIE1_PF3_SRIOV_ARI_CAPBL_HIER_PRESERVED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR0_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR0_ENABLED {1} \
      CPM_PCIE1_PF3_SRIOV_BAR0_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR0_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR0_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR0_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_BAR1_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR1_ENABLED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR1_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR1_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR1_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR1_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_BAR2_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR2_ENABLED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR2_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR2_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR2_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR2_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_BAR3_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR3_ENABLED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR3_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR3_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR3_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR3_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_BAR4_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR4_ENABLED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR4_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR4_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR4_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR4_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_BAR5_64BIT {0} \
      CPM_PCIE1_PF3_SRIOV_BAR5_ENABLED {0} \
      CPM_PCIE1_PF3_SRIOV_BAR5_PREFETCHABLE {0} \
      CPM_PCIE1_PF3_SRIOV_BAR5_SCALE {Kilobytes} \
      CPM_PCIE1_PF3_SRIOV_BAR5_SIZE {4} \
      CPM_PCIE1_PF3_SRIOV_BAR5_TYPE {Memory} \
      CPM_PCIE1_PF3_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE1_PF3_SRIOV_CAP_INITIAL_VF {4} \
      CPM_PCIE1_PF3_SRIOV_CAP_TOTAL_VF {0} \
      CPM_PCIE1_PF3_SRIOV_CAP_VER {1} \
      CPM_PCIE1_PF3_SRIOV_FIRST_VF_OFFSET {13} \
      CPM_PCIE1_PF3_SRIOV_FUNC_DEP_LINK {0} \
      CPM_PCIE1_PF3_SRIOV_SUPPORTED_PAGE_SIZE {553} \
      CPM_PCIE1_PF3_SRIOV_VF_DEVICE_ID {C334} \
      CPM_PCIE1_PF3_SUB_CLASS_INTF_MENU {Other_memory_controller} \
      CPM_PCIE1_PF3_SUB_CLASS_VALUE {80} \
      CPM_PCIE1_PF3_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
      CPM_PCIE1_PF3_VEND_ID {10EE} \
      CPM_PCIE1_PL_LINK_CAP_MAX_LINK_SPEED {Gen3} \
      CPM_PCIE1_PL_LINK_CAP_MAX_LINK_WIDTH {NONE} \
      CPM_PCIE1_PL_UPSTREAM_FACING {1} \
      CPM_PCIE1_PL_USER_SPARE {0} \
      CPM_PCIE1_PM_ASPML0S_TIMEOUT {0} \
      CPM_PCIE1_PM_ASPML1_ENTRY_DELAY {0} \
      CPM_PCIE1_PM_ENABLE_L23_ENTRY {0} \
      CPM_PCIE1_PM_ENABLE_SLOT_POWER_CAPTURE {1} \
      CPM_PCIE1_PM_L1_REENTRY_DELAY {0} \
      CPM_PCIE1_PM_PME_TURNOFF_ACK_DELAY {0} \
      CPM_PCIE1_PORT_TYPE {PCI_Express_Endpoint_device} \
      CPM_PCIE1_REF_CLK_FREQ {100_MHz} \
      CPM_PCIE1_SRIOV_CAP_ENABLE {0} \
      CPM_PCIE1_SRIOV_FIRST_VF_OFFSET {4} \
      CPM_PCIE1_TL2CFG_IF_PARITY_CHK {0} \
      CPM_PCIE1_TL_PF_ENABLE_REG {1} \
      CPM_PCIE1_TL_USER_SPARE {0} \
      CPM_PCIE1_TX_FC_IF {0} \
      CPM_PCIE1_TYPE1_MEMBASE_MEMLIMIT_ENABLE {Disabled} \
      CPM_PCIE1_TYPE1_PREFETCHABLE_MEMBASE_MEMLIMIT {Disabled} \
      CPM_PCIE1_USER_CLK2_FREQ {125_MHz} \
      CPM_PCIE1_USER_CLK_FREQ {125_MHz} \
      CPM_PCIE1_USER_EDR_CLK2_FREQ {312.5_MHz} \
      CPM_PCIE1_USER_EDR_CLK_FREQ {312.5_MHz} \
      CPM_PCIE1_VC0_CAPABILITY_POINTER {80} \
      CPM_PCIE1_VC1_BASE_DISABLE {0} \
      CPM_PCIE1_VFG0_ATS_CAP_ON {0} \
      CPM_PCIE1_VFG0_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_VFG0_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_VFG0_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_VFG0_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_VFG0_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_VFG0_MSIX_ENABLED {1} \
      CPM_PCIE1_VFG0_PRI_CAP_ON {0} \
      CPM_PCIE1_VFG1_ATS_CAP_ON {0} \
      CPM_PCIE1_VFG1_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_VFG1_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_VFG1_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_VFG1_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_VFG1_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_VFG1_MSIX_ENABLED {1} \
      CPM_PCIE1_VFG1_PRI_CAP_ON {0} \
      CPM_PCIE1_VFG2_ATS_CAP_ON {0} \
      CPM_PCIE1_VFG2_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_VFG2_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_VFG2_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_VFG2_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_VFG2_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_VFG2_MSIX_ENABLED {1} \
      CPM_PCIE1_VFG2_PRI_CAP_ON {0} \
      CPM_PCIE1_VFG3_ATS_CAP_ON {0} \
      CPM_PCIE1_VFG3_MSIX_CAP_PBA_BIR {BAR_0} \
      CPM_PCIE1_VFG3_MSIX_CAP_PBA_OFFSET {50} \
      CPM_PCIE1_VFG3_MSIX_CAP_TABLE_BIR {BAR_0} \
      CPM_PCIE1_VFG3_MSIX_CAP_TABLE_OFFSET {40} \
      CPM_PCIE1_VFG3_MSIX_CAP_TABLE_SIZE {001} \
      CPM_PCIE1_VFG3_MSIX_ENABLED {1} \
      CPM_PCIE1_VFG3_PRI_CAP_ON {0} \
      CPM_PCIE_CHANNELS_FOR_POWER {0} \
      CPM_PERIPHERAL_EN {0} \
      CPM_PERIPHERAL_TEST_EN {0} \
      CPM_REQ_AGENTS_0_ENABLE {0} \
      CPM_REQ_AGENTS_0_L2_ENABLE {0} \
      CPM_REQ_AGENTS_1_ENABLE {0} \
      CPM_SELECT_GTOUTCLK {TXOUTCLK} \
      CPM_TYPE1_MEMBASE_MEMLIMIT_ENABLE {Disabled} \
      CPM_TYPE1_PREFETCHABLE_MEMBASE_MEMLIMIT {Disabled} \
      CPM_USE_MODES {None} \
      CPM_XDMA_2PF_INTERRUPT_ENABLE {0} \
      CPM_XDMA_TL_PF_VISIBLE {1} \
      CPM_XPIPE_0_CLKDLY_CFG {0} \
      CPM_XPIPE_0_CLK_CFG {0} \
      CPM_XPIPE_0_INSTANTIATED {0} \
      CPM_XPIPE_0_LINK0_CFG {DISABLE} \
      CPM_XPIPE_0_LINK1_CFG {DISABLE} \
      CPM_XPIPE_0_LOC {QUAD0} \
      CPM_XPIPE_0_MODE {0} \
      CPM_XPIPE_0_REG_CFG {0} \
      CPM_XPIPE_0_RSVD {0} \
      CPM_XPIPE_1_CLKDLY_CFG {0} \
      CPM_XPIPE_1_CLK_CFG {0} \
      CPM_XPIPE_1_INSTANTIATED {0} \
      CPM_XPIPE_1_LINK0_CFG {DISABLE} \
      CPM_XPIPE_1_LINK1_CFG {DISABLE} \
      CPM_XPIPE_1_LOC {QUAD1} \
      CPM_XPIPE_1_MODE {0} \
      CPM_XPIPE_1_REG_CFG {0} \
      CPM_XPIPE_1_RSVD {0} \
      CPM_XPIPE_2_CLKDLY_CFG {0} \
      CPM_XPIPE_2_CLK_CFG {0} \
      CPM_XPIPE_2_INSTANTIATED {0} \
      CPM_XPIPE_2_LINK0_CFG {DISABLE} \
      CPM_XPIPE_2_LINK1_CFG {DISABLE} \
      CPM_XPIPE_2_LOC {QUAD2} \
      CPM_XPIPE_2_MODE {0} \
      CPM_XPIPE_2_REG_CFG {0} \
      CPM_XPIPE_2_RSVD {0} \
      CPM_XPIPE_3_CLKDLY_CFG {0} \
      CPM_XPIPE_3_CLK_CFG {0} \
      CPM_XPIPE_3_INSTANTIATED {0} \
      CPM_XPIPE_3_LINK0_CFG {DISABLE} \
      CPM_XPIPE_3_LINK1_CFG {DISABLE} \
      CPM_XPIPE_3_LOC {QUAD3} \
      CPM_XPIPE_3_MODE {0} \
      CPM_XPIPE_3_REG_CFG {0} \
      CPM_XPIPE_3_RSVD {0} \
      GT_REFCLK_MHZ {156.25} \
      PS_HSDP0_REFCLK {0} \
      PS_HSDP1_REFCLK {0} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_USE_NOC_PS_PCI_0 {0} \
      PS_USE_PS_NOC_PCI_0 {0} \
      PS_USE_PS_NOC_PCI_1 {0} \
    } \
    CONFIG.PS_BOARD_INTERFACE {Custom} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      AURORA_LINE_RATE_GPBS {10.0} \
      BOOT_MODE {Custom} \
      BOOT_SECONDARY_PCIE_ENABLE {0} \
      CLOCK_MODE {Custom} \
      COHERENCY_MODE {Custom} \
      CPM_PCIE0_TANDEM {None} \
      DDR_MEMORY_MODE {Custom} \
      DEBUG_MODE {Custom} \
      DESIGN_MODE {2} \
      DEVICE_INTEGRITY_MODE {Custom} \
      DIS_AUTO_POL_CHECK {0} \
      GT_REFCLK_MHZ {156.25} \
      INIT_CLK_MHZ {125} \
      INV_POLARITY {0} \
      IO_CONFIG_MODE {Custom} \
      PCIE_APERTURES_DUAL_ENABLE {0} \
      PCIE_APERTURES_SINGLE_ENABLE {0} \
      PERFORMANCE_MODE {Custom} \
      PL_SEM_GPIO_ENABLE {0} \
      PMC_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_BANK_0_IO_STANDARD {LVCMOS1.8} \
      PMC_BANK_1_IO_STANDARD {LVCMOS1.8} \
      PMC_CIPS_MODE {ADVANCE} \
      PMC_CORE_SUBSYSTEM_LOAD {10} \
      PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {299.999725} \
      PMC_CRP_CFU_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_CFU_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_CFU_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_DFT_OSC_REF_CTRL_ACT_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_DFT_OSC_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_EFUSE_REF_CTRL_ACT_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {32.432404} \
      PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {37} \
      PMC_CRP_HSM0_REF_CTRL_FREQMHZ {33.333} \
      PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {124.999878} \
      PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {8} \
      PMC_CRP_HSM1_REF_CTRL_FREQMHZ {133.333} \
      PMC_CRP_HSM1_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_I2C_REF_CTRL_ACT_FREQMHZ {99.999908} \
      PMC_CRP_I2C_REF_CTRL_DIVISOR0 {12} \
      PMC_CRP_I2C_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_I2C_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {149.999863} \
      PMC_CRP_LSBUS_REF_CTRL_DIVISOR0 {8} \
      PMC_CRP_LSBUS_REF_CTRL_FREQMHZ {150} \
      PMC_CRP_LSBUS_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {999.999023} \
      PMC_CRP_NOC_REF_CTRL_FREQMHZ {1000} \
      PMC_CRP_NOC_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_NPI_REF_CTRL_ACT_FREQMHZ {299.999725} \
      PMC_CRP_NPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_NPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_NPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NPLL_CTRL_CLKOUTDIV {4} \
      PMC_CRP_NPLL_CTRL_FBDIV {120} \
      PMC_CRP_NPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_NPLL_TO_XPD_CTRL_DIVISOR0 {4} \
      PMC_CRP_OSPI_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_OSPI_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {99.999908} \
      PMC_CRP_PL0_REF_CTRL_DIVISOR0 {12} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_PL0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_PL1_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL1_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL1_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL1_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL2_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL2_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL2_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL2_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL3_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL3_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL3_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL3_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL5_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_PPLL_CTRL_CLKOUTDIV {2} \
      PMC_CRP_PPLL_CTRL_FBDIV {72} \
      PMC_CRP_PPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_PPLL_TO_XPD_CTRL_DIVISOR0 {1} \
      PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {299.999725} \
      PMC_CRP_QSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_QSPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_QSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO0_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_SDIO0_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.999817} \
      PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_SDIO1_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO1_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1199.998901} \
      PMC_CRP_SD_DLL_REF_CTRL_DIVISOR0 {1} \
      PMC_CRP_SD_DLL_REF_CTRL_FREQMHZ {1200} \
      PMC_CRP_SD_DLL_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_ACT_FREQMHZ {1.000000} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_DIVISOR0 {100} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_FREQMHZ {1} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_SYSMON_REF_CTRL_ACT_FREQMHZ {299.999725} \
      PMC_CRP_SYSMON_REF_CTRL_FREQMHZ {299.999725} \
      PMC_CRP_SYSMON_REF_CTRL_SRCSEL {NPI_REF_CLK} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_USB_SUSPEND_CTRL_ACT_FREQMHZ {0.200000} \
      PMC_CRP_USB_SUSPEND_CTRL_DIVISOR0 {500} \
      PMC_CRP_USB_SUSPEND_CTRL_FREQMHZ {0.2} \
      PMC_CRP_USB_SUSPEND_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_EXTERNAL_TAMPER {{ENABLE 0} {IO {PMC_MIO 12}}} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PMC_GPIO_EMIO_WIDTH {64} \
      PMC_GPIO_EMIO_WIDTH_HDL {64} \
      PMC_GPI_ENABLE {0} \
      PMC_GPI_WIDTH {32} \
      PMC_GPO_ENABLE {0} \
      PMC_GPO_WIDTH {32} \
      PMC_HSM0_CLK_ENABLE {1} \
      PMC_HSM1_CLK_ENABLE {1} \
      PMC_I2CPMC_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PMC_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO1 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO10 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO11 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO14 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO15 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO16 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO17 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO19 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO2 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO20 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO21 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO22 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO25 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO26 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO27 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO28 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO29 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO3 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO30 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO31 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO32 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO33 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO34 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO35 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO36 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO38 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO39 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO4 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO40 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO41 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO42 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO43 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO44 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO45 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO46 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO47 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO48 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO49 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO50 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO51 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO6 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO7 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO8 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO9 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO_EN_FOR_PL_PCIE {0} \
      PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB\
2.0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#GPIO 1###CANFD1#CANFD1#UART 0#UART 0#LPD_I2C1#LPD_I2C1#pmc_i2c#pmc_i2c####SD1/eMMC1#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem0#Gem0}\
\
      PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#gpio_1_pin[37]###phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda####buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio}\
\
      PMC_NOC_PMC_ADDR_WIDTH {64} \
      PMC_NOC_PMC_DATA_WIDTH {128} \
      PMC_OSPI_COHERENCY {0} \
      PMC_OSPI_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_OSPI_ROUTE_THROUGH_FPD {0} \
      PMC_OT_CHECK {{DELAY 0} {ENABLE 0}} \
      PMC_PL_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_PMC_NOC_ADDR_WIDTH {64} \
      PMC_PMC_NOC_DATA_WIDTH {128} \
      PMC_QSPI_COHERENCY {0} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_QSPI_ROUTE_THROUGH_FPD {0} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD0 {{CD_ENABLE 0} {CD_IO {PMC_MIO 24}} {POW_ENABLE 0} {POW_IO {PMC_MIO 17}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 17}} {WP_ENABLE 0} {WP_IO {PMC_MIO 25}}} \
      PMC_SD0_COHERENCY {0} \
      PMC_SD0_DATA_TRANSFER_MODE {4Bit} \
      PMC_SD0_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x00} {CLK_50_DDR_ITAP_DLY 0x00} {CLK_50_DDR_OTAP_DLY 0x00} {CLK_50_SDR_ITAP_DLY 0x00} {CLK_50_SDR_OTAP_DLY 0x00} {ENABLE 0}\
{IO {PMC_MIO 13 .. 25}}} \
      PMC_SD0_ROUTE_THROUGH_FPD {0} \
      PMC_SD0_SLOT_TYPE {SD 2.0} \
      PMC_SD0_SPEED_MODE {default speed} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_COHERENCY {0} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_ROUTE_THROUGH_FPD {0} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_SD1_SPEED_MODE {high speed} \
      PMC_SHOW_CCI_SMMU_SETTINGS {0} \
      PMC_SMAP_PERIPHERAL {{ENABLE 0} {IO {32 Bit}}} \
      PMC_TAMPER_EXTMIO_ENABLE {0} \
      PMC_TAMPER_EXTMIO_ERASE_BBRAM {0} \
      PMC_TAMPER_EXTMIO_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_ENABLE {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_ENABLE {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_JTAGDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_ENABLE {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM {0} \
      PMC_TAMPER_TEMPERATURE_RESPONSE {SYS INTERRUPT} \
      PMC_USE_CFU_SEU {0} \
      PMC_USE_NOC_PMC_AXI0 {0} \
      PMC_USE_PL_PMC_AUX_REF_CLK {0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PMC_WDT_PERIOD {100} \
      PMC_WDT_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0}}} \
      POWER_REPORTING_MODE {Custom} \
      PSPMC_MANUAL_CLK_ENABLE {0} \
      PS_A72_ACTIVE_BLOCKS {2} \
      PS_A72_LOAD {90} \
      PS_BANK_2_IO_STANDARD {LVCMOS1.8} \
      PS_BANK_3_IO_STANDARD {LVCMOS1.8} \
      PS_BOARD_INTERFACE {Custom} \
      PS_CAN0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 8 .. 9}}} \
      PS_CAN1_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} \
      PS_CRF_ACPU_CTRL_ACT_FREQMHZ {1349.998657} \
      PS_CRF_ACPU_CTRL_DIVISOR0 {1} \
      PS_CRF_ACPU_CTRL_FREQMHZ {1350} \
      PS_CRF_ACPU_CTRL_SRCSEL {APLL} \
      PS_CRF_APLL_CTRL_CLKOUTDIV {2} \
      PS_CRF_APLL_CTRL_FBDIV {81} \
      PS_CRF_APLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRF_APLL_TO_XPD_CTRL_DIVISOR0 {4} \
      PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {399.999634} \
      PS_CRF_DBG_FPD_CTRL_DIVISOR0 {3} \
      PS_CRF_DBG_FPD_CTRL_FREQMHZ {400} \
      PS_CRF_DBG_FPD_CTRL_SRCSEL {PPLL} \
      PS_CRF_DBG_TRACE_CTRL_ACT_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_DIVISOR0 {3} \
      PS_CRF_DBG_TRACE_CTRL_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {149.999863} \
      PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {8} \
      PS_CRF_FPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRF_FPD_LSBUS_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {824.999207} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_DIVISOR0 {1} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_FREQMHZ {825} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_SRCSEL {RPLL} \
      PS_CRL_CAN0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_CAN0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_CAN0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_CAN0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {149.999863} \
      PS_CRL_CAN1_REF_CTRL_DIVISOR0 {8} \
      PS_CRL_CAN1_REF_CTRL_FREQMHZ {150} \
      PS_CRL_CAN1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {599.999451} \
      PS_CRL_CPM_TOPSW_REF_CTRL_DIVISOR0 {2} \
      PS_CRL_CPM_TOPSW_REF_CTRL_FREQMHZ {600} \
      PS_CRL_CPM_TOPSW_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {599.999451} \
      PS_CRL_CPU_R5_CTRL_DIVISOR0 {2} \
      PS_CRL_CPU_R5_CTRL_FREQMHZ {600} \
      PS_CRL_CPU_R5_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {399.999634} \
      PS_CRL_DBG_LPD_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_LPD_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_LPD_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {399.999634} \
      PS_CRL_DBG_TSTMP_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_TSTMP_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_TSTMP_CTRL_SRCSEL {PPLL} \
      PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.999878} \
      PS_CRL_GEM0_REF_CTRL_DIVISOR0 {2} \
      PS_CRL_GEM0_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM0_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {124.999878} \
      PS_CRL_GEM1_REF_CTRL_DIVISOR0 {2} \
      PS_CRL_GEM1_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM1_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.999756} \
      PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {1} \
      PS_CRL_GEM_TSU_REF_CTRL_FREQMHZ {250} \
      PS_CRL_GEM_TSU_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_I2C0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_I2C0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_I2C0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {99.999908} \
      PS_CRL_I2C1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_I2C1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_IOU_SWITCH_CTRL_ACT_FREQMHZ {249.999756} \
      PS_CRL_IOU_SWITCH_CTRL_DIVISOR0 {1} \
      PS_CRL_IOU_SWITCH_CTRL_FREQMHZ {250} \
      PS_CRL_IOU_SWITCH_CTRL_SRCSEL {NPLL} \
      PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {149.999863} \
      PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {8} \
      PS_CRL_LPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRL_LPD_LSBUS_CTRL_SRCSEL {PPLL} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {599.999451} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_FREQMHZ {600} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_SRCSEL {PPLL} \
      PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {399.999634} \
      PS_CRL_PSM_REF_CTRL_DIVISOR0 {3} \
      PS_CRL_PSM_REF_CTRL_FREQMHZ {400} \
      PS_CRL_PSM_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_RPLL_CTRL_CLKOUTDIV {4} \
      PS_CRL_RPLL_CTRL_FBDIV {99} \
      PS_CRL_RPLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRL_RPLL_TO_XPD_CTRL_DIVISOR0 {1} \
      PS_CRL_SPI0_REF_CTRL_ACT_FREQMHZ {200} \
      PS_CRL_SPI0_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI0_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_SPI1_REF_CTRL_ACT_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI1_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_TIMESTAMP_REF_CTRL_ACT_FREQMHZ {99.999908} \
      PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_TIMESTAMP_REF_CTRL_FREQMHZ {100} \
      PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999908} \
      PS_CRL_UART0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_UART0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_UART1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_UART1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999981} \
      PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {60} \
      PS_CRL_USB0_BUS_REF_CTRL_FREQMHZ {20} \
      PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_USB3_DUAL_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_USB3_DUAL_REF_CTRL_DIVISOR0 {100} \
      PS_CRL_USB3_DUAL_REF_CTRL_FREQMHZ {100} \
      PS_CRL_USB3_DUAL_REF_CTRL_SRCSEL {PPLL} \
      PS_DDRC_ENABLE {1} \
      PS_DDR_RAM_HIGHADDR_OFFSET {34359738368} \
      PS_DDR_RAM_LOWADDR_OFFSET {2147483648} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_MDIO {{ENABLE 0} {IO {PMC_MIO 50 .. 51}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}} \
      PS_EN_AXI_STATUS_PORTS {0} \
      PS_EN_PORTS_CONTROLLER_BASED {0} \
      PS_EXPAND_CORESIGHT {0} \
      PS_EXPAND_FPD_SLAVES {0} \
      PS_EXPAND_GIC {0} \
      PS_EXPAND_LPD_SLAVES {0} \
      PS_FPD_INTERCONNECT_LOAD {90} \
      PS_FTM_CTI_IN0 {0} \
      PS_FTM_CTI_IN1 {0} \
      PS_FTM_CTI_IN2 {0} \
      PS_FTM_CTI_IN3 {0} \
      PS_FTM_CTI_OUT0 {0} \
      PS_FTM_CTI_OUT1 {0} \
      PS_FTM_CTI_OUT2 {0} \
      PS_FTM_CTI_OUT3 {0} \
      PS_GEM0_COHERENCY {0} \
      PS_GEM0_ROUTE_THROUGH_FPD {0} \
      PS_GEM1_COHERENCY {0} \
      PS_GEM1_ROUTE_THROUGH_FPD {0} \
      PS_GEM_TSU {{ENABLE 0} {IO {PS_MIO 24}}} \
      PS_GEM_TSU_CLK_PORT_PAIR {0} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI1_MASTER {A72} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI2_MASTER {A72} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI3_MASTER {A72} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI4_MASTER {A72} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI5_MASTER {A72} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GEN_IPI6_MASTER {A72} \
      PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
      PS_GEN_IPI_PMCNOBUF_MASTER {PMC} \
      PS_GEN_IPI_PMC_ENABLE {1} \
      PS_GEN_IPI_PMC_MASTER {PMC} \
      PS_GEN_IPI_PSM_ENABLE {1} \
      PS_GEN_IPI_PSM_MASTER {PSM} \
      PS_GPIO2_MIO_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 0 .. 25}}} \
      PS_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PS_GPIO_EMIO_WIDTH {32} \
      PS_HSDP0_REFCLK {0} \
      PS_HSDP1_REFCLK {0} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_HSDP_SAME_EGRESS_AS_INGRESS_TRAFFIC {1} \
      PS_I2C0_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 23 .. 24}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 0} {CH9 0}} \
      PS_LPDMA0_COHERENCY {0} \
      PS_LPDMA0_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA1_COHERENCY {0} \
      PS_LPDMA1_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA2_COHERENCY {0} \
      PS_LPDMA2_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA3_COHERENCY {0} \
      PS_LPDMA3_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA4_COHERENCY {0} \
      PS_LPDMA4_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA5_COHERENCY {0} \
      PS_LPDMA5_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA6_COHERENCY {0} \
      PS_LPDMA6_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA7_COHERENCY {0} \
      PS_LPDMA7_ROUTE_THROUGH_FPD {0} \
      PS_LPD_DMA_CHANNEL_ENABLE {{CH0 0} {CH1 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0}} \
      PS_LPD_DMA_CH_TZ {{CH0 NonSecure} {CH1 NonSecure} {CH2 NonSecure} {CH3 NonSecure} {CH4 NonSecure} {CH5 NonSecure} {CH6 NonSecure} {CH7 NonSecure}} \
      PS_LPD_DMA_ENABLE {0} \
      PS_LPD_INTERCONNECT_LOAD {90} \
      PS_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO1 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO10 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO11 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO14 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO15 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO16 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO17 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO2 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO20 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO22 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO25 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO3 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO4 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO6 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO8 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_M_AXI_FPD_DATA_WIDTH {32} \
      PS_M_AXI_GP4_DATA_WIDTH {128} \
      PS_M_AXI_LPD_DATA_WIDTH {128} \
      PS_NOC_PS_CCI_DATA_WIDTH {128} \
      PS_NOC_PS_NCI_DATA_WIDTH {128} \
      PS_NOC_PS_PCI_DATA_WIDTH {128} \
      PS_NOC_PS_PMC_DATA_WIDTH {128} \
      PS_NUM_F2P0_INTR_INPUTS {1} \
      PS_NUM_F2P1_INTR_INPUTS {1} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_OCM_ACTIVE_BLOCKS {1} \
      PS_PCIE1_PERIPHERAL_ENABLE {0} \
      PS_PCIE2_PERIPHERAL_ENABLE {0} \
      PS_PCIE_EP_RESET1_IO {None} \
      PS_PCIE_EP_RESET2_IO {None} \
      PS_PCIE_PERIPHERAL_ENABLE {0} \
      PS_PCIE_RESET {ENABLE 1} \
      PS_PCIE_ROOT_RESET1_IO {None} \
      PS_PCIE_ROOT_RESET1_IO_DIR {output} \
      PS_PCIE_ROOT_RESET1_POLARITY {Active Low} \
      PS_PCIE_ROOT_RESET2_IO {None} \
      PS_PCIE_ROOT_RESET2_IO_DIR {output} \
      PS_PCIE_ROOT_RESET2_POLARITY {Active Low} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_PL_DONE {0} \
      PS_PL_PASS_AXPROT_VALUE {0} \
      PS_PMCPL_CLK0_BUF {1} \
      PS_PMCPL_CLK1_BUF {1} \
      PS_PMCPL_CLK2_BUF {1} \
      PS_PMCPL_CLK3_BUF {1} \
      PS_PMCPL_IRO_CLK_BUF {1} \
      PS_PMU_PERIPHERAL_ENABLE {0} \
      PS_PS_ENABLE {0} \
      PS_PS_NOC_CCI_DATA_WIDTH {128} \
      PS_PS_NOC_NCI_DATA_WIDTH {128} \
      PS_PS_NOC_PCI_DATA_WIDTH {128} \
      PS_PS_NOC_PMC_DATA_WIDTH {128} \
      PS_PS_NOC_RPU_DATA_WIDTH {128} \
      PS_R5_ACTIVE_BLOCKS {2} \
      PS_R5_LOAD {90} \
      PS_RPU_COHERENCY {0} \
      PS_SLR_TYPE {master} \
      PS_SMON_PL_PORTS_ENABLE {0} \
      PS_SPI0 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PMC_MIO 15}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PMC_MIO 14}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PMC_MIO 13}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PMC_MIO 12 ..\
17}}} \
      PS_SPI1 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PS_MIO 9}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PS_MIO 8}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PS_MIO 7}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PS_MIO 6 .. 11}}} \
      PS_S_AXI_ACE_DATA_WIDTH {128} \
      PS_S_AXI_ACP_DATA_WIDTH {128} \
      PS_S_AXI_FPD_DATA_WIDTH {128} \
      PS_S_AXI_GP2_DATA_WIDTH {128} \
      PS_S_AXI_LPD_DATA_WIDTH {128} \
      PS_TCM_ACTIVE_BLOCKS {2} \
      PS_TRACE_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 30 .. 47}}} \
      PS_TRACE_WIDTH {2Bit} \
      PS_TRISTATE_INVERTED {0} \
      PS_TTC0_CLK {{ENABLE 0} {IO {PS_MIO 6}}} \
      PS_TTC0_PERIPHERAL_ENABLE {1} \
      PS_TTC0_REF_CTRL_ACT_FREQMHZ {149.999863} \
      PS_TTC0_REF_CTRL_FREQMHZ {149.999863} \
      PS_TTC0_WAVEOUT {{ENABLE 0} {IO {PS_MIO 7}}} \
      PS_TTC1_CLK {{ENABLE 0} {IO {PS_MIO 12}}} \
      PS_TTC1_PERIPHERAL_ENABLE {0} \
      PS_TTC1_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC1_REF_CTRL_FREQMHZ {50} \
      PS_TTC1_WAVEOUT {{ENABLE 0} {IO {PS_MIO 13}}} \
      PS_TTC2_CLK {{ENABLE 0} {IO {PS_MIO 2}}} \
      PS_TTC2_PERIPHERAL_ENABLE {0} \
      PS_TTC2_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC2_REF_CTRL_FREQMHZ {50} \
      PS_TTC2_WAVEOUT {{ENABLE 0} {IO {PS_MIO 3}}} \
      PS_TTC3_CLK {{ENABLE 0} {IO {PS_MIO 16}}} \
      PS_TTC3_PERIPHERAL_ENABLE {0} \
      PS_TTC3_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC3_REF_CTRL_FREQMHZ {50} \
      PS_TTC3_WAVEOUT {{ENABLE 0} {IO {PS_MIO 17}}} \
      PS_TTC_APB_CLK_TTC0_SEL {APB} \
      PS_TTC_APB_CLK_TTC1_SEL {APB} \
      PS_TTC_APB_CLK_TTC2_SEL {APB} \
      PS_TTC_APB_CLK_TTC3_SEL {APB} \
      PS_UART0_BAUD_RATE {115200} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_UART0_RTS_CTS {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
      PS_UART1_BAUD_RATE {115200} \
      PS_UART1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 4 .. 5}}} \
      PS_UART1_RTS_CTS {{ENABLE 0} {IO {PMC_MIO 6 .. 7}}} \
      PS_UNITS_MODE {Custom} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USB_COHERENCY {0} \
      PS_USB_ROUTE_THROUGH_FPD {0} \
      PS_USE_ACE_LITE {0} \
      PS_USE_APU_EVENT_BUS {0} \
      PS_USE_APU_INTERRUPT {0} \
      PS_USE_AXI4_EXT_USER_BITS {0} \
      PS_USE_BSCAN_USER1 {0} \
      PS_USE_BSCAN_USER2 {0} \
      PS_USE_BSCAN_USER3 {0} \
      PS_USE_BSCAN_USER4 {0} \
      PS_USE_CAPTURE {0} \
      PS_USE_CLK {0} \
      PS_USE_DEBUG_TEST {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_FPD {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_GP2 {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_LPD {0} \
      PS_USE_ENET0_PTP {0} \
      PS_USE_ENET1_PTP {0} \
      PS_USE_FIFO_ENET0 {0} \
      PS_USE_FIFO_ENET1 {0} \
      PS_USE_FIXED_IO {0} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {0} \
      PS_USE_FPD_CCI_NOC1 {0} \
      PS_USE_FPD_CCI_NOC2 {0} \
      PS_USE_FPD_CCI_NOC3 {0} \
      PS_USE_FTM_GPI {0} \
      PS_USE_FTM_GPO {0} \
      PS_USE_HSDP_PL {0} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_M_AXI_LPD {0} \
      PS_USE_NOC_FPD_AXI0 {0} \
      PS_USE_NOC_FPD_AXI1 {0} \
      PS_USE_NOC_FPD_CCI0 {0} \
      PS_USE_NOC_FPD_CCI1 {0} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_NOC_PS_PCI_0 {0} \
      PS_USE_NOC_PS_PMC_0 {0} \
      PS_USE_NPI_CLK {0} \
      PS_USE_NPI_RST {0} \
      PS_USE_PL_FPD_AUX_REF_CLK {0} \
      PS_USE_PL_LPD_AUX_REF_CLK {0} \
      PS_USE_PMC {0} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      PS_USE_PMCPL_IRO_CLK {0} \
      PS_USE_PSPL_IRQ_FPD {0} \
      PS_USE_PSPL_IRQ_LPD {0} \
      PS_USE_PSPL_IRQ_PMC {0} \
      PS_USE_PS_NOC_PCI_0 {0} \
      PS_USE_PS_NOC_PCI_1 {0} \
      PS_USE_PS_NOC_PMC_0 {0} \
      PS_USE_PS_NOC_PMC_1 {0} \
      PS_USE_RPU_EVENT {0} \
      PS_USE_RPU_INTERRUPT {0} \
      PS_USE_RTC {0} \
      PS_USE_SMMU {0} \
      PS_USE_STARTUP {0} \
      PS_USE_STM {0} \
      PS_USE_S_ACP_FPD {0} \
      PS_USE_S_AXI_ACE {0} \
      PS_USE_S_AXI_FPD {0} \
      PS_USE_S_AXI_GP2 {0} \
      PS_USE_S_AXI_LPD {0} \
      PS_USE_TRACE_ATB {0} \
      PS_WDT0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_SEL {NONE} \
      PS_WDT1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_SEL {NONE} \
      PS_WWDT0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_WWDT0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 5}}} \
      PS_WWDT1_CLK {{ENABLE 0} {IO {PMC_MIO 6}}} \
      PS_WWDT1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 6 .. 11}}} \
      SEM_ERROR_HANDLE_OPTIONS {Detect & Correct} \
      SEM_EVENT_LOG_OPTIONS {Log & Notify} \
      SEM_MEM_BUILT_IN_SELF_TEST {0} \
      SEM_MEM_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_MEM_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_MEM_GOLDEN_ECC {0} \
      SEM_MEM_GOLDEN_ECC_SW {0} \
      SEM_MEM_SCAN {0} \
      SEM_NPI_BUILT_IN_SELF_TEST {0} \
      SEM_NPI_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_NPI_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_NPI_GOLDEN_CHECKSUM_SW {0} \
      SEM_NPI_SCAN {0} \
      SEM_TIME_INTERVAL_BETWEEN_SCANS {80} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_INT_VOLTAGE_MONITORING {0} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_INTERFACE_TO_USE {None} \
      SMON_INT_MEASUREMENT_ALARM_ENABLE {0} \
      SMON_INT_MEASUREMENT_AVG_ENABLE {0} \
      SMON_INT_MEASUREMENT_ENABLE {0} \
      SMON_INT_MEASUREMENT_MODE {0} \
      SMON_INT_MEASUREMENT_TH_HIGH {0} \
      SMON_INT_MEASUREMENT_TH_LOW {0} \
      SMON_MEAS0 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_103} {SUPPLY_NUM 0}} \
      SMON_MEAS1 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_104} {SUPPLY_NUM 0}} \
      SMON_MEAS10 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_206} {SUPPLY_NUM 0}} \
      SMON_MEAS100 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS101 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS102 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS103 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS104 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS105 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS106 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS107 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS108 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS109 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS11 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_103} {SUPPLY_NUM 0}} \
      SMON_MEAS110 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS111 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS112 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS113 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS114 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS115 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS116 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS117 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS118 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS119 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS12 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_104} {SUPPLY_NUM 0}} \
      SMON_MEAS120 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS121 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS122 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS123 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS124 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS125 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS126 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS127 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS128 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS129 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS13 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_105} {SUPPLY_NUM 0}} \
      SMON_MEAS130 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS131 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS132 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS133 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS134 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS135 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS136 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS137 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS138 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS139 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS14 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_106} {SUPPLY_NUM 0}} \
      SMON_MEAS140 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS141 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS142 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS143 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS144 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS145 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS146 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS147 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS148 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS149 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS15 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_200} {SUPPLY_NUM 0}} \
      SMON_MEAS150 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS151 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS152 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS153 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS154 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS155 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS156 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS157 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS158 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS159 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS16 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_201} {SUPPLY_NUM 0}} \
      SMON_MEAS160 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS161 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS162 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT}} \
      SMON_MEAS163 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX}} \
      SMON_MEAS164 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM}} \
      SMON_MEAS165 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC}} \
      SMON_MEAS166 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP}} \
      SMON_MEAS167 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP}} \
      SMON_MEAS168 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC}} \
      SMON_MEAS169 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC}} \
      SMON_MEAS17 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_202} {SUPPLY_NUM 0}} \
      SMON_MEAS170 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS171 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS172 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS173 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS174 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS175 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS18 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_203} {SUPPLY_NUM 0}} \
      SMON_MEAS19 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_204} {SUPPLY_NUM 0}} \
      SMON_MEAS2 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_105} {SUPPLY_NUM 0}} \
      SMON_MEAS20 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_205} {SUPPLY_NUM 0}} \
      SMON_MEAS21 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_206} {SUPPLY_NUM 0}} \
      SMON_MEAS22 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_103} {SUPPLY_NUM 0}} \
      SMON_MEAS23 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_104} {SUPPLY_NUM 0}} \
      SMON_MEAS24 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_105} {SUPPLY_NUM 0}} \
      SMON_MEAS25 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_106} {SUPPLY_NUM 0}} \
      SMON_MEAS26 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_200} {SUPPLY_NUM 0}} \
      SMON_MEAS27 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_201} {SUPPLY_NUM 0}} \
      SMON_MEAS28 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_202} {SUPPLY_NUM 0}} \
      SMON_MEAS29 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_203} {SUPPLY_NUM 0}} \
      SMON_MEAS3 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_106} {SUPPLY_NUM 0}} \
      SMON_MEAS30 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_204} {SUPPLY_NUM 0}} \
      SMON_MEAS31 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_205} {SUPPLY_NUM 0}} \
      SMON_MEAS32 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_206} {SUPPLY_NUM 0}} \
      SMON_MEAS33 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 0}} \
      SMON_MEAS34 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS35 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_SMON} {SUPPLY_NUM 0}} \
      SMON_MEAS36 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT} {SUPPLY_NUM 0}} \
      SMON_MEAS37 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_306} {SUPPLY_NUM 0}} \
      SMON_MEAS38 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_406} {SUPPLY_NUM 0}} \
      SMON_MEAS39 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_500} {SUPPLY_NUM 0}} \
      SMON_MEAS4 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_200} {SUPPLY_NUM 0}} \
      SMON_MEAS40 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_501} {SUPPLY_NUM 0}} \
      SMON_MEAS41 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_502} {SUPPLY_NUM 0}} \
      SMON_MEAS42 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_503} {SUPPLY_NUM 0}} \
      SMON_MEAS43 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_700} {SUPPLY_NUM 0}} \
      SMON_MEAS44 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_701} {SUPPLY_NUM 0}} \
      SMON_MEAS45 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_702} {SUPPLY_NUM 0}} \
      SMON_MEAS46 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_703} {SUPPLY_NUM 0}} \
      SMON_MEAS47 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_704} {SUPPLY_NUM 0}} \
      SMON_MEAS48 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_705} {SUPPLY_NUM 0}} \
      SMON_MEAS49 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_706} {SUPPLY_NUM 0}} \
      SMON_MEAS5 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_201} {SUPPLY_NUM 0}} \
      SMON_MEAS50 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_707} {SUPPLY_NUM 0}} \
      SMON_MEAS51 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_708} {SUPPLY_NUM 0}} \
      SMON_MEAS52 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_709} {SUPPLY_NUM 0}} \
      SMON_MEAS53 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_710} {SUPPLY_NUM 0}} \
      SMON_MEAS54 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_711} {SUPPLY_NUM 0}} \
      SMON_MEAS55 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_BATT} {SUPPLY_NUM 0}} \
      SMON_MEAS56 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS57 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 0}} \
      SMON_MEAS58 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 0}} \
      SMON_MEAS59 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM} {SUPPLY_NUM 0}} \
      SMON_MEAS6 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_202} {SUPPLY_NUM 0}} \
      SMON_MEAS60 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 0}} \
      SMON_MEAS61 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 1.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {1 V unipolar}} {NAME VP_VN} {SUPPLY_NUM 0}} \
      SMON_MEAS62 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS63 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS64 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS65 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS66 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS67 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS68 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS69 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS7 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_203} {SUPPLY_NUM 0}} \
      SMON_MEAS70 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS71 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS72 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS73 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS74 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS75 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS76 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS77 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS78 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS79 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS8 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_204} {SUPPLY_NUM 0}} \
      SMON_MEAS80 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS81 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS82 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS83 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS84 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS85 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS86 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS87 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS88 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS89 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS9 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_205} {SUPPLY_NUM 0}} \
      SMON_MEAS90 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS91 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS92 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS93 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS94 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS95 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS96 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS97 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS98 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS99 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEASUREMENT_COUNT {62} \
      SMON_MEASUREMENT_LIST {BANK_VOLTAGE:GTY_AVTT-GTY_AVTT_103,GTY_AVTT_104,GTY_AVTT_105,GTY_AVTT_106,GTY_AVTT_200,GTY_AVTT_201,GTY_AVTT_202,GTY_AVTT_203,GTY_AVTT_204,GTY_AVTT_205,GTY_AVTT_206#VCC-GTY_AVCC_103,GTY_AVCC_104,GTY_AVCC_105,GTY_AVCC_106,GTY_AVCC_200,GTY_AVCC_201,GTY_AVCC_202,GTY_AVCC_203,GTY_AVCC_204,GTY_AVCC_205,GTY_AVCC_206#VCCAUX-GTY_AVCCAUX_103,GTY_AVCCAUX_104,GTY_AVCCAUX_105,GTY_AVCCAUX_106,GTY_AVCCAUX_200,GTY_AVCCAUX_201,GTY_AVCCAUX_202,GTY_AVCCAUX_203,GTY_AVCCAUX_204,GTY_AVCCAUX_205,GTY_AVCCAUX_206#VCCO-VCCO_306,VCCO_406,VCCO_500,VCCO_501,VCCO_502,VCCO_503,VCCO_700,VCCO_701,VCCO_702,VCCO_703,VCCO_704,VCCO_705,VCCO_706,VCCO_707,VCCO_708,VCCO_709,VCCO_710,VCCO_711|DEDICATED_PAD:VP-VP_VN|SUPPLY_VOLTAGE:VCC-VCC_BATT,VCC_PMC,VCC_PSFP,VCC_PSLP,VCC_RAM,VCC_SOC#VCCAUX-VCCAUX,VCCAUX_PMC,VCCAUX_SMON#VCCINT-VCCINT}\
\
      SMON_OT {{THRESHOLD_LOWER -55} {THRESHOLD_UPPER 125}} \
      SMON_PMBUS_ADDRESS {0x0} \
      SMON_PMBUS_UNRESTRICTED {0} \
      SMON_REFERENCE_SOURCE {Internal} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
      SMON_TEMP_THRESHOLD {0} \
      SMON_USER_TEMP {{THRESHOLD_LOWER 0} {THRESHOLD_UPPER 125} {USER_ALARM_TYPE window}} \
      SMON_VAUX_CH0 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH0} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH1 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH1} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH10 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH10} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH11 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH11} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH12 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH12} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH13 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH13} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH14 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH14} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH15 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH15} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH2 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH2} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH3 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH3} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH4 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH4} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH5 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH5} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH6 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH6} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH7 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH7} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH8 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH8} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH9 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH9} {SUPPLY_NUM 0}} \
      SMON_VAUX_IO_BANK {MIO_BANK0} \
      SMON_VOLTAGE_AVERAGING_SAMPLES {None} \
      SPP_PSPMC_FROM_CORE_WIDTH {12000} \
      SPP_PSPMC_TO_CORE_WIDTH {12000} \
      SUBPRESET1 {Custom} \
      USE_UART0_IN_DEVICE_BOOT {0} \
      preset {None} \
    } \
    CONFIG.PS_PMC_CONFIG_APPLIED {1} \
  ] $versal_cips_0


  # Create instance: subsys_axi_ctl_smartconnect, and set properties
  set subsys_axi_ctl_smartconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect subsys_axi_ctl_smartconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $subsys_axi_ctl_smartconnect


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_DDR4_0_BOARD_INTERFACE {Custom} \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_c0} \
    CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_c1} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_c0} \
    CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_c1} \
    CONFIG.HBM_CHNL0_CONFIG {HBM_REORDER_EN FALSE HBM_MAINTAIN_COHERENCY TRUE HBM_Q_AGE_LIMIT 0x7f HBM_CLOSE_PAGE_REORDER FALSE HBM_LOOKAHEAD_PCH TRUE HBM_COMMAND_PARITY FALSE HBM_DQ_WR_PARITY FALSE HBM_DQ_RD_PARITY\
FALSE HBM_RD_DBI FALSE HBM_WR_DBI FALSE HBM_REFRESH_MODE ALL_BANK_REFRESH HBM_PC0_ADDRESS_MAP SID,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA3,BA2,BA1,BA0,CA5,CA4,CA3,CA2,CA1,NC,NA,NA,NA,NA\
HBM_PC1_ADDRESS_MAP SID,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA3,BA2,BA HBM_PC0_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC1_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC0_USER_DEFINED_ADDRESS_MAP\
NONE HBM_PC1_USER_DEFINED_ADDRESS_MAP NONE HBM_WRITE_BACK_CORRECTED_DATA TRUE} \
    CONFIG.MC2_CONFIG_NUM {config26} \
    CONFIG.MC3_CONFIG_NUM {config26} \
    CONFIG.MC_ADDR_WIDTH {6} \
    CONFIG.MC_BOARD_INTRF_EN {true} \
    CONFIG.MC_BURST_LENGTH {16} \
    CONFIG.MC_CASLATENCY {36} \
    CONFIG.MC_CASWRITELATENCY {18} \
    CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CKE_WIDTH {0} \
    CONFIG.MC_CK_WIDTH {0} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_ECC {false} \
    CONFIG.MC_ECC_SCRUB_SIZE {4096} \
    CONFIG.MC_F1_CASLATENCY {36} \
    CONFIG.MC_F1_CASWRITELATENCY {18} \
    CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
    CONFIG.MC_F1_TCCD_L {0} \
    CONFIG.MC_F1_TCCD_L_MIN {0} \
    CONFIG.MC_F1_TFAW {40000} \
    CONFIG.MC_F1_TFAWMIN {40000} \
    CONFIG.MC_F1_TMOD {0} \
    CONFIG.MC_F1_TMOD_MIN {0} \
    CONFIG.MC_F1_TMRD {14000} \
    CONFIG.MC_F1_TMRDMIN {14000} \
    CONFIG.MC_F1_TMRW {10000} \
    CONFIG.MC_F1_TMRWMIN {10000} \
    CONFIG.MC_F1_TRAS {42000} \
    CONFIG.MC_F1_TRASMIN {42000} \
    CONFIG.MC_F1_TRCD {18000} \
    CONFIG.MC_F1_TRCDMIN {18000} \
    CONFIG.MC_F1_TRPAB {21000} \
    CONFIG.MC_F1_TRPABMIN {21000} \
    CONFIG.MC_F1_TRPPB {18000} \
    CONFIG.MC_F1_TRPPBMIN {18000} \
    CONFIG.MC_F1_TRRD {10000} \
    CONFIG.MC_F1_TRRDMIN {10000} \
    CONFIG.MC_F1_TRRD_L {0} \
    CONFIG.MC_F1_TRRD_L_MIN {0} \
    CONFIG.MC_F1_TRRD_S {0} \
    CONFIG.MC_F1_TRRD_S_MIN {0} \
    CONFIG.MC_F1_TWR {18000} \
    CONFIG.MC_F1_TWRMIN {18000} \
    CONFIG.MC_F1_TWTR {10000} \
    CONFIG.MC_F1_TWTRMIN {10000} \
    CONFIG.MC_F1_TWTR_L {0} \
    CONFIG.MC_F1_TWTR_L_MIN {0} \
    CONFIG.MC_F1_TWTR_S {0} \
    CONFIG.MC_F1_TWTR_S_MIN {0} \
    CONFIG.MC_F1_TZQLAT {30000} \
    CONFIG.MC_F1_TZQLATMIN {30000} \
    CONFIG.MC_INTERLEAVE_SIZE {2048} \
    CONFIG.MC_IP_TIMEPERIOD1 {512} \
    CONFIG.MC_LP4_CA_A_WIDTH {6} \
    CONFIG.MC_LP4_CA_B_WIDTH {6} \
    CONFIG.MC_LP4_CKE_A_WIDTH {1} \
    CONFIG.MC_LP4_CKE_B_WIDTH {1} \
    CONFIG.MC_LP4_CKT_A_WIDTH {1} \
    CONFIG.MC_LP4_CKT_B_WIDTH {1} \
    CONFIG.MC_LP4_CS_A_WIDTH {1} \
    CONFIG.MC_LP4_CS_B_WIDTH {1} \
    CONFIG.MC_LP4_DMI_A_WIDTH {2} \
    CONFIG.MC_LP4_DMI_B_WIDTH {2} \
    CONFIG.MC_LP4_DQS_A_WIDTH {2} \
    CONFIG.MC_LP4_DQS_B_WIDTH {2} \
    CONFIG.MC_LP4_DQ_A_WIDTH {16} \
    CONFIG.MC_LP4_DQ_B_WIDTH {16} \
    CONFIG.MC_LP4_RESETN_WIDTH {1} \
    CONFIG.MC_NETLIST_SIMULATION {true} \
    CONFIG.MC_ODTLon {6} \
    CONFIG.MC_ODT_WIDTH {0} \
    CONFIG.MC_PER_RD_INTVL {0} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
    CONFIG.MC_READ_BANDWIDTH {6400.0} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.MC_TCCD {8} \
    CONFIG.MC_TCCD_L {0} \
    CONFIG.MC_TCCD_L_MIN {0} \
    CONFIG.MC_TCKE {12} \
    CONFIG.MC_TCKEMIN {12} \
    CONFIG.MC_TDQS2DQ_MAX {800} \
    CONFIG.MC_TDQS2DQ_MIN {200} \
    CONFIG.MC_TDQSCK_MAX {3500} \
    CONFIG.MC_TFAW {40000} \
    CONFIG.MC_TFAWMIN {40000} \
    CONFIG.MC_TMOD {0} \
    CONFIG.MC_TMOD_MIN {0} \
    CONFIG.MC_TMRD {14000} \
    CONFIG.MC_TMRDMIN {14000} \
    CONFIG.MC_TMRD_div4 {10} \
    CONFIG.MC_TMRD_nCK {23} \
    CONFIG.MC_TMRW {10000} \
    CONFIG.MC_TMRWMIN {10000} \
    CONFIG.MC_TMRW_div4 {10} \
    CONFIG.MC_TMRW_nCK {16} \
    CONFIG.MC_TODTon_MIN {3} \
    CONFIG.MC_TOSCO {40000} \
    CONFIG.MC_TOSCOMIN {40000} \
    CONFIG.MC_TOSCO_nCK {64} \
    CONFIG.MC_TPBR2PBR {90000} \
    CONFIG.MC_TPBR2PBRMIN {90000} \
    CONFIG.MC_TRAS {42000} \
    CONFIG.MC_TRASMIN {42000} \
    CONFIG.MC_TRAS_nCK {68} \
    CONFIG.MC_TRC {63000} \
    CONFIG.MC_TRCD {18000} \
    CONFIG.MC_TRCDMIN {18000} \
    CONFIG.MC_TRCD_nCK {29} \
    CONFIG.MC_TRCMIN {0} \
    CONFIG.MC_TREFI {3904000} \
    CONFIG.MC_TREFIPB {488000} \
    CONFIG.MC_TRFC {0} \
    CONFIG.MC_TRFCAB {280000} \
    CONFIG.MC_TRFCABMIN {280000} \
    CONFIG.MC_TRFCMIN {0} \
    CONFIG.MC_TRFCPB {140000} \
    CONFIG.MC_TRFCPBMIN {140000} \
    CONFIG.MC_TRP {0} \
    CONFIG.MC_TRPAB {21000} \
    CONFIG.MC_TRPABMIN {21000} \
    CONFIG.MC_TRPAB_nCK {34} \
    CONFIG.MC_TRPMIN {0} \
    CONFIG.MC_TRPPB {18000} \
    CONFIG.MC_TRPPBMIN {18000} \
    CONFIG.MC_TRPPB_nCK {29} \
    CONFIG.MC_TRPRE {1.8} \
    CONFIG.MC_TRRD {10000} \
    CONFIG.MC_TRRDMIN {10000} \
    CONFIG.MC_TRRD_L {0} \
    CONFIG.MC_TRRD_L_MIN {0} \
    CONFIG.MC_TRRD_S {0} \
    CONFIG.MC_TRRD_S_MIN {0} \
    CONFIG.MC_TRRD_nCK {16} \
    CONFIG.MC_TWPRE {1.8} \
    CONFIG.MC_TWPST {0.4} \
    CONFIG.MC_TWR {18000} \
    CONFIG.MC_TWRMIN {18000} \
    CONFIG.MC_TWR_nCK {29} \
    CONFIG.MC_TWTR {10000} \
    CONFIG.MC_TWTRMIN {10000} \
    CONFIG.MC_TWTR_L {0} \
    CONFIG.MC_TWTR_S {0} \
    CONFIG.MC_TWTR_S_MIN {0} \
    CONFIG.MC_TWTR_nCK {16} \
    CONFIG.MC_TXP {12} \
    CONFIG.MC_TXPMIN {12} \
    CONFIG.MC_TXPR {0} \
    CONFIG.MC_TZQCAL {1000000} \
    CONFIG.MC_TZQCAL_div4 {400} \
    CONFIG.MC_TZQCS_ITVL {0} \
    CONFIG.MC_TZQLAT {30000} \
    CONFIG.MC_TZQLATMIN {30000} \
    CONFIG.MC_TZQLAT_div4 {12} \
    CONFIG.MC_TZQLAT_nCK {48} \
    CONFIG.MC_TZQ_START_ITVL {1000000000} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {16RA-3BA-10CA} \
    CONFIG.MC_WRITE_BANDWIDTH {6400.0} \
    CONFIG.MC_XPLL_CLKOUT1_PERIOD {1250} \
    CONFIG.MC_XPLL_CLKOUT1_PHASE {238.176} \
    CONFIG.NUM_CLKS {9} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {2} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {11} \
    CONFIG.SI_SIDEBAND_PINS {} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_sma_clk1} \
    CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_sma_clk2} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {50} write_bw {50} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 {read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {12000} write_bw {50} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {50} write_bw {12000} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_1 {read_bw {750} write_bw {750} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S10_AXI]

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
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S08_AXI:S09_AXI:S10_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  # Create instance: DATAPATH_MCDMA_HIER
  create_hier_cell_DATAPATH_MCDMA_HIER [current_bd_instance .] DATAPATH_MCDMA_HIER

  # Create instance: xlconstant_128b0, and set properties
  set xlconstant_128b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_128b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {128} \
  ] $xlconstant_128b0


  # Create instance: axis_vio_0, and set properties
  set axis_vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio axis_vio_0 ]
  set_property -dict [list \
    CONFIG.C_NUM_PROBE_IN {21} \
    CONFIG.C_NUM_PROBE_OUT {0} \
    CONFIG.C_PROBE_IN11_WIDTH {4} \
    CONFIG.C_PROBE_IN12_WIDTH {4} \
    CONFIG.C_PROBE_IN13_WIDTH {4} \
    CONFIG.C_PROBE_IN14_WIDTH {4} \
    CONFIG.C_PROBE_IN15_WIDTH {4} \
    CONFIG.C_PROBE_IN16_WIDTH {4} \
    CONFIG.C_PROBE_IN17_WIDTH {4} \
    CONFIG.C_PROBE_IN18_WIDTH {4} \
    CONFIG.C_PROBE_IN20_WIDTH {3} \
  ] $axis_vio_0


  # Create interface connections
  connect_bd_intf_net -intf_net AXI_LITE_1 [get_bd_intf_pins GT_WRAPPER/AXI_LITE] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M01_AXI]
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports CLK_IN_D] [get_bd_intf_pins GT_WRAPPER/CLK_IN_D]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_MM2S [get_bd_intf_pins axi_noc_0/S08_AXI] [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_MM2S]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_S2MM] [get_bd_intf_pins axi_noc_0/S09_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_SG [get_bd_intf_pins axi_noc_0/S10_AXI] [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports ch0_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports ch1_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net lpddr4_sma_clk1_1 [get_bd_intf_ports lpddr4_sma_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_sma_clk2_1 [get_bd_intf_ports lpddr4_sma_clk2] [get_bd_intf_pins axi_noc_0/sys_clk1]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_0 [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_0] [get_bd_intf_pins GT_WRAPPER/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_1 [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_1] [get_bd_intf_pins GT_WRAPPER/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_2 [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_2] [get_bd_intf_pins GT_WRAPPER/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_3 [get_bd_intf_pins mrmac_0/gt_rx_serdes_interface_3] [get_bd_intf_pins GT_WRAPPER/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_0 [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_0] [get_bd_intf_pins GT_WRAPPER/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_1 [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_1] [get_bd_intf_pins GT_WRAPPER/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_2 [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_2] [get_bd_intf_pins GT_WRAPPER/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_3 [get_bd_intf_pins mrmac_0/gt_tx_serdes_interface_3] [get_bd_intf_pins GT_WRAPPER/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M00_AXI [get_bd_intf_pins mrmac_0/s_axi] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M00_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M02_AXI [get_bd_intf_pins subsys_axi_ctl_smartconnect/M02_AXI] [get_bd_intf_pins GT_WRAPPER/S_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M03_AXI [get_bd_intf_pins subsys_axi_ctl_smartconnect/M03_AXI] [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI_LITE]
  connect_bd_intf_net -intf_net versal_cips_0_IF_NOC_LPD_AXI_0 [get_bd_intf_pins axi_noc_0/S07_AXI] [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_CCI_0 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_CCI_1 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_CCI_2 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_CCI_3 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_NCI_0 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_IF_PS_NOC_NCI_1 [get_bd_intf_pins axi_noc_0/S06_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins subsys_axi_ctl_smartconnect/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_axi_lite_interconnect_resetn  [get_bd_pins CLK_RST_WRAPPER/axi_lite_interconnect_resetn] \
  [get_bd_pins subsys_axi_ctl_smartconnect/aresetn]
  connect_bd_net -net CLK_RST_WRAPPER_axis_clk_rx_out  [get_bd_pins CLK_RST_WRAPPER/axis_clk_rx_out] \
  [get_bd_pins mrmac_0/rx_axi_clk] \
  [get_bd_pins mrmac_0/rx_flexif_clk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_clk]
  connect_bd_net -net CLK_RST_WRAPPER_axis_clk_tx_out  [get_bd_pins CLK_RST_WRAPPER/axis_clk_tx_out] \
  [get_bd_pins mrmac_0/tx_flexif_clk] \
  [get_bd_pins mrmac_0/tx_axi_clk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_clk]
  connect_bd_net -net CLK_RST_WRAPPER_mcdma_clk  [get_bd_pins CLK_RST_WRAPPER/mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/mcdma_clk] \
  [get_bd_pins axi_noc_0/aclk8]
  connect_bd_net -net CLK_RST_WRAPPER_rx_axis_rst  [get_bd_pins CLK_RST_WRAPPER/rx_axis_rst] \
  [get_bd_pins mrmac_0/rx_flexif_reset] \
  [get_bd_pins axis_vio_0/probe_in16]
  connect_bd_net -net CLK_RST_WRAPPER_rx_axis_rstn  [get_bd_pins CLK_RST_WRAPPER/rx_axis_rstn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_rstn] \
  [get_bd_pins axis_vio_0/probe_in17]
  connect_bd_net -net CLK_RST_WRAPPER_rx_reset  [get_bd_pins CLK_RST_WRAPPER/rx_reset] \
  [get_bd_pins mrmac_0/rx_serdes_reset] \
  [get_bd_pins mrmac_0/rx_core_reset]
  connect_bd_net -net CLK_RST_WRAPPER_ts_clk  [get_bd_pins CLK_RST_WRAPPER/ts_clk] \
  [get_bd_pins mrmac_0/tx_ts_clk] \
  [get_bd_pins mrmac_0/rx_ts_clk]
  connect_bd_net -net CLK_RST_WRAPPER_tx_axis_rstn  [get_bd_pins CLK_RST_WRAPPER/tx_axis_rstn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_rstn]
  connect_bd_net -net CLK_RST_WRAPPER_tx_reset  [get_bd_pins CLK_RST_WRAPPER/tx_reset] \
  [get_bd_pins mrmac_0/tx_core_reset] \
  [get_bd_pins mrmac_0/tx_serdes_reset] \
  [get_bd_pins axis_vio_0/probe_in18]
  connect_bd_net -net DATAPATH_MCDMA_HIER_mm2s_introut  [get_bd_pins DATAPATH_MCDMA_HIER/mm2s_introut] \
  [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_s2mm_introut  [get_bd_pins DATAPATH_MCDMA_HIER/s2mm_introut] \
  [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata0  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata0] \
  [get_bd_pins mrmac_0/tx_axis_tdata0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata1] \
  [get_bd_pins mrmac_0/tx_axis_tdata1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata2] \
  [get_bd_pins mrmac_0/tx_axis_tdata2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata3] \
  [get_bd_pins mrmac_0/tx_axis_tdata3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata4  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata4] \
  [get_bd_pins mrmac_0/tx_axis_tdata4]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata5  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata5] \
  [get_bd_pins mrmac_0/tx_axis_tdata5]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user0  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user0] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user1] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user2] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user3] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user4  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user4] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user4]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user5  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user5] \
  [get_bd_pins mrmac_0/tx_axis_tkeep_user5]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tlast_0  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tlast_0] \
  [get_bd_pins mrmac_0/tx_axis_tlast_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tvalid_0  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_0/tx_axis_tvalid_0]
  connect_bd_net -net GT_WRAPPER_gt_reset_all  [get_bd_pins GT_WRAPPER/gt_reset_all] \
  [get_bd_pins mrmac_0/gt_reset_all_in] \
  [get_bd_pins axis_vio_0/probe_in11]
  connect_bd_net -net GT_WRAPPER_gt_reset_rx_datapath  [get_bd_pins GT_WRAPPER/gt_reset_rx_datapath] \
  [get_bd_pins mrmac_0/gt_reset_rx_datapath_in] \
  [get_bd_pins axis_vio_0/probe_in13]
  connect_bd_net -net GT_WRAPPER_gt_reset_tx_datapath  [get_bd_pins GT_WRAPPER/gt_reset_tx_datapath] \
  [get_bd_pins mrmac_0/gt_reset_tx_datapath_in] \
  [get_bd_pins axis_vio_0/probe_in12]
  connect_bd_net -net GT_WRAPPER_gt_txn_out_0  [get_bd_pins GT_WRAPPER/gt_txn_out_0] \
  [get_bd_ports gt_txn_out_0]
  connect_bd_net -net GT_WRAPPER_gt_txp_out_0  [get_bd_pins GT_WRAPPER/gt_txp_out_0] \
  [get_bd_ports gt_txp_out_0]
  connect_bd_net -net GT_WRAPPER_gtpowergood  [get_bd_pins GT_WRAPPER/gtpowergood] \
  [get_bd_pins mrmac_0/gtpowergood_in] \
  [get_bd_pins axis_vio_0/probe_in10]
  connect_bd_net -net GT_WRAPPER_rx_usrclk  [get_bd_pins GT_WRAPPER/rx_usrclk] \
  [get_bd_pins mrmac_0/rx_core_clk] \
  [get_bd_pins mrmac_0/rx_serdes_clk]
  connect_bd_net -net GT_WRAPPER_rx_usrclk2  [get_bd_pins GT_WRAPPER/rx_usrclk2] \
  [get_bd_pins mrmac_0/rx_alt_serdes_clk]
  connect_bd_net -net GT_WRAPPER_tx_usrclk  [get_bd_pins GT_WRAPPER/tx_usrclk] \
  [get_bd_pins mrmac_0/tx_core_clk]
  connect_bd_net -net GT_WRAPPER_tx_usrclk2  [get_bd_pins GT_WRAPPER/tx_usrclk2] \
  [get_bd_pins mrmac_0/tx_alt_serdes_clk]
  connect_bd_net -net GT_txoutclk_alive_0  [get_bd_pins GT_WRAPPER/Dout] \
  [get_bd_pins axis_vio_0/probe_in19] \
  [get_bd_ports GPIO_LED_0_LS]
  connect_bd_net -net gt_loopback_vio  [get_bd_pins GT_WRAPPER/Dout1] \
  [get_bd_pins axis_vio_0/probe_in20]
  connect_bd_net -net gt_rxn_in_0_0_1  [get_bd_ports gt_rxn_in_0] \
  [get_bd_pins GT_WRAPPER/gt_rxn_in_0]
  connect_bd_net -net gt_rxp_in_0_0_1  [get_bd_ports gt_rxp_in_0] \
  [get_bd_pins GT_WRAPPER/gt_rxp_in_0]
  connect_bd_net -net mrmac_0_gt_rx_reset_done_out  [get_bd_pins mrmac_0/gt_rx_reset_done_out] \
  [get_bd_pins CLK_RST_WRAPPER/rx_mst_reset_done] \
  [get_bd_pins GT_WRAPPER/gt_rx_reset_done] \
  [get_bd_pins axis_vio_0/probe_in15]
  connect_bd_net -net mrmac_0_gt_tx_reset_done_out  [get_bd_pins mrmac_0/gt_tx_reset_done_out] \
  [get_bd_pins CLK_RST_WRAPPER/tx_mst_reset_done] \
  [get_bd_pins GT_WRAPPER/gt_tx_reset_done] \
  [get_bd_pins axis_vio_0/probe_in14]
  connect_bd_net -net mrmac_0_rx_axis_tdata0  [get_bd_pins mrmac_0/rx_axis_tdata0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata0]
  connect_bd_net -net mrmac_0_rx_axis_tdata1  [get_bd_pins mrmac_0/rx_axis_tdata1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata1]
  connect_bd_net -net mrmac_0_rx_axis_tdata2  [get_bd_pins mrmac_0/rx_axis_tdata2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata2]
  connect_bd_net -net mrmac_0_rx_axis_tdata3  [get_bd_pins mrmac_0/rx_axis_tdata3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata3]
  connect_bd_net -net mrmac_0_rx_axis_tdata4  [get_bd_pins mrmac_0/rx_axis_tdata4] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata4]
  connect_bd_net -net mrmac_0_rx_axis_tdata5  [get_bd_pins mrmac_0/rx_axis_tdata5] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata5]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins mrmac_0/rx_axis_tkeep_user0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user0]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user1  [get_bd_pins mrmac_0/rx_axis_tkeep_user1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user2  [get_bd_pins mrmac_0/rx_axis_tkeep_user2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user2]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user3  [get_bd_pins mrmac_0/rx_axis_tkeep_user3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user3]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user4  [get_bd_pins mrmac_0/rx_axis_tkeep_user4] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user4]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user5  [get_bd_pins mrmac_0/rx_axis_tkeep_user5] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user5]
  connect_bd_net -net mrmac_0_rx_axis_tlast_0  [get_bd_pins mrmac_0/rx_axis_tlast_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tlast_0]
  connect_bd_net -net mrmac_0_rx_axis_tvalid_0  [get_bd_pins mrmac_0/rx_axis_tvalid_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tvalid_0]
  connect_bd_net -net mrmac_0_rx_clr_out_0  [get_bd_pins mrmac_0/rx_clr_out_0] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLR4] \
  [get_bd_pins axis_vio_0/probe_in2]
  connect_bd_net -net mrmac_0_rx_clr_out_1  [get_bd_pins mrmac_0/rx_clr_out_1] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLR1] \
  [get_bd_pins axis_vio_0/probe_in3]
  connect_bd_net -net mrmac_0_rx_clr_out_2  [get_bd_pins mrmac_0/rx_clr_out_2] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLR3] \
  [get_bd_pins axis_vio_0/probe_in4]
  connect_bd_net -net mrmac_0_rx_clr_out_3  [get_bd_pins mrmac_0/rx_clr_out_3] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLR] \
  [get_bd_pins axis_vio_0/probe_in5]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_0  [get_bd_pins mrmac_0/rx_clrb_leaf_out_0] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLRB_LEAF4] \
  [get_bd_pins axis_vio_0/probe_in6]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_1  [get_bd_pins mrmac_0/rx_clrb_leaf_out_1] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLRB_LEAF1] \
  [get_bd_pins axis_vio_0/probe_in7]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_2  [get_bd_pins mrmac_0/rx_clrb_leaf_out_2] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLRB_LEAF3] \
  [get_bd_pins axis_vio_0/probe_in8]
  connect_bd_net -net mrmac_0_rx_clrb_leaf_out_3  [get_bd_pins mrmac_0/rx_clrb_leaf_out_3] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLRB_LEAF] \
  [get_bd_pins axis_vio_0/probe_in9]
  connect_bd_net -net mrmac_0_tx_axis_tready_0  [get_bd_pins mrmac_0/tx_axis_tready_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tready_0]
  connect_bd_net -net mrmac_0_tx_clr_out_0  [get_bd_pins mrmac_0/tx_clr_out_0] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLR2] \
  [get_bd_pins axis_vio_0/probe_in0]
  connect_bd_net -net mrmac_0_tx_clrb_leaf_out_0  [get_bd_pins mrmac_0/tx_clrb_leaf_out_0] \
  [get_bd_pins GT_WRAPPER/MBUFG_GT_CLRB_LEAF2] \
  [get_bd_pins axis_vio_0/probe_in1]
  connect_bd_net -net mrmac_constant_drive_zero_66bit_dout  [get_bd_pins mrmac_constant_drive_zero_66bit/dout] \
  [get_bd_pins mrmac_0/tx_flex_data0] \
  [get_bd_pins mrmac_0/tx_flex_data2] \
  [get_bd_pins mrmac_0/tx_flex_data1] \
  [get_bd_pins mrmac_0/tx_flex_data3] \
  [get_bd_pins mrmac_0/tx_flex_data4] \
  [get_bd_pins mrmac_0/tx_flex_data5] \
  [get_bd_pins mrmac_0/tx_flex_data6] \
  [get_bd_pins mrmac_0/tx_flex_data7] \
  [get_bd_pins mrmac_0/rx_flex_cm_data0] \
  [get_bd_pins mrmac_0/rx_flex_cm_data1] \
  [get_bd_pins mrmac_0/rx_flex_cm_data2] \
  [get_bd_pins mrmac_0/rx_flex_cm_data3] \
  [get_bd_pins mrmac_0/rx_flex_cm_data4] \
  [get_bd_pins mrmac_0/rx_flex_cm_data5] \
  [get_bd_pins mrmac_0/rx_flex_cm_data6] \
  [get_bd_pins mrmac_0/rx_flex_cm_data7]
  connect_bd_net -net mrmac_constant_drive_zero_8bit_dout  [get_bd_pins mrmac_constant_drive_zero_8bit/dout] \
  [get_bd_pins mrmac_0/ctl_tx_lane0_vlm_bip7_override_value_01] \
  [get_bd_pins mrmac_0/ctl_tx_lane0_vlm_bip7_override_value_23]
  connect_bd_net -net mrmac_constant_drive_zero_dout  [get_bd_pins mrmac_constant_drive_zero/dout] \
  [get_bd_pins mrmac_0/ctl_tx_lane0_vlm_bip7_override_01] \
  [get_bd_pins mrmac_0/ctl_tx_send_idle_in_0] \
  [get_bd_pins mrmac_0/ctl_tx_send_lfi_in_0] \
  [get_bd_pins mrmac_0/ctl_tx_send_rfi_in_0] \
  [get_bd_pins mrmac_0/ctl_tx_send_idle_in_1] \
  [get_bd_pins mrmac_0/ctl_tx_send_lfi_in_1] \
  [get_bd_pins mrmac_0/ctl_tx_send_rfi_in_1] \
  [get_bd_pins mrmac_0/ctl_tx_lane0_vlm_bip7_override_23] \
  [get_bd_pins mrmac_0/ctl_tx_send_idle_in_2] \
  [get_bd_pins mrmac_0/ctl_tx_send_lfi_in_2] \
  [get_bd_pins mrmac_0/ctl_tx_send_rfi_in_2] \
  [get_bd_pins mrmac_0/ctl_tx_send_idle_in_3] \
  [get_bd_pins mrmac_0/ctl_tx_send_lfi_in_3] \
  [get_bd_pins mrmac_0/ctl_tx_send_rfi_in_3] \
  [get_bd_pins mrmac_0/tx_flex_almarker0] \
  [get_bd_pins mrmac_0/tx_flex_almarker1] \
  [get_bd_pins mrmac_0/tx_flex_almarker2] \
  [get_bd_pins mrmac_0/tx_flex_almarker3] \
  [get_bd_pins mrmac_0/tx_flex_almarker4] \
  [get_bd_pins mrmac_0/tx_flex_almarker5] \
  [get_bd_pins mrmac_0/tx_flex_almarker6] \
  [get_bd_pins mrmac_0/tx_flex_almarker7] \
  [get_bd_pins mrmac_0/tx_flex_ena_0] \
  [get_bd_pins mrmac_0/tx_flex_ena_1] \
  [get_bd_pins mrmac_0/tx_flex_ena_2] \
  [get_bd_pins mrmac_0/tx_flex_ena_3] \
  [get_bd_pins mrmac_0/rx_flex_cm_ena_0] \
  [get_bd_pins mrmac_0/rx_flex_cm_ena_1] \
  [get_bd_pins mrmac_0/rx_flex_cm_ena_2] \
  [get_bd_pins mrmac_0/rx_flex_cm_ena_3]
  connect_bd_net -net mrmac_pm_tick_drive_zero_dout  [get_bd_pins mrmac_pm_tick_drive_zero/dout] \
  [get_bd_pins mrmac_0/pm_tick]
  connect_bd_net -net mrmac_tx_preamble_value_dout  [get_bd_pins mrmac_tx_preamble_value/dout] \
  [get_bd_pins mrmac_0/tx_preamblein_0] \
  [get_bd_pins mrmac_0/tx_preamblein_1] \
  [get_bd_pins mrmac_0/tx_preamblein_2] \
  [get_bd_pins mrmac_0/tx_preamblein_3]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins versal_cips_0/pl0_ref_clk] \
  [get_bd_pins mrmac_0/s_axi_aclk] \
  [get_bd_pins GT_WRAPPER/s_axi_aclk_0] \
  [get_bd_pins CLK_RST_WRAPPER/s_axi_lite_aclk] \
  [get_bd_pins versal_cips_0/m_axi_fpd_aclk] \
  [get_bd_pins subsys_axi_ctl_smartconnect/aclk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/s_axi_lite_aclk] \
  [get_bd_pins axis_vio_0/clk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins CLK_RST_WRAPPER/axi_lite_perpheral_resetn] \
  [get_bd_pins mrmac_0/s_axi_aresetn] \
  [get_bd_pins GT_WRAPPER/s_axi_aresetn_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/s_axis_aresetn]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk  [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi1_clk  [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk] \
  [get_bd_pins axi_noc_0/aclk6]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] \
  [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] \
  [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] \
  [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk  [get_bd_pins versal_cips_0/lpd_axi_noc_clk] \
  [get_bd_pins axi_noc_0/aclk7]
  connect_bd_net -net versal_cips_0_pl0_resetn  [get_bd_pins versal_cips_0/pl0_resetn] \
  [get_bd_pins CLK_RST_WRAPPER/pl0_resetn]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk  [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net xlconstant_128b0_dout  [get_bd_pins xlconstant_128b0/dout] \
  [get_bd_pins mrmac_0/ctl_rsvd_in]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S07_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0xA4060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA40A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_reset_mask/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/gt_quad_base/AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW0x2] -force


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


