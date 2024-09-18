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
namespace eval board {
namespace import ::xit::*
###############################################################################
proc util_dbg_spec { msg } {
#    set rand_id [expr {int(100 + rand() * 100)}]
#    send_msg_id "ethUtilProc-$rand_id" "WARNING" "$msg"
}

proc util_dbg_reg { msg } {
#    send_msg INFO 16 "$msg"
}

###############################################################################
proc is_board_flow_enabled { } {
    return  [get_param  project.enableBoardFlow ] 
}
###############################################################################
proc is_enable_board_gui {} {
    set cur_board [get_project_property BOARD]
    if { $cur_board  eq "" } {
        return 0
    }
    return [is_board_flow_enabled ]
}
###############################################################################
proc is_intf_exist_in_board { busif_vlnv args} {
    set board_intf_list [get_board_part_interfaces  -filter "vlnv==$busif_vlnv"]
    set filtered_list ""
    util_dbg_reg "is_intf_exist_in_board 1: all intfs :$board_intf_list: and filtered intfs :$filtered_list: "
    if {$board_intf_list != ""} {
        if {$args == ""} {
            set filtered_list $board_intf_list
            util_dbg_reg "is_intf_exist_in_board 2: all intfs :$board_intf_list: and filtered intfs :$filtered_list: "
        } else {
            set param_type [lindex [regexp -all -inline {\S+} $args] 0]
            set param_values [lrange  [regexp -all -inline {\S+} $args] 1 end]
            foreach item $board_intf_list {
                foreach param_value $param_values {
                    if {[get_property $param_type $item] == $param_value } {
                        set filtered_list "$filtered_list $item" 
                    }
                }
            }
        }
        if { $filtered_list != "" } {
            util_dbg_reg "is_intf_exist_in_board 3: all intfs :$board_intf_list: and filtered intfs :$filtered_list: "
            return [regexp -all {\w+} $filtered_list]
        } else {
            util_dbg_reg "is_intf_exist_in_board 4: all intfs :$board_intf_list: and filtered intfs :$filtered_list: "
            return 0
        }
    } else {
        util_dbg_reg "is_intf_exist_in_board 5: all intfs :$board_intf_list: and filtered intfs :$filtered_list: "
        return 0
    }
}
###############################################################################
proc get_interface_property {if_name prop} {
    if { [is_enable_board_gui ] == 0 } {
       return "" 
    }
    set prop_value ""
    set board_if [get_board_part_interfaces   -filter "NAME==$if_name"]
    set prop_value [get_property   $prop $board_if ]
    return $prop_value
}
###############################################################################
proc get_board_pins_of_intf_port { intf_name logical_port_name } {
    if { [is_board_flow_enabled] == 0 } {
       return "" 
    }
    set board_pins ""
    set board_if [get_board_part_interfaces   -filter "NAME==$intf_name" ]
    util_dbg_reg "Inside board_get_board_pins_of_intf_port intf=$intf_name log_port=$logical_port_name board_if=$board_if"
    if { $board_if ne "" } {
        set board_port [get_property   "PORT.$logical_port_name" $board_if]
        util_dbg_reg "Inside board_get_board_pins_of_intf_port board_port=$board_port"
        if { $board_port ne "" } {
            set board_pins [get_board_part_pins   -filter "BUS_NAME==$board_port"]
        }
    }
    util_dbg_reg "Inside board_get_board_pins_of_intf_port board_pins=$board_pins"
    return $board_pins  
}
###############################################################################
proc add_message_board_flow_not_supported { ipview BoardPage } {
    ipgui::add_static_text $ipview -parent $BoardPage -name Board_missing_static_text -text \
    "No Board specific customization is allowed so it is recommended to uncheck the box to reset board specific ip parameters"
    ipgui::add_static_text $ipview -parent $BoardPage -name \
    Board_missing_static_text -text "MESSAGE: There are following possibilities\
    \n1. Either Project property does not have board\
    \n2. Project is disabled to use board flow\
    \n3. Board does not have this IP specific interface "
} 
###############################################################################
proc create_board_page { ipview } {
     #if { [is_enable_board_gui ] == 0 } {
     #   return "" 
     #}
    #util_dbg_reg "Board Flow is enabled"
    set BoardPage [ ipgui::add_page $ipview -name "Board" -layout vertical]
    return $BoardPage
}
###############################################################################
proc create_board_table { ipview BoardPage row } {
    set board [get_project_property BOARD ]
    set board [string toupper $board]
    util_dbg_reg "Current Selected board is $board"
    if { $board eq "" } {
        set board "Custom"
    }
    set Groupbox  [ipgui::add_group $ipview -parent $BoardPage -name " Associate IP interface with $board Board interface"]
    set table [ipgui::add_table $ipview  -name "Board_table" -rows $row -columns "2" -parent $Groupbox]
    set Label_IP_Interface [ipgui::add_static_text  $ipview -name Label_IP_Interface -parent  $table -text "<b>IP Interface"]
    set Label_Board_Interface [ipgui::add_static_text  $ipview -name Label_Board_Interface -parent  $table -text "<b>Board Interface"]
    set_property cell_location "0,0" $Label_IP_Interface
    set_property cell_location "0,1" $Label_Board_Interface
    return $table
    #return $BoardPage
}
###############################################################################
proc set_range { userparam bif_vlnv args} {
    set bif_string "Custom"
    if { [is_enable_board_gui ] == 1 } {
        set board_if [get_board_part_interfaces   -filter "VLNV==$bif_vlnv" ]
        if {$args == ""} {
        #util_dbg_reg "Args are not provided, Get interface list by filtering:     $userparam $bif_vlnv  $args"
            foreach item $board_if {
                set bif_string "$bif_string,$item" 
            }
        } else {
        # util_dbg_reg "Args are provided, Get interface list from args:     $userparam $bif_vlnv $args"
            set param_type [lindex [regexp -all -inline {\S+} $args] 0]
            set param_value [lindex [regexp -all -inline {\S+} $args] end]
            foreach item $board_if {
                if {[get_property $param_type $item] == $param_value } {
                    set bif_string "$bif_string,$item" 
                }
            }
        }
    }
    set bif_string [join [ lsort -unique [split $bif_string "," ] ] "," ]

    set_property range "$bif_string" $userparam
}

###############################################################################
proc get_intf_vlnv { board_intf_name } {
    if {[get_board_part_interfaces -quiet $board_intf_name] == ""} {
        return Custom
    } else {
        return [get_property  VLNV [get_board_part_interfaces  $board_intf_name] ] 
    }
}

###############################################################################
proc add_ethernet_board_if_option { ipview BoardTable intfname userparam row } {
    set mii_vlnv "xilinx.com:interface:mii_rtl:1.0"
    set gmii_vlnv "xilinx.com:interface:gmii_rtl:1.0"
    set rgmii_vlnv "xilinx.com:interface:rgmii_rtl:1.0"
    set mdio_vlnv "xilinx.com:interface:mdio_io:1.0"
    set mdio_r_vlnv "xilinx.com:interface:mdio_rtl:1.0"
    set sgmii_vlnv "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv "xilinx.com:interface:sfp_rtl:1.0"
    set diffclk_vlnv "xilinx.com:interface:diff_clock_rtl:1.0"
    set phyrst_vlnv "xilinx.com:signal:reset_rtl:1.0"

    util_dbg_reg "Args are not provided, Get interface list by filtering: $ipview  $BoardTable $intfname $userparam $row "

    set bif_string "Custom"
    if { [is_enable_board_gui ] } {
        set board_if [get_board_part_interfaces -filter "VLNV==$mii_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item"
        }
        set board_if [get_board_part_interfaces -filter "VLNV==$gmii_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item"
        }
        set board_if [get_board_part_interfaces -filter "VLNV==$rgmii_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item"
        }
        set board_if [get_board_part_interfaces -filter "VLNV==$sgmii_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item"
        }
        set board_if [get_board_part_interfaces -filter "VLNV==$sfp_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item"
        }
    }

    set BOARD_IF_NAME [ipgui::add_param $ipview -name $userparam -parent $BoardTable -widget comboBox]
    set INTERFACE [ipgui::add_static_text $ipview -name "Board::$intfname" -parent $BoardTable -text "$intfname"]
    set_property range "$bif_string" [ipgui::get_paramspec $userparam -of $ipview]
    set_property cell_location "$row,0" $INTERFACE
    set_property cell_location "$row,1" $BOARD_IF_NAME
    util_dbg_reg "add_ethernet_board_if_option $bif_string $BOARD_IF_NAME"
    return $BOARD_IF_NAME
}
###############################################################################
proc add_board_if_option { ipview  BoardTable intfname userparam bif_vlnv row args} {
    set BOARD_IF_NAME [ipgui::add_param $ipview -name $userparam -parent $BoardTable -widget comboBox]
    set INTERFACE [ipgui::add_static_text $ipview -name "Board::$intfname" -parent $BoardTable -text "$intfname"]
    #set_range $userparam $bif_vlnv $ipview
    #set_property range "$bif_string" [ipgui::get_paramspec $userparam -of $ipview]
    set_property cell_location "$row,0" $INTERFACE
    set_property cell_location "$row,1" $BOARD_IF_NAME
    return $BOARD_IF_NAME
}

###############################################################################
proc validate_board_if_param {ipview boardIfName bif_vlnv } {

    #default value is Custom so return true
    if { $boardIfName eq "Custom" } {
        return true
    }

    #for non-default value check board is enabled and allowed
    if { [is_enable_board_gui ] == 0 } {
       set_property errmsg "Invalid bus interface name is used $boardIfName.  Either provide the correct interface name or disable the Board Flow" [ipgui::get_paramspec $userparam -of $ipview]
       return false 
    }

    set board_if [get_board_part_interfaces   -filter "NAME==$boardIfName"]
    set board_if_vlnv [get_property   VLNV $board_if]
    if { $board_if_vlnv eq $bif_vlnv } {
        return true
    }
    set_property errmsg "Invalid bus interface name is used $boardIfName.  Either provide the correct interface name or disable the Board Flow" [ipgui::get_paramspec $userparam -of $ipview]
    return false
}
###############################################################################
}
#endif of namespace board

###############################################################################
#Following proc are placed out of namespace as puts_ipfile was not working 
#inside boad namespace
###############################################################################
proc board_add_pin_constraints { f_xdc board_pin ip_pin_name} {
    if { [board::is_board_flow_enabled] == 0 } {
       return  
    }
    puts_ipfile  $f_xdc "set_property BOARD_PIN \{$board_pin\} \[get_ports $ip_pin_name\]\n"
}
###############################################################################
proc board_add_port_constraints { f_xdc board_if logical_port ip_port_name } {
    set ret false
    if { [board::is_board_flow_enabled] == 0 } {
       return $ret 
    }
    set instname [current_inst]
    set board_port [board::get_board_pins_of_intf_port $board_if $logical_port]
    if { $board_port ne "" } {
        set ret true
        set board_port_width [ get_property   BUS_WIDTH [lindex $board_port 0] ]
        set board_port_name [get_property   BUS_NAME [lindex $board_port 0] ]
        set board_pin_name [get_property   NAME [lindex $board_port 0] ]
        if { $board_port_width == 1  && $board_pin_name == $board_port_name } {
            set board_pin [lindex $board_port 0]
            board_add_pin_constraints $f_xdc $board_pin "$ip_port_name"
        } else {
            set i 0 
            foreach item $board_port {
                board_add_pin_constraints $f_xdc $item "\{$ip_port_name\[$i\]\}"
                incr i
            }
        }
    }
    return $ret
}
###############################################################################
proc board_add_tri_state_port_constraints { f_xdc board_if logical_tri_i port_tri_i logical_tri_o port_tri_o logical_tri_t port_tri_t } {
    if { [board_add_port_constraints $f_xdc $board_if $logical_tri_t $port_tri_t] == false } {
        if { [board_add_port_constraints $f_xdc $board_if $logical_tri_i $port_tri_i] == false } {
            board_add_port_constraints $f_xdc $board_if $logical_tri_o $port_tri_o
        }
    }
}
###############################################################################

###############################################################################
# Proc is used to return list of parameter and value pairs for preset 
# constraints.
# @ip_vlnv - vlnv of the ip
# @board_if - Board Interface Name
# @board - Board Name
###############################################################################
proc board_ip_presets {ip_vlnv board_if board {ip_intf ""}} {
    set ip_vendor [lindex [split $ip_vlnv ":"] 0]
    set ip_library [lindex [split $ip_vlnv ":"] 1]
    set ip_name [lindex [split $ip_vlnv ":"] 2]
    set ip_version [lindex [split $ip_vlnv ":"] 3]
    set preset_string ""

    set bif_presets [get_property PRESETS [get_board_part_interfaces $board_if]]
    if {$bif_presets == ""} {
        return ""
    }
    foreach bif_preset $bif_presets {
        set preset_ip_vendor [lindex [split $bif_preset ":"] 1]
        set preset_ip_library [lindex [split $bif_preset ":"] 2]
        set preset_ip_name [lindex [split $bif_preset ":"] 3]
        set preset_ip_version [lindex [split $bif_preset ":"] 4]
        set preset_ip_intf [string toupper [lindex [split $bif_preset ":"] 5]]

        if {$preset_ip_vendor == $ip_vendor && $preset_ip_library == $ip_library && $preset_ip_name == $ip_name} {
            if {$preset_ip_version == $ip_version || $preset_ip_version == "*"} {
                if {$preset_ip_intf == $ip_intf || $preset_ip_intf == "*" || $preset_ip_intf == ""} {
                    set preset_string $bif_preset
                    break
                }
            }
        }
    }
    if {$preset_string == ""} { return "" }
    set preset_list [llength [::xilinx::board::get_board_presets -of_objects [get_board_parts $board] $preset_string]]
    set total_list ""
    if {$preset_list > 0} {
        set total_list [list_property [::xilinx::board::get_board_presets -of_objects [get_board_parts $board] $preset_string]]
    }
    set param_list ""
    foreach property $total_list {
        if {[string first "CONFIG." $property 0] == 0} {
            lappend param_list $property
        }
    }
    if {$param_list == ""} { return "" }
    set return_val ""
    foreach prop $param_list {
        set val [get_property $prop [::xilinx::board::get_board_presets -of_objects [get_board_parts $board] $preset_string]]
        append return_val $prop " {" $val "} "
    }
    return $return_val
}

