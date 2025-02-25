set_property PACKAGE_PIN F4 [get_ports {gt_rxp_in*[0]}]
set_property PACKAGE_PIN L18 [get_ports {ref_clk_p_0[0]}]
###----

set_property LOC GTM_QUAD_X0Y15 [get_cells -hier -filter {name =~ */gt_quad_base*/inst/quad_inst}]
set_property LOC GTM_REFCLK_X0Y28 [get_cells -hier -filter {name =~ */USE_IBUFDS_GTME5.GEN_IBUFDS_GTME5[0].IBUFDS_GTME5_U}]


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch0_rxdata[0]}]

create_clock -period 6.400 -name {ref_clk_p_0[0]} -waveform {0.000 3.200} [get_ports {ref_clk_p_0[0]}]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch0_rxoutclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch0_txoutclk] 

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch1_rxoutclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch1_txoutclk] 

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch2_rxoutclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch2_txoutclk]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch3_rxoutclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch3_txoutclk] 

#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch0_rxdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch0_txdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch1_rxdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch1_txdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch2_rxdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch2_txdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch3_rxdata[0]]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/gt_quad_base/inst/ch3_txdata[0]]



set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base*/inst/quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.800
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base*/inst/quad_inst/CH0_TXOUTCLK}]] 2.800
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mrmac_0_gt_wrapper/mbufg_gt_*/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[*].MBUFG_GT_U/O*}]] 2.800
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.800



set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]]

set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_RXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_RXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_RXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_RXOUTCLK}]]

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]] 2.560




set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mrmac_0_gt_wrapper/mbufg_gt_*/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[*].MBUFG_GT_U/O1*}]] 1.552






#set_clock_groups -name pl0_ref_clk_0 -asynchronous -group [get_clocks -of_objects [get_pins i_mrmac_0_cips_wrapper/mrmac_0_cips_i/pl0_ref_clk_0]]
#set_clock_groups -name pl0_ref_clk -asynchronous -group [get_clocks -of_objects [get_pins mrmac_0_exdes_support_i/versal_cips_0/pl0_ref_clk]]

#create_waiver -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 warning is waived, this is a level signal and this is safe to ignore" -tags "1101959" -from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/axi_gpio_gt_prbs_comm_ctl/*/gpio_core_*/Dual.gpio_Data_Out_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter {name =~ */*_gt_wrapper/gt_quad_base/inst/quad_inst/CH*_RXRATE*}] -timestamp "Thu Apr  6 10:54:47 GMT 2023"

#create_waiver -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 warning is waived, this is a level signal and this is safe to ignore" -tags "1101959" -from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/axi_gpio_gt_prbs_comm_ctl/*/gpio_core_*/Dual.gpio_Data_Out_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter {name =~ */*_gt_wrapper/gt_quad_base/inst/quad_inst/CH*_TXRATE*}] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks " -tags "1101959" -from [get_pins -hier -filter { name =~ *_exdes_*/*_core/inst/*_top/*/TX_CORE_CLK*}] -to [list [] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D }]] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks " -tags "1101959" -from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/*_Data_Out_reg*}] -filter { name =~ *C }] -to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *D }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *D }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *R }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D }]] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks" -tags "1101959" -from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/proc_sys_reset_*/*/ACTIVE_LOW_PR_OUT_DFF*.FDRE_PER_*}] -filter { name =~ *C }] -to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/CLIENT*_FSM_r_reg*}] -filter { name =~ *S }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/CLIENT*_FSM_r_reg*}] -filter { name =~ *R }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/client*_prbs_reg*}] -filter { name =~ *R }] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.*_buff*_reg*}] -filter {name =~ *R}] [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.*_buff*_reg*}] -filter {name =~ *D}]] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-10} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/axi_gpio_prbs_ctl/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter {name =~ */*_pkt_gen_mon_*/*_pkt_gen_*/DUPLEX_PKT_SIZE_*_reg*/CLR}] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 is safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter { name =~ */*_support_wrapper/*_exdes_support_i/*_core/*/*_core_0_top/*/TX_AXIS_TLAST_*}] -timestamp "Thu Apr  6 10:54:48 GMT 2023"

#create_waiver -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 is safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter { name =~ */*_support_wrapper/*_exdes_support_i/*_core/*/*_core_0_top/*/TX_AXIS_TVALID_*}] -timestamp "Thu Apr  6 10:54:49 GMT 2023"

#create_waiver -type CDC -id {CDC-11} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter { name =~ *_exdes/*_pkt_gen_mon_*/*_pkt_gen_*/DUPLEX_PKT_SIZE_*_reg*/CLR}] -timestamp "Thu Apr  6 10:54:49 GMT 2023"

#create_waiver -type CDC -id {CDC-7} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}] -filter { name =~ *C }] -to [get_pins -hier -filter { name =~ *_exdes/*_pkt_gen_mon_*/*_pkt_gen_*/*_reg*/CLR}] -timestamp "Thu Apr  6 10:54:49 GMT 2023"

#create_waiver -type CDC -id {CDC-7} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/proc_sys_reset_*/*/ACTIVE_LOW_PR_OUT_DFF*.FDRE_PER_*}] -filter { name =~ *C }] -to [get_pins -hier -filter { name =~ *_exdes/*_trig_in_edge_detect_reg/CLR}] -timestamp "Thu Apr  6 10:54:49 GMT 2023"

#create_waiver -type CDC -id {CDC-14} -user "mrmac" -desc "The CDC-14 is safe to ignore" -tags "1101959" -from [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*_buff*_reg* }] -filter { name =~ *C }] -to [get_pins -hier -filter {name =~ *_exdes/*_exdes_support_wrapper/*/*_core/*/*_top/*/TX_AXIS_*}] -timestamp "Thu Apr  6 10:54:49 GMT 2023"




#set_property GCLK_DESKEW Off [get_nets i_mrmac_0_exdes_support_wrapper/mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/mbufg_gt_1_1/U0/MBUFG_GT_O1[0]]
#set_property GCLK_DESKEW Off [get_nets i_mrmac_0_exdes_support_wrapper/mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/mbufg_gt_1/U0/MBUFG_GT_O1[0]]
#set_property GCLK_DESKEW Off [get_nets i_mrmac_0_exdes_support_wrapper/mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/mbufg_gt_1_2/U0/MBUFG_GT_O1[0]]
#set_property GCLK_DESKEW Off [get_nets i_mrmac_0_exdes_support_wrapper/mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/mbufg_gt_1_3/U0/MBUFG_GT_O1[0]]
#create_waiver -type DRC -id {BFGCHK-1} -user "shabbirk" -desc "Ignore this DRC as all clocks are within FMAX specification." -timestamp "Thu Apr  6 15:23:51 GMT 2023"

##################


set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base/inst/quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.8
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base/inst/quad_inst/CH0_TXOUTCLK}]] 2.8
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mrmac_0_gt_wrapper/mbufg_gt_*/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[*].MBUFG_GT_U/O*}]] 2.8
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.8


set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */ClockReset/clk_wizard_0/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *mrmac_0_exdes_support_i/mrmac_0_gt_wrapper/mbufg_gt_*/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[*].MBUFG_GT_U/O1*}]] 1.552





#set_false_path -quiet -from [get_pins -hier -filter { name =~ *_pkt_gen_mon_*/*_pkt_gen_*g/*_reg/C}]\
#-to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D } ]]
#set_false_path -quiet -from [get_pins -hier -filter { name =~ */*_exdes_support_i/*_core/inst/*_top/*/TX_CORE_CLK*}]\
#-to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D } ]]

#set_false_path -quiet -from [get_pins  -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buf*_reg*/C}]  -to [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buf*_reg*}] -filter { name =~ *CE } ]
#set_false_path  -quiet -from [get_pins  -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buf*_reg*/C}]  -to [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buf*_reg*}] -filter { name =~ *CE } ]
#set_false_path -quiet -from [get_pins  -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buf*_reg*/C}]  -to [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buf*_reg*}] -filter { name =~ *CE } ]
#set_false_path -quiet -from [get_pins  -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buf*_reg*/C}]  -to [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buf*_reg*}] -filter { name =~ *D} ]


set_clock_groups -name pl0_ref_clk_0 -asynchronous -group [get_clocks clk_pl_0]

create_waiver -quiet -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 warning is waived, this is a level signal and this is safe to ignore" -tags "1101959"\
-from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/axi_gpio_gt_prbs_comm_ctl/*/gpio_core_*/Dual.gpio_Data_Out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -hier -filter {name =~ */*_gt_wrapper/gt_quad_base/inst/quad_inst/CH*_RXRATE*}]  

create_waiver -quiet -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 warning is waived, this is a level signal and this is safe to ignore" -tags "1101959"\
-from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/axi_gpio_gt_prbs_comm_ctl/*/gpio_core_*/Dual.gpio_Data_Out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -hier -filter {name =~ */*_gt_wrapper/gt_quad_base/inst/quad_inst/CH*_TXRATE*}]  

#create_waiver -quiet -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks " -tags "1101959"\
#-from [get_pins -hier -filter { name =~ */*_exdes_support_i/*_core/inst/*_top/*/TX_CORE_CLK*}]\
#-to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D } ]]

#create_waiver -quiet -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/*_Data_Out_reg*}] -filter { name =~ *C } ]\
#-to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tdata_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tkeep_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *CE } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *R } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff*_reg*}] -filter { name =~ *D } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff*_reg*}] -filter { name =~ *D } ]]

#create_waiver -quiet -type CDC -id {CDC-1} -user "mrmac" -desc "This register drives multiple destination path and all are registered on the destination clocks" -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter { name =~ *_cips_wrapper/*_cips_i/proc_sys_reset_*/*/ACTIVE_LOW_PR_OUT_DFF*.FDRE_PER_*}] -filter { name =~ *C } ]\
#-to [list [get_pins -of [get_cells -hier -filter {name =~ *_exdes/CLIENT*_FSM_r_reg*}] -filter { name =~ *S } ]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/CLIENT*_FSM_r_reg*}] -filter { name =~ *R }]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/client*_prbs_reg*}] -filter { name =~ *R }]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.*_buff*_reg*}] -filter {name =~ *R}]\
#[get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.*_buff*_reg*}] -filter {name =~ *D}]]

#create_waiver  -quiet -type CDC -id {CDC-10} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/axi_gpio_prbs_ctl/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}] -filter { name =~ *C } ]\
#-to [get_pins -hier -filter {name =~ */*_pkt_gen_mon_*/*_pkt_gen_*/DUPLEX_PKT_SIZE_*_reg*/CLR}]

#create_waiver -quiet -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 is safe to ignore " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tlast_buff_reg*}] -filter { name =~ *C } ]\
#-to [get_pins -hier -filter { name =~ */*_support_wrapper/*_exdes_support_i/*_core/*/*_core_0_top/*/TX_AXIS_TLAST_*}]

#create_waiver -quiet -type CDC -id {CDC-13} -user "mrmac" -desc "The CDC-13 is safe to ignore " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*.tvalid_buff_reg*}] -filter { name =~ *C } ]\
#-to [get_pins -hier -filter { name =~ */*_support_wrapper/*_exdes_support_i/*_core/*/*_core_0_top/*/TX_AXIS_TVALID_*}]

#create_waiver -quiet -type CDC -id {CDC-11} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}]  -filter { name =~ *C } ]\
#-to [get_pins -hier -filter { name =~ *_exdes/*_pkt_gen_mon_*/*_pkt_gen_*/DUPLEX_PKT_SIZE_*_reg*/CLR}]

#create_waiver -quiet -type CDC -id {CDC-7} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter {name =~ *_cips_wrapper/*_cips_i/*/gpio_core_*/Dual.gpio*_Data_Out_reg*}]  -filter { name =~ *C } ]\
#-to [get_pins  -hier -filter { name =~ *_exdes/*_pkt_gen_mon_*/*_pkt_gen_*/*_reg*/CLR}] 

 create_waiver -quiet -type CDC -id {CDC-7} -user "mrmac" -desc "This is a level signal and safe to ignore " -tags "1101959"\
-from [get_pins -of [get_cells -hier -filter  {name =~ *_cips_wrapper/*_cips_i/proc_sys_reset_*/*/ACTIVE_LOW_PR_OUT_DFF*.FDRE_PER_*}]  -filter { name =~ *C } ]\
-to [get_pins  -hier -filter { name =~ *_exdes/*_trig_in_edge_detect_reg/CLR}] 

#create_waiver -quiet -type CDC -id {CDC-14} -user "mrmac" -desc "The CDC-14 is safe to ignore" -tags "1101959"\
#-from [get_pins -of [get_cells -hier -filter  {name =~ *_exdes/*_axis_stream_mux/axis_2stg_buff*_buff*_reg* }]  -filter { name =~ *C } ]\
#-to [get_pins -hier -filter {name =~ *_exdes/*_exdes_support_wrapper/*/*_core/*/*_top/*/TX_AXIS_*}] 

  
