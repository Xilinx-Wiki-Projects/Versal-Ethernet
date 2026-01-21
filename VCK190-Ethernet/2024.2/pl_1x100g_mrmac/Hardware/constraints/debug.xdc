#set_property    PACKAGE_PIN L35         [get_ports "GPIO_LED_3_LS"]           ; # Bank 306  VCC1V8       IO_L6P_HDGC_306
#set_property    IOSTANDARD LVCMOS18     [get_ports "GPIO_LED_3_LS"]           ;
#set_property    PACKAGE_PIN K36         [get_ports "GPIO_LED_2_LS"]           ; # Bank 306  VCC1V8       IO_L6N_306
#set_property    IOSTANDARD LVCMOS18     [get_ports "GPIO_LED_2_LS"]           ;
#set_property    PACKAGE_PIN J33         [get_ports "GPIO_LED_1_LS"]           ; # Bank 306  VCC1V8       IO_L7P_306
#set_property    IOSTANDARD LVCMOS18     [get_ports "GPIO_LED_1_LS"]           ;
set_property PACKAGE_PIN H34 [get_ports {GPIO_LED_0_LS[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {GPIO_LED_0_LS[0]}]

set_clock_groups -name vio_grp -asynchronous -group [get_clocks -of_objects [get_pins mrmac_subsys_i/CLK_RST_WRAPPER/clk_wizard_tx_rx_axis/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0]] -group [get_clocks clk_pl_0]
set_clock_groups -name vio_grp -asynchronous -group [get_clocks -of_objects [get_pins {mrmac_subsys_i/GT_WRAPPER/mbufg_gt_0/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -group [get_clocks clk_pl_0]

####################################################################################
# Constraints from file : 'xpm_cdc_async_rst.tcl'
####################################################################################

set_property LOC SLICE_X245Y54 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/PR_OUT_DFF[0].FDRE_PER_replica_1}]
set_property LOC SLICE_X285Y49 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_replica}]
set_property LOC SLICE_X283Y45 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_replica_1}]
set_property LOC SLICE_X245Y54 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/PR_OUT_DFF[0].FDRE_PER_replica_2}]
set_property LOC SLICE_X291Y49 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_replica_2}]
set_property LOC SLICE_X283Y42 [get_cells {mrmac_subsys_i/CLK_RST_WRAPPER/proc_sys_reset_3/U0/ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_replica_3}]
set_false_path -from [get_clocks -of_objects [get_pins mrmac_subsys_i/CLK_RST_WRAPPER/clk_wizard_tx_rx_axis/inst/clock_primitive_inst/MMCME5_inst/CLKOUT0]] -to [get_clocks clk_pl_0]
