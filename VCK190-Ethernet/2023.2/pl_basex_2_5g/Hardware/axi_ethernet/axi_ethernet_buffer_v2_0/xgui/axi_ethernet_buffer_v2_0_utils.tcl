###############################################################################
##
## (c) Copyright 2013 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and 
## international copyright and other intellectual property
## laws.
##
###############################################################################


namespace eval axi_ethernet_buffer_v2_0_utils {
    proc upgrade_from_axi_ethernet_buffer_v1_0 {xciv} {
        namespace import ::xcoUpgradeLib::*
        upvar $xciv  valueArray
        addParameter SIMULATION_MODE false valueArray
        addParameter C_PHYADDR 1 valueArray
        addParameter USE_BOARD_FLOW false valueArray
        addParameter MDIO_BOARD_INTERFACE Custom valueArray
        namespace forget ::xcoUpgradeLib::*
    }
}
