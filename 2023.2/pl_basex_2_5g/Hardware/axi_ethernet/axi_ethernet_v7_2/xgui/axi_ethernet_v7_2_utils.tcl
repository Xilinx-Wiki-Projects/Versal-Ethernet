# (c) Copyright 2013, 2023 Advanced Micro Devices, Inc. All rights reserved.
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


namespace eval axi_ethernet_v7_2_utils {

#    Example to set a warning message 
#    proc warning_for_upgrade_from_axi_ethernet_v6_0 {xciv} {
#        namespace import ::xcoUpgradeLib::*
#        upvar $xciv  valueArray
#        set warningString "Checking the warning proc."
#        namespace forget ::xcoUpgradeLib::*
#        return $warningString
#    }

    proc dbg_s_msg {str} {
#       send_msg INFO 5 $str
    }

    proc dbg_msg {str} {
##        send_msg INFO 2 $str
    }

    proc updates_in_v7_0 {xciv} {
        dbg_msg  "Running updates_in_v7_0 proc"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray

        addParameter speed_1_2p5    1G    valueArray
        addParameter drpclkrate     50.0  valueArray
        addParameter gtrefclkrate   125   valueArray
        addParameter axiliteclkrate 100.0 valueArray
        addParameter axisclkrate    100.0 valueArray
        addParameter gt_type        GTH   valueArray
        addParameter GTinEx         false valueArray
        addParameter EnableAsyncSGMII   false  valueArray
        addParameter gtrefclksrc        clk0   valueArray
        addParameter gtlocation         X0Y0   valueArray

        addParameter Tx_In_Upper_Nibble      true           valueArray
        addParameter TxLane0_Placement       DIFF_PAIR_0    valueArray
        addParameter RxLane0_Placement       DIFF_PAIR_0    valueArray
        addParameter RxNibbleBitslice0Used   true           valueArray

        set mdio_board_val [getParameter MDIO_BOARD_INTERFACE valueArray]
        if { [string match -nocase "mdio_io" $mdio_board_val] } {
            renameParameterSetting MDIO_BOARD_INTERFACE mdio_io mdio_mdc valueArray
        }
        if { [isInterface mdio_io valueArray] } {
            renameInterface mdio_io  mdio valueArray 
        }

        namespace forget ::xcoUpgradeLib::*
    }

    proc updates_in_v6_2 {xciv} {
        dbg_msg  "Running updates_in_v6_2 proc"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray

        dbg_msg  " 33 - addParameter Enable_Pfc         false  valueArray "
        set Standalone [getParameter Standalone valueArray]
        set enable_1588 [getParameter Enable_1588 valueArray]
        removeParameter  Standalone             valueArray
        addParameter Enable_Pfc         false  valueArray
        addParameter TransceiverControl false  valueArray
        if {$Standalone || $enable_1588} {
            addParameter processor_mode false  valueArray
        } else {
            addParameter processor_mode true  valueArray
        }

        dbg_msg  " 37 - set include_io [getParameter Include_IO valueArray] "
        set include_io [getParameter Include_IO valueArray]
        set phy_type   [getParameter PHY_TYPE valueArray  ]

        dbg_msg  "the values to determine change in mdio name are $phy_type and $include_io"
        if {([string match -nocase "sgmii" $phy_type] || !$include_io)} {
            set rename_mdio 0
        } else {
            set rename_mdio 1
        }

        dbg_msg  " 48 - if -[isInterface mdio valueArray] && $rename_mdio- -  "
        if {[isInterface mdio valueArray] && $rename_mdio} { 
            dbg_msg  "Renaming mdio interface from mdio to mdio_io [isInterface mdio valueArray] && $rename_mdio"
            renameInterface mdio  mdio_io valueArray 
        } else {
            dbg_msg  "Not renaming mdio interface and is skipped [isInterface mdio valueArray] && $rename_mdio"
        }

        dbg_msg  " 56 - if -[isPort pause_val             valueArray]- - renamePort  pause_val             s_axis_pause_tdata             valueArray - "
        if {[isPort pause_val             valueArray]} { renamePort  pause_val             s_axis_pause_tdata             valueArray }
        if {[isPort pause_req             valueArray]} { renamePort  pause_req             s_axis_pause_tvalid            valueArray }
        if {[isPort rx_statistics_valid   valueArray]} { renamePort  rx_statistics_valid   tx_statistics_statistics_valid valueArray }
        if {[isPort rx_statistics_vector  valueArray]} { renamePort  rx_statistics_vector  tx_statistics_statistics_data  valueArray }
        if {[isPort tx_statistics_valid   valueArray]} { renamePort  tx_statistics_valid   tx_statistics_statistics_valid valueArray }
        if {[isPort tx_statistics_vector  valueArray]} { renamePort  tx_statistics_vector  tx_statistics_statistics_data  valueArray }

        namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_params_4m_4_n_5 {xciv} {
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray
        dbg_msg  "Running upgrade procs upgrade_params_4m_4_n_5 "
        addParameter USE_BOARD_FLOW            false   valueArray
        dbg_msg  "Completed adding Parameter Use board flow "
        addParameter ETHERNET_BOARD_INTERFACE  Custom  valueArray
        addParameter DIFFCLK_BOARD_INTERFACE   Custom  valueArray
        addParameter MDIO_BOARD_INTERFACE      Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE    Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE_DUMMY_PORT    Custom  valueArray
        addParameter Include_IO                true    valueArray
        addParameter SupportLevel              1       valueArray
        addParameter Timer_Format              0       valueArray
        addParameter Standalone                false   valueArray
        dbg_msg  " 81 - removeParameter  INSTANCE              valueArray "
        removeParameter  INSTANCE              valueArray
        removeParameter  MAC_Speed             valueArray
        removeParameter  Management_Interface  valueArray
        removeParameter  PREV_PHY_TYPE         valueArray
        removeParameter  Prev_Enable_1588      valueArray
        removeParameter  gtx_clk_freq_mhz      valueArray
        removeParameter  mgt_clk_p_freq_mhz    valueArray
        namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_axi_ethernet_v6_2 {xciv} {
        dbg_msg  "Running upgrade procs upgrade_from_axi_ethernet_v6_2"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray
        dbg_msg  " 97 - updates_in_v7_0 valueArray "
        updates_in_v7_0 valueArray
        namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_axi_ethernet_v6_1 {xciv} {
        dbg_msg  "Running upgrade procs upgrade_from_axi_ethernet_v6_1"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray
        dbg_msg  " 96 - updates_in_v6_2 valueArray "
        updates_in_v6_2 valueArray
        dbg_msg  " 97 - updates_in_v7_0 valueArray "
        updates_in_v7_0 valueArray
        namespace forget ::xcoUpgradeLib::*
    }


    proc upgrade_from_axi_ethernet_v6_0 {xciv} {
        dbg_msg  "Running upgrade procs upgrade_from_axi_ethernet_v6_0"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray

        dbg_msg  " 107 - addParameter Standalone    false  valueArray "
        addParameter Standalone    false  valueArray
        addParameter Timer_Format  0      valueArray

        dbg_msg  " 111 - if -![isParameter Include_IO valueArray]- - "
        if {![isParameter Include_IO valueArray]} {
            dbg_msg  "Running upgrade proc for IncludeIO"
            addParameter Include_IO    true   valueArray
            set include_io    true
        } else {
            dbg_msg  "Skipping upgrade proc for IncludeIO"
            set include_io       [getParameter Include_IO valueArray]
        }

        dbg_msg  " 121 - set mdio_board_val [getParameter MDIO_BOARD_INTERFACE valueArray] "
        set mdio_board_val [getParameter MDIO_BOARD_INTERFACE valueArray]
        set phy_type       [getParameter PHY_TYPE valueArray]
        dbg_msg  "the values for MDIO are $phy_type and $mdio_board_val"
        if {[regexp -nocase "sgmii" $phy_type] && [regexp -nocase "mdio_io" $mdio_board_val] } {
            renameParameterSetting MDIO_BOARD_INTERFACE mdio_io mdio_mdc valueArray
        }
        if {!$include_io && ![regexp -nocase "Custom" $mdio_board_val] } {
            renameParameterSetting MDIO_BOARD_INTERFACE $mdio_board_val Custom valueArray
        }

        dbg_msg  " 132 - renameParameterSetting Frame_Filter false true valueArray "
        renameParameterSetting Frame_Filter false true valueArray
        renameParameterSetting Statistics_Counters false true valueArray

        dbg_msg  " 136 - updates_in_v6_2 valueArray "
        updates_in_v6_2 valueArray
        dbg_msg  " 97 - updates_in_v7_0 valueArray "
        updates_in_v7_0 valueArray

        namespace forget ::xcoUpgradeLib::*
    }

    proc comments {} {
        setParameter MDIO_BOARD_INTERFACE Custom   valueArray
        removeParameter MDIO_BOARD_INTERFACE valueArray
        addParameter    MDIO_BOARD_INTERFACE "Custom" valueArray
        renameParameterSetting MDIO_BOARD_INTERFACE mdio_io mdio_mdc valueArray
        find $swsand/ws/HEAD/data/boards/board_parts/ -type f -name "*.xml" | xargs egrep -rih "interface.*mdio"
    }

    proc upgrade_from_axi_ethernet_v5_0 {xciv} {
        dbg_msg  "Running upgrade procs upgrade_from_axi_ethernet_v5_0"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray

        dbg_msg  " 102 - set Enable_1588_1step       [getParameter Enable_1588_1step valueArray] "
        set Enable_1588_1step       [getParameter Enable_1588_1step valueArray]
        set Enable_1588       [getParameter Enable_1588 valueArray]
        dbg_msg  " 104 - set phy_type   [string tolower [getParameter PHY_TYPE valueArray  ]] "
        set phy_type   [string tolower [getParameter PHY_TYPE valueArray  ]]

        dbg_msg  " 202 - removeParameter  Enable_1588_1step     valueArray "
        removeParameter  Enable_1588_1step     valueArray

        dbg_msg  " 154 - removeParameter  INSTANCE              valueArray "
        removeParameter  INSTANCE              valueArray
        removeParameter  MAC_Speed             valueArray
        removeParameter  Management_Interface  valueArray
        removeParameter  PREV_PHY_TYPE         valueArray
        removeParameter  Prev_Enable_1588      valueArray
        removeParameter  gtx_clk_freq_mhz      valueArray
        removeParameter  mgt_clk_p_freq_mhz    valueArray

        dbg_msg  " 163 - addParameter USE_BOARD_FLOW            false   valueArray "
        addParameter USE_BOARD_FLOW            false   valueArray
        addParameter ETHERNET_BOARD_INTERFACE  Custom  valueArray
        addParameter DIFFCLK_BOARD_INTERFACE   Custom  valueArray
        addParameter MDIO_BOARD_INTERFACE      Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE    Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE_DUMMY_PORT    Custom  valueArray
        addParameter Include_IO                true    valueArray
        addParameter SupportLevel              1       valueArray
        addParameter Timer_Format              0       valueArray
        addParameter Standalone                false   valueArray

        dbg_msg  " 174 - renameParameterSetting Frame_Filter false true valueArray "
        renameParameterSetting Frame_Filter false true valueArray
        renameParameterSetting Statistics_Counters false true valueArray

        dbg_msg  " 178 - updates_in_v6_2 valueArray "
        updates_in_v6_2 valueArray
        dbg_msg  " 97 - updates_in_v7_0 valueArray "
        updates_in_v7_0 valueArray

        namespace forget ::xcoUpgradeLib::*
    }

    proc upgrade_from_axi_ethernet_v4_0 {xciv} {
        dbg_msg  "Running upgrade procs upgrade_from_axi_ethernet_v4_0"
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray

        dbg_msg  " 102 - set Enable_1588_1step       [getParameter Enable_1588_1step valueArray] "
        set Enable_1588_1step       [getParameter Enable_1588_1step valueArray]
        set Enable_1588       [getParameter Enable_1588 valueArray]
        dbg_msg  " 104 - set phy_type   [string tolower [getParameter PHY_TYPE valueArray  ]] "
        set phy_type   [string tolower [getParameter PHY_TYPE valueArray  ]]

        dbg_msg  " 202 - removeParameter  Enable_1588_1step     valueArray "
        removeParameter  Enable_1588_1step     valueArray
        dbg_msg  " 188 - removeParameter  INSTANCE              valueArray "
        removeParameter  INSTANCE              valueArray
        removeParameter  MAC_Speed             valueArray
        removeParameter  Management_Interface  valueArray
        removeParameter  PREV_PHY_TYPE         valueArray
        removeParameter  Prev_Enable_1588      valueArray
        removeParameter  gtx_clk_freq_mhz      valueArray
        removeParameter  mgt_clk_p_freq_mhz    valueArray

        dbg_msg  " 198 - addParameter ENABLE_LVDS               false   valueArray "
        addParameter ENABLE_LVDS               false   valueArray
        addParameter SIMULATION_MODE           false   valueArray
        addParameter USE_BOARD_FLOW            false   valueArray
        addParameter ETHERNET_BOARD_INTERFACE  Custom  valueArray
        addParameter DIFFCLK_BOARD_INTERFACE   Custom  valueArray
        addParameter MDIO_BOARD_INTERFACE      Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE    Custom  valueArray
        addParameter PHYRST_BOARD_INTERFACE_DUMMY_PORT    Custom  valueArray
        addParameter Include_IO                true    valueArray
        addParameter SupportLevel              1       valueArray
        addParameter Timer_Format              0       valueArray
        addParameter Standalone                false   valueArray

        dbg_msg  " 211 - renameParameterSetting Frame_Filter false true valueArray "
        renameParameterSetting Frame_Filter false true valueArray
        renameParameterSetting Statistics_Counters false true valueArray

#        if {[isParameter    valueArray]} {
#            set val [getParameter valueArray]
#            removeParameter    valueArray
#        } else {
#            set val 
#        }
#        addParameter          false   valueArray

        dbg_msg  " 223 - if -[isPort ref_clk_in valueArray]- - renamePort ref_clk_in ref_clk valueArray - "
        if {[isPort ref_clk_in valueArray]} { renamePort ref_clk_in ref_clk valueArray }

        if {[isInterface S_AXI valueArray]      } { renameInterface S_AXI        s_axi      valueArray }
        if {[isInterface AXI_STR_RXD valueArray]} { renameInterface AXI_STR_RXD  m_axis_rxd valueArray }
        if {[isInterface AXI_STR_RXS valueArray]} { renameInterface AXI_STR_RXS  m_axis_rxs valueArray }
        if {[isInterface AXI_STR_TXC valueArray]} { renameInterface AXI_STR_TXC  s_axis_txc valueArray }
        if {[isInterface AXI_STR_TXD valueArray]} { renameInterface AXI_STR_TXD  s_axis_txd valueArray }

        dbg_msg  " 146 - if -[isPort mdio valueArray] && [isPort mdc  valueArray]- -  "
        if {[isPort mdio valueArray] && [isPort mdc  valueArray]} { 
            renamePort  mdio   mdio_io_io  valueArray 
            renamePort  mdc    mdio_io_mdc valueArray
        }

        dbg_msg  " 152 - if -[isPort mdio_i valueArray] && [isPort mdc  valueArray]- -  "
        if {[isPort mdio_i valueArray] && [isPort mdc  valueArray]} { 
            renamePort  mdio_i   mdio_mdio_i  valueArray 
            renamePort  mdio_o   mdio_mdio_o  valueArray 
            renamePort  mdio_t   mdio_mdio_t  valueArray 
            renamePort  mdc      mdio_mdc valueArray
        }

        dbg_msg  " 160 - if -[isPort mgt_clk_p valueArray]- -  "
        if {[isPort mgt_clk_p valueArray]} { 
            renamePort  mgt_clk_p    mgt_clk_clk_p valueArray
            renamePort  mgt_clk_n    mgt_clk_clk_n valueArray
        }
        dbg_msg  " 165 - if -$phy_type == -sgmii- - "
        if {$phy_type == "sgmii"} {
            renamePort  rxp sgmii_rxp valueArray 
            renamePort  rxn sgmii_rxn valueArray 
            renamePort  txp sgmii_txp valueArray 
            renamePort  txn sgmii_txn valueArray 
        } elseif {$phy_type == "1000basex"} {
            renamePort  rxp sfp_rxp valueArray 
            renamePort  rxn sfp_rxn valueArray 
            renamePort  txp sfp_txp valueArray 
            renamePort  txn sfp_txn valueArray 
        }

        dbg_msg  " 232 - updates_in_v6_2 valueArray "
        updates_in_v6_2 valueArray
        dbg_msg  " 97 - updates_in_v7_0 valueArray "
        updates_in_v7_0 valueArray

        namespace forget ::xcoUpgradeLib::*
    }
}

