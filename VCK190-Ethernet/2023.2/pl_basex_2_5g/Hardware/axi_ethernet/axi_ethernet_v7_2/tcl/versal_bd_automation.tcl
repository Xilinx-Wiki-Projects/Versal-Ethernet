# (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of AMD and is protected under U.S. and international copyright
# and other intellectual property laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# AMD, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) AMD shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or AMD had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# AMD products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of AMD products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
############################################################
proc create_unet_name {cell pin} {
 set cell_name [get_property NAME $cell]
 return [bd::gt_utils::create_unique_name ${cell_name}_${pin}] 
}

proc bd_automation {parentCell} {
   set parent_name      [get_property NAME $parentCell]
   set quadsConnected   [::bd::gt_utils::get_sorted_quad_cells $parentCell]
   set Cur_Proj_family  [string tolower [get_property ARCHITECTURE [get_property PART [current_project]]]]
   set phy_type         [string tolower [get_property CONFIG.PHY_TYPE  $parentCell]]
   set c_is_sgmii       [string equal -nocase "sgmii"     $phy_type]
   set c_is_1gbx        [string equal -nocase "1000basex" $phy_type]
   set c_is_both        [string equal -nocase "both"      $phy_type]
   set maxdatarate      [get_property CONFIG.speed_1_2p5  $parentCell]
   set enable_avb       [get_property CONFIG.ENABLE_AVB   $parentCell]
   set enable_1588      [get_property CONFIG.Enable_1588  $parentCell]
   set enable_Lvds      [get_property CONFIG.ENABLE_LVDS  $parentCell]
   set en_pfc           [get_property CONFIG.Enable_Pfc   $parentCell]
   set processor_mode   [get_property CONFIG.processor_mode $parentCell]
   set gt_in_exd        [get_property CONFIG.GTinEx         $parentCell]
      
   
   
   if {(($Cur_Proj_family eq "versal")  || ($Cur_Proj_family eq "versales1") || ($Cur_Proj_family eq "versaleaes1")  || ($Cur_Proj_family eq "everestea"))} {
      if {($c_is_sgmii || $c_is_1gbx || $c_is_both) && $gt_in_exd && !$enable_Lvds} {
         
         set bCheckIPs 1
         if { $bCheckIPs == 1 } {
            set list_check_ips "\ 
            xilinx.com:ip:axi_ethernet:7.2\
            xilinx.com:ip:bufg_gt:1.0\
            xilinx.com:ip:util_ds_buf:2.2\
            xilinx.com:ip:gt_quad_base:1.1\
            "
            set list_ips_missing ""
            common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."
         
            foreach ip_vlnv $list_check_ips {
               set ip_obj [get_ipdefs -all $ip_vlnv]
               if { $ip_obj eq "" } {
                  lappend list_ips_missing $ip_vlnv
               }
            }

            if { $list_ips_missing ne "" } {
               catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
               set bCheckIPsPassed 0
            }
         }
	 
	 ungroup_bd_cells [get_bd_cells GT_Quad_and_Clk]
         set tx_pin [bd::gt_utils::find_connected_pin [get_bd_intf_pins -quiet ${parentCell}/* -filter "VLNV=~ xilinx.com:interface:gt_tx_interface_rtl:1.0"]]
         set gt_quad [::bd::gt_utils::find_connected_core [get_bd_intf_pins $parentCell/gt_tx_interface]]
         set quad_phier [::bd::utils::get_parent $gt_quad]
         set axie_phier [::bd::utils::get_parent $parentCell]
         set lane_idx ""
         regexp "TX(.)_GT_IP_Interface" [get_property NAME $tx_pin]  -> lane_idx
         
         set gt_rxoutclk [get_bd_pins  -of_objects $gt_quad -filter "NAME == ch${lane_idx}_rxoutclk" ]
         set gt_txoutclk [get_bd_pins  -of_objects $gt_quad -filter "NAME == ch${lane_idx}_txoutclk" ]
         set gt_rxusrclk [get_bd_pins  -of_objects $gt_quad -filter "NAME == ch${lane_idx}_rxusrclk" ]
         set gt_txusrclk [get_bd_pins  -of_objects $gt_quad -filter "NAME == ch${lane_idx}_txusrclk" ]
         
         set bufg_rxclk [get_bd_cells -of_objects [bd::gt_utils::find_connected_pin $gt_rxusrclk] -filter "VLNV=~ xilinx.com:ip:bufg_gt:*" ]
         set bufg_txclk2 [get_bd_cells -of_objects [bd::gt_utils::find_connected_pin $gt_txusrclk] -filter "VLNV=~ xilinx.com:ip:bufg_gt:*" ]
         set bufg_txclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 [bd::gt_utils::create_unique_name bufg_gt] ]
         set bufg_rxclk2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 [bd::gt_utils::create_unique_name bufg_gt] ] 
         
             
        
         
         set rxuserclk2_0 [ create_bd_port -dir O -type clk [bd::gt_utils::create_unique_portname rxuserclk2] ]
         
         set rxuserclk_0 [ create_bd_port -dir O -type clk  [bd::gt_utils::create_unique_portname rxuserclk] ]
         
         
         set userclk2_0 [ create_bd_port -dir O -type clk  [bd::gt_utils::create_unique_portname userclk2] ]
         
         set userclk_0 [ create_bd_port -dir O -type clk [bd::gt_utils::create_unique_portname  userclk] ]
         
         if { $maxdatarate == "2p5G" } {
             set_property -dict [ list CONFIG.FREQ_HZ {156250000}  ] $bufg_txclk
             set_property -dict [ list CONFIG.FREQ_HZ {312500000}  ] $bufg_txclk2
             set_property -dict [ list CONFIG.FREQ_HZ {156250000}  ] $bufg_rxclk
             set_property -dict [ list CONFIG.FREQ_HZ {156250000}  ] $bufg_rxclk2
             set_property -dict [ list CONFIG.FREQ_HZ {156250000} ] $rxuserclk2_0
             set_property -dict [ list CONFIG.FREQ_HZ {156250000} ] $rxuserclk_0
             set_property -dict [ list CONFIG.FREQ_HZ {312500000} ] $userclk2_0
             set_property -dict [ list  CONFIG.FREQ_HZ {156250000}  ] $userclk_0
         } else {
             set_property -dict [ list CONFIG.FREQ_HZ {62500000}  ] $bufg_txclk
             set_property -dict [ list CONFIG.FREQ_HZ {125000000}  ] $bufg_txclk2
             set_property -dict [ list CONFIG.FREQ_HZ {62500000}  ] $bufg_rxclk
             set_property -dict [ list CONFIG.FREQ_HZ {62500000}  ] $bufg_rxclk2
             set_property -dict [ list CONFIG.FREQ_HZ {62500000} ] $rxuserclk2_0
             set_property -dict [ list CONFIG.FREQ_HZ {62500000} ] $rxuserclk_0
             set_property -dict [ list CONFIG.FREQ_HZ {125000000} ] $userclk2_0
             set_property -dict [ list  CONFIG.FREQ_HZ {62500000}  ] $userclk_0
         }
         set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 [bd::gt_utils::create_unique_name xlconstant] ]
         set_property -dict [ list CONFIG.CONST_WIDTH {3} ] $xlconstant_2
         set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 [bd::gt_utils::create_unique_name xlconstant] ]
         set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 [bd::gt_utils::create_unique_name xlconstant] ]
         set_property -dict [ list CONFIG.CONST_VAL {0} ] $xlconstant_1
         
         
         

         #set rx_gtreset_vars [bd::gt_utils::create_unique_portname gtwiz_reset_rx_done_in_0]
         #create_bd_port -dir I $rx_gtreset_vars
         #set tx_gtreset_vars [bd::gt_utils::create_unique_portname gtwiz_reset_tx_done_in_0]
         #create_bd_port -dir I $tx_gtreset_vars
         ## Move Cells out of hierarchical blocks if any
         if { $axie_phier != "" } { 
             move_bd_cells / $parentCell $bufg_txclk2 $bufg_rxclk
         }
         if { $quad_phier != ""} {
             move_bd_cells / $gt_quad
         }
         if { ($axie_phier != "") || ($quad_phier != "") } {
             common::send_msg_id "BD_TCL-006" "INFO" "Moved cells out of hierarchies."
         }
            
          
          
         
         connect_bd_net  [get_bd_pins -of [list $bufg_rxclk $bufg_rxclk2 $bufg_txclk $bufg_txclk2] \
         -filter { NAME =~ gt_bufgtce* || NAME == gt_bufgtclrmask } ] [get_bd_pins $xlconstant_0/dout]
         
         connect_bd_net  [get_bd_pins -of [list $bufg_rxclk $bufg_rxclk2 $bufg_txclk $bufg_txclk2] \
         -filter { NAME == gt_bufgtclr } ] [get_bd_pins $xlconstant_1/dout] 
         
         connect_bd_net  [get_bd_pins $bufg_txclk/gt_bufgtdiv] [get_bd_pins $xlconstant_2/dout]
         
         connect_bd_net -quiet [get_bd_pins $parentCell/gtwiz_reset_rx_done_in] [get_bd_pins $gt_quad/ch${lane_idx}_rxprogdivresetdone] 
         connect_bd_net -quiet [get_bd_pins $parentCell/gtwiz_reset_tx_done_in] [get_bd_pins $gt_quad/ch${lane_idx}_txprogdivresetdone]
       
         delete_bd_objs [get_bd_nets -hier -of $gt_txusrclk ] 
         delete_bd_objs [get_bd_nets -hier -of $gt_rxusrclk ] 
         
         connect_bd_net [get_bd_pins $parentCell/userclk2] [get_bd_pins ${bufg_txclk2}/usrclk] [get_bd_ports $userclk2_0]
         connect_bd_net $gt_txusrclk [get_bd_pins $parentCell/userclk] [get_bd_pins ${bufg_txclk}/usrclk] [get_bd_ports $userclk_0] 
         if { $c_is_sgmii || $enable_1588 || $c_is_both } {
           connect_bd_net [get_bd_pins $parentCell/rxuserclk2] [get_bd_pins ${bufg_rxclk2}/usrclk] [get_bd_ports $rxuserclk2_0] 
           connect_bd_net $gt_rxusrclk [get_bd_pins $parentCell/rxuserclk] [get_bd_pins ${bufg_rxclk}/usrclk] [get_bd_ports $rxuserclk_0]
         } else {
           connect_bd_net $gt_rxusrclk [get_bd_pins ${bufg_txclk}/usrclk] 
           connect_bd_net [get_bd_ports $rxuserclk2_0] [get_bd_pins ${bufg_rxclk2}/usrclk] [get_bd_pins $parentCell/rxuserclk2] 
           connect_bd_net [get_bd_ports $rxuserclk_0] [get_bd_pins ${bufg_rxclk}/usrclk] [get_bd_pins $parentCell/rxuserclk]
         }
         
         connect_bd_net $gt_txoutclk [get_bd_pins ${bufg_txclk}/outclk]
         connect_bd_net $gt_rxoutclk [get_bd_pins ${bufg_rxclk2}/outclk]
        
         connect_bd_net   [get_bd_pins $gt_quad/gtpowergood] [get_bd_pins $parentCell/gtpowergood_in]
         ##Move cells back to hierarchical blocks
         
         if { $quad_phier != ""} {
             move_bd_cells $quad_phier $gt_quad $bufg_rxclk $bufg_rxclk2 $bufg_txclk $bufg_txclk2 \
             $xlconstant_0 $xlconstant_1 $xlconstant_2
         }
         if { $axie_phier != "" } {
             move_bd_cells $axie_phier $parentCell 
         }
         if { ($axie_phier != "") || ($quad_phier != "") } {
             common::send_msg_id "BD_TCL-006" "INFO" "Moved Cells into previous hierarchies."
         }
         
         ##AXI External pins
         if {($c_is_1gbx || $c_is_sgmii || $c_is_both)} {  
            make_bd_pins_external  [get_bd_pins  $parentCell/signal_detect]
            if {!$processor_mode} {  
               make_bd_pins_external  [get_bd_pins  $parentCell/status_vector]
            }  
         }  
         make_bd_intf_pins_external [get_bd_intf_pins $parentCell/s_axi]
         make_bd_pins_external  [get_bd_pins  $parentCell/cplllock_in]
         make_bd_pins_external  [get_bd_pins  $parentCell/mmcm_locked]
         #make_bd_pins_external  [get_bd_pins  $parentCell/userclk]
         #make_bd_pins_external  [get_bd_pins  $parentCell/userclk2]
         #make_bd_pins_external  [get_bd_pins  $parentCell/rxuserclk]
         #make_bd_pins_external  [get_bd_pins  $parentCell/rxuserclk2]
         make_bd_pins_external  [get_bd_pins  $parentCell/s_axi_lite_clk]
         make_bd_pins_external  [get_bd_pins  $parentCell/s_axi_lite_resetn]
         make_bd_pins_external  [get_bd_pins  $parentCell/ref_clk]
         make_bd_pins_external  [get_bd_pins  $parentCell/mac_irq]
         make_bd_pins_external  [get_bd_pins  $parentCell/mmcm_reset_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/rx8b10ben_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/tx8b10ben_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/rxcommadeten_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/rxmcommaalignen_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/rxpcommaalignen_out]
         make_bd_pins_external  [get_bd_pins  $parentCell/pma_reset]

         if {!($c_is_1gbx && !$enable_Lvds)} {  
            make_bd_pins_external  [get_bd_pins  $parentCell/mdio_mdc] 
            make_bd_pins_external  [get_bd_pins  $parentCell/mdio_mdio_i] 
            make_bd_pins_external  [get_bd_pins  $parentCell/mdio_mdio_o] 
            make_bd_pins_external  [get_bd_pins  $parentCell/mdio_mdio_t]
         }  

         if { !$c_is_1gbx } {  
            make_bd_pins_external  [get_bd_pins  $parentCell/phy_rst_n]
         }  

         if {$processor_mode} {  
            make_bd_pins_external  [get_bd_pins  $parentCell/axis_clk] 
            make_bd_pins_external  [get_bd_pins  $parentCell/axi_txd_arstn]
            make_bd_pins_external  [get_bd_pins  $parentCell/axi_txc_arstn]
            make_bd_pins_external  [get_bd_pins  $parentCell/axi_rxd_arstn]
            make_bd_pins_external  [get_bd_pins  $parentCell/axi_rxs_arstn]
            make_bd_intf_pins_external  [get_bd_intf_pins $parentCell/s_axis_txd]
            make_bd_intf_pins_external  [get_bd_intf_pins $parentCell/s_axis_txc]
            make_bd_intf_pins_external  [get_bd_intf_pins $parentCell/m_axis_rxd]
            make_bd_intf_pins_external  [get_bd_intf_pins $parentCell/m_axis_rxs]
         } else {  
            make_bd_pins_external  [get_bd_pins  $parentCell/tx_mac_aclk] 
            make_bd_pins_external  [get_bd_pins  $parentCell/rx_mac_aclk]
            make_bd_pins_external  [get_bd_pins  $parentCell/glbl_rst]
            make_bd_pins_external  [get_bd_pins  $parentCell/tx_ifg_delay] 
            make_bd_intf_pins_external  [get_bd_intf_pins  $parentCell/m_axis_rx]
            make_bd_intf_pins_external  [get_bd_intf_pins  $parentCell/s_axis_tx]
            make_bd_intf_pins_external  [get_bd_intf_pins  $parentCell/s_axis_pause]
         }  

         if {$enable_1588} {  
            make_bd_pins_external  [get_bd_pins  $parentCell/systemtimer_clk] 
            make_bd_pins_external  [get_bd_pins  $parentCell/systemtimer_s_field] 
            make_bd_pins_external  [get_bd_pins  $parentCell/systemtimer_ns_field]
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_dclk_in] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_drdy_in] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_gnt_in] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_do_in] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_den_out] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_di_out] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_dwe_out] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_req_out] 
            make_bd_pins_external  [get_bd_pins  $parentCell/drp_daddr_out] 
         }  

         if {$enable_avb} {  
            make_bd_intf_pins_external  [get_bd_intf_pins  $parentCell/s_axis_tx_av]
            make_bd_intf_pins_external  [get_bd_intf_pins  $parentCell/m_axis_rx_av]
            make_bd_pins_external  [get_bd_pins  $parentCell/avb_tx_clk]
            make_bd_pins_external  [get_bd_pins  $parentCell/avb_rx_clk]  
         }  

         if {$en_pfc} {  
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc0_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc1_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc2_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc3_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc4_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc5_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc6_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/s_axis_tx_pfc7_tvalid]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc0_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc1_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc2_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc3_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc4_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc5_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc6_tready]
            make_bd_pins_external  [get_bd_pins  $parentCell/m_axis_rx_pfc7_tready]
         }

         ##GT QUAD external ports
         make_bd_pins_external  [get_bd_pins $gt_quad/apb3clk]
         
         
          

      }
   }
}

