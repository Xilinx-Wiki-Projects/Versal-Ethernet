# (c) Copyright 2012-2014, 2023 Advanced Micro Devices, Inc. All rights reserved.
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
#
###################################################################################################################################
##
## axi_ethernet_v7_2/bd/bd.tcl
##
################################################################################################################################>->

proc post_config_ip {cellpath otherInfo} {
   set axi_eth_sys       [get_bd_cells $cellpath]
   set phy_type          [string tolower [get_property CONFIG.PHY_TYPE  $axi_eth_sys]]
   set Enable_LVDS       [get_property CONFIG.ENABLE_LVDS $axi_eth_sys] 
   set Cur_Proj_family   [string tolower [get_property ARCHITECTURE [get_property PART [current_project]]]]
   set refclkrate        [get_property CONFIG.gtrefclkrate $axi_eth_sys]
   set maxdatarate       [get_property CONFIG.speed_1_2p5  $axi_eth_sys]
   set gt_in_ed          [get_property CONFIG.GTinEx $axi_eth_sys]
   set Gt_type           [get_property CONFIG.gt_type $axi_eth_sys]
   set c_is_sgmii        [string equal -nocase "sgmii"     $phy_type]
   set c_is_1gbx         [string equal -nocase "1000basex" $phy_type]
   set c_is_both         [string equal -nocase "both" $phy_type]
   set c_1588_en         [get_property CONFIG.Enable_1588 $axi_eth_sys]
   set project_part      [get_property board_part [current_project]]
   
   if { $project_part ne "" } {
      set add_settings [dict create GT_TYPE $Gt_type BOARD_INTERFACE true]
   } else {
      set add_settings [dict create GT_TYPE $Gt_type BOARD_INTERFACE false]
   }


   if {(($Cur_Proj_family eq "versal")  || ($Cur_Proj_family eq "versales1") || ($Cur_Proj_family eq "versaleaes1")  || ($Cur_Proj_family eq "everestea"))} {

      if { $c_is_sgmii || $c_is_1gbx || $c_is_both } {

         if { $Enable_LVDS == "false" } {

         source [::bd::get_vlnv_dir xilinx.com:ip:gt_quad_base:1.1]/tcl/params.tcl

         if { $maxdatarate == "2p5G" } {
            set INT_SETTINGS_2P5G [dict create]
               set INT_SETTINGS_2P5G "TX_LINE_RATE 3.125 TX_PLL_TYPE LCPLL TXPROGDIV_FREQ_VAL 312.500 RX_LINE_RATE 3.125 RX_PLL_TYPE LCPLL RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_VAL 156.250" 
            if { $c_is_sgmii || $c_is_both || $c_1588_en } {
               set INT_SETTINGS_2P5G_SGMII [dict merge $INT_SETTINGS_2P5G [dict create TX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_REFCLK_FREQUENCY $refclkrate] [dict create RX_BUFFER_MODE 0] [dict create RX_BUFFER_BYPASS_MODE_LANE "SINGLE"] [dict create TX_BUFFER_MODE [expr !$c_1588_en]]]
               set IP_2P5G_SETTINGS_LR0 [dict create LR0 $INT_SETTINGS_2P5G_SGMII]
            } elseif { $c_is_1gbx } {
               set INT_SETTINGS_2P5G_BASEX [dict merge $INT_SETTINGS_2P5G [dict create TX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_REFCLK_FREQUENCY $refclkrate] [dict create RX_BUFFER_MODE 1]]
               set IP_2P5G_SETTINGS_LR0 [dict create LR0 $INT_SETTINGS_2P5G_BASEX]
            }

            set IP_TX_SETTINGS_LR0 [dict get [get_GT_string "$Gt_type-Ethernet_2_5G" $IP_2P5G_SETTINGS_LR0 "TX"] LR0_SETTINGS]
            set IP_RX_SETTINGS_LR0 [dict get [get_GT_string "$Gt_type-Ethernet_2_5G" $IP_2P5G_SETTINGS_LR0 "RX"] LR0_SETTINGS]

         } 
         ######################
         if { $maxdatarate == "1G" } {

         set INT_SETTINGS_1G [dict create]
         set INT_SETTINGS_1G "TX_PLL_TYPE LCPLL TXPROGDIV_FREQ_VAL 125.000 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 62.500" 

         if { $c_is_sgmii  || $c_is_both || $c_1588_en } {
            set INT_SETTINGS_1G_SGMII [dict merge $INT_SETTINGS_1G [dict create TX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_BUFFER_MODE 0] [dict create RX_BUFFER_BYPASS_MODE_LANE "SINGLE"] [dict create TX_BUFFER_MODE [expr !$c_1588_en]]]
            set IP_1G_SETTINGS_LR0 [dict create LR0 $INT_SETTINGS_1G_SGMII]
         } elseif { $c_is_1gbx  } {
            set INT_SETTINGS_1G_BASEX [dict merge $INT_SETTINGS_1G [dict create TX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_REFCLK_FREQUENCY $refclkrate]  [dict create RX_BUFFER_MODE 1]]
            set IP_1G_SETTINGS_LR0 [dict create LR0 $INT_SETTINGS_1G_BASEX]
         }

            set IP_TX_SETTINGS_LR0 [dict get [get_GT_string "$Gt_type-Ethernet_1G" $IP_1G_SETTINGS_LR0 "TX"] LR0_SETTINGS]
            set IP_RX_SETTINGS_LR0 [dict get [get_GT_string "$Gt_type-Ethernet_1G" $IP_1G_SETTINGS_LR0 "RX"] LR0_SETTINGS]
         }

           set TX_SETTINGS_DICT [dict create LR0_SETTINGS $IP_TX_SETTINGS_LR0]
           set RX_SETTINGS_DICT [dict create LR0_SETTINGS $IP_RX_SETTINGS_LR0]

              set pid [get_property CONFIG.Component_Name $axi_eth_sys]

               set txHandle [get_bd_intf_pins $axi_eth_sys/gt_tx_interface]
                   set_property CONFIG.PARENT_ID ${pid}_0 $txHandle
                   set_property CONFIG.CHNL_NUMBER 0  $txHandle
                   set_property CONFIG.MASTERCLK_SRC 1 $txHandle
                   set_property CONFIG.GT_DIRECTION "DUPLEX" $txHandle
                   set_property CONFIG.TX_SETTINGS $TX_SETTINGS_DICT $txHandle
                   set_property CONFIG.ADDITIONAL_QUAD_SETTINGS $add_settings $txHandle

               set rxHandle [get_bd_intf_pins $axi_eth_sys/gt_rx_interface]
                   set_property CONFIG.PARENT_ID ${pid}_0 $rxHandle
                   set_property CONFIG.MASTERCLK_SRC 1 $rxHandle
                   set_property CONFIG.CHNL_NUMBER 0  $rxHandle
                   set_property CONFIG.GT_DIRECTION "DUPLEX" $rxHandle
                   set_property CONFIG.RX_SETTINGS $RX_SETTINGS_DICT $rxHandle
                   set_property CONFIG.ADDITIONAL_QUAD_SETTINGS $add_settings $rxHandle
                   
         }
      }
   }
}


##---------------------------------------------------------------------------------------------------------------------------------
# start section: propagate procs  ###<-<
##---------------------------------------------------------------------------------------------------------------------------------
#####################proc post_propagate {cell args} {
#####################   set axi_eth_sys [get_bd_cells $cell]
#####################
#####################    set Cur_Proj_FAMILY  [string tolower [xit::get_project_property FAMILY          ]]
#####################    set Phy_Type         [string tolower [get_property CONFIG.PHY_TYPE  $axi_eth_sys]]
#####################    set Enable_Lvds      [get_property CONFIG.ENABLE_LVDS           $axi_eth_sys     ]
#####################
#####################    if {("sgmii" == $Phy_Type) || ("1000basex" == $Phy_Type)} {set Is_Sgmii_or_1000Bx 1} else {set Is_Sgmii_or_1000Bx 0}
#####################    if {[regexp virtexu $Cur_Proj_FAMILY]} { set family_is_virtexu 1 } else { set family_is_virtexu 0 }
#####################    if {[regexp kintexu $Cur_Proj_FAMILY]} { set family_is_kintexu 1 } else { set family_is_kintexu 0 }
#####################
#####################    if { ($family_is_kintexu || $family_is_virtexu ) && $Is_Sgmii_or_1000Bx && !$Enable_Lvds && !$drp_en } {
#####################        set ref_clk_freq [get_property -quiet CONFIG.FREQ_HZ  [get_bd_pin -quiet ${axi_eth_sys}/ref_clk]]
#####################        if {($ref_clk_freq != "")} {
#####################            set drpclkrate [expr $ref_clk_freq /1000000.0]
#####################        } else {
#####################            set drpclkrate 50.0
#####################        }
#####################        set_property -quiet CONFIG.drpclkrate  $drpclkrate      $axi_eth_sys 
#####################    }
#####################}
#####################
#####################proc propagate {cell args} {
##################### puts "+++++++++++  enabled propagate proc ++++++++++++++++++++++++++++++++++++++++++++++++"
#####################    set axi_eth_sys [get_bd_cells $cell]
#####################
#####################    set Cur_Proj_ARCH   [string tolower [get_property ARCHITECTURE [get_property PART [current_project]]]] 
#####################    set Phy_Type        [string tolower  [get_property CONFIG.PHY_TYPE  $axi_eth_sys]]
#####################    set SupportLevel    [get_property CONFIG.SupportLevel    $axi_eth_sys            ]
#####################    set gt_in_exd       [get_property CONFIG.GTinEx          $axi_eth_sys            ]
#####################    set Enable_Lvds     [get_property CONFIG.ENABLE_LVDS     $axi_eth_sys            ]
#####################    if {("sgmii" == $Phy_Type) || ("1000basex" == $Phy_Type)} {set Is_Sgmii_or_1000Bx 1} else {set Is_Sgmii_or_1000Bx 0}
#####################    if {([string match kintexu $Cur_Proj_ARCH]) || ([string match virtexu $Cur_Proj_ARCH])} { set device_is_uscale 1 } else { set device_is_uscale 0}
#####################    if {([regexp uplus $Cur_Proj_ARCH])} { set device_is_usplus 1 } else { set device_is_usplus 0}
#####################    if {$device_is_usplus || $device_is_uscale} {set device_is_us 1} else {set device_is_us 0}
#####################
#####################    set gtrefclkport [get_bd_pins -quiet $axi_eth_sys/gtref_clk]
#####################    ### puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################    ### puts  " $Cur_Proj_ARCH $device_is_us $Phy_Type        $SupportLevel    $gt_in_exd       $Enable_Lvds    $gtrefclkport "
#####################    ### puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################
#####################    if {($Is_Sgmii_or_1000Bx &&  !$Enable_Lvds  && !$SupportLevel && !$gt_in_exd && $device_is_us && ($gtrefclkport != ""))} {
#####################        if { [get_property CONFIG.gtrefclkrate.VALUE_SRC $axi_eth_sys] == "USER" } {
#####################        } else {
#####################            set src_pin  [get_bd_pins  -of [get_bd_nets -of [get_bd_pins $gtrefclkport] ] -filter {DIR == O}]
#####################            set src_port [get_bd_ports -of [get_bd_nets -of [get_bd_pins $gtrefclkport] ] -filter {DIR == I}]
#####################            puts   " ++++++ output pins:  $src_pin ports: $src_port"
#####################            ### puts   "   all nets [get_bd_nets -of [get_bd_pins $gtrefclkport] ]"
#####################            ### puts   "     all pins of nets  [get_bd_pins -of [get_bd_nets -of [get_bd_pins $gtrefclkport] ]]"
#####################            ### puts   "         first pins is [lindex [get_bd_pins -of [get_bd_nets -of [get_bd_pins $gtrefclkport] ]] 0 ] "
#####################
#####################            set ref_clk_freq [get_property -quiet CONFIG.FREQ_HZ [get_bd_pins  -quiet $src_pin ]][get_property -quiet CONFIG.FREQ_HZ [get_bd_ports -quiet $src_port]]
#####################            set ref_clk_conf [get_property  CONFIG.gtrefclkrate  [get_bd_cells ${axi_eth_sys}]]
#####################
#####################            if { [expr {$ref_clk_freq == ($ref_clk_conf * 1000000)}] } {
#####################            puts   "No need to update ref clk freq"
#####################            } else {
#####################                set_property CONFIG.FREQ_HZ $ref_clk_freq  $gtrefclkport
#####################                puts  "setting FREQ_HZ of pin:$src_pin or port: $src_port to $gtrefclkport with value $ref_clk_freq "
#####################                if {       [expr {$ref_clk_freq == 250000000}] } { set_property  CONFIG.gtrefclkrate "250"      [get_bd_cells ${axi_eth_sys}]
#####################                } elseif { [expr {$ref_clk_freq == 156250000}] } { set_property  CONFIG.gtrefclkrate "156.25"   [get_bd_cells ${axi_eth_sys}]
#####################                } elseif { [expr {$ref_clk_freq == 125000000}] } { set_property  CONFIG.gtrefclkrate "125"      [get_bd_cells ${axi_eth_sys}]
#####################                } elseif { [expr {$ref_clk_freq == 312500000}] } { set_property  CONFIG.gtrefclkrate "312.5"    [get_bd_cells ${axi_eth_sys}]
#####################                } elseif { [expr {$ref_clk_freq == 100000000}] } {
#####################                } else {
#####################                    puts  " gtrefclkrate $ref_clk_freq is not in valid range for port $gtrefclkport"
#####################                }
#####################            }
#####################        }
#####################    } else {
#####################        puts   "in else of the condition to update ref clk freq"
#####################    }
#####################    puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################    puts  "+++++++++++AXI streaming clk update function                  ++++++++++++++++++++++++++++++++++++++++"
#####################    puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################
#####################    if { [get_property CONFIG.axisclkrate.VALUE_SRC $axi_eth_sys] == "USER" } {
#####################                puts  "in user mode                          "
#####################    } else {
#####################        set src_pin  [get_bd_pins -quiet -of [get_bd_nets -quiet -of [get_bd_pins -quiet $axi_eth_sys/axis_clk] ] -filter {DIR == O}]
#####################        set src_port [get_bd_ports -quiet -of [get_bd_nets -quiet -of [get_bd_pins -quiet $axi_eth_sys/axis_clk] ] -filter {DIR == I}]
#####################        if {$src_pin == "" && $src_port == "" } {
#####################            puts  "no source pins found"
#####################        } else {
#####################            set axis_clk_freq "[get_property -quiet CONFIG.FREQ_HZ  [get_bd_pins -quiet $src_pin ]][get_property -quiet CONFIG.FREQ_HZ  [get_bd_ports -quiet $src_port ]]"
#####################            set axis_clk_rate [get_property  CONFIG.axisclkrate  [get_bd_cells ${axi_eth_sys}]]
#####################            if {[expr {$axis_clk_freq == ($axis_clk_rate * 1000000)}]} {
#####################                puts  "no update required for axis clk                           "
#####################            } else {
#####################                puts  " updating axis clk                           "
#####################                puts   " 131 - set_property  CONFIG.axisclkrate [expr {$axis_clk_freq / 1000000} ] [get_bd_cells $axi_eth_sys] "
#####################                set_property  CONFIG.axisclkrate [expr {$axis_clk_freq / 1000000} ] [get_bd_cells ${axi_eth_sys}]
#####################                ## querys outside pins and not inside nets/ pins.
#####################                ##set src_pins  [get_bd_pins -quiet  ${axi_eth_sys}/eth_buf/*STR*ACLK ]
#####################                ##puts "the pins are $src_pins " 
#####################                ##foreach pinl $src_pins {
#####################                ##    puts  " 45 - set_property CONFIG.FREQ_HZ   $axis_clk_freq   [get_bd_pins $pinl] "
#####################                ##    set_property CONFIG.FREQ_HZ   $axis_clk_freq   [get_bd_pins $pinl]
#####################                ##}
#####################            }
#####################        }
#####################    }
#####################    puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################    puts  "+++++++++++AXI Lite update function    axiliteclkrate         ++++++++++++++++++++++++++++++++++++++++"
#####################    puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################
#####################    if { [get_property CONFIG.axiliteclkrate.VALUE_SRC $axi_eth_sys] == "USER" } {
#####################                puts  "in user mode     "
#####################    } else {
#####################        set src_pin  [get_bd_pins -quiet -of [get_bd_nets -quiet -of [get_bd_pins -quiet $axi_eth_sys/s_axi_lite_clk] ] -filter {DIR == O}]
#####################        set src_port [get_bd_ports -quiet -of [get_bd_nets -quiet -of [get_bd_pins -quiet $axi_eth_sys/s_axi_lite_clk] ] -filter {DIR == I}]
#####################        if {$src_pin == "" && $src_port == "" } {
#####################            puts  "no source pins found"
#####################        } else {
#####################            set axil_clk_freq "[get_property -quiet CONFIG.FREQ_HZ  [get_bd_pins -quiet $src_pin ]][get_property -quiet CONFIG.FREQ_HZ  [get_bd_ports -quiet $src_port ]]"
#####################            set axil_clk_rate [get_property  CONFIG.axiliteclkrate  [get_bd_cells ${axi_eth_sys}]]
#####################            if {[expr {$axil_clk_freq == ($axil_clk_rate * 1000000)}]} {
#####################                puts  "no update required for axil clk  $axil_clk_freq == $axil_clk_rate                         "
#####################            } else {
#####################                puts  " updating axil clk    $axil_clk_freq == $axil_clk_rate                            "
#####################                puts   " 161 - set_property  CONFIG.axiliteclkrate [expr {$axil_clk_freq / 1000000} ] [get_bd_cells $axi_eth_sys] "
#####################                set_property  CONFIG.axiliteclkrate [expr {$axil_clk_freq / 1000000} ] [get_bd_cells ${axi_eth_sys}]
#####################            }
#####################        }
#####################    }
#####################    puts  "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#####################}
#####################
#####################proc post_config_ip {cell args} {
#####################    set axi_eth_sys [get_bd_cells $cell]
#####################}
#####################
#####################proc init {cell args} {
#####################    set axi_eth_sys [get_bd_cells $cell]
#####################    set paramList "gtrefclkrate drpclkrate lvdsclkrate axiliteclkrate axisclkrate  "
#####################    bd::mark_propagate_overrideable $axi_eth_sys $paramList
#####################}
#####################
##---------------------------------------------------------------------------------------------------------------------------------
# End section  propagate procs ###>->
##---------------------------------------------------------------------------------------------------------------------------------

