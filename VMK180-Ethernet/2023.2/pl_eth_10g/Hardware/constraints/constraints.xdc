### Any other Constraints
set_false_path -to [get_cells -hierarchical -filter {NAME =~ */i_*_axi_if_top/*/i_*_syncer/*meta_reg*}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ */i_*_SYNC*/*stretch_reg*}]

#set_false_path -to [get_cells -hierarchical -filter {NAME=~ */i*syncer/*d2_cdc_to*}]

#set_false_path -to [get_cells -hierarchical -filter {NAME =~ */*ptp_port_timer/*ns_meta_reg*}]

#set_max_delay 2.56 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_RX_CORE_LANE/i_RX_WD_ALIGN/align_status_reg[*]}] -filter { name =~ *C } ] #-to [get_pins -of [get_cells -hier -filter { name =~ */*_block_lock_syncer_gen/s_out_d2_cdc_to_reg}] -filter { name =~ *D } ]



#set_max_delay -from [get_pins -of [get_cells -hier -filter { name =~ */*_ptp_1588_timer_syncer*core_top/tod_snapshot_1pps_r_reg}] -filter { name =~ *C } ] #-to [get_pins -of [get_cells -hier -filter { name =~ */*_ptp_1588_timer_syncer*core_top/*_timer_snapshot_*_reg[*]}] -filter { name =~ *CE } ] -datapath_only 4.0



set_max_delay -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_RX_WD_ALIGN/align_status_reg[*]*}] -filter { name =~ *C }] -to [get_pins -of [get_cells -hier -filter { name =~ */s_out_d2_cdc_to_reg*}] -filter { name =~ *D }] 10.000 -quiet



set_max_delay -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */s_out_d4_reg*}] -filter { name =~ *C }] -to [get_pins -of [get_cells -hier -filter { name =~ */s_out_d2_cdc_to_reg*}] -filter { name =~ *D }] 10.000 -quiet


#set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ *tx_reset_syncer/data_out_d3_reg*}] -filter { name =~ *C } ] #-to [get_pins -of [get_cells -hier -filter { name =~ */*EXAMPLE_FSM/completion_status_reg*}] -filter { name =~ *S } ]
#set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ *tx_reset_syncer/data_out_d3_reg*}] -filter { name =~ *C } ] #-to [get_pins -of [get_cells -hier -filter { name =~ */*EXAMPLE_FSM/*}] -filter { name =~ *R } ]





create_waiver -type CDC -id {CDC-11} -user "xxv_ethernet" -desc "The align status signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */i_RX_WD_ALIGN/align_status_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ */s_out_d2_cdc_to_reg*}] -filter {name =~ *D}] -timestamp "Thu Feb 22 17:53:18 GMT 2024"












## TIMER SYNCER











##set_false_path -to [get_cells -hier -filter {name=~ */ptp_1588_timer_syncer_*/inst/*_timer_syncer_ptp_1588_timer_syncer_*_core_top/*_ptp_port_timer/*_meta_reg*}]




















set_max_delay -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */*_axi_if_top/i_pif_registers/ctl_*x_max_packet_len_out_reg*}] -filter { name =~ *C }] 10.000 -quiet









set_property PACKAGE_PIN K46 [get_ports {GT_Serial_grx_p[2]}]
set_property PACKAGE_PIN L39 [get_ports {xxv_ethernet_0_diff_gt_ref_clock_clk_p[0]}]

