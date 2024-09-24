# GTM Reference Clock - Bank 203 RefClk_0
set_property PACKAGE_PIN AF45 [get_ports {ref_clk_p_0[0]}]

# GTM Bank 203
set_property PACKAGE_PIN BE47 [get_ports {gt_txp_out_0[0]}]
# GTM Bank 202
#set_property PACKAGE_PIN BG45 [get_ports {gt_txp_out_0[0]}]

# 8A34001 Clock Generator for Reference Clocks
#set_property PACKAGE_PIN BF19 [get_ports clk_8a34001]
#set_property IOSTANDARD LVSTL_11 [get_ports clk_8a34001]


####################################################################################
# Timing
####################################################################################

set_property PACKAGE_PIN T33 [get_ports {leds[0]}]
set_property PACKAGE_PIN U33 [get_ports {leds[1]}]
set_property PACKAGE_PIN U37 [get_ports {leds[2]}]
set_property PACKAGE_PIN V37 [get_ports {leds[3]}]

set_property PACKAGE_PIN R36 [get_ports {QSFPDD2_INTn[0]}]
set_property PACKAGE_PIN T36 [get_ports {QSFPDD2_LPMODE[0]}]
set_property PACKAGE_PIN R33 [get_ports {QSFPDD2_MODPRSn[0]}]
set_property PACKAGE_PIN R37 [get_ports {QSFPDD2_MODSELn[0]}]
set_property PACKAGE_PIN P33 [get_ports {QSFPDD2_RESETn[0]}]

set_property IOSTANDARD LVCMOS15 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {QSFPDD2_INTn[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {QSFPDD2_LPMODE[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {QSFPDD2_MODPRSn[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {QSFPDD2_MODSELn[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {QSFPDD2_RESETn[0]}]

create_clock -period 6.400 -name {ref_clk_p_0[0]} -waveform {0.000 3.200} [get_ports {ref_clk_p_0[0]}]

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins {design_1_i/mrmac_4x25g_gt_wrapper/mbufg_gt_0/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to [get_clocks -of_objects [get_pins {design_1_i/mrmac_4x25g_gt_wrapper/mbufg_gt_0_2/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] 1.600







set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base*/inst/quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.800
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */gt_quad_base*/inst/quad_inst/CH0_TXOUTCLK}]] 2.800
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mbufg_gt_*/U0/USE_MBUFG_GT*.GEN_MBUFG_GT*.MBUFG_GT_U/O*}]] 2.800
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */inst/clock_primitive_inst/MMCME5_inst/CLKOUT0}]] 2.800



set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] 2.560

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH0_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH1_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH2_TXOUTCLK}]] 2.560
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */quad_inst/CH3_TXOUTCLK}]] 2.560

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */MMCME5_inst/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ */mbufg_gt_*/U0/USE_MBUFG_GT*.GEN_MBUFG_GT[0].MBUFG_GT_U/O1*}]] 1.552

set_clock_groups -name pl0_ref_clk_0 -asynchronous -group [get_clocks -of_objects [get_pins design_1_i/versal_cips_0/pl0_ref_clk]] -quiet

### Narrow
##### TX CH0
##### TX CH1
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_0/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_1_1/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]]
##### TX CH2
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_0/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_1_2/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]]
##### TX CH3
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_0/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_1_3/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]]
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_0_2/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]] -to [get_clocks -of_objects [get_pins -hier -filter { name =~ */*_gt_wrapper/mbufg_gt_1_3/U0/USE_MBUFG_GT_SYNC.GEN_MBUFG_GT[0].MBUFG_GT_U/O1}]]
