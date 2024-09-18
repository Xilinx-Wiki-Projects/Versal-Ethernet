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
###########################################################################################################################################
###         HELPER FUNCTIONS START#<-<
###########################################################################################################################################
source_ipfile "utils/board/utils.tcl"

proc init_params {IPINST PARAM_VALUE.ETHERNET_BOARD_INTERFACE} {
    set_property preset_proc "ETHERNET_BOARD_INTERFACE_PRESET" ${PARAM_VALUE.ETHERNET_BOARD_INTERFACE}
}

proc ETHERNET_BOARD_INTERFACE_PRESET {IPINST PRESET_VALUE} {
    set mii_vlnv     "xilinx.com:interface:mii_rtl:1.0"
    set gmii_vlnv    "xilinx.com:interface:gmii_rtl:1.0"
    set rgmii_vlnv   "xilinx.com:interface:rgmii_rtl:1.0"
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

    if { $PRESET_VALUE == "Custom" } { return "" }

    set board [::ipxit::get_project_property BOARD]
    set ip_vlnv [get_property ipdef $IPINST]
    set vlnv [board::get_intf_vlnv $PRESET_VALUE]

    if {$vlnv == $mii_vlnv } {
        set ip_intf MII
    } elseif { $vlnv == $rgmii_vlnv } {
        set ip_intf RGMII
    } elseif { $vlnv == $sfp_vlnv } {
        set ip_intf SFP
    } elseif { $vlnv == $sgmii_vlnv } {
        set ip_intf SGMII
    } else {
        set ip_intf GMII
    }

    set preset_params [board_ip_presets $ip_vlnv $PRESET_VALUE $board $ip_intf]

    if { $preset_params != "" } {
        return $preset_params
    } else {
        return ""
    }
}

proc dbg_s_msg { msg } {
    set rand_id [expr {int(2000 + rand() * 1000)}]
    send_msg_id "EthXguiDbg-$rand_id" INFO "$msg"
}

proc dbg_brd_msg { msg } {
#    set rand_id [expr {int(300 + rand() * 100)}]
#    send_msg INFO $rand_id "$msg"
}

proc dbg_msg { msg } {
#    set rand_id [expr {int(600 + rand() * 100)}]
#    send_msg INFO $rand_id "$msg"
}

proc dbg_gui_msg { msg } {
#    set rand_id [expr {int(800 + rand() * 100)}]
#    send_msg_id "EthXgui-$rand_id" INFO "$msg"
}

proc set_tool_tip {param str} {
    set_property tooltip $str $param
}

set PR_PROC {
    proc update_param_value.<<n>> {IPINST param_value.<<n>> param_value.processor_mode } {
        set processor_mode  [get_property value  ${param_value.processor_mode} ]
        if {$processor_mode} {
            set_property enabled true   ${param_value.<<n>>}
        } else {
            set_property enabled false  ${param_value.<<n>>}
        }
        dbg_msg "proc update_param_value.<<n>> completed"
    }
}
set PR_PROC_NO_1588 {
    proc update_param_value.<<x>> {IPINST param_value.<<x>> param_value.processor_mode  param_value.Enable_1588} {
        set processor_mode  [get_property value  ${param_value.processor_mode} ]
        set enable_1588  [get_property value  ${param_value.Enable_1588} ]
        if {$processor_mode && (!$enable_1588)} {
            set_property enabled true   ${param_value.<<x>>}
        } else {
            set_property enabled false  ${param_value.<<x>>}
        }
        dbg_msg "proc update_param_value.<<x>> completed"
    }
}

proc check_params_util {IPINST PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PROJECT_PARAM.PART PROJECT_PARAM.SPEEDGRADE} {
    set t_speedgrade [get_project_property SPEEDGRADE  ]
    set t_part_name  [get_project_property PART        ]
    set t_familyA    [get_project_property ARCHITECTURE]
    set t_family     [get_project_property FAMILY      ]
    set t_pkg        [get_project_property PACKAGE     ]
    set t_brd        [get_project_property BOARD       ]
    set t_device     [get_project_property DEVICE      ]

    set c_family     ${PROJECT_PARAM.ARCHITECTURE}
    set c_device     ${PROJECT_PARAM.DEVICE}
    set c_package    [getpackage_name ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE} ${PROJECT_PARAM.DEVICE}]
    set c_speedgrade ${PROJECT_PARAM.SPEEDGRADE}
    set c_part       ${PROJECT_PARAM.PART}

    dbg_msg "IPinstance name is $IPINST "
    dbg_msg " # $t_part_name              # $t_familyA  # $t_family   # $t_pkg   # $t_brd                     # $c_family   # $c_device # $t_device # $c_package # $c_speedgrade # $t_speedgrade "
# xcku060-ffva1517-1L-i-es2 # kintexu     # kintexu     # ffva1517 #                            # kintexu     # xcku060   #           # ffva1517   # -1l           # -1L
# xc7vx690tffg1761-2        # virtex7     # virtex7     # ffg1761  # xilinx.com:vc709:part0:1.6 # virtex7     # xc7vx690t #           # ffg1761    # -2            # -2
# xq7z030rb484-1I           # zynq        # qzynq       # rb484    #                            # zynq        # xq7z030   # xq7z030   # rb484      # -1i           # -1I
# xczu3eg-sbva625-3-e-es1   # zynquplus   # zynquplus   # sbva625  #                            # zynquplus   # xczu3eg   # xczu3eg   # sbva625    # -3            # -3
# xa7z030fbg484-1Q          # zynq        # azynq       # fbg484   #                            # zynq        # xa7z030   # xa7z030   # fbg484     # -1q           # -1Q
# xcku9p-ffve900-1-i-es1    # kintexuplus # kintexuplus # ffve900  #                            # kintexuplus # xcku9p    # xcku9p    # ffve900    # -1            # -1
# xc7k355tlffv901-2L        # kintex7     # kintex7l    # ffv901   #                            # kintex7     # xc7k355tl # xc7k355tl # ffv901     # -2L           # -2L
# xq7a100tcs324-1I          # artix7      # qartix7     # cs324    #                            # artix7      # xq7a100t  # xq7a100t  # cs324      # -1I           # -1I
}

proc get_dvc_gt_xy_locs {gt_type} {
    set available_types [xit::get_device_data D_AVAILABLE_GT_TYPES -of [xit::current_scope]]
    set avl_val [regexp $gt_type $available_types]
    set c_family     [string tolower [get_project_property ARCHITECTURE]]

    if {$avl_val} {set avl_str "AVAILABLE"} else {set avl_str "NOT AVAILABLE"}
    set gt_bonded_l "" ; set gt_loc_list ""
    if { [regexp $gt_type $available_types] } {
        set gt_full_l [xit::get_device_data D_AVAILABLE_GT_SITES $gt_type -of [xit::current_scope]]
        foreach site $gt_full_l {
            set isBonded  [::xit::get_device_data D_GT_SITE_IS_BONDED $site -of [xit::current_scope]]
            if { $isBonded || [regexp versal $c_family] } {
                set gt_bonded_l "$site $gt_bonded_l"
                set gt_site_loc [split [::xit::get_device_data D_GT_SITE_LOC $site -of [xit::current_scope]] ]
                set gt_loc_list "X[lindex $gt_site_loc 0]Y[lindex $gt_site_loc 1] $gt_loc_list "
            }
        }
    }
    set gt_loc_list [lsort -dictionary $gt_loc_list]
#    dbg_msg " get_dvc_gt_xy_locs : $gt_type is $avl_str in $available_types \n The XY locations are $gt_loc_list \n The GTs are [join $gt_bonded_l "\n"]"
    return "$gt_loc_list"
}

proc get_dvc_gt_refclk_locs {gt_site_loc gt_type} {
    set dvc_name "" ; set ref_clk_l ""
    if { $gt_type == "GTY" } {
        if { [get_dvc_has_gty3] } { set dvc_name "GTYE3_CHANNEL" } elseif { [get_dvc_has_gty4] } { set dvc_name "GTYE4_CHANNEL" } elseif { [get_dvc_has_gty5] } { set dvc_name "GTY_QUAD" } elseif { [get_dvc_has_gtyp] } { set dvc_name "GTYP_QUAD" }
    } else {
        if { [get_dvc_has_gth3] } { set dvc_name "GTHE3_CHANNEL" } elseif { [get_dvc_has_gth4] } { set dvc_name "GTHE4_CHANNEL" }
    }

# dbg_msg  " 136 - set gt_clk_pins xit::get_device_data D_GT_SITE_CLOCK_LOCS -$dvc_name _$gt_site_loc  -of xit::current_scope "
    set gt_clk_pins ""
    set d [ catch { set gt_clk_pins [xit::get_device_data D_GT_SITE_CLOCK_LOCS "${dvc_name}_${gt_site_loc}" -of [xit::current_scope]] } ]
# dbg_msg  " 138 - $d "
    if {$gt_clk_pins == "" } {
# dbg_msg "no gt clock pins found exiting."
        return clk0
    }

    set mgt_clk_srcs [lsort -unique [regexp -all -inline -nocase -- {mgtrefclk\d+.gt..._common_x\d+y\d+} $gt_clk_pins]]
    set sth_clk_srcs [lsort -unique [regexp -all -inline -nocase -- {uthrefclk\d+.gt..._common_x\d+y\d+} $gt_clk_pins]]
    set nrt_clk_srcs [lsort -unique [regexp -all -inline -nocase -- {rthrefclk\d+.gt..._common_x\d+y\d+} $gt_clk_pins]]

    set mgt_clk_srcn [lsort -unique -dictionary [regexp -all -inline -nocase -- {y\d+} $mgt_clk_srcs]]
    set sth_clk_srcn [lsort -unique -dictionary [regexp -all -inline -nocase -- {y\d+} $sth_clk_srcs]]
    set nrt_clk_srcn [lsort -unique -dictionary [regexp -all -inline -nocase -- {y\d+} $nrt_clk_srcs]]

    dbg_msg "ref clk $gt_site_loc mgt numbers are $mgt_clk_srcn and locs: $mgt_clk_srcs"
    dbg_msg "ref clk $gt_site_loc sth numbers are $sth_clk_srcn and locs: $sth_clk_srcs"
    dbg_msg "ref clk $gt_site_loc nrt numbers are $nrt_clk_srcn and locs: $nrt_clk_srcs"

    foreach clksrc $mgt_clk_srcs {
        set fir "refclk0.gt..._common_x\\d\+${mgt_clk_srcn}" ; set sec "refclk1.gt..._common_x\\d+${mgt_clk_srcn}"
        if       {[regexp -nocase $fir $clksrc ]} { set ref_clk_l "$ref_clk_l clk0"
        } elseif {[regexp -nocase $sec $clksrc ]} { set ref_clk_l "$ref_clk_l clk1"
        } else { dbg_msg "noting matched for $clksrc"
        }
    }
    foreach clksrc $sth_clk_srcs {
        set one [lindex $sth_clk_srcn 0] ; set two [lindex $sth_clk_srcn end]
        set fir "refclk0.gt..._common_x\\d+$one"    ; set sec "refclk1.gt..._common_x\\d+$one"    ;
        set thd "refclk0.gt..._common_x\\d+$two"    ; set fur "refclk1.gt..._common_x\\d+$two"    ;
        if       {[regexp -nocase $fir $clksrc ]} { set ref_clk_l "$ref_clk_l clk0+1"
        } elseif {[regexp -nocase $sec $clksrc ]} { set ref_clk_l "$ref_clk_l clk1+1"
        } elseif {[regexp -nocase $thd $clksrc ]} { set ref_clk_l "$ref_clk_l clk0+2"
        } elseif {[regexp -nocase $fur $clksrc ]} { set ref_clk_l "$ref_clk_l clk1+2"
        } else { dbg_msg "noting matched for $clksrc"
        }
    }
    foreach clksrc $nrt_clk_srcs {
        set one [lindex $nrt_clk_srcn 0] ; set two [lindex $nrt_clk_srcn end]
        set fir "refclk0.gt..._common_x\\d+$one"    ; set sec "refclk1.gt..._common_x\\d+$one"    ;
        set thd "refclk0.gt..._common_x\\d+$two"    ; set fur "refclk1.gt..._common_x\\d+$two"    ;
        if       {[regexp -nocase $fir $clksrc ]} { set ref_clk_l "$ref_clk_l clk0-1"
        } elseif {[regexp -nocase $sec $clksrc ]} { set ref_clk_l "$ref_clk_l clk1-1"
        } elseif {[regexp -nocase $thd $clksrc ]} { set ref_clk_l "$ref_clk_l clk0-2"
        } elseif {[regexp -nocase $fur $clksrc ]} { set ref_clk_l "$ref_clk_l clk1-2"
        } else { dbg_msg "noting matched for $clksrc"
        }
    }

# dbg_msg "ref clks for $gt_site_loc are $ref_clk_l"
    return "$ref_clk_l"
}

proc get_dvc_gt_type {gt_type} {
    set available_types [xit::get_device_data D_AVAILABLE_GT_TYPES -of [xit::current_scope]]
    set avl_val [regexp $gt_type $available_types]
    set c_family     [string tolower [get_project_property ARCHITECTURE]]
    set gt_bonded_l ""
    set ret_str "NOT PRESENT"
    set devicepart [get_project_property PART]
    if { [regexp versal $c_family] } {
      set available_gts [xit::get_device_data -part $devicepart D_AVAILABLE_SITE_TYPES GT -of [xit::current_scope]]
      if {[expr {[lsearch $available_gts $gt_type]} != -1]} {
	set list [xit::get_device_data D_AVAILABLE_GT_SITES $gt_type -of [xit::current_scope]]
        foreach site $list {
            set isBonded  [::xit::get_device_data D_GT_SITE_IS_BONDED $site -of [xit::current_scope]]
            if {($isBonded)} {
                set gt_bonded_l "$gt_bonded_l $site"
                set ret_val [expr {[string length $gt_bonded_l] > 1}]
                if {$ret_val} {set ret_str "PRESENT"} else {set ret_str "NOT PRESENT"}
                continue
            }
        }
        return [expr {$ret_str == "PRESENT"}]
      } else {
	return false
      } 
    }
    if {$avl_val} {set avl_str "AMONG"} else {set avl_str "NOT AMONG"}
    set gt_bonded_l ""
    set ret_str "NOT PRESENT"
    if { [regexp $gt_type $available_types] } {
        set list [xit::get_device_data D_AVAILABLE_GT_SITES $gt_type -of [xit::current_scope]]
        foreach site $list {
            set isBonded  [xit::get_device_data D_GT_SITE_IS_BONDED $site -of [xit::current_scope]]
            if { $isBonded } {
                set gt_bonded_l "$gt_bonded_l $site"
                set ret_val [expr {[string length $gt_bonded_l] > 1}]
                if {$ret_val} {set ret_str "PRESENT"} else {set ret_str "NOT PRESENT"}
                continue
            }
        }
    }
#    dbg_msg " 60 - The GT $gt_type for part [get_project_property PART] is $avl_str available types and is $ret_str in [xit::current_scope] scope\n Available / bonded GT sites are :$gt_bonded_l: \n Available GT types are $available_types"
    return [expr {[string length [string trim $gt_bonded_l]] > 1}]
}

proc get_dvc_has_gtp2 {} {
    return [get_dvc_gt_type GTPE2_CHANNEL]
}

proc get_dvc_has_gtx2 {} {
    return [get_dvc_gt_type GTXE2_CHANNEL]
}

proc get_dvc_has_gth2 {} {
    return [get_dvc_gt_type GTHE2_CHANNEL]
}

proc get_dvc_has_gty3 {} {
    return [get_dvc_gt_type GTYE3_CHANNEL]
}

proc get_dvc_has_gty4 {} {
    return [get_dvc_gt_type GTYE4_CHANNEL]
}

proc get_dvc_has_gty5 {} {
    return [get_dvc_gt_type GTY_QUAD ]
    }
    
proc get_dvc_has_gtyp {} {
    return [get_dvc_gt_type GTYP_QUAD ]
    }    

proc get_dvc_has_gth3 {} {
    return [get_dvc_gt_type GTHE3_CHANNEL]
}

proc get_dvc_has_gth4 {} {
    return [get_dvc_gt_type GTHE4_CHANNEL]
}

proc get_dvc_has_gth34 {} {
    return [expr { [get_dvc_has_gth3] || [get_dvc_has_gth4] } ]
}

proc get_dvc_has_gty34 {} {
    return [expr { [get_dvc_has_gty3] || [get_dvc_has_gty4] } ]
}

proc get_dvc_has_gty5p {} {
    return [expr { [get_dvc_has_gty5] || [get_dvc_has_gtyp] } ]
}



proc get_dvc_is_uscale {} {
    set dvc_arch    [get_project_property ARCHITECTURE]
    return [regexp -nocase "^(kintexu|virtexu)$" $dvc_arch]
}

proc get_dvc_is_uscaleplus {} {
    set dvc_arch    [get_project_property ARCHITECTURE]
    return [regexp -nocase "uplus" $dvc_arch]
}

proc get_dvc_is_us {} {
    set dvc_arch    [get_project_property ARCHITECTURE]
    return [regexp -nocase "kintexu|virtexu|zynqu" $dvc_arch]
}

proc get_dvc_is_versal {} {
    set dvc_arch    [get_project_property ARCHITECTURE]
    return [regexp -nocase "versal|versales1|versal|versalea|versaleaes1" $dvc_arch]
}

proc no_versal_lvds {} {
    set SIM_DEVICE   [get_device_data D_SIM BUFGCE]
    set devicepart   [get_project_property PART]
    set c_speedgrade [string tolower [get_project_property SPEEDGRADE  ]]
    if { ([get_dvc_is_versal] && ([regexp {(xcvp10[0|5]2)-(nfvi1369)} $devicepart])) } {
      return true
    } else {
      return false
    }

}
proc get_dvc_suprt_sgmii_lvds {} {
    set c_family     [string tolower [get_project_property ARCHITECTURE]]
    set c_device     [string tolower [get_project_property DEVICE      ]]
    set c_speedgrade [string tolower [get_project_property SPEEDGRADE  ]]
    if { ([regexp artix7 $c_family] && ([regexp "1" $c_speedgrade] || ([regexp -nocase tl $c_device])))
         || ([regexp spartan7 $c_family] && ([regexp "1" $c_speedgrade] || ([regexp -nocase "2l" $c_speedgrade] && [regexp -nocase tl $c_device])))
         || ([string match -nocase zynq $c_family] && (([regexp 7z01 $c_device] || [regexp 7z02 $c_device]) && [regexp "1" $c_speedgrade])) 
         || ([get_dvc_is_versal] && [no_versal_lvds])  } {
        return  false
    } else {
        return true
    }
}

proc get_dvc_suprt_1gbx_lvds {} {
# 1000basex LVDS is not available through GUI.
#   return false
# 1000basex LVDS limited to only US. for US+ it is expected to work but it is not characterised.
# This is supported with with shared logic in core mode only.
    if { [get_dvc_is_versal] && [no_versal_lvds] } { return  false }
    if { [get_dvc_is_us] || [get_dvc_is_versal] } { return  true } else { return false }
}

proc get_dvc_suprt_async_sgmii_lvds {} {
# 1000basex LVDS is not available through GUI.
#   return false
# 1000basex LVDS limited to only US. for US+ it is expected to work but it is not characterised.
# This is supported with with shared logic in core mode only.
    if { [get_dvc_is_versal] && [no_versal_lvds] } { return  false }
    if { [get_dvc_is_us] || [get_dvc_is_versal] } { return  true } else { return false }
}

proc get_dvc_suprt_2p5 {} {
    set c_speedgrade [string toupper [get_project_property SPEEDGRADE  ]]
    if {   [get_dvc_has_gth34]
        || [get_dvc_has_gty34]
        || [get_dvc_has_gth2]
        || ([get_dvc_has_gtp2] && [regexp {(2|2L|3)$} $c_speedgrade])
        || [get_dvc_has_gtx2]
        || [get_dvc_has_gty5p] } {
        return true
    } else {
        return  false
    }
}

proc get_dvc_suprt_transvr {} {
    if {   [get_dvc_has_gth34]
        || [get_dvc_has_gty34]
        || [get_dvc_has_gth2]
        || [get_dvc_has_gtx2]
        || [get_dvc_has_gtp2]
        || [get_dvc_has_gty5p] } {
        return true
    } else {
        return false
    }
}

proc get_dvc_suprt_1588 {} {
# 1588 can only be supported in GTX  and GTH for this release. GTHE4 needs to be checked for 1588
    if {   [get_dvc_has_gth3]
        || [get_dvc_has_gth4]
        || [get_dvc_has_gty4]
        || [get_dvc_has_gty3]
        || [get_dvc_has_gth2]
        || [get_dvc_has_gtx2]
        || [get_dvc_has_gty5p] } {
        return true
    } else {
        return false
    }
}

###########################################################################################################################################
###         HELPER FUNCTIONS END#>->
###########################################################################################################################################
###########################################################################################################################################
###         DYNAMIC TEXT FUNCTIONS START#<-<
###########################################################################################################################################
proc DT_Phy_type { param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE param_value.speed_1_2p5 } {
    set c_family  [get_project_property ARCHITECTURE]
    set c_device  [get_project_property DEVICE      ]
    set c_package [get_project_property PACKAGE     ]
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    set text {}
    switch -- $c_family {
        "virtex7"   {
            if {$phy_type == "mii"} {
                set text  "WARNING: The selected Part/Package only has 1.8V I/O and does not natively support MII"
            } elseif {$phy_type == "gmii"} {
                set text  "WARNING: The selected Part/Package only has 1.8V I/O and does not natively support GMII"
            } elseif {$phy_type == "rgmii"} {
                set text  "WARNING: RGMII v2.0 is only supported at 1.8V: please check PHY compatibility"
            } elseif {$phy_type == "both"} {
                set text   "This mode would instantiate an on-chip PHY. Dynamic Switching between SGMII and 1000BASEX modes of operation."
            }
            if { [regexp -nocase -- ffg1761 $c_package]} {
                if { [regexp -nocase -- (vx330|v585) $c_device] } {
                    if {$phy_type == "mii"} {
                        set text  "WARNING: only HR I/O supports 2.5V/3.3V MII in the selected Part/Package"
                    } elseif  {$phy_type == "gmii"} {
                        set text  "WARNING: only HR I/O supports 2.5V/3.3V GMII in the selected Part/Package"
                    } elseif {$phy_type == "rgmii"} {
                        set text  "WARNING: RGMII v2.0 is supported at 1.8V in HP I/O or up to 2.5V in HR I/O: please check PHY compatibility"
                    } elseif {$phy_type == "both"} {
                        set text   "This mode would instantiate an on-chip PHY. Dynamic Switching between SGMII and 1000BASEX modes of operation."
                    }
                }
            }
        }
        default {
            if {$phy_type == "mii"} {
                set text  "WARNING: only HR I/O supports 2.5V/3.3V MII in the selected Part/Package"
            } elseif {$phy_type == "gmii"} {
                set text  "WARNING: only HR I/O supports 2.5V/3.3V GMII in the selected Part/Package"
            } elseif {$phy_type == "rgmii"} {
                set text  "WARNING: RGMII v2.0 is supported at 1.8V in HP I/O or up to 2.5V in HR I/O: please check PHY compatibility"
           }  elseif {$phy_type == "both"} {
                set text   "This mode would instantiate an on-chip PHY. Dynamic Switching between SGMII and 1000BASEX modes of operation."
            }
        }
    }
    if {($phy_type == "sgmii") || ($phy_type == "1000basex")} {
        if { $speed_is_2p5 } {
            set text  "This mode would instantiate an on-chip PHY. Data rate is 2.5G for SGMII and 2500BASEX modes of operation."
        } else {
            set text  "This mode would instantiate an on-chip PHY. Data rate is 10/100/1000 Mbps for SGMII and 1G for 1000BASEX modes of operation."
        }
    }
    return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$text"
}

proc DT_Support_Level {phy_type include_io} {
    set text {}
    if {$phy_type == "gmii" && $include_io } {
        set text "Select whether the IDELAYCTRL is included in core or not included in core."
    } elseif {$phy_type == "gmii" && !$include_io } {
        set text "There is no shareable logic for GMII Internal mode."
    } elseif {$phy_type == "rgmii" } {
        set text "Select whether the IDELAYCTRL (and the Tx MMCM with its associated clock buffers \nfor Artix-7 or Kintex-7 devices) are included in core or not included in core."
    } elseif {$phy_type == "mii" } {
        set text "There is no shareable logic for MII. Both options are same."
    } elseif {$phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both"} {
        set text "Select whether the transceiver quad PLL, transceiver differential reference clock buffer, MMCM, \nIDELAYCTRL and clock buffer are included in core or not included in core."
    } else {
        set text "Refer PG for resource sharing details."
    }
    return $text
}

proc DT_Shared_Logic { param_value.SupportLevel } {
    set suprt_lvl  [get_property value ${param_value.SupportLevel}]
    if {$suprt_lvl == 1} {
        set    text "Include Shared Logic in Core\n"
        append text "- For users who want a complete single solution.\n"
        append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n"
    } else {
        set    text "Include Shared Logic in example design\n"
        append text "- For users who want the Shared Logic outside the core.\n"
        append text "- For users who want to edit the Shared Logic or use their own.\n"
        append text "- For users who want one core with Shared Logic to drive multiple cores without Shared Logic.\n\n"
    }
    return $text
}

proc DT_phy_type_space { param_value.PHY_TYPE } {
    set phy_type  [get_property value ${param_value.PHY_TYPE}]
    set text "\n"
    return $text
}

###########################################################################################################################################
###         DYNAMIC TEXT FUNCTIONS END#>->
###########################################################################################################################################
###########################################################################################################################################
###         BOARD Functions   START#<-<
###########################################################################################################################################
proc create_board_gui { IPINST  } {
    set mdio_vlnv  "xilinx.com:interface:mdio_rtl:1.0"
    set diffclk_vlnv "xilinx.com:interface:diff_clock_rtl:1.0"
    set phyrst_vlnv  "xilinx.com:signal:reset_rtl:1.0"

    set BoardPage [board::create_board_page $IPINST]
    set USE_BOARD_FLOW [ipgui::add_param $IPINST -name USE_BOARD_FLOW -parent $BoardPage -widget checkBox]
    set board_tab_entries [get_board_tab_entries]
    dbg_brd_msg "create_board_gui_1: Board page is :$BoardPage : The board tab entries are :$board_tab_entries : "
    if { $board_tab_entries != 0} {
        set BoardTable [board::create_board_table $IPINST $BoardPage [expr $board_tab_entries +1]]
        set board_entry_index 1
        if { [is_ethernet_intf_exist_in_board] } {
            set ETHERNET_BOARD_INTERFACE [board::add_ethernet_board_if_option $IPINST $BoardTable ETHERNET ETHERNET_BOARD_INTERFACE $board_entry_index]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        if { [board::is_intf_exist_in_board $mdio_vlnv]} {
            set MDIO_BOARD_INTERFACE [board::add_board_if_option $IPINST $BoardTable MDIO MDIO_BOARD_INTERFACE $mdio_vlnv $board_entry_index]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        if { [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_MGT_CLK ETH_LVDS_CLK]} {
            set DIFFCLK_BOARD_INTERFACE [board::add_board_if_option $IPINST $BoardTable DIFFCLK DIFFCLK_BOARD_INTERFACE $diffclk_vlnv $board_entry_index PARAM.TYPE ETH_MGT_CLK ETH_LVDS_CLK]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master]} {
            set PHYRST_BOARD_INTERFACE [board::add_board_if_option $IPINST $BoardTable PHYRST_N PHYRST_BOARD_INTERFACE $phyrst_vlnv $board_entry_index MODE master]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE slave] } {
            set PHYRST_BOARD_INTERFACE_DUMMY_PORT [board::add_board_if_option $IPINST $BoardTable DUMMYPORT_IN PHYRST_BOARD_INTERFACE_DUMMY_PORT $phyrst_vlnv $board_entry_index MODE slave]
            set board_entry_index  [expr $board_entry_index + 1]
        }
        dbg_brd_msg "create_board_gui: $BoardPage is Created as total board tab entries are $board_entry_index."
    } else {
        dbg_brd_msg "create_board_gui: $BoardPage is not visible as board tab entries are 0. "
        set_property visible false $BoardPage
    }
}

proc get_board_tab_entries { } {
    set mdio_vlnv       "xilinx.com:interface:mdio_rtl:1.0"
    set diffclk_vlnv    "xilinx.com:interface:diff_clock_rtl:1.0"
    set phyrst_vlnv     "xilinx.com:signal:reset_rtl:1.0"

    set supported_ifs 0
    if { [board::is_enable_board_gui ] } {
        set board_name [get_property NAME [current_board_part]]
        if { [is_ethernet_intf_exist_in_board] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        if { [board::is_intf_exist_in_board $mdio_vlnv] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        if { [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_MGT_CLK ETH_LVDS_CLK] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE master] } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        if { [board::is_intf_exist_in_board $phyrst_vlnv MODE slave] && ([regexp vcu128 $board_name] || [regexp vcu129 $board_name]) } {
            set supported_ifs  [expr $supported_ifs + 1]
        }
        dbg_brd_msg "get_board_tab_entries returns $supported_ifs for supported interfaces as :eth [is_ethernet_intf_exist_in_board]: :mgtclk [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_MGT_CLK ETH_LVDS_CLK]: :mdio [board::is_intf_exist_in_board $mdio_vlnv]: :phyrst [board::is_intf_exist_in_board $phyrst_vlnv MODE master]: :dummyport [board::is_intf_exist_in_board $phyrst_vlnv MODE slave]: "
    } else {
        dbg_brd_msg "get_board_tab_entries returns 0 As no board is selected"
    }
    return $supported_ifs
}

proc is_ethernet_intf_exist_in_board { } {
    set mii_vlnv     "xilinx.com:interface:mii_rtl:1.0"
    set gmii_vlnv    "xilinx.com:interface:gmii_rtl:1.0"
    set rgmii_vlnv   "xilinx.com:interface:rgmii_rtl:1.0"
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

    dbg_brd_msg "is_ethernet_intf_exist_in_board returned : [board::is_intf_exist_in_board $sgmii_vlnv] [board::is_intf_exist_in_board $sfp_vlnv] [board::is_intf_exist_in_board $gmii_vlnv] [board::is_intf_exist_in_board $rgmii_vlnv] [board::is_intf_exist_in_board $mii_vlnv] :"
    if { [board::is_intf_exist_in_board $sgmii_vlnv] || [board::is_intf_exist_in_board $sfp_vlnv] || [board::is_intf_exist_in_board $gmii_vlnv] || [board::is_intf_exist_in_board $rgmii_vlnv] || [board::is_intf_exist_in_board $mii_vlnv] } {
        return 1
    } else {
        return 0
    }
}

###########################################################################################################################################
###    Board Functions      END#>->
###########################################################################################################################################
###########################################################################################################################################
###         START#<-<
###########################################################################################################################################
###########################################################################################################################################
###         END#>->
###########################################################################################################################################
###########################################################################################################################################
###         INIT GUI START#<-<
###########################################################################################################################################
proc init_gui { IPINST } {
    set d [ catch {

        set component_name  [ipgui::add_param  $IPINST -parent $IPINST -name Component_Name ]
        set_property show_ipsymbol true   [ipgui::get_canvasspec -of $IPINST]
        # set_property hide_disabled_pins false [ipgui::get_canvasspec -of $IPINST]
        if { ![get_dvc_is_versal] } {
          create_board_gui $IPINST
        }

        set InterfacePage        [ ipgui::add_page $IPINST  -name "Physical Interface" -layout vertical]
        set eth_spd     [ipgui::add_param $IPINST -parent $InterfacePage -name  speed_1_2p5 -widget radioGroup  -display_name "Ethernet Speed" -layout horizontal]
        set PHY_TYPE    [ipgui::add_param $IPINST -parent $InterfacePage -name  PHY_TYPE -widget radioGroup -layout horizontal -show_label false]
        ipgui::add_dynamic_text $IPINST  -parent $InterfacePage  -name n_phy_type -display_border false -tclproc DT_Phy_type
        ipgui::add_static_text  $IPINST  -parent $InterfacePage  -name n1_phytype -text "\n"

        set incio_grp   [ipgui::add_group $IPINST -parent $InterfacePage -name incio_grp    -display_name "Configure TEMAC to Include IO Elements." ]
        set Include_IO  [ipgui::add_param $IPINST -parent $incio_grp     -name Include_IO   -display_name "Select to Include IO Elements. De-select to configure TEMAC in INTERNAL mode."]

        set gt_grp      [ipgui::add_group $IPINST -parent $InterfacePage -name gt_grp       -display_name "Transceiver Options" -layout vertical ]

        set lvds_grp    [ipgui::add_group $IPINST -parent $gt_grp        -name lvds_grp     -display_name "LVDS Option"                       ]
        if { [get_dvc_is_versal] } {
	    set enable_lvds [ipgui::add_param $IPINST -parent $lvds_grp      -name ENABLE_LVDS   -display_name "Enable Advanced IO (LVDS) for 1000BASE-X/SGMII instead of a transceiver."]
        } else {
	    set enable_lvds [ipgui::add_param $IPINST -parent $lvds_grp      -name ENABLE_LVDS   -display_name "Enable Standard I/O (LVDS) for 1000BASE-X/SGMII instead of a transceiver."]
        }
        set en_asgmii   [ipgui::add_param $IPINST -parent $lvds_grp      -name EnableAsyncSGMII   -display_name "Enable Asynchronous SGMII."]
        set Clock_Selection [ipgui::add_group $IPINST -parent $gt_grp -name "Clock_Selection" -layout vertical]    
        set ClockSelection [ipgui::add_param $IPINST -name ClockSelection -parent $Clock_Selection -widget comboBox] 

        set phyadr_grp  [ipgui::add_group $IPINST -parent $gt_grp        -name phyadr_grp   -display_name "MDIO Phy Address of internal 1000BASE-X/SGMII" ]
        set PHYADDR     [ipgui::add_param $IPINST -parent $phyadr_grp    -name  PHYADDR                                                             ]

        set gtclkr_grp  [ipgui::add_group $IPINST -parent $gt_grp        -name gtclkr_grp   -display_name "GT Reference Clock Frequency MHz" ]
        set gtclkrate   [ipgui::add_param $IPINST -parent $gtclkr_grp    -name gtrefclkrate -widget radioGroup -show_label false -layout horizontal]
        if { [get_dvc_is_versal] } {
	    set lvclkr_grp  [ipgui::add_group $IPINST -parent $gt_grp        -name lvclkr_grp   -display_name "Advanced IO PLL Input Clock" ]
        } else {
	    set lvclkr_grp  [ipgui::add_group $IPINST -parent $gt_grp        -name lvclkr_grp   -display_name "LVDS Clock Frequency MHz" ]
	}
        set lvdsclkrate [ipgui::add_param $IPINST -parent $lvclkr_grp    -name lvdsclkrate  -widget radioGroup -show_label false -layout horizontal]
        if { [get_dvc_is_versal] } {
	    set_property display_name "PLL Clock Frequency (MHz)" $lvdsclkrate
	}
        set gt_type     [ipgui::add_param $IPINST -parent $gt_grp        -name  gt_type     -display_name "Choose GT Type" -widget radioGroup   -layout horizontal     ]

        set drp_grp     [ipgui::add_group $IPINST -parent $gt_grp        -name drp_grp      -display_name "Transceiver Debug" -layout vertical      ]
        set Enable_drp  [ipgui::add_param $IPINST -parent $drp_grp       -name  TransceiverControl                                                  ]
        set drpclkrate  [ipgui::add_param $IPINST -parent $drp_grp       -name  drpclkrate  -display_name "  DRP Clock Frequency MHz"               ]

        set FeaturesPage    [ ipgui::add_page $IPINST  -name "MAC Features" -layout vertical]

        set processor_mode  [ipgui::add_param $IPINST -parent $FeaturesPage -name  processor_mode   -display_name "Enable Processor Features (Enables AXI Buffer and drivers)." ]

        set embeded_grp  [ipgui::add_group $IPINST -parent $FeaturesPage  -name "embeded_grp" -display_name "Processor Mode Options" -layout vertical -collapsed false ]

        set embeded_pnl1 [ipgui::add_panel $IPINST -parent $embeded_grp  -name embeded_pnl1   -layout horizontal]
        set Tx_Op_pnl1   [ipgui::add_panel $IPINST -parent $embeded_pnl1 -name Tx_Op_pnl1                       ]
        set Rx_Op_pnl1   [ipgui::add_panel $IPINST -parent $embeded_pnl1 -name Rx_Op_pnl1                       ]
        set Tx_Op_pnl2   [ipgui::add_panel $IPINST -parent $Tx_Op_pnl1   -name Tx_Op_pnl2                       ]
        set Rx_Op_pnl2   [ipgui::add_panel $IPINST -parent $Rx_Op_pnl1   -name Rx_Op_pnl2                       ]

        set TXMEM        [ipgui::add_param $IPINST -parent $Tx_Op_pnl2   -name TXMEM     -widget comboBox       ]
        set TXCSUM       [ipgui::add_param $IPINST -parent $Tx_Op_pnl2   -name TXCSUM    -widget comboBox       ]
        set RXMEM        [ipgui::add_param $IPINST -parent $Rx_Op_pnl2   -name RXMEM     -widget comboBox       ]
        set RXCSUM       [ipgui::add_param $IPINST -parent $Rx_Op_pnl2   -name RXCSUM    -widget comboBox       ]

        set TXVLAN_TRAN  [ipgui::add_param $IPINST -parent $Tx_Op_pnl1   -name TXVLAN_TRAN                      ]
        set TXVLAN_TAG   [ipgui::add_param $IPINST -parent $Tx_Op_pnl1   -name TXVLAN_TAG                       ]
        set TXVLAN_STRP  [ipgui::add_param $IPINST -parent $Tx_Op_pnl1   -name TXVLAN_STRP                      ]
        set RXVLAN_TRAN  [ipgui::add_param $IPINST -parent $Rx_Op_pnl1   -name RXVLAN_TRAN                      ]
        set RXVLAN_TAG   [ipgui::add_param $IPINST -parent $Rx_Op_pnl1   -name RXVLAN_TAG                       ]
        set RXVLAN_STRP  [ipgui::add_param $IPINST -parent $Rx_Op_pnl1   -name RXVLAN_STRP                      ]
        set MCAST_EXTEND [ipgui::add_param $IPINST -parent $Rx_Op_pnl1   -name MCAST_EXTEND                     ]

        set pfc_grp    [ipgui::add_group $IPINST -parent $FeaturesPage -name "pfc_grp" -display_name "Flow Control Options" -layout vertical]
        set Enable_Pfc [ipgui::add_param $IPINST -parent $pfc_grp -name  Enable_Pfc ]

        set stats_grp  [ipgui::add_group $IPINST -parent $FeaturesPage -name stats_grp              -display_name "Statistics Counter Options" -layout vertical]
        set stats_pn11 [ipgui::add_panel $IPINST -parent $stats_grp    -name stats_pn11             -layout horizontal                                         ]
        set stats_pn12 [ipgui::add_panel $IPINST -parent $stats_pn11   -name stats_pn12             -layout vertical                                           ]
        set stat_Cntrs [ipgui::add_param $IPINST -parent $stats_pn12   -name Statistics_Counters    -display_name "Enable Statistics Counters                         "]
        set stat_Reset [ipgui::add_param $IPINST -parent $stats_pn12   -name Statistics_Reset                         ]
        set stat_Width [ipgui::add_param $IPINST -parent $stats_pn11   -name Statistics_Width       -layout horizontal]

        set fltrs_grp  [ipgui::add_group $IPINST -parent $FeaturesPage  -name "fltrs_grp"       -display_name "Frame Filter Options" -layout vertical ]
        set en_fltrs   [ipgui::add_param $IPINST -parent $fltrs_grp     -name  Frame_Filter     -display_name "Enable Frame Filters"                  ]
        set nooffltrs  [ipgui::add_param $IPINST -parent $fltrs_grp     -name  Number_of_Table_Entries                                                ]

        set TimingPage        [ipgui::add_page  $IPINST -name   "Network Timing" -layout vertical     ]
        dbg_gui_msg "Timing page creation started"
        set en_1588_grp       [ipgui::add_group $IPINST -parent $TimingPage     -name en_1588_grp -display_name "IEEE1588-2008 Hardware Time-stamping Support for modes with GT." -layout vertical]
        set Enable_1588       [ipgui::add_param $IPINST -parent $en_1588_grp    -name Enable_1588     ]
        set Op_1588_grp       [ipgui::add_group $IPINST -parent $en_1588_grp    -name Op_1588_grp -display_name "Time-stamping Support Options" -layout vertical]
        set TIMER_CLK_PERIOD  [ipgui::add_param $IPINST -parent $Op_1588_grp    -name TIMER_CLK_PERIOD]
        set tmrfmt_stp_pnl    [ipgui::add_panel $IPINST -parent $Op_1588_grp    -name tmrfmt_stp_pnl    -layout horizontal                    ]
        set Enable_1588_1step [ipgui::add_param $IPINST -parent $tmrfmt_stp_pnl -name Enable_1588_1step -widget radioGroup  -layout horizontal]
        set Timer_Format      [ipgui::add_param $IPINST -parent $tmrfmt_stp_pnl -name Timer_Format      -widget radioGroup  -layout horizontal]

        set En_avb_grp [ipgui::add_group $IPINST -parent $TimingPage -name En_avb_grp -display_name "Ethernet Audio Video Bridging (AVB) Support (IEEE802.1AS, IEEE802.1Qat)" -layout vertical]
        set ENABLE_AVB [ipgui::add_param $IPINST -parent $En_avb_grp -name  ENABLE_AVB ]
        ipgui::add_static_text  $IPINST -name label_avb -parent $En_avb_grp -text "The Ethernet AVB feature requires a separate fee based license and is not available with the MII I/F."
        dbg_gui_msg "Timing page creation completed"

        set Shared_Logic [ipgui::add_page $IPINST -name Shared_Logic -display_name "Shared Logic" -layout vertical ]
        dbg_gui_msg "Shared_Logic page  creation started"
        set suprt_lvl [ipgui::add_param $IPINST -parent $Shared_Logic  -name SupportLevel]
        set SL_desc "There is no shareable logic for GMII Internal mode."
        set_property description $SL_desc [ipgui::get_guiparamspec SupportLevel -of $IPINST]
        set GTinEx  [ipgui::add_param $IPINST -parent $Shared_Logic -name GTinEx]
        set supportl_info_grp [ipgui::add_group $IPINST -parent $Shared_Logic -name supportl_info_grp -display_name "Shared Logic Overview" -layout vertical]
        ipgui::add_dynamic_text $IPINST -name label_shared_logic -parent $supportl_info_grp  -tclproc DT_Shared_Logic
        ipgui::add_image $IPINST -name PixmapAFix2 -parent $supportl_info_grp -width 400 -height 400
        set_property load_image "xgui/with_shared_logic.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        dbg_gui_msg "Shared_Logic page  creation completed"

        set oocstngs        [ipgui::add_page  $IPINST -name "OOC Settings" -layout vertical]
        dbg_gui_msg "OOC settings page  creation started"
        set ooc_grp         [ipgui::add_group $IPINST -parent $oocstngs    -name ooc_grp -display_name "Clock frequency Settings for OOC mode" -layout vertical]
        set axilclkrate     [ipgui::add_param $IPINST -parent $ooc_grp     -name  axiliteclkrate  -display_name "AXI4-Lite Clock Frequency MHz"  ]
        set axisclkrate     [ipgui::add_param $IPINST -parent $ooc_grp     -name  axisclkrate     -display_name "AXI4-Stream Clock Frequency MHz"  ]
        set SIMULATION_MODE [ipgui::add_param $IPINST -parent $oocstngs    -name  SIMULATION_MODE ]
        dbg_gui_msg "OOC settings page  creation completed"

        set locations_page        [ipgui::add_page $IPINST  -name "Locations" -layout vertical                                                                                 ]
        dbg_gui_msg "LOC settings page  creation Started"
        set lvds_loc_grp          [ipgui::add_group $IPINST -parent $locations_page   -name "lvds_loc_grp" -layout vertical   -display_name "Select LVDS Locations"   ]
        set lvds_bitslice_grp     [ipgui::add_group $IPINST -parent $lvds_loc_grp    -name lvds_bitslice_grp     -layout vertical   -display_name "LVDS BITSLICE settings"]
        set tx_in_upper_nibble    [ipgui::add_param $IPINST -parent $lvds_bitslice_grp -name tx_in_upper_nibble    -layout horizontal -display_name "Select TX in upper nibble"]
        set rxnibblebitslice0used [ipgui::add_param $IPINST -parent $lvds_bitslice_grp -name rxnibblebitslice0used -layout horizontal -display_name "RX nibble BITSLICE_0 is used."]
        set InstantiateBitslice0  [ipgui::add_param $IPINST -parent $lvds_bitslice_grp -name InstantiateBitslice0 -widget comboBox]
        set lane0_grp             [ipgui::add_group $IPINST -parent $lvds_loc_grp    -name lane0_grp             -layout vertical   -display_name "Lane 0 placement settings" ]
        set txlane0_placement     [ipgui::add_param $IPINST -parent $lane0_grp         -name txlane0_placement     -layout horizontal -display_name "TX Lane 0"]
        set rxlane0_placement     [ipgui::add_param $IPINST -parent $lane0_grp         -name rxlane0_placement     -layout horizontal -display_name "RX Lane 0"]
        set lane1_grp             [ipgui::add_group $IPINST -parent $lvds_loc_grp    -name lane1_grp             -layout vertical   -display_name "Lane 1 placement settings" ]
        set txlane1_placement     [ipgui::add_param $IPINST -parent $lane1_grp         -name txlane1_placement     -layout horizontal -display_name "TX Lane 1"]
        set rxlane1_placement     [ipgui::add_param $IPINST -parent $lane1_grp         -name rxlane1_placement     -layout horizontal -display_name "RX Lane 1"]
        set_property  visible false [ipgui::get_groupspec  lane1_grp -of $IPINST]

        set gt_loc_grp    [ipgui::add_group $IPINST -parent $locations_page   -name "gt_loc_grp" -layout horizontal  -display_name "Select GT Locations"  ]
        set gtlocation    [ipgui::add_param $IPINST -parent $gt_loc_grp -name gtlocation   -widget comboBox    ]
        set gtrefclksrc   [ipgui::add_param $IPINST -parent $gt_loc_grp -name gtrefclksrc  -widget comboBox    ]
        dbg_gui_msg "LOC settings page  creation completed"

# Tool Tips for different parameters.
        set_tool_tip $ENABLE_AVB        "This Audio Video Bridging support (802.1)."
        set_tool_tip $en_fltrs          "Configures the MAC Frame Filter abilities."
        set_tool_tip $nooffltrs         "The number of Table Entries (0 to 16)."
        set_tool_tip $stat_Cntrs        "Configures the Statistics Counteers abilities."
        set_tool_tip $stat_Reset        "Configures the Statistics Counteers Reset."
        set_tool_tip $stat_Width        "Configures the Statistics counters width."
        set_tool_tip $Enable_1588       "Enables the 1588 feature."
        set_tool_tip $Enable_1588_1step "The core will include 1-step 1588 support (2-step support is always included)."
        set_tool_tip $suprt_lvl      "Select the location of shareable logic."
#set_tool_tip $suprt_lvl      "Select the location of shareable logic. Shared Logic in IP Example design was earlier named as No Shared Logic in core."
        set_tool_tip $Enable_Pfc        "Enables the PFC feature."
        set_tool_tip $processor_mode     "This enables 'TCP/UDP full checksum offload', 'VLAN stripping, tagging, translation' and 'Extended filtering for multicast frames' features."
        set_tool_tip $Include_IO        "This would instantiate TEMAC in internal mode."
        set_tool_tip $eth_spd           "Data rate selection. This is enabled only for supported devices and in SGMII and 1000BaseX modes using GT."
        set_tool_tip $GTinEx           "Select the location of GT to be present in core or outside core."
        set_tool_tip $rxnibblebitslice0used "Use BITSLICE0 Location of RX Nibble as reference clock. This will instantiate a dummy bitslice and connect clock to it" 
        set_tool_tip $InstantiateBitslice0 "Instantiate BITSLICE0 with the RX Nibble. IO may be used as clock input based on RxNibbleBitslice0Used" 

        dbg_gui_msg "init_gui  completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg " init_gui error messages $d" }
}
###########################################################################################################################################
###         INIT GUI END#>->
###########################################################################################################################################
###########################################################################################################################################
###         Update Pram Value functions  Use the respective param function to enable/disable it or to update the value.      START#<-<
###########################################################################################################################################

proc update_param_value.USE_BOARD_FLOW {IPINST param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.DEVICE PROJECT_PARAM.PART PROJECT_PARAM.SPEEDGRADE} {
    set display_board_tab  [get_board_tab_entries         ]
    if {$display_board_tab != 0} {
        set_property value     true     ${param_value.USE_BOARD_FLOW}
        set_property enabled   true     ${param_value.USE_BOARD_FLOW}
    } else {
        set_property value     false     ${param_value.USE_BOARD_FLOW}
        set_property enabled   false     ${param_value.USE_BOARD_FLOW}
    }
#####check_params_util $IPINST ${PROJECT_PARAM.ARCHITECTURE} ${PROJECT_PARAM.DEVICE} ${PROJECT_PARAM.PART} ${PROJECT_PARAM.SPEEDGRADE}
#set drpclkrate  ${param_value.drpclkrate}
#####dbg_msg [list_property $drpclkrate]
#BIN_VALUE BITSTRING_LENGTH DEC_VALUE DEFAULT_RANGE DEFAULT_VALUE ENABLED ERRMSG HEX_VALUE NAME OCT_VALUE PRESET_PROC RANGE RANGE_LABELS RANGE_VALUE VALUE VALUE_SRC
    dbg_msg "proc update_param_value.USE_BOARD_FLOW completed"
}

proc update_param_value.ETHERNET_BOARD_INTERFACE {IPINST param_value.ETHERNET_BOARD_INTERFACE param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE} {
    if { [board::is_enable_board_gui] } {
        set mii_vlnv     "xilinx.com:interface:mii_rtl:1.0"
        set gmii_vlnv    "xilinx.com:interface:gmii_rtl:1.0"
        set rgmii_vlnv   "xilinx.com:interface:rgmii_rtl:1.0"
        set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
        set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

        if { [is_ethernet_intf_exist_in_board] } {
            set_property enabled true ${param_value.ETHERNET_BOARD_INTERFACE}
            set intf_list "Custom"
            foreach vlnv [list $mii_vlnv $gmii_vlnv $rgmii_vlnv  $sgmii_vlnv $sfp_vlnv] {
                set board_if [get_board_part_interfaces -filter "VLNV==$vlnv"]
#                dbg_brd_msg "The values returned are [join [list Custom $board_if] ,]"
                foreach item $board_if {
                    set intf_list "$intf_list,$item"
                }
            }
            set_property range  $intf_list ${param_value.ETHERNET_BOARD_INTERFACE}
        }
    }

    set use_brd  [get_property value ${param_value.USE_BOARD_FLOW}]
    if {!$use_brd} {
        dbg_msg "Useboardflow is false in ETHERNET_BOARD_INTERFACE $use_brd"
        set_property value   Custom  ${param_value.ETHERNET_BOARD_INTERFACE}
        set_property enabled false   ${param_value.ETHERNET_BOARD_INTERFACE}
    }
    dbg_msg "Done updating ETHERNET_BOARD_INTERFACE"
}

proc update_param_value.speed_1_2p5 {IPINST param_value.speed_1_2p5 param_value.ETHERNET_BOARD_INTERFACE PROJECT_PARAM.ARCHITECTURE} {
    set mii_vlnv     "xilinx.com:interface:mii_rtl:1.0"
    set gmii_vlnv    "xilinx.com:interface:gmii_rtl:1.0"
    set rgmii_vlnv   "xilinx.com:interface:rgmii_rtl:1.0"
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

    set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
    set vlnv [board::get_intf_vlnv $boardIfName]
    if {($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv)} {
        set gt_loc [get_property PARAM.GT_LOC [get_board_part_interfaces $boardIfName]]
    } else {
        set gt_loc ""
    }

    if { [get_dvc_suprt_2p5] && (($boardIfName == "Custom") || ($vlnv == $sfp_vlnv) || (($vlnv == $sgmii_vlnv) && ($gt_loc != ""))) } {
        set_property enabled true  ${param_value.speed_1_2p5}
    } else {
        set_property value   1G    ${param_value.speed_1_2p5}
        set_property enabled false ${param_value.speed_1_2p5}
    }
    dbg_msg "proc update_param_value.speed_1_2p5 completed"
}

proc  update_param_value.phy_type {IPINST param_value.PHY_TYPE param_value.ETHERNET_BOARD_INTERFACE param_value.speed_1_2p5 PROJECT_PARAM.ARCHITECTURE } {
    set mii_vlnv     "xilinx.com:interface:mii_rtl:1.0"
    set gmii_vlnv    "xilinx.com:interface:gmii_rtl:1.0"
    set rgmii_vlnv   "xilinx.com:interface:rgmii_rtl:1.0"
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

    set phy_type     ${param_value.PHY_TYPE}
    set phy_type_value  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    if { $speed_is_2p5 } {
        set_property range  "SGMII,1000BaseX"  $phy_type
        set_property range_labels [join [dict create SGMII {2.5G SGMII} 1000BaseX {2500 BASEX}] ,] $phy_type
        if { !(($phy_type_value == "sgmii") || ($phy_type_value == "1000basex")) } {
            set_property value  "SGMII" $phy_type
        }
    } else {
        set_property range_labels [join [dict create 1000BaseX {1000BASEX} SGMII {SGMII}] ,] $phy_type
        if {[get_dvc_suprt_transvr] || ([get_dvc_suprt_1gbx_lvds] && [get_dvc_suprt_sgmii_lvds]) } {
            if { ![string match [get_property range $phy_type] "MII,GMII,RGMII,SGMII,1000BaseX,Both"] } {
                set_property range "MII,GMII,RGMII,SGMII,1000BaseX,Both"  $phy_type
            }  elseif { $phy_type_value == "both" } {
                set_property value  "Both"  $phy_type
            }
        } elseif {[get_dvc_suprt_sgmii_lvds]} {
            if { ![string match [get_property range $phy_type] "MII,GMII,RGMII,SGMII"] } {
                set_property range "MII,GMII,RGMII,SGMII"   $phy_type
            }
            if { $phy_type_value == "1000basex" } {
                set_property value  "GMII"  $phy_type
            }
        } elseif {[get_dvc_suprt_1gbx_lvds]} {
            if { ![string match [get_property range $phy_type] "MII,GMII,RGMII,1000BaseX"] } {
                set_property range "MII,GMII,RGMII,1000BaseX"   $phy_type
            }
            if { $phy_type_value == "sgmii" } {
                set_property value  "GMII"  $phy_type
            }
        } else {
            if { ![string match [get_property range $phy_type] "MII,GMII,RGMII"] } {
                set_property range  "MII,GMII,RGMII"  $phy_type
            }
            if { (($phy_type_value == "sgmii") || ($phy_type_value == "1000basex")) } {
                set_property value  "GMII" $phy_type
            }
        }
    }

    set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
    set vlnv [board::get_intf_vlnv $boardIfName]
    if {$boardIfName ne "Custom"} {
        set_property enabled false   $phy_type
        if {$vlnv == $mii_vlnv } {
            set_property value   "MII"    $phy_type
        } elseif { $vlnv == $gmii_vlnv } {
            set_property value   "GMII"   $phy_type
        } elseif { $vlnv == $rgmii_vlnv } {
            set_property value   "RGMII"  $phy_type
        } elseif { $vlnv == $sfp_vlnv } {
            set_property value   "1000BaseX"  $phy_type
        } elseif { $vlnv == $sgmii_vlnv } {
            set_property value   "SGMII"  $phy_type
        } else {
            set_property enabled true   $phy_type
        }
    } else {
        set_property enabled true   $phy_type
    }
    dbg_msg "proc update_param_value.phy_type completed"
}

proc update_param_value.processor_mode {IPINST param_value.processor_mode param_value.speed_1_2p5 param_value.Enable_1588 param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set processor_mode   ${param_value.processor_mode}
    set phy_type [string tolower [get_property value  ${param_value.PHY_TYPE}] ]
    set Enable_1588  [get_property value  ${param_value.Enable_1588} ]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    if {($speed_is_2p5 && !([get_dvc_is_uscaleplus] || [get_dvc_is_uscale] || [get_dvc_is_versal])) } {
        set_property  enabled false  $processor_mode
        set_property  value   false  $processor_mode
    } elseif { (($phy_type == "sgmii") || ($phy_type == "1000basex") || ($phy_type == "both")) } {
        set_property  enabled true   $processor_mode
    } else {
        set_property  enabled false  $processor_mode
        set_property  value   true  $processor_mode
    }
    dbg_msg "proc update_param_value.processor_mode completed"
}

proc update_param_value.PHYRST_BOARD_INTERFACE  {IPINST param_value.PHYRST_BOARD_INTERFACE param_value.PHY_TYPE param_value.processor_mode param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE }  {
    if { [board::is_enable_board_gui] } {
        set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
        set processor_mode [get_property value ${param_value.processor_mode}]
        set phyrst_vlnv  "xilinx.com:signal:reset_rtl:1.0"
        if { ($phy_type == "1000basex")} {
            set_property value Custom ${param_value.PHYRST_BOARD_INTERFACE}
            set_property enabled false ${param_value.PHYRST_BOARD_INTERFACE}
        } else {
            if {[board::is_intf_exist_in_board $phyrst_vlnv  MODE master]} {
                set_property enabled true  ${param_value.PHYRST_BOARD_INTERFACE}
                board::set_range ${param_value.PHYRST_BOARD_INTERFACE} $phyrst_vlnv  MODE master
            }
        }
    }
    set use_brd  [get_property value ${param_value.USE_BOARD_FLOW}]
    if {!$use_brd} {
        dbg_msg "Useboardflow is false in PHYRST_BOARD_INTERFACE $use_brd"
        set_property value    Custom    ${param_value.PHYRST_BOARD_INTERFACE}
        set_property enabled  false     ${param_value.PHYRST_BOARD_INTERFACE}
    }
    dbg_msg "proc update_PHYRST_BOARD_INTERFACE  completed"
}

proc update_param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT  {IPINST param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT param_value.ETHERNET_BOARD_INTERFACE param_value.PHY_TYPE param_value.processor_mode param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE }  {
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
    set vlnv [board::get_intf_vlnv $boardIfName]

    if { [board::is_enable_board_gui] } {
        set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
        set processor_mode [get_property value ${param_value.processor_mode}]
        set phyrst_vlnv  "xilinx.com:signal:reset_rtl:1.0"
        if {[board::is_intf_exist_in_board $phyrst_vlnv  MODE slave] && ($vlnv == $sgmii_vlnv)} {
            set_property enabled true  ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT}
            board::set_range ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT} $phyrst_vlnv  MODE slave
        } else {
            set_property value Custom  ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT}
            set_property enabled false ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT}
        }
    }
    set use_brd  [get_property value ${param_value.USE_BOARD_FLOW}]
    if {!$use_brd} {
        dbg_msg "Useboardflow is false in PHYRST_BOARD_INTERFACE_DUMMY_PORT $use_brd"
        set_property value    Custom    ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT}
        set_property enabled  false     ${param_value.PHYRST_BOARD_INTERFACE_DUMMY_PORT}
    }
    dbg_msg "proc update_PHYRST_BOARD_INTERFACE_DUMMY_PORT  completed"
}

proc  update_param_value.DIFFCLK_BOARD_INTERFACE {IPINST param_value.DIFFCLK_BOARD_INTERFACE param_value.ETHERNET_BOARD_INTERFACE param_value.PHY_TYPE param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE}  {
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"
    set diffclk_vlnv "xilinx.com:interface:diff_clock_rtl:1.0"
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
    set vlnv [board::get_intf_vlnv $boardIfName]

    if { [board::is_enable_board_gui] } {
        if { ($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv) } { set gt_loc [get_property PARAM.GT_LOC [get_board_part_interfaces $boardIfName]] } else { set gt_loc "" }

#        puts  " 691 - all diff_clk srcs - [board::is_intf_exist_in_board $diffclk_vlnv]  "
#        puts  " 692 - diff_clk srcs related to axi eth - [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_LVDS_CLK ETH_MGT_CLK]  "
        if { (  ( [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_MGT_CLK] )
             && ( ($gt_loc != "") && ( ($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv)) ) ) } {
            set_property enabled true ${param_value.DIFFCLK_BOARD_INTERFACE}
            board::set_range ${param_value.DIFFCLK_BOARD_INTERFACE} $diffclk_vlnv  PARAM.TYPE ETH_MGT_CLK
        } elseif { (  ( [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_LVDS_CLK] )
                   && ( ($gt_loc == "") && ( ($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv)) ) ) } {
            set_property enabled true ${param_value.DIFFCLK_BOARD_INTERFACE}
            board::set_range ${param_value.DIFFCLK_BOARD_INTERFACE} $diffclk_vlnv  PARAM.TYPE ETH_LVDS_CLK
        } elseif { ( [board::is_intf_exist_in_board $diffclk_vlnv PARAM.TYPE ETH_MGT_CLK]
                   && ($vlnv == "Custom") ) } {
            board::set_range ${param_value.DIFFCLK_BOARD_INTERFACE} $diffclk_vlnv  PARAM.TYPE ETH_LVDS_CLK ETH_MGT_CLK
            if { ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") } {
                set_property enabled true  ${param_value.DIFFCLK_BOARD_INTERFACE}
            } else {
                set_property enabled false  ${param_value.DIFFCLK_BOARD_INTERFACE}
            }
        } else {
            set_property value Custom  ${param_value.DIFFCLK_BOARD_INTERFACE}
            set_property enabled false ${param_value.DIFFCLK_BOARD_INTERFACE}
        }
    }
    set use_brd  [get_property value ${param_value.USE_BOARD_FLOW}]
    if {!$use_brd} {
        dbg_brd_msg "Useboardflow is false in DIFFCLK_BOARD_INTERFACE $use_brd"
        set_property value     Custom   ${param_value.DIFFCLK_BOARD_INTERFACE}
        set_property enabled   false    ${param_value.DIFFCLK_BOARD_INTERFACE}
    }
    dbg_msg "proc update_DIFFCLK_BOARD_INTERFACE  completed"
}

proc update_param_value.MDIO_BOARD_INTERFACE  {IPINST param_value.MDIO_BOARD_INTERFACE param_value.ETHERNET_BOARD_INTERFACE param_value.USE_BOARD_FLOW PROJECT_PARAM.ARCHITECTURE} {
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"
    set mdio_vlnv  "xilinx.com:interface:mdio_rtl:1.0"
    if { [board::is_enable_board_gui] } {
        set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
        set vlnv [board::get_intf_vlnv $boardIfName]
        if { ( $vlnv == $sfp_vlnv )  } {
            set_property value   Custom  ${param_value.MDIO_BOARD_INTERFACE}
            set_property enabled false  ${param_value.MDIO_BOARD_INTERFACE}
        } else {
            if {[board::is_intf_exist_in_board $mdio_vlnv]} {
                set intf_list "Custom,[join [get_board_part_interfaces -filter "VLNV==$mdio_vlnv"] ","]"
                set_property range  $intf_list  ${param_value.MDIO_BOARD_INTERFACE}
                set_property enabled true   ${param_value.MDIO_BOARD_INTERFACE}
            }
        }
    }
    set use_brd  [get_property value ${param_value.USE_BOARD_FLOW}]
    if {!$use_brd} {
        dbg_msg "Useboardflow is false in MDIO_BOARD_INTERFACE $use_brd"
        set_property value    Custom   ${param_value.MDIO_BOARD_INTERFACE}
        set_property enabled  false    ${param_value.MDIO_BOARD_INTERFACE}
    }
    dbg_msg "proc update_MDIO_BOARD_INTERFACE  completed"
}

proc update_param_value.ENABLE_LVDS {IPINST param_value.ENABLE_LVDS param_value.PHY_TYPE param_value.ETHERNET_BOARD_INTERFACE param_value.speed_1_2p5 PROJECT_PARAM.ARCHITECTURE} {
    set enable_lvds  ${param_value.ENABLE_LVDS}
    set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
    set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"

    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
    set vlnv        [board::get_intf_vlnv $boardIfName                         ]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    if {!$speed_is_2p5 && (($phy_type == "sgmii" && [get_dvc_suprt_sgmii_lvds]) || ($phy_type == "1000basex" && [get_dvc_suprt_1gbx_lvds])) } {
        if { ![get_dvc_suprt_transvr] } {
            set_property value   true  $enable_lvds
            set_property enabled false   $enable_lvds
        } else {
            set_property enabled true   $enable_lvds
        }
    } else {
        set_property value   false  $enable_lvds
        set_property enabled false  $enable_lvds
    }

    if { ($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv) } {
        set gt_loc [get_property PARAM.GT_LOC [get_board_part_interfaces $boardIfName]]
        if {$gt_loc == ""} {
            set_property enabled false $enable_lvds
            set_property value   true  $enable_lvds
        } else {
            set_property enabled false $enable_lvds
            set_property value   false $enable_lvds
        }
    }
    dbg_msg "proc update_param_value.ENABLE_LVDS completed value = $enable_lvds"
}


##ng there may be a better way to enable/disable locations than doing it in below procedure .

proc update_param_value.EnableAsyncSGMII {IPINST param_value.EnableAsyncSGMII param_value.ENABLE_LVDS param_value.PHY_TYPE param_value.speed_1_2p5 PROJECT_PARAM.ARCHITECTURE} {
    set enable_lvds  [get_property value  ${param_value.ENABLE_LVDS}   ]
    set en_asgmii    ${param_value.EnableAsyncSGMII}

    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]

    if {($phy_type == "sgmii" && $enable_lvds && [get_dvc_is_uscale])} {
        set_property enabled true   $en_asgmii
    } else {
        set_property enabled false  $en_asgmii
        set_property value   false  $en_asgmii
    }
    dbg_msg "proc update_param_value.EnableAsyncSGMII completed"
}

proc update_param_value.Enable_1588 {IPINST param_value.Enable_1588 param_value.PHY_TYPE param_value.speed_1_2p5 param_value.ENABLE_LVDS PROJECT_PARAM.ARCHITECTURE} {
    set phy_type       [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set enable_lvds    [get_property value  ${param_value.ENABLE_LVDS}   ]
    set Enable_1588    ${param_value.Enable_1588}

    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  false } else { set speed_is_2p5  false }

    if { ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && [get_dvc_suprt_1588] && !$speed_is_2p5 && !$enable_lvds} {
        set_property enabled true  $Enable_1588
    } else {
        set_property enabled false $Enable_1588
        set_property value   false $Enable_1588
    }
    dbg_msg "proc update_param_value.Enable_1588 completed"
}

## In AVB mode, User will not experience any difference. Technically AVB uses 1588 timers and is more efficient.
## For 1588 full functonality AVB should be disabled.
## So in customer's view: 1588 and AVB are mutually exclusive.
proc update_param_value.ENABLE_AVB   {IPINST param_value.ENABLE_AVB param_value.PHY_TYPE param_value.Enable_1588 param_value.speed_1_2p5 PROJECT_PARAM.ARCHITECTURE} {
    set ENABLE_AVB ${param_value.ENABLE_AVB}
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set Enable_1588  [get_property value  ${param_value.Enable_1588} ]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    if {$phy_type == "mii" || $Enable_1588 || $speed_is_2p5} {
        set_property value false $ENABLE_AVB
        set_property enabled false  $ENABLE_AVB
    } else {
        set_property enabled true  $ENABLE_AVB
    }
    dbg_msg "proc update_param_value.ENABLE_AVB   completed"
}

proc update_param_value.Enable_1588_1step {IPINST param_value.Enable_1588_1step param_value.Enable_1588 PROJECT_PARAM.ARCHITECTURE} {
    set Enable_1588 [get_property value  ${param_value.Enable_1588}]
    if {$Enable_1588 } {
        set_property enabled true  ${param_value.Enable_1588_1step}
        set_property value   true  ${param_value.Enable_1588_1step}
    } else {
        set_property enabled  false  ${param_value.Enable_1588_1step}
        set_property value   false  ${param_value.Enable_1588_1step}
    }
    dbg_msg "proc update_param_value.Enable_1588_1step completed"
}

proc update_param_value.Timer_Format {IPINST param_value.Timer_Format param_value.Enable_1588 PROJECT_PARAM.ARCHITECTURE} {
    set Enable_1588 [get_property value  ${param_value.Enable_1588}]
    if {$Enable_1588 } {
        set_property enabled true  ${param_value.Timer_Format}
    } else {
        set_property enabled  false  ${param_value.Timer_Format}
    }
    dbg_msg "proc update_param_value.Timer_Format completed"
}

proc update_param_value.TIMER_CLK_PERIOD {IPINST param_value.TIMER_CLK_PERIOD param_value.Enable_1588 PROJECT_PARAM.ARCHITECTURE} {
    set Enable_1588 [get_property value  ${param_value.Enable_1588}]
    if {$Enable_1588 } {
        set_property enabled true  ${param_value.TIMER_CLK_PERIOD}
    } else {
        set_property enabled  false  ${param_value.TIMER_CLK_PERIOD}
    }
    dbg_msg "proc update_param_value.TIMER_CLK_PERIOD completed"
}

proc update_param_value.PHYADDR  {IPINST param_value.PHYADDR param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set PHYADDR  ${param_value.PHYADDR}
    if {$phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both"} {
        set_property enabled true   $PHYADDR
    } else {
        set_property value   1      $PHYADDR
        set_property enabled false  $PHYADDR
    }
    dbg_msg "proc update_param_value.PHYADDR  completed"
}

proc update_param_value.Include_IO {IPINST param_value.Include_IO param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set Include_IO   ${param_value.Include_IO}
    if {$phy_type == "gmii" || $phy_type == "mii"} {
        set_property  value   true   $Include_IO
        if {[get_property  enabled  ${param_value.PHY_TYPE}]} {
            set_property  enabled true   $Include_IO
        } else {
            set_property  enabled false   $Include_IO
        }
    } else {
        set_property  enabled false  $Include_IO
        set_property  value   true   $Include_IO
    }
    dbg_msg "proc update_param_value.Include_IO completed"
}

proc update_param_value.SupportLevel {IPINST param_value.SupportLevel param_value.PHY_TYPE param_value.Include_IO param_value.ENABLE_LVDS param_value.DIFFCLK_BOARD_INTERFACE PROJECT_PARAM.ARCHITECTURE} {
    set suprt_lvl     ${param_value.SupportLevel}
    set phy_type     [string tolower [get_property value ${param_value.PHY_TYPE}               ]]
    set diff_brd_val [string tolower [get_property value ${param_value.DIFFCLK_BOARD_INTERFACE}]]
    set include_io   [get_property value  ${param_value.Include_IO} ]
    set enable_lvds  [get_property value  ${param_value.ENABLE_LVDS}]

    if {($phy_type eq "mii") || !$include_io || ($diff_brd_val != "custom")} {
        set_property  enabled false $suprt_lvl
        set_property  value 1       $suprt_lvl
    } else {
        set_property  enabled true  $suprt_lvl
    }

   if {[get_dvc_is_versal] && ( $phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both")} {
        set_property  enabled false $suprt_lvl
        set_property  value 0       $suprt_lvl  
   } elseif {[get_dvc_is_versal] && ( $phy_type == "gmii" || $phy_type == "rgmii" ) } {
        set_property  value 0       $suprt_lvl
   }

    dbg_msg "proc update_param_value.SupportLevel completed"
}

proc update_param_value.GTinEx {IPINST param_value.GTinEx param_value.ENABLE_LVDS param_value.SupportLevel param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set gt_in_exd   ${param_value.GTinEx}
    set enable_lvds   [get_property value  ${param_value.ENABLE_LVDS}]
    set suprt_lvl   [get_property value  ${param_value.SupportLevel}]
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if {($phy_type == "sgmii" || $phy_type == "1000basex") && !$enable_lvds && !$suprt_lvl && [get_dvc_is_us]} {
        set_property  enabled true   $gt_in_exd
    } else {
        set_property  value   false  $gt_in_exd
        set_property  enabled false  $gt_in_exd
    }

    if  {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && [get_dvc_is_versal]} {
        set_property  value   true  $gt_in_exd
        set_property  enabled false  $gt_in_exd
    }
    dbg_msg "proc update_param_value.GTinEx completed"
}

proc update_param_value.TransceiverControl {IPINST param_value.TransceiverControl param_value.GTinEx param_value.ENABLE_LVDS param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set TransceiverControl   ${param_value.TransceiverControl}
    set enable_lvds   [get_property value  ${param_value.ENABLE_LVDS}]
    set gt_in_exd   [get_property value  ${param_value.GTinEx}]
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && !$gt_in_exd} {
        set_property  enabled true   $TransceiverControl
    } else {
        set_property  value   false  $TransceiverControl
        set_property  enabled false  $TransceiverControl
    }
    dbg_msg "proc update_param_value.TransceiverControl completed"
}

proc update_param_value.drpclkrate {IPINST param_value.drpclkrate param_value.ENABLE_LVDS param_value.speed_1_2p5 param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE} {
    set drpclkrate  ${param_value.drpclkrate}
    set enable_lvds   [get_property value  ${param_value.ENABLE_LVDS}]
    set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if {[get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }

    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && [get_dvc_is_us]} {
        if {$speed_is_2p5} {
        #set_property range_value "50.0,6.25,156.25"  $drpclkrate
            set_property range "6.25,156.25"  $drpclkrate
            if {[expr {[get_property value  $drpclkrate]>156.25}]} {set_property value "156.25" $drpclkrate}
        } else {
        # always resets the value to 50.0 set_property range_value "50.0,6.25,62.5"    $drpclkrate
            set_property range "6.25,62.5"    $drpclkrate
            if {[expr {[get_property value  $drpclkrate]>62.5}]} {set_property value "62.5" $drpclkrate}

        }
        if {[expr {[get_property value  $drpclkrate]<6.25}]} {set_property value "6.25" $drpclkrate}
        set_property enabled true   $drpclkrate
    } else {
        set_property value  50.0    $drpclkrate
        set_property enabled false  $drpclkrate
    }
    dbg_msg "proc update_param_value.drpclkrate completed"
}

#########
# Update all parameters that are dependent only on processor_mode
###########
foreach n [list TXMEM RXMEM] {
    set PR [regsub -all <<n>> $PR_PROC $n]
    eval $PR
}

foreach x [list MCAST_EXTEND TXCSUM TXVLAN_TRAN TXVLAN_TAG TXVLAN_STRP RXCSUM RXVLAN_TRAN RXVLAN_TAG RXVLAN_STRP] {
    set PR [regsub -all <<x>> $PR_PROC_NO_1588 $x]
    eval $PR
}

proc update_param_value.Frame_Filter {IPINST param_value.Frame_Filter PROJECT_PARAM.ARCHITECTURE} {
    dbg_msg "proc update_param_value.Frame_Filter completed"
}

proc update_param_value.Number_of_Table_Entries {IPINST param_value.Number_of_Table_Entries param_value.Frame_Filter PROJECT_PARAM.ARCHITECTURE} {
    if {[get_property value ${param_value.Frame_Filter}]} {
        set_property enabled  true  ${param_value.Number_of_Table_Entries}
    } else {
        set_property enabled  false  ${param_value.Number_of_Table_Entries}
    }
    dbg_msg "proc update_param_value.Number_of_Table_Entries completed"
}

proc update_param_value.Statistics_Counters {param_value.Statistics_Counters PROJECT_PARAM.ARCHITECTURE} {
    dbg_msg "proc update_param_value.Statistics_Counters completed"
}

proc update_param_value.Statistics_Reset {IPINST param_value.Statistics_Reset param_value.Statistics_Counters PROJECT_PARAM.ARCHITECTURE} {
    set Statistics_Reset ${param_value.Statistics_Reset}
    if { [get_property value  ${param_value.Statistics_Counters}]  } {
        set_property enabled true $Statistics_Reset
    } else {
        set_property enabled false $Statistics_Reset
    }
    dbg_msg "proc update_param_value.Statistics_Reset completed"
}

proc update_param_value.Statistics_Width {IPINST param_value.Statistics_Width param_value.Statistics_Counters PROJECT_PARAM.ARCHITECTURE} {
    set Statistics_Width      ${param_value.Statistics_Width}
    if {  [get_property value  ${param_value.Statistics_Counters}]  } {
        set_property  enabled true $Statistics_Width
        set_property  enabled true $Statistics_Width
    } else {
        set_property  enabled false $Statistics_Width
        set_property  enabled false $Statistics_Width
    }
    dbg_msg "proc update_param_value.Statistics_Width completed"
}

proc update_param_value.Enable_Pfc {IPINST param_value.Enable_Pfc param_value.speed_1_2p5 param_value.processor_mode PROJECT_PARAM.ARCHITECTURE} {
    set processor_mode [get_property value  ${param_value.processor_mode}]
    if { [get_property value ${param_value.speed_1_2p5}] == "2p5G" } { set speed_is_2p5  true } else { set speed_is_2p5  false }
    if { $processor_mode } {
        set_property  enabled false  ${param_value.Enable_Pfc}
        set_property  value   false  ${param_value.Enable_Pfc}
    } else {
        set_property  enabled true   ${param_value.Enable_Pfc}
    }
    dbg_msg "proc update_param_value.Enable_Pfc completed"
}

proc update_param_value.gt_type {IPINST param_value.gt_type param_value.SupportLevel param_value.PHY_TYPE param_value.ENABLE_LVDS PROJECT_PARAM.ARCHITECTURE} {
    set gt_type             ${param_value.gt_type}
    set phy_type            [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set enable_lvds         [get_property value ${param_value.ENABLE_LVDS}       ]
    if { ![get_dvc_is_versal] } {
      set_property range "GTH,GTY" $gt_type 
    }
    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && [get_dvc_is_us] && ([get_dvc_has_gth34] && [get_dvc_has_gty34])} {
        set_property enabled true $gt_type
    } else {
        if {([get_dvc_has_gty34] && ![get_dvc_has_gth34]) || [get_dvc_has_gty5]} {
            set_property value  GTY $gt_type
        } elseif { [get_dvc_has_gtyp] } {
	    set_property value GTYP $gt_type
        } else {
            set_property value  GTH $gt_type
        }
        set_property enabled false $gt_type
    }
    dbg_msg "proc update_param_value.gt_type completed"
}

proc update_param_value.gtrefclkrate {IPINST param_value.gtrefclkrate param_value.SupportLevel param_value.PHY_TYPE param_value.ENABLE_LVDS PROJECT_PARAM.ARCHITECTURE param_value.DIFFCLK_BOARD_INTERFACE} {
    set gtrefclkrate        ${param_value.gtrefclkrate}
    set phy_type            [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set enable_lvds         [get_property value ${param_value.ENABLE_LVDS}       ]
    set gtrefclkIfName      [get_property value ${param_value.DIFFCLK_BOARD_INTERFACE}]
    
    if {$gtrefclkIfName eq "mgt_si570_clk"} {
       if {(($phy_type == "sgmii") || ($phy_type == "1000basex") || ($phy_type == "both")) && [get_dvc_is_us] && !$enable_lvds} {
           set_property value   156.25 $gtrefclkrate
           set_property enabled true $gtrefclkrate
       } else {
           set_property value   125 $gtrefclkrate
           set_property enabled false $gtrefclkrate
       }
    } else {
       if {(($phy_type == "sgmii") || ($phy_type == "1000basex") || ($phy_type == "both")) && ([get_dvc_is_versal]) && !$enable_lvds} {
           set_property enabled true $gtrefclkrate
       } elseif {(($phy_type == "sgmii") || ($phy_type == "1000basex") || ($phy_type == "both")) && ([get_dvc_is_us]) && !$enable_lvds} {
           set_property range "312.5,250,156.25,125" $gtrefclkrate
           set_property enabled true $gtrefclkrate
       } else {
           set_property value   125 $gtrefclkrate
           set_property enabled false $gtrefclkrate
       }
    }
    dbg_msg "proc update_param_value.gtrefclkrate completed"
}

proc update_param_value.lvdsclkrate {IPINST param_value.EnableAsyncSGMII param_value.lvdsclkrate PARAM_VALUE.ClockSelection param_value.PHY_TYPE param_value.SupportLevel param_value.ENABLE_LVDS PROJECT_PARAM.ARCHITECTURE} {
    set lvdsclkrate         ${param_value.lvdsclkrate}
    set phy_type            [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set enable_lvds         [get_property value ${param_value.ENABLE_LVDS} ]
    set en_asgmii           [get_property value ${param_value.EnableAsyncSGMII} ]
    set suprt_lvl           [get_property value ${param_value.SupportLevel}]
    set ClockSelection      [get_property value ${PARAM_VALUE.ClockSelection}]

    if { (($phy_type == "1000basex" || $phy_type == "both") || ($phy_type == "sgmii"  && (($en_asgmii && [get_dvc_is_uscale]) || [get_dvc_is_uscaleplus] || [get_dvc_is_versal]) )) && $enable_lvds && $ClockSelection == "Async" } {
        set_property value   625    $lvdsclkrate
        set_property enabled false  $lvdsclkrate
    } elseif {$suprt_lvl && ($phy_type == "sgmii" ) && $enable_lvds  && !$en_asgmii && [get_dvc_is_uscale] || $ClockSelection == "Sync"} {
        set_property enabled true   $lvdsclkrate
    } else {
        if {!$suprt_lvl && ($phy_type == "sgmii" ) && $enable_lvds  && !$en_asgmii && [get_dvc_is_uscale] } {
            set_property value   625    $lvdsclkrate
        } else {
            set_property value   125    $lvdsclkrate
        }
        set_property enabled false  $lvdsclkrate
    }
    if { [get_dvc_is_versal] } {
      set_property range "625,312.5,156.25,125" $lvdsclkrate
      set_property enabled true  $lvdsclkrate
    } else {
      set_property range "625,156.25,125" $lvdsclkrate
    }
    dbg_msg "proc update_param_value.lvdsclkrate completed"
}

proc update_param_value.ClockSelection {IPINST PARAM_VALUE.ClockSelection PROJECT_PARAM.ARCHITECTURE} {
  set ClockSelection      ${PARAM_VALUE.ClockSelection}
  
  if { [get_dvc_is_versal] } {
    set_property value "Async" $ClockSelection
    set_property enabled false $ClockSelection
  }
}


proc update_param_value.axiliteclkrate {param_value.axiliteclkrate PROJECT_PARAM.ARCHITECTURE} {
    dbg_msg "proc update_param_value.axiliteclkrate completed"
}

proc update_param_value.axisclkrate {param_value.axisclkrate param_value.processor_mode PROJECT_PARAM.ARCHITECTURE} {
    set processor_mode   [get_property value  ${param_value.processor_mode}]
    set axisclkrate   ${param_value.axisclkrate}
    if { $processor_mode } {
        set_property  enabled true   $axisclkrate
    } else {
        set_property  enabled false  $axisclkrate
    }
    dbg_msg "proc update_param_value.axisclkrate completed"
}

proc update_param_value.InstantiateBitslice0 {param_value.InstantiateBitslice0 param_value.rxlane0_placement PROJECT_PARAM.ARCHITECTURE} {
    set InstantiateBitslice0 ${param_value.InstantiateBitslice0}
    if {[get_property value ${param_value.rxlane0_placement}] == "DIFF_PAIR_0" } {
        set_property value false $InstantiateBitslice0
    } else {
        set_property value true $InstantiateBitslice0
    } 
}
proc update_gui_for_param_value.rxlane0_placement { param_value.rxlane0_placement IPINST} {
    set InstantiateBitslice0 [ipgui::get_guiparamspec -name InstantiateBitslice0 -of $IPINST]
    if { [get_property value ${param_value.rxlane0_placement}] == "DIFF_PAIR_0" } {
        set_property visible false $InstantiateBitslice0
    } else {
        set_property visible true $InstantiateBitslice0
    }
}
proc update_gui_for_param_value.rxnibblebitslice0used {param_value.rxnibblebitslice0used param_value.InstantiateBitslice0 PROJECT_PARAM.ARCHITECTURE IPINST} {
    if {([get_property value ${param_value.InstantiateBitslice0}] == false) } {
        set_property visible false [ipgui::get_guiparamspec rxnibblebitslice0used -of $IPINST] 
    } else {
        set_property visible true [ipgui::get_guiparamspec rxnibblebitslice0used -of $IPINST]
    }
}
proc update_param_value.rxnibblebitslice0used { param_value.rxnibblebitslice0used param_value.InstantiateBitslice0 PROJECT_PARAM.ARCHITECTURE} {
    set rxnibblebitslice0used ${param_value.rxnibblebitslice0used}
    if { ([get_property value ${param_value.InstantiateBitslice0}] == false) } {
        set_property value false $rxnibblebitslice0used
    } else {
        set_property value true $rxnibblebitslice0used
    } 
   dbg_msg "proc update_param_value.rxnibblebitslice0used completed"
}

#proc update_param_value.rxnibblebitslice0used {param_value.rxnibblebitslice0used param_value.rxlane0_placement param_value.rxlane1_placement PROJECT_PARAM.ARCHITECTURE} {
#    set rxlane0_placement   [get_property value  ${param_value.rxlane0_placement}]
#    set rxlane1_placement   [get_property value  ${param_value.rxlane1_placement}]
#    if { $rxlane0_placement == "DIFF_PAIR_0" } {
#        set_property  value    true   ${param_value.rxnibblebitslice0used}
#        set_property  enabled  false  ${param_value.rxnibblebitslice0used}
#    } else {
#        set_property  value    false  ${param_value.rxnibblebitslice0used}
#        set_property  enabled  true   ${param_value.rxnibblebitslice0used}
#    }
#    dbg_msg "proc update_param_value.rxnibblebitslice0used completed"
#}

proc update_PARAM_VALUE.gtlocation {PARAM_VALUE.gtlocation PARAM_VALUE.gt_type param_value.PHY_TYPE param_value.ETHERNET_BOARD_INTERFACE PROJECT_PARAM.ARCHITECTURE} {
    dbg_msg "proc update_PARAM_VALUE.gtlocation started"
    set gt_type     [get_property value ${PARAM_VALUE.gt_type}]
    set phy_type    [string tolower [get_property value ${param_value.PHY_TYPE}]]

    if { ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both")  && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p]) } {
        if { $gt_type == "GTY" } {
            set rangeList [join "[get_dvc_gt_xy_locs GTYE3_CHANNEL][get_dvc_gt_xy_locs GTYE4_CHANNEL] [get_dvc_gt_xy_locs GTY_QUAD] [get_dvc_gt_xy_locs GTYP_QUAD]" ,]
        } else {
            set rangeList [join "[get_dvc_gt_xy_locs GTHE3_CHANNEL][get_dvc_gt_xy_locs GTHE4_CHANNEL]" ,]
        }
        dbg_msg "set_property range - $rangeList - ${PARAM_VALUE.gtlocation}"
        set_property range $rangeList ${PARAM_VALUE.gtlocation}

        set boardIfName [get_property value ${param_value.ETHERNET_BOARD_INTERFACE}]
        set vlnv [board::get_intf_vlnv $boardIfName]
        set sgmii_vlnv   "xilinx.com:interface:sgmii_rtl:1.0"
        set sfp_vlnv     "xilinx.com:interface:sfp_rtl:1.0"
        if { ($vlnv == $sfp_vlnv) || ($vlnv == $sgmii_vlnv) } {
            set_property enabled false ${PARAM_VALUE.gtlocation}
            set gt_loc [string trim [get_property PARAM.GT_LOC [get_board_part_interfaces $boardIfName]]]
            if {$gt_loc != ""} {
                set gt_site_loc [split [::xit::get_device_data D_GT_SITE_LOC $gt_loc -of [xit::current_scope]] ]
                set gt_loc_xy "X[lindex $gt_site_loc 0]Y[lindex $gt_site_loc 1]"
                set_property value   $gt_loc_xy ${PARAM_VALUE.gtlocation}
            }
        } else {
            set_property enabled true ${PARAM_VALUE.gtlocation}
        }
    } else {
#set_property range X0Y0 ${PARAM_VALUE.gtlocation}
    }
    dbg_msg "proc update_PARAM_VALUE.gtlocation completed"
}

proc update_PARAM_VALUE.gtrefclksrc {PARAM_VALUE.gtrefclksrc PARAM_VALUE.gtlocation PARAM_VALUE.gt_type param_value.PHY_TYPE } {
    dbg_msg "proc update_PARAM_VALUE.gtrefclksrc started "
    set phy_type    [string tolower [get_property value ${param_value.PHY_TYPE}]]
    if { ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both")  && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p]) } {
        set gt_loc  [get_property value  ${PARAM_VALUE.gtlocation}]
        set gt_type [get_property value ${PARAM_VALUE.gt_type}]
        set ref_clk_srcs [join [get_dvc_gt_refclk_locs ${gt_loc} $gt_type] ","]
        set_property range $ref_clk_srcs ${PARAM_VALUE.gtrefclksrc}
    }
    dbg_msg "proc update_PARAM_VALUE.gtrefclksrc completed "
}

proc update_PARAM_VALUE.VERSAL_GT_BOARD_FLOW {PARAM_VALUE.VERSAL_GT_BOARD_FLOW} {
    set_property value 1 ${PARAM_VALUE.VERSAL_GT_BOARD_FLOW}
}

###########################################################################################################################################
###  Update Pram Value functions           END#>->
###########################################################################################################################################
###########################################################################################################################################
###         Update GUI for Param Value functions        START#<-<
###########################################################################################################################################

proc update_gui_for_param_value.PHY_TYPE {IPINST param_value.PHY_TYPE param_value.ENABLE_LVDS PARAM_VALUE.ClockSelection param_value.gt_type param_value.Include_IO param_value.SupportLevel param_value.EnableAsyncSGMII param_value.GTinEx PROJECT_PARAM.ARCHITECTURE} {
    set phy_type [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set Include_IO  [get_property value ${param_value.Include_IO}  ]
    set enable_lvds [get_property value ${param_value.ENABLE_LVDS} ]
    set en_asgmii   [get_property value ${param_value.EnableAsyncSGMII} ]
    set suprt_lvl   [get_property value ${param_value.SupportLevel}]
    set gt_type     [get_property value ${param_value.gt_type}     ]
    set gt_in_exd   [get_property value ${param_value.GTinEx}]
    set clock_selection   [get_property value ${PARAM_VALUE.ClockSelection}]
    set Shared_Logic [ipgui::get_pagespec Shared_Logic -of $IPINST]

    set SL_desc [DT_Support_Level $phy_type $Include_IO]
    set_property description $SL_desc [ipgui::get_guiparamspec SupportLevel -of $IPINST]

    if {($phy_type == "sgmii" && $enable_lvds && [get_dvc_is_uscale])} {
        set_property visible true   [ipgui::get_guiparamspec EnableAsyncSGMII -of $IPINST]
    } else {
        set_property visible false  [ipgui::get_guiparamspec EnableAsyncSGMII -of $IPINST]
    }

    if { ![get_dvc_suprt_transvr] } {
        if { !([get_dvc_suprt_sgmii_lvds] || [get_dvc_suprt_1gbx_lvds]) } {
            set_property description "This device doesnot support SGMII and 1000BaseX" [ipgui::get_guiparamspec PHY_TYPE -of $IPINST]
        } else {
            set_property description "This device doesnot have transceiver. It supports only LVDS mode" [ipgui::get_guiparamspec PHY_TYPE -of $IPINST]
        }
    }

    if { ( ([get_dvc_is_uscaleplus] && $phy_type == "sgmii") || [get_dvc_is_versal] ) && $enable_lvds} { 
        set_property visible true [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
        set_property visible true [ipgui::get_groupspec Clock_Selection -of $IPINST]
    } else {
        set_property visible false [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
        set_property visible false [ipgui::get_groupspec Clock_Selection -of $IPINST]
    }

    if {$phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both"} {
        set_property visible true   [ipgui::get_groupspec phyadr_grp -of $IPINST ]
    } else {
        set_property visible false  [ipgui::get_groupspec phyadr_grp -of $IPINST ]
    }

    if { $phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both" } {
        set_property visible true  [ipgui::get_groupspec lvds_grp -of $IPINST ]
    } else {
        set_property visible false [ipgui::get_groupspec lvds_grp -of $IPINST ]
    }

    if {$phy_type == "gmii" || $phy_type == "mii"} {
        set_property  visible true   [ipgui::get_groupspec incio_grp -of $IPINST ]
    } else {
        set_property  visible false  [ipgui::get_groupspec incio_grp -of $IPINST ]
    }

    if {($phy_type == "mii") || !$Include_IO } {
        set_property  visible false [ipgui::get_groupspec supportl_info_grp  -of $IPINST]
    } else {
        set_property  visible true  [ipgui::get_groupspec supportl_info_grp  -of $IPINST]
    }

    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p])} {
        set_property  visible true  [ipgui::get_groupspec gtclkr_grp -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec gtclkr_grp -of $IPINST]
    }

    if {((($phy_type == "sgmii" ) && (([get_dvc_is_uscaleplus] && $clock_selection == "Sync") || ([get_dvc_is_uscale] && $en_asgmii && $clock_selection == "Sync") || ([get_dvc_is_uscale] && !$en_asgmii ))) || [get_dvc_is_versal]) && $enable_lvds} {
        set_property  visible true  [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    }

    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && ([get_dvc_has_gth34] && [get_dvc_has_gty34] )} {
        set_property  visible true  [ipgui::get_guiparamspec gt_type -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_guiparamspec gt_type -of $IPINST]
    }

    if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus] || [get_dvc_is_versal] || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))
        ||  (!$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34]))} {
        set_property  visible true  [ipgui::get_pagespec   Locations  -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_pagespec   Locations  -of $IPINST]
    }

    if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus] || [get_dvc_is_versal] || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))  } {
        set_property  visible true  [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
        set_property  visible true  [ipgui::get_groupspec  lane0_grp -of $IPINST]
        set_property  visible true  [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
        set_property  visible false [ipgui::get_groupspec  lane0_grp -of $IPINST]
        set_property  visible false [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
    }

    if { !$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p]) } {
        set_property  visible true  [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
        set_property  visible false [ipgui::get_guiparamspec  gtrefclksrc -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
    }

    if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_is_us] || [get_dvc_is_versal])} {
        set_property  visible true  [ipgui::get_guiparamspec GTinEx -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_guiparamspec GTinEx -of $IPINST]
    }

    if {($phy_type == "1000basex" || $phy_type == "sgmii" || $phy_type == "both") && [get_dvc_is_versal] } {
        set_property  visible false  $Shared_Logic
     } else {
        set_property  visible true  $Shared_Logic 
     }

    set d [ catch {
        dbg_gui_msg "update_gui_for_param_value.PHY_TYPE completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "update_gui_for_param_value.PHY_TYPE error messages $d" }
}

proc update_gui_for_PARAM_VALUE.ClockSelection {PARAM_VALUE.ClockSelection PARAM_VALUE.EnableAsyncSGMII param_value.PHY_TYPE param_value.ENABLE_LVDS PROJECT_PARAM.ARCHITECTURE IPINST} {
    set async_sgmii [get_property value ${PARAM_VALUE.EnableAsyncSGMII}]
    set clock_selection [get_property value ${PARAM_VALUE.ClockSelection}]
    set phy_type [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set devicefamily [get_project_property ARCHITECTURE]
    set enable_lvds  [get_property value ${param_value.ENABLE_LVDS}       ]

    if {((($phy_type == "sgmii" ) && (([get_dvc_is_uscaleplus] && $clock_selection == "Sync") || ([get_dvc_is_uscale] && $async_sgmii && $clock_selection == "Sync") || ([get_dvc_is_uscale] && !$async_sgmii))) || [get_dvc_is_versal]) && $enable_lvds } {
      set_property visible true [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    } else {
      set_property visible false [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    }
}

proc update_gui_for_param_value.SupportLevel {param_value.SupportLevel param_value.GTinEx param_value.PHY_TYPE param_value.ENABLE_LVDS IPINST} {
    set d [ catch {
        set phy_type     [string tolower [get_property value ${param_value.PHY_TYPE}]]
        set enable_lvds  [get_property value ${param_value.ENABLE_LVDS}       ]
        set suprt_lvl    [get_property value ${param_value.SupportLevel}      ]
        set gt_in_exd    [get_property value  ${param_value.GTinEx}                  ] 

        if { $gt_in_exd } {
            set_property load_image "xgui/gt_in_ed.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        } elseif { $suprt_lvl } {
            set_property load_image "xgui/with_shared_logic.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        } else {
            set_property load_image "xgui/without_shared_logic.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        }
#        if {($phy_type == "sgmii" || $phy_type == "1000basex") && !$enable_lvds && ([get_dvc_has_gth34] || [get_dvc_has_gty34])} {
#            set_property  visible true  [ipgui::groupspec gtclkr_grp -of $IPINST]
#        } else {
#            set_property  visible false [ipgui::groupspec gtclkr_grp -of $IPINST]
#        }
#        if {($phy_type == "sgmii" || $phy_type == "1000basex") && $enable_lvds && [get_dvc_is_us] && !$en_asgmii} {
#            set_property  visible true  [ipgui::get_groupspec lvclkr_grp -of $IPINST]
#        } else {
#            set_property  visible false [ipgui::get_groupspec lvclkr_grp -of $IPINST]
#        }

        dbg_gui_msg "update_gui_for_param_value.SupportLevel completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "update_gui_for_param_value.SupportLevel error  messages $d" }
}

proc update_gui_for_param_value.GTinEx {param_value.GTinEx param_value.SupportLevel param_value.PHY_TYPE param_value.ENABLE_LVDS IPINST} {
    set d [ catch {
        set phy_type     [string tolower [get_property value ${param_value.PHY_TYPE}]]
        set enable_lvds  [get_property value ${param_value.ENABLE_LVDS}       ]
        set suprt_lvl    [get_property value ${param_value.SupportLevel}      ]
        set gt_in_exd    [get_property value  ${param_value.GTinEx}                  ] 

        if { $gt_in_exd } {
            set_property load_image "xgui/gt_in_ed.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        } elseif { $suprt_lvl } {
            set_property load_image "xgui/with_shared_logic.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        } else {
            set_property load_image "xgui/without_shared_logic.png" [ipgui::get_imagespec PixmapAFix2 -of $IPINST]
        }
        dbg_gui_msg "update_gui_for_param_value.GTinEx completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "update_gui_for_param_value.GTinEx error  messages $d" }
}

proc update_gui_for_param_value.TransceiverControl {param_value.TransceiverControl IPINST} {
    set d [ catch {
        if {[get_property value ${param_value.TransceiverControl}] && ([get_dvc_has_gth34] || [get_dvc_has_gty34])} {
            set_property  visible true  [ipgui::get_guiparamspec drpclkrate -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_guiparamspec drpclkrate -of $IPINST]
        }
        dbg_gui_msg "update_gui_for_param_value.TransceiverControl completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "TransceiverControl error messages $d" }
}

proc update_gui_for_param_value.processor_mode {IPINST param_value.processor_mode PROJECT_PARAM.ARCHITECTURE}  {
    set d [ catch {
        set processor_mode [get_property value ${param_value.processor_mode}]
        if {$processor_mode} {
            set_property  enabled false [ipgui::get_groupspec pfc_grp  -of $IPINST ]
            set_property  visible true  [ipgui::get_guiparamspec axisclkrate  -of $IPINST ]
        } else {
            set_property  enabled true  [ipgui::get_groupspec pfc_grp  -of $IPINST ]
            set_property  visible false [ipgui::get_guiparamspec axisclkrate  -of $IPINST ]
        }
        dbg_gui_msg "update_gui_for_param_value.processor_mode completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "processor_mode error messages $d" }
}

proc update_gui_for_param_value.ENABLE_LVDS {IPINST param_value.ENABLE_LVDS param_value.GTinEx param_value.EnableAsyncSGMII param_value.ClockSelection param_value.SupportLevel param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE}  {
    set d [ catch {
        set enable_lvds [get_property value  ${param_value.ENABLE_LVDS}             ] 
        set en_asgmii   [get_property value  ${param_value.EnableAsyncSGMII}        ] 
        set phy_type    [string tolower [get_property value ${param_value.PHY_TYPE}]] 
        set suprt_lvl   [get_property value ${param_value.SupportLevel}             ] 
        set gt_in_exd   [get_property value  ${param_value.GTinEx}                  ] 
        set clock_selection [get_property value ${param_value.ClockSelection}]
        set test [get_dvc_is_uscale]
        set Shared_Logic [ipgui::get_pagespec Shared_Logic -of $IPINST              ]


        if {($phy_type == "sgmii" && [get_dvc_is_uscale])} {
            set_property visible true   [ipgui::get_guiparamspec EnableAsyncSGMII -of $IPINST]
        } else {
            set_property visible false  [ipgui::get_guiparamspec EnableAsyncSGMII -of $IPINST]
        }

        if { $enable_lvds && (([get_dvc_is_uscaleplus] && $phy_type == "sgmii") || [get_dvc_is_versal]) } { 
            set_property visible true [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
            set_property visible true [ipgui::get_groupspec Clock_Selection -of $IPINST]
        } else {
            set_property visible false [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
            set_property visible false [ipgui::get_groupspec Clock_Selection -of $IPINST]
        }

        if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p])} {
            set_property  visible true  [ipgui::get_groupspec gtclkr_grp -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_groupspec gtclkr_grp -of $IPINST]
        }

        if {($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && !$enable_lvds && ([get_dvc_has_gth34] && [get_dvc_has_gty34])} {
            set_property  visible true  [ipgui::get_guiparamspec gt_type -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_guiparamspec gt_type -of $IPINST]
        }

        if {((($phy_type == "sgmii" ) && (([get_dvc_is_uscaleplus] && $clock_selection == "Sync") || ([get_dvc_is_uscale] && $en_asgmii && $clock_selection == "Sync") || ([get_dvc_is_uscale] && !$en_asgmii ))) || [get_dvc_is_versal]) && $enable_lvds } {
            set_property  visible true  [ipgui::get_groupspec lvclkr_grp -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_groupspec lvclkr_grp -of $IPINST]
        }

        if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus] ||  [get_dvc_is_versal] || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))
            ||  (!$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34]))} {
            set_property  visible true  [ipgui::get_pagespec   Locations  -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_pagespec   Locations  -of $IPINST]
        }

        if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus] ||  [get_dvc_is_versal]  || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))  } {
            set_property  visible true  [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
            set_property  visible true  [ipgui::get_groupspec  lane0_grp -of $IPINST]
            set_property  visible true  [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
        } else {
            set_property  visible false  [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
            set_property  visible false [ipgui::get_groupspec  lane0_grp -of $IPINST]
            set_property  visible false [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
        }

        if { !$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p]) } {
            set_property  visible true  [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
            set_property  visible false [ipgui::get_guiparamspec  gtrefclksrc -of $IPINST]
        } else {
            set_property  visible false [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
        }

        if { (($phy_type == "1000basex" || $phy_type == "sgmii" || $phy_type == "both") && [get_dvc_is_versal] ) } {
           set_property  visible false  $Shared_Logic
        } else {
           set_property  visible true  $Shared_Logic
        }


        dbg_gui_msg "update_gui_for_param_value.ENABLE_LVDS completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "ENABLE_LVDS error messages $d" }
}

proc update_gui_for_param_value.EnableAsyncSGMII {IPINST param_value.EnableAsyncSGMII param_value.ENABLE_LVDS PARAM_VALUE.ClockSelection param_value.GTinEx param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE}  {

    set en_asgmii   [get_property value  ${param_value.EnableAsyncSGMII}]
    set enable_lvds [get_property value  ${param_value.ENABLE_LVDS}     ]
    set phy_type    [string tolower [get_property value ${param_value.PHY_TYPE}]]
    set gt_in_exd   [get_property value  ${param_value.GTinEx}          ]
    set clock_selection [get_property value ${PARAM_VALUE.ClockSelection}]

    if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus]  || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))
        ||  (!$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34] ))} {
        set_property  visible true  [ipgui::get_pagespec Locations  -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_pagespec Locations  -of $IPINST]
    }

    if { $en_asgmii && ([get_dvc_is_uscale] || [get_dvc_is_uscaleplus]) && $phy_type == "sgmii"} { 
        set_property visible true [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
        set_property visible true [ipgui::get_groupspec Clock_Selection -of $IPINST]
    } else {
        set_property visible false [ipgui::get_guiparamspec -name ClockSelection -of $IPINST]
        set_property visible false [ipgui::get_groupspec Clock_Selection -of $IPINST]
    }

    if {($phy_type == "sgmii" ) && $enable_lvds && (([get_dvc_is_uscaleplus] && $clock_selection == "Sync") || ([get_dvc_is_uscale] && $en_asgmii && $clock_selection == "Sync") || ([get_dvc_is_uscale] && !$en_asgmii ) )} {
      set_property visible true [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    } else {
      set_property visible false [ipgui::get_groupspec lvclkr_grp -of $IPINST]
    }

    if {( $enable_lvds && ($phy_type == "1000basex" ||  [get_dvc_is_uscaleplus]  || ($phy_type == "sgmii" && [get_dvc_is_uscale]  && $en_asgmii)))  } {
        set_property  visible true  [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
        set_property  visible true  [ipgui::get_groupspec  lane0_grp -of $IPINST]
        set_property  visible true  [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec  lvds_loc_grp -of $IPINST]
        set_property  visible false [ipgui::get_groupspec  lane0_grp -of $IPINST]
        set_property  visible false [ipgui::get_groupspec  lvds_bitslice_grp -of $IPINST]
    }

    if { !$enable_lvds && !$gt_in_exd && ($phy_type == "sgmii" || $phy_type == "1000basex" || $phy_type == "both") && ([get_dvc_has_gth34] || [get_dvc_has_gty34] || [get_dvc_has_gty5p]) } {
        set_property  visible true  [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
        set_property  visible false [ipgui::get_guiparamspec  gtrefclksrc -of $IPINST]
    } else {
        set_property  visible false [ipgui::get_groupspec  gt_loc_grp -of $IPINST]
    }

    set d [ catch {
        dbg_gui_msg "update_gui_for_param_value.EnableAsyncSGMII completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "ENABLE_LVDS error messages $d" }
}

proc update_gui_for_param_value.SIMULATION_MODE {IPINST param_value.SIMULATION_MODE PROJECT_PARAM.ARCHITECTURE}  {
    set d [ catch {
        set_property  visible false [ipgui::get_guiparamspec SIMULATION_MODE -of $IPINST]
        dbg_gui_msg "update_gui_for_param_value.SIMULATION_MODE completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "simulation mode error messages $d" }
}

proc update_gui_for_param_value.Include_IO {IPINST param_value.Include_IO param_value.PHY_TYPE PROJECT_PARAM.ARCHITECTURE }  {
    set d [ catch {
        set Include_IO [get_property value ${param_value.Include_IO}]
        set phy_type  [string tolower [get_property value ${param_value.PHY_TYPE}]]

        if {$phy_type == "gmii"} {
            if {![get_property value  ${param_value.Include_IO}] } {
                set_property  visible false [ipgui::get_groupspec supportl_info_grp  -of $IPINST ]
            } else {
                set_property  visible true [ipgui::get_groupspec supportl_info_grp  -of $IPINST ]
            }
        }
        set SL_desc [DT_Support_Level $phy_type $Include_IO]
        set_property description $SL_desc [ipgui::get_guiparamspec SupportLevel -of $IPINST ]
        dbg_gui_msg "update_gui_for_param_value.Include_IO completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "Include_IO error messages $d" }
}

proc update_gui_for_param_value.Enable_1588 { param_value.Enable_1588 IPINST} {
    set d [ catch {
        if {[get_property value ${param_value.Enable_1588}] } {
            set_property enabled true   [ipgui::get_groupspec Op_1588_grp -of $IPINST ]
#set_property enabled true   [ipgui::get_paramspec TIMER_CLK_PERIOD -of $IPINST ]
        } else {
            set_property enabled false   [ipgui::get_groupspec Op_1588_grp -of $IPINST ]
#set_property enabled false   [ipgui::get_paramspec TIMER_CLK_PERIOD -of $IPINST ]
        }
        dbg_gui_msg "update_gui_for_param_value.Enable_1588 completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "Enable_1588 error messages $d" }
}

proc update_gui_for_param_value.USE_BOARD_FLOW { param_value.USE_BOARD_FLOW IPINST} {
    dbg_gui_msg "update_gui_for_param_value.USE_BOARD_FLOW started"
    set d [ catch {
        dbg_gui_msg "update_gui_for_param_value.USE_BOARD_FLOW completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "USE_BOARD_FLOW error messages $d" }
}

proc update_gui_for_param_value.lvdsclkrate {IPINST param_value.lvdsclkrate PROJECT_PARAM.ARCHITECTURE}  {
    set d [ catch {
        dbg_gui_msg "update_gui_for_param_value.lvdsclkrate completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "lvdsclkrate error messages  $d" }
}
proc update_gui_for_param_value.gtrefclkrate {IPINST param_value.gtrefclkrate PROJECT_PARAM.ARCHITECTURE}  {
    set d [ catch {
        dbg_gui_msg "update_gui_for_param_value.gtrefclkrate completed"
    } ]
    if { !($d == "" || $d == "0") } { dbg_gui_msg "gtrefclkrate error messages  $d" }
}

###########################################################################################################################################
###  Update GUI for Param Value functions          END#>->
###########################################################################################################################################
