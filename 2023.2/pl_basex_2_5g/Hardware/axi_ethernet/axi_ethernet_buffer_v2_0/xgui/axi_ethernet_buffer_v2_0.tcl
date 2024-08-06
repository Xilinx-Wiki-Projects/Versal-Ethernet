source_ipfile "utils/board/utils.tcl"
set mdio_vlnv "xilinx.com:interface:mdio_rtl:1.0"
set phyrst_vlnv "xilinx.com:signal:reset_rtl:1.0"

#Definitional proc to organize widgets for parameters.
proc create_gui { ipview } {
	set Component_Name [ipgui::add_param  $ipview  -parent  $ipview  -name Component_Name                                                                ]
    create_board_gui $ipview

	set Page0          [ipgui::add_page $ipview  -name "Basic Configuration" -layout vertical                                                            ]
	set embdd_grp0     [ipgui::add_group $ipview -parent $Page0      -name embdd_grp0   -layout horizontal -display_name "Physical Interface Selection"]
	set C_PHY_TYPE     [ipgui::add_param $ipview -parent $embdd_grp0 -name C_PHY_TYPE                                                                    ]
	set SPEED_2P5    [ipgui::add_param $ipview -parent $embdd_grp0 -name SPEED_2P5                                                                    ]
	set C_TYPE         [ipgui::add_param $ipview -parent $embdd_grp0 -name C_TYPE                                                                        ]

    set embdd_pnl1 [ipgui::add_panel $ipview -parent $Page0      -name embdd_pnl1   -layout horizontal              ]
    set Tx_Op_grp1 [ipgui::add_group $ipview -parent $embdd_pnl1 -name Tx_Op_grp1   -display_name "Transmit Options"]
    set Rx_Op_grp1 [ipgui::add_group $ipview -parent $embdd_pnl1 -name Rx_Op_grp1   -display_name "Receive Options" ]
    set TXVLAN_TRAN  [ipgui::add_param $ipview -parent $Tx_Op_grp1 -name TXVLAN_TRAN ]
    set RXVLAN_TRAN  [ipgui::add_param $ipview -parent $Rx_Op_grp1 -name RXVLAN_TRAN ]
    set TXVLAN_TAG   [ipgui::add_param $ipview -parent $Tx_Op_grp1 -name TXVLAN_TAG  ]
    set RXVLAN_TAG   [ipgui::add_param $ipview -parent $Rx_Op_grp1 -name RXVLAN_TAG  ]
    set TXVLAN_STRP  [ipgui::add_param $ipview -parent $Tx_Op_grp1 -name TXVLAN_STRP ]
    set RXVLAN_STRP  [ipgui::add_param $ipview -parent $Rx_Op_grp1 -name RXVLAN_STRP ]
    set MCAST_EXTEND [ipgui::add_param $ipview -parent $Rx_Op_grp1 -name MCAST_EXTEND]

    set embdd_pnl2  [ipgui::add_panel $ipview -parent $Page0        -name embdd_pnl2   -layout horizontal                                      ]
    set Mem_Op_grp1 [ipgui::add_group $ipview -parent $embdd_pnl2   -name Mem_Op_grp1   -display_name "Select Buffer Memory size              "]
	set TXMEM [ipgui::add_param $ipview -parent $Mem_Op_grp1 -name TXMEM -widget comboBox]
	set RXMEM [ipgui::add_param $ipview -parent $Mem_Op_grp1 -name RXMEM -widget comboBox]

    set csum_op_grp1 [ipgui::add_group $ipview -parent $embdd_pnl2        -name csum_op_grp1   -display_name "Select Checksum Offload Options"]
	set TXCSUM [ipgui::add_param $ipview -parent $csum_op_grp1 -name TXCSUM -widget comboBox]
	set RXCSUM [ipgui::add_param $ipview -parent $csum_op_grp1 -name RXCSUM -widget comboBox]

	set Page1 [ipgui::add_page $ipview  -name "Other Configurations" -layout vertical]
    #set_property visible false $Page1
	set C_PHYADDR       [ipgui::add_param $ipview -parent $Page1 -name C_PHYADDR      ]
	set C_AVB           [ipgui::add_param $ipview -parent $Page1 -name C_AVB          ]
	set C_STATS         [ipgui::add_param $ipview -parent $Page1 -name C_STATS        ]
	set ENABLE_1588     [ipgui::add_param $ipview -parent $Page1 -name enable_1588    ]
	set ENABLE_LVDS     [ipgui::add_param $ipview -parent $Page1 -name ENABLE_LVDS    ]
	set HAS_SGMII       [ipgui::add_param $ipview -parent $Page1 -name HAS_SGMII      ]
	set phy_rst_count   [ipgui::add_param $ipview -parent $Page1 -name phy_rst_count      ]
	set SIMULATION_MODE [ipgui::add_param $ipview -parent $Page1 -name SIMULATION_MODE]
}

proc SIMULATION_MODE_updated {ipview} {
# Procedure called when SIMULATION is updated
	return true
}

proc validate_SIMULATION_MODE {ipview} {
# Procedure called to validate SIMULATION
	return true
}

proc updateModel_C_HAS_SGMII {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property modelparam_value [get_property value [ipgui::get_paramspec HAS_SGMII -of $ipview ]] [ipgui::get_modelparamspec C_HAS_SGMII -of $ipview ]
	return true
}

proc updateModel_C_SPEED_2P5 {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
        set_property modelparam_value [get_property value [ipgui::get_paramspec SPEED_2P5 -of $ipview ]] [ipgui::get_modelparamspec C_SPEED_2P5 -of $ipview ]
	return true
}

proc updateModel_C_ENABLE_LVDS {ipview} {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property modelparam_value [get_property value [ipgui::get_paramspec ENABLE_LVDS -of $ipview ]] [ipgui::get_modelparamspec C_ENABLE_LVDS -of $ipview ]
	return true
}

proc updateModel_C_PHYADDR {ipview} {
    set c_phy_add [get_property value [ipgui::get_paramspec C_PHYADDR -of $ipview ]]
	set_property modelparam_value $c_phy_add [ipgui::get_modelparamspec C_PHYADDR -of $ipview ]
	return true
}
proc updateModel_C_ENABLE_1588 {ipview} {
    set c_enable_1588 [get_property value [ipgui::get_paramspec enable_1588 -of $ipview ]]
	set_property modelparam_value $c_enable_1588 [ipgui::get_modelparamspec C_ENABLE_1588 -of $ipview]
	return true
}
proc updateModel_C_TYPE {ipview} {
	set_property modelparam_value [get_property value [ipgui::get_paramspec C_TYPE -of $ipview ]] [ipgui::get_modelparamspec C_TYPE -of $ipview ]
	return true
}
proc updateModel_C_PHY_TYPE {ipview} {
	set_property modelparam_value [get_property value [ipgui::get_paramspec C_PHY_TYPE -of $ipview ]] [ipgui::get_modelparamspec C_PHY_TYPE -of $ipview ]
	return true
}
proc updateModel_C_STATS {ipview} {
	set_property modelparam_value [get_property value [ipgui::get_paramspec C_STATS -of $ipview ]] [ipgui::get_modelparamspec C_STATS -of $ipview ]
	return true
}
proc updateModel_C_AVB {ipview} {
	set_property modelparam_value [get_property value [ipgui::get_paramspec C_AVB -of $ipview ]] [ipgui::get_modelparamspec C_AVB -of $ipview ]
	return true
}

proc updateModel_C_TEMAC_ADDR_WIDTH {ipview} {
    set size_val [expr {[get_property value [ipgui::get_paramspec C_AVB -of $ipview]] == 1 ? 17 : 12}]
	set_property modelparam_value $size_val [ipgui::get_modelparamspec C_TEMAC_ADDR_WIDTH -of $ipview ]
	return true
}

proc updateModel_C_TXMEM {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

    if { [get_param_value TXMEM	] == "4k" } {
        set_property modelparam_value 4096 [ipgui::get_modelparamspec C_TXMEM -of $ipview ]
    } elseif { [get_param_value TXMEM	] == "8k" } {
        set_property modelparam_value 8192 [ipgui::get_modelparamspec C_TXMEM -of $ipview ]
    } elseif { [get_param_value TXMEM	] == "16k" } {
        set_property modelparam_value 16384 [ipgui::get_modelparamspec C_TXMEM -of $ipview ]
    } elseif { [get_param_value TXMEM	] == "32k" } {
        set_property modelparam_value 32768 [ipgui::get_modelparamspec C_TXMEM -of $ipview ]
    } elseif { [get_param_value TXMEM	] == "2k" } {
        set_property modelparam_value 2048 [ipgui::get_modelparamspec C_TXMEM -of $ipview ]
    }

    return true
}

proc updateModel_C_RXMEM {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

    if { [get_param_value RXMEM	] == "4k" } {
        set_property modelparam_value 4096 [ipgui::get_modelparamspec C_RXMEM -of $ipview ]
    } elseif { [get_param_value RXMEM	] == "8k" } {
        set_property modelparam_value 8192 [ipgui::get_modelparamspec C_RXMEM -of $ipview ]
    } elseif { [get_param_value RXMEM	] == "16k" } {
        set_property modelparam_value 16384 [ipgui::get_modelparamspec C_RXMEM -of $ipview ]
    } elseif { [get_param_value RXMEM	] == "32k" } {
        set_property modelparam_value 32768 [ipgui::get_modelparamspec C_RXMEM -of $ipview ]
    } elseif { [get_param_value RXMEM	] == "2k" } {
        set_property modelparam_value 2048 [ipgui::get_modelparamspec C_RXMEM -of $ipview ]
    }

	return true
}

proc updateModel_C_TXCSUM {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

	if { [get_param_value TXCSUM	] == "None" } {
	        set_property modelparam_value 0 [ipgui::get_modelparamspec C_TXCSUM -of $ipview ]
        } elseif { [get_param_value TXCSUM	] == "Partial" } {
	        set_property modelparam_value 1 [ipgui::get_modelparamspec C_TXCSUM -of $ipview ]
        } elseif { [get_param_value TXCSUM	] == "Full" } {
	        set_property modelparam_value 2 [ipgui::get_modelparamspec C_TXCSUM -of $ipview ]
        }


	return true
}

proc updateModel_C_RXCSUM {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

	if { [get_param_value RXCSUM	] == "None" } {
	        set_property modelparam_value 0 [ipgui::get_modelparamspec C_RXCSUM -of $ipview ]
        } elseif { [get_param_value RXCSUM	] == "Partial" } {
	        set_property modelparam_value 1 [ipgui::get_modelparamspec C_RXCSUM -of $ipview ]
        } elseif { [get_param_value RXCSUM	] == "Full" } {
	        set_property modelparam_value 2 [ipgui::get_modelparamspec C_RXCSUM -of $ipview ]
        }
	return true
}

proc updateModel_C_TXVLAN_TRAN {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set TXVLAN_TRAN [get_property value [ipgui::get_paramspec TXVLAN_TRAN -of $ipview ]]
    if {$TXVLAN_TRAN == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_TXVLAN_TRAN -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_TXVLAN_TRAN -of $ipview ]
    }
	return true
}

proc updateModel_C_RXVLAN_TRAN {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set RXVLAN_TRAN [get_property value [ipgui::get_paramspec RXVLAN_TRAN -of $ipview ]]
    if {$RXVLAN_TRAN == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_RXVLAN_TRAN -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_RXVLAN_TRAN -of $ipview ]
    }
	return true
}

proc updateModel_C_TXVLAN_TAG {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set TXVLAN_TAG [get_property value [ipgui::get_paramspec TXVLAN_TAG -of $ipview ]]
    if {$TXVLAN_TAG == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_TXVLAN_TAG -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_TXVLAN_TAG -of $ipview ]
    }
	return true
}

proc updateModel_C_RXVLAN_TAG {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set RXVLAN_TAG [get_property value [ipgui::get_paramspec RXVLAN_TAG -of $ipview ]]
    if {$RXVLAN_TAG == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_RXVLAN_TAG -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_RXVLAN_TAG -of $ipview ]
    }
	return true
}

proc updateModel_C_TXVLAN_STRP {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set TXVLAN_STRP [get_property value [ipgui::get_paramspec TXVLAN_STRP -of $ipview ]]
    if {$TXVLAN_STRP == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_TXVLAN_STRP -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_TXVLAN_STRP -of $ipview ]
    }
	return true
}

proc updateModel_C_RXVLAN_STRP {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set RXVLAN_STRP [get_property value [ipgui::get_paramspec RXVLAN_STRP -of $ipview ]]
    if {$RXVLAN_STRP == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_RXVLAN_STRP -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_RXVLAN_STRP -of $ipview ]
    }
	return true
}

proc updateModel_C_MCAST_EXTEND {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set MCAST_EXTEND [get_property value [ipgui::get_paramspec MCAST_EXTEND -of $ipview ]]
    if {$MCAST_EXTEND == true } {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_MCAST_EXTEND -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_MCAST_EXTEND -of $ipview ]
    }
	return true
}

proc updateModel_C_SIMULATION {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set SIMULATION_MODE [get_property value [ipgui::get_paramspec SIMULATION_MODE -of $ipview ]]
    if {$SIMULATION_MODE} {
        set_property modelparam_value 1 [ipgui::get_modelparamspec C_SIMULATION -of $ipview ]
    } else {
        set_property modelparam_value 0 [ipgui::get_modelparamspec C_SIMULATION -of $ipview ]
    }
	return true
}

proc updateModel_C_PHY_RST_COUNT {ipview} {
# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    set phy_rst_count [get_property value [ipgui::get_paramspec phy_rst_count -of $ipview ]]
    set_property modelparam_value $phy_rst_count [ipgui::get_modelparamspec C_PHY_RST_COUNT -of $ipview ]
	return true
}

set c_family [get_project_property ARCHITECTURE]
proc updateModel_c_family {IpView} {
    variable c_family
    set_property modelparam_value  [ipgui::get_modelparamspec C_FAMILY -of $IpView]
}

#####################################
# Board Data Manager (BDM) TCL code
#####################################

proc get_board_tab_entries { } {
    variable mdio_vlnv
    variable phyrst_vlnv

    set supported_ifs 0
    if { [board::is_enable_board_gui ] == 1 } {
        if { [board::is_intf_exist_in_board $mdio_vlnv] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
    }
    return $supported_ifs
}

proc create_board_gui { ipview } {
    variable mdio_vlnv
    variable phyrst_vlnv

    set BoardPage [board::create_board_page $ipview]
    set USE_BOARD_FLOW [ipgui::add_param $ipview -name USE_BOARD_FLOW -parent $BoardPage -widget checkBox]
    set board_tab_entries [get_board_tab_entries]

    if { $board_tab_entries != 0} {
        set BoardTable [board::create_board_table $ipview $BoardPage [expr $board_tab_entries +1]]

        set board_entry_index 1

        if { [board::is_intf_exist_in_board $mdio_vlnv] } {
            set MDIO_BOARD_INTERFACE [board::add_board_if_option $ipview $BoardTable MDIO MDIO_BOARD_INTERFACE $mdio_vlnv $board_entry_index]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master]} {
            set PHYRST_BOARD_INTERFACE [board::add_board_if_option $ipview $BoardTable PHYRST_N PHYRST_BOARD_INTERFACE  $phyrst_vlnv $board_entry_index MODE master]
            set board_entry_index  [expr $board_entry_index + 1]
        }

    } else {
        set_property visible false $BoardPage
    }
}

proc USE_BOARD_FLOW_updated {ipview} {
    variable mdio_vlnv
    variable phyrst_vlnv

    set enableBoardFlow [get_param_value USE_BOARD_FLOW]
    set display_board_tab [get_board_tab_entries]

    if {$display_board_tab != 0} {
        if {$enableBoardFlow == false } {
            if { [board::is_intf_exist_in_board $mdio_vlnv] } {
                set_property value Custom  [ipgui::get_paramspec MDIO_BOARD_INTERFACE -of $ipview]
                set_property enabled false [ipgui::get_paramspec MDIO_BOARD_INTERFACE -of $ipview]
            }
            if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master] } {
                set_property value Custom  [ipgui::get_paramspec PHYRST_BOARD_INTERFACE -of $ipview]
                set_property enabled false [ipgui::get_paramspec PHYRST_BOARD_INTERFACE -of $ipview]
        }
        } else {
        if { [board::is_intf_exist_in_board $mdio_vlnv] } {
                set_property enabled true  [ipgui::get_paramspec MDIO_BOARD_INTERFACE -of $ipview]
        }
            if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master] } {
                set_property enabled true [ipgui::get_paramspec PHYRST_BOARD_INTERFACE -of $ipview]
        }
        }
    }
    MDIO_BOARD_INTERFACE_updated $ipview
}

proc MDIO_BOARD_INTERFACE_updated {ipview} {
    set boardIfName [get_param_value MDIO_BOARD_INTERFACE]
}

proc  PHYRST_BOARD_INTERFACE_updated {ipview}  {
    set boardIfName [get_param_value PHYRST_BOARD_INTERFACE]
}

