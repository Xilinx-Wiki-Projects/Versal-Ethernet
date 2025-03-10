

##### GTY Bank 200
set_property PACKAGE_PIN AF2 [get_ports {gt_rxp_in_0[0]}]
set_property PACKAGE_PIN AF1 [get_ports {gt_rxn_in_0[0]}]
set_property PACKAGE_PIN AF7 [get_ports {gt_txp_out_0[0]}]
set_property PACKAGE_PIN AF6 [get_ports {gt_txn_out_0[0]}]
set_property PACKAGE_PIN AE4 [get_ports {gt_rxp_in_0[1]}]
set_property PACKAGE_PIN AE3 [get_ports {gt_rxn_in_0[1]}]
set_property PACKAGE_PIN AE9 [get_ports {gt_txp_out_0[1]}]
set_property PACKAGE_PIN AE8 [get_ports {gt_txn_out_0[1]}]
set_property PACKAGE_PIN AD2 [get_ports {gt_rxp_in_0[2]}]
set_property PACKAGE_PIN AD1 [get_ports {gt_rxn_in_0[2]}]
set_property PACKAGE_PIN AD7 [get_ports {gt_txp_out_0[2]}]
set_property PACKAGE_PIN AD6 [get_ports {gt_txn_out_0[2]}]
set_property PACKAGE_PIN AC4 [get_ports {gt_rxp_in_0[3]}]
set_property PACKAGE_PIN AC3 [get_ports {gt_rxn_in_0[3]}]
set_property PACKAGE_PIN AC9 [get_ports {gt_txp_out_0[3]}]
set_property PACKAGE_PIN AC8 [get_ports {gt_txn_out_0[3]}]

### GTREFCLK 1 ( Driven by 8A34001 Q1 )
set_property PACKAGE_PIN AD11 [get_ports {CLK_IN_D_clk_p[0]}]
set_property PACKAGE_PIN AD10 [get_ports {CLK_IN_D_clk_n[0]}]


####################################################################################
# Timing
####################################################################################


### For GT Rate port




####################################################################################
# Constraints from file : 'xpm_cdc_async_rst.tcl'
####################################################################################


create_clock -period 3.103 -name {CLK_IN_D_clk_p[0]} -waveform {0.000 1.551} [get_ports {CLK_IN_D_clk_p[0]}]
set_max_delay -datapath_only -from [get_pins -hierarchical -filter {NAME =~ *mrmac_subsys_i/GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_*/U0/gpio_core_1/Dual.gpio_Data_Out_reg[*]*/C}] -to [get_pins -hierarchical -filter {NAME =~ *mrmac_subsys_i/GT_WRAPPER/gt_quad_base/inst/quad_inst/CH*_*XRATE[*]}] 9.000

####################################################################################
# Constraints from file : 'debug.xdc'
####################################################################################

