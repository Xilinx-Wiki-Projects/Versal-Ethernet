################################################################################<-<
##
# (c) Copyright 2012-2013 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property laws. 
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by Xilinx, and to the maximum extent permitted by applicable law:
# (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND
# CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of liability) for any loss or damage of any kind or nature related to,
# arising under or in connection with these materials, including for any direct, or any indirect, special, incidental, or
# consequential loss or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered as a
# result of any action brought by a third party) even if such damage or loss was reasonably foreseeable or Xilinx had
# been advised of the possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any other applications that could lead to death, personal injury,
# or severe property or environmental damage (individually and collectively, "Critical Applications"). Customer assumes
# the sole risk and liability of any use of Xilinx products in Critical Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
#
###############################################################################
##
## axi_ethernet_v6_0/bd/bd.tcl
##
################################################################################>->

##---------------------------------------------------------------------------------------------------------------------------------
# start section: config procs ####<-<
##---------------------------------------------------------------------------------------------------------------------------------
proc post_config_ip {cellPath otherInfo} {
}
##---------------------------------------------------------------------------------------------------------------------------------
# start section: config procs ####>->
##---------------------------------------------------------------------------------------------------------------------------------

##---------------------------------------------------------------------------------------------------------------------------------
# start section: propagate procs ###<-<
##---------------------------------------------------------------------------------------------------------------------------------

proc post_propagate  {this args} {

    set axi_buf            [get_bd_cells $this                          ]

    set a_S_AXI_ACLK       [get_bd_pins -quiet $axi_buf/S_AXI_ACLK      ]
    set a_AXI_STR_TXC_ACLK [get_bd_pins -quiet $axi_buf/AXI_STR_TXC_ACLK]
    set a_AXI_STR_TXD_ACLK [get_bd_pins -quiet $axi_buf/AXI_STR_TXD_ACLK]
    set a_AXI_STR_RXS_ACLK [get_bd_pins -quiet $axi_buf/AXI_STR_RXS_ACLK]
    set a_AXI_STR_RXD_ACLK [get_bd_pins -quiet $axi_buf/AXI_STR_RXD_ACLK]
    set a_rx_mac_aclk      [get_bd_pins -quiet $axi_buf/rx_mac_aclk     ]
    set a_tx_mac_aclk      [get_bd_pins -quiet $axi_buf/tx_mac_aclk     ]
    set a_GTX_CLK          [get_bd_pins -quiet $axi_buf/GTX_CLK         ]

    set  a_S_AXI_ACLK_freq_hz       [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_S_AXI_ACLK      ]]
    set  a_S_AXI_ACLK_clk_dom       [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_S_AXI_ACLK      ]]
    set  a_S_AXI_ACLK_phase         [get_property CONFIG.PHASE      [get_bd_pins $a_S_AXI_ACLK      ]]
    set  a_AXI_STR_TXC_ACLK_freq_hz [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_AXI_STR_TXC_ACLK]]
    set  a_AXI_STR_TXC_ACLK_clk_dom [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_AXI_STR_TXC_ACLK]]
    set  a_AXI_STR_TXC_ACLK_phase   [get_property CONFIG.PHASE      [get_bd_pins $a_AXI_STR_TXC_ACLK]]
    set  a_AXI_STR_TXD_ACLK_freq_hz [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_AXI_STR_TXD_ACLK]]
    set  a_AXI_STR_TXD_ACLK_clk_dom [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_AXI_STR_TXD_ACLK]]
    set  a_AXI_STR_TXD_ACLK_phase   [get_property CONFIG.PHASE      [get_bd_pins $a_AXI_STR_TXD_ACLK]]
    set  a_AXI_STR_RXS_ACLK_freq_hz [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_AXI_STR_RXS_ACLK]]
    set  a_AXI_STR_RXS_ACLK_clk_dom [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_AXI_STR_RXS_ACLK]]
    set  a_AXI_STR_RXS_ACLK_phase   [get_property CONFIG.PHASE      [get_bd_pins $a_AXI_STR_RXS_ACLK]]
    set  a_AXI_STR_RXD_ACLK_freq_hz [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_AXI_STR_RXD_ACLK]]
    set  a_AXI_STR_RXD_ACLK_clk_dom [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_AXI_STR_RXD_ACLK]]
    set  a_AXI_STR_RXD_ACLK_phase   [get_property CONFIG.PHASE      [get_bd_pins $a_AXI_STR_RXD_ACLK]]
    set  a_rx_mac_aclk_freq_hz      [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_rx_mac_aclk     ]]
    set  a_rx_mac_aclk_clk_dom      [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_rx_mac_aclk     ]]
    set  a_rx_mac_aclk_phase        [get_property CONFIG.PHASE      [get_bd_pins $a_rx_mac_aclk     ]]
    set  a_tx_mac_aclk_freq_hz      [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_tx_mac_aclk     ]]
    set  a_tx_mac_aclk_clk_dom      [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_tx_mac_aclk     ]]
    set  a_tx_mac_aclk_phase        [get_property CONFIG.PHASE      [get_bd_pins $a_tx_mac_aclk     ]]
    set  a_GTX_CLK_freq_hz          [get_property CONFIG.FREQ_HZ    [get_bd_pins $a_GTX_CLK         ]]
    set  a_GTX_CLK_clk_dom          [get_property CONFIG.CLK_DOMAIN [get_bd_pins $a_GTX_CLK         ]]
    set  a_GTX_CLK_phase            [get_property CONFIG.PHASE      [get_bd_pins $a_GTX_CLK         ]]


    set_property   CONFIG.FREQ_HZ      $a_S_AXI_ACLK_freq_hz        [get_bd_intf_pins ${axi_buf}/S_AXI]
    set_property   CONFIG.CLK_DOMAIN   $a_S_AXI_ACLK_clk_dom        [get_bd_intf_pins ${axi_buf}/S_AXI]
    set_property   CONFIG.PHASE        $a_S_AXI_ACLK_phase          [get_bd_intf_pins ${axi_buf}/S_AXI]
    set_property   CONFIG.FREQ_HZ      $a_S_AXI_ACLK_freq_hz        [get_bd_intf_pins ${axi_buf}/S_AXI_2TEMAC]
    set_property   CONFIG.CLK_DOMAIN   $a_S_AXI_ACLK_clk_dom        [get_bd_intf_pins ${axi_buf}/S_AXI_2TEMAC]
    set_property   CONFIG.PHASE        $a_S_AXI_ACLK_phase          [get_bd_intf_pins ${axi_buf}/S_AXI_2TEMAC]
    set_property   CONFIG.FREQ_HZ      $a_AXI_STR_TXC_ACLK_freq_hz  [get_bd_intf_pins ${axi_buf}/AXI_STR_TXC]
    set_property   CONFIG.CLK_DOMAIN   $a_AXI_STR_TXC_ACLK_clk_dom  [get_bd_intf_pins ${axi_buf}/AXI_STR_TXC]
    set_property   CONFIG.PHASE        $a_AXI_STR_TXC_ACLK_phase    [get_bd_intf_pins ${axi_buf}/AXI_STR_TXC]
    set_property   CONFIG.FREQ_HZ      $a_AXI_STR_TXD_ACLK_freq_hz  [get_bd_intf_pins ${axi_buf}/AXI_STR_TXD]
    set_property   CONFIG.CLK_DOMAIN   $a_AXI_STR_TXD_ACLK_clk_dom  [get_bd_intf_pins ${axi_buf}/AXI_STR_TXD]
    set_property   CONFIG.PHASE        $a_AXI_STR_TXD_ACLK_phase    [get_bd_intf_pins ${axi_buf}/AXI_STR_TXD]
    set_property   CONFIG.FREQ_HZ      $a_AXI_STR_RXS_ACLK_freq_hz  [get_bd_intf_pins ${axi_buf}/AXI_STR_RXS]
    set_property   CONFIG.CLK_DOMAIN   $a_AXI_STR_RXS_ACLK_clk_dom  [get_bd_intf_pins ${axi_buf}/AXI_STR_RXS]
    set_property   CONFIG.PHASE        $a_AXI_STR_RXS_ACLK_phase    [get_bd_intf_pins ${axi_buf}/AXI_STR_RXS]
    set_property   CONFIG.FREQ_HZ      $a_AXI_STR_RXD_ACLK_freq_hz  [get_bd_intf_pins ${axi_buf}/AXI_STR_RXD]
    set_property   CONFIG.CLK_DOMAIN   $a_AXI_STR_RXD_ACLK_clk_dom  [get_bd_intf_pins ${axi_buf}/AXI_STR_RXD]
    set_property   CONFIG.PHASE        $a_AXI_STR_RXD_ACLK_phase    [get_bd_intf_pins ${axi_buf}/AXI_STR_RXD]
    set_property   CONFIG.FREQ_HZ      $a_rx_mac_aclk_freq_hz       [get_bd_intf_pins ${axi_buf}/RX_AXIS_MAC]
    set_property   CONFIG.CLK_DOMAIN   $a_rx_mac_aclk_clk_dom       [get_bd_intf_pins ${axi_buf}/RX_AXIS_MAC]
    set_property   CONFIG.PHASE        $a_rx_mac_aclk_phase         [get_bd_intf_pins ${axi_buf}/RX_AXIS_MAC]
    set_property   CONFIG.FREQ_HZ      $a_tx_mac_aclk_freq_hz       [get_bd_intf_pins ${axi_buf}/TX_AXIS_MAC]
    set_property   CONFIG.CLK_DOMAIN   $a_tx_mac_aclk_clk_dom       [get_bd_intf_pins ${axi_buf}/TX_AXIS_MAC]
    set_property   CONFIG.PHASE        $a_tx_mac_aclk_phase         [get_bd_intf_pins ${axi_buf}/TX_AXIS_MAC]

    set clk_div_value [expr {int (($a_S_AXI_ACLK_freq_hz * 0.005) / 1000)}]
    #send_msg_id "axibuf_bd-101" INFO "phy_rst_count value before update [get_property CONFIG.phy_rst_count [get_bd_cells $axi_buf]]"
    set_property   CONFIG.phy_rst_count     $clk_div_value         [get_bd_cells $axi_buf]
    #send_msg_id "axibuf_bd-101" INFO "phy_rst_count value after update [get_property CONFIG.phy_rst_count [get_bd_cells $axi_buf]]"
}
##---------------------------------------------------------------------------------------------------------------------------------
# End section propagate procs ###>->
##---------------------------------------------------------------------------------------------------------------------------------

