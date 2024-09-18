namespace eval board {
namespace import ::xit::*
###############################################################################
proc dbg_msg { msg } {
#    send_msg INFO 1 "$msg"
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
    if {$board_intf_list != ""} {
        if {$args == ""} {
            set filtered_list $board_intf_list
        } else {
            set param_type [lindex [regexp -all -inline {\S+} $args] 0]
            set param_value [lindex [regexp -all -inline {\S+} $args] end]
            foreach item $board_intf_list {
                if {[get_property $param_type $item] == $param_value } {
                    set filtered_list "$filtered_list $item" 
                }
            }
        }
        if { $filtered_list != "" } {
            return [regexp -all {\w+} $filtered_list]
        } else {
            return 0
        }
    } else {
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
    dbg_msg "Inside board_get_board_pins_of_intf_port intf=$intf_name log_port=$logical_port_name board_if=$board_if"
    if { $board_if ne "" } {
        set board_port [get_property   "PORT.$logical_port_name" $board_if]
        dbg_msg "Inside board_get_board_pins_of_intf_port board_port=$board_port"
        if { $board_port ne "" } {
            set board_pins [get_board_part_pins   -filter "BUS_NAME==$board_port"]
        }
    }
    dbg_msg "Inside board_get_board_pins_of_intf_port board_pins=$board_pins"
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
    #dbg_msg "Board Flow is enabled"
    set BoardPage [ ipgui::add_page $ipview -name "Board" -layout vertical]
    return $BoardPage
}
###############################################################################
proc create_board_table { ipview BoardPage row } {
    set board [get_project_property BOARD]
    set board [string toupper $board]
    dbg_msg "Current Selected board is $board"
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
proc set_range { userparam bif_vlnv ipview} {
   set bif_string "Custom"

    if { [is_enable_board_gui ] == 1 } {
        set board_if [get_board_part_interfaces   -filter "VLNV==$bif_vlnv" ]
        foreach item $board_if {
           set bif_string "$bif_string,$item" 
        }
   }  

   set_property range "$bif_string" [ipgui::get_paramspec $userparam -of $ipview]
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
proc add_board_if_option { ipview  BoardTable intfname userparam bif_vlnv row args} {
    set bif_string "Custom"
    if { [is_enable_board_gui ] == 1 } {
        set board_if [get_board_part_interfaces   -filter "VLNV==$bif_vlnv" ]
        if {$args == ""} {
            foreach item $board_if {
                set bif_string "$bif_string,$item" 
            }
        } else {
            set param_type [lindex [regexp -all -inline {\S+} $args] 0]
            set param_value [lindex [regexp -all -inline {\S+} $args] end]
            foreach item $board_if {
                if {[get_property $param_type $item] == $param_value } {
                    set bif_string "$bif_string,$item" 
                }
            }
        }
    }

    set BOARD_IF_NAME [ipgui::add_param $ipview -name $userparam -parent $BoardTable -widget comboBox]
    set INTERFACE [ipgui::add_static_text $ipview -name "Board::$intfname" -parent $BoardTable -text "$intfname"]
    set_range $userparam $bif_vlnv $ipview
    set_property range "$bif_string" [ipgui::get_paramspec $userparam -of $ipview]
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
