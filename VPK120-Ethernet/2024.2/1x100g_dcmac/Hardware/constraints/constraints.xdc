

###### Below are the constraints for VPK120 Board(xcvp1202-vsva2785-2LP-e-S-es1) example design with DCMAC_X0Y0 - GTM
##### Example design DCMAC_X0Y0 - GTM Bank 202 to Bank 205 are usable.
##### GTM Bank 202
##### GTM Bank 203
create_clock -period 6.400 -name gt_ref_clk0_clk_p -waveform {0.000 3.200} [get_ports {gt_ref_clk0_clk_p[0]}]
set_property PACKAGE_PIN AB46 [get_ports {gt_ref_clk0_clk_n[0]}]
set_property PACKAGE_PIN AW53 [get_ports {GT_Serial_grx_n[0]}]


#### Waivers ####

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This tx_pkt_gen_max_len register drives the pkt_len_r register and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This tx_pkt_gen_max_len register drives the pkt_len_r register and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This scratch register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [list [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/FSM_onehot_state_reg*}] -filter { name =~ *CE } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_axis_pkt_mon_reg*}] -filter { name =~ *D } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_axis_pkt_mon_reg*}] -filter { name =~ *R } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_gearbox_valid_reg*}] -filter { name =~ *S } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_gearbox_slice_reg*}] -filter { name =~ *D } ]]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/memcel_apb3_reset_d_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/cal_cnt_reg*}] -filter { name =~ *R } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/memcel_apb3_reset_d_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/*vld_mask_reg*}] -filter { name =~ *R } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This fixe_calender register drives fixe_calender_axi and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/fixe_calender_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/fixe_calender_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This fixe_calender register drives fixe_calender_axi and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/fixe_calender_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/fixe_calender_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg**}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]


create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This multi bit clear counter registered with destination clock not needed syncer" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/clear_*x_counters_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_*_ts/*_pkt_cnt_*_inst/clear_rx_counters_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This multi bit clear counter registered with destination clock not needed syncer" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/clear_*x_counters_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_*_ts/*_pkt_cnt_*_inst/clear_rx_counters_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-5} -user "dcmac" -desc "This multi bit clear counter registered with destination clock not needed syncer" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/clear_*x_counters_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_*_ts/*_pkt_cnt_*_inst/clear_rx_counters_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This scratch register drives the rx_gearbox_slice_reg and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */rx_gearbox_slice_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "The CDC-13 warning is waived, this is a level signal and it is getting changed when pm_tick is applied. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_mon_ts/rx_id_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-11} -user "dcmac" -desc "Fan-out is expected on this data rate reg path as this drives to multiple destination" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*rx_gearbox_slice_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_apb3_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-11} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_apb3_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_apb3_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer/port*_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer/o_emu_*x_rst_reg*}] -filter { name =~ *C}]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*emu_gearbox_tx/rst_mask_reg*}] -filter { name =~ *D}]

#create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "This txdata register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
#-from [get_pins {i_*_exdes/i_*_support_wrapper/*_support_i/*_core/inst/i_*_exdes_support_*_core_0_top/obsabqrqac5cbvet/TX_ALT_SERDES_CLK[*]}]\
#-to [get_pins {i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base*/inst/quad_inst/CH*_TXDATA[*]}]
####

## Additional false path constraints within the Gen/Mon
set_false_path -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]]
set_false_path -from [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]] -to [get_clocks clk_pl_0]




create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This tx_pkt_gen_min_len_reg register drives pkt_len_r_reg and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */tx_pkt_gen_min_len_reg[*]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*ctrl_gen/pkt_len_r_reg[*][*]}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This o_emu_rx_rst_reg register drives o_prbs_locked_reg and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer/o_emu_rx_rst_reg[*]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_mon_ts/o_prbs_locked_reg[*]}] -filter { name =~ *D } ]



create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "The CDC-13 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */gpio_core_*/Not_Dual.gpio_Data_Out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_exdes_support_*_core_*_top/obsabqrqac5cbvet}] -filter { name =~ *_CORE_RESET} ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This pkt_gen_min_len register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_min_len_reg[15]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_gen_ts/*_ctrl_gen/pkt_len_r_reg[*][*]}] -filter { name =~ *D }]


create_waiver -quiet -type CDC -id {CDC-5} -user "dcmac" -desc "The path is registered and it does not require ASYNC_REG" -tags "1169576"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_ena*}] -filter {name =~ *C}]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_gen_ts/*_ctrl_gen/pkt_ena*}] -filter {name =~ *D}]

create_waiver -quiet -type DRC -id {REQP-2057} -user "dcmac" -desc "REQP-2057 is waived as the MBUFG_GT CLR and CLRBLEAF pins are connected with the GT Reset IP" -tags "1138767" -objects [get_cells -hier -filter {REF_NAME==MBUFG_GT && NAME=~ */*_exdes_support*/*gt_wrapper*/*}]



















#create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "This txdata register drives multiple destination path and all are registered on the destination clocks" -tags "1103070" #-from [get_pins {i_*_exdes/i_*_support_wrapper/*_support_i/*_core/inst/i_*_exdes_support_*_core_0_top/obsabqrqac5cbvet/TX_ALT_SERDES_CLK[*]}] #-to [get_pins {i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base*/inst/quad_inst/CH*_TXDATA[*]}]
####

## Additional false path constraints within the Gen/Mon















####################################################################################
# Constraints from file : 'xpm_cdc_async_rst.tcl'
####################################################################################

