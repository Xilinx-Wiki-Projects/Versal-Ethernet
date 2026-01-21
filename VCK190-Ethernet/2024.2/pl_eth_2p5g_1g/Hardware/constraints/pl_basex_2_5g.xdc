########################################################
###
### XDC for Axi Ethernet Subsystem design for VCK190
###
########################################################


##### GTY Bank 200 - QSFP
#set_property PACKAGE_PIN AF2 [get_ports {gt_rxp_in_0[0]}]
#set_property PACKAGE_PIN AF1 [get_ports {gt_rxn_in_0[0]}]
#set_property PACKAGE_PIN AF7 [get_ports {gt_txp_out_0[0]}]
#set_property PACKAGE_PIN AF6 [get_ports {gt_txn_out_0[0]}]
#set_property PACKAGE_PIN AE4 [get_ports {gt_rxp_in_0[1]}]
#set_property PACKAGE_PIN AE3 [get_ports {gt_rxn_in_0[1]}]
#set_property PACKAGE_PIN AE9 [get_ports {gt_txp_out_0[1]}]
#set_property PACKAGE_PIN AE8 [get_ports {gt_txn_out_0[1]}]
#set_property PACKAGE_PIN AD2 [get_ports {gt_rxp_in_0[2]}]
#set_property PACKAGE_PIN AD1 [get_ports {gt_rxn_in_0[2]}]
#set_property PACKAGE_PIN AD7 [get_ports {gt_txp_out_0[2]}]
#set_property PACKAGE_PIN AD6 [get_ports {gt_txn_out_0[2]}]
#set_property PACKAGE_PIN AC4 [get_ports {gt_rxp_in_0[3]}]
#set_property PACKAGE_PIN AC3 [get_ports {gt_rxn_in_0[3]}]
#set_property PACKAGE_PIN AC9 [get_ports {gt_txp_out_0[3]}]
#set_property PACKAGE_PIN AC8 [get_ports {gt_txn_out_0[3]}]
#### GTREFCLK 0 Configured as Output (Recovered Clock) which connects to 8A34001 CLK1_IN
#set_property PACKAGE_PIN AF11 [get_ports {RX_REC_CLK_out_p_0}]
#set_property PACKAGE_PIN AF10 [get_ports {RX_REC_CLK_out_n_0}]
#### GTREFCLK 1 ( Driven by 8A34001 Q1 )
#set_property PACKAGE_PIN AD11 [get_ports {CLK_IN_D_clk_p}]
#set_property PACKAGE_PIN AD10 [get_ports {CLK_IN_D_clk_n}]


##### GTY Bank 105 - SFP0 interface pin
set_property PACKAGE_PIN K46 [get_ports {gt_rxp_in_0[2]}]
set_property PACKAGE_PIN K47 [get_ports {gt_rxn_in_0[2]}]
set_property PACKAGE_PIN H41 [get_ports {gt_txp_out_0[2]}]
set_property PACKAGE_PIN H42 [get_ports {gt_txn_out_0[2]}]
### GTREFCLK 0 ( Driven by SI570 )

####SFP1
set_property PACKAGE_PIN H46 [get_ports {gt_rxp_in_0[3]}]
set_property PACKAGE_PIN H47 [get_ports {gt_rxn_in_0[3]}]
set_property PACKAGE_PIN G43 [get_ports {gt_txp_out_0[3]}]
set_property PACKAGE_PIN G44 [get_ports {gt_txn_out_0[3]}]

##### LED Outputs

####################################################################################
# Timing
####################################################################################



####################################################################################
# Constraints from file : 'bd_fb30_eth_buf_0.xdc'
####################################################################################




set_property PACKAGE_PIN G36 [get_ports ch0_txprogdivresetdone_0]

set_property IOSTANDARD LVCMOS18 [get_ports gtwiz_reset_rx_done_in_0]
set_property IOSTANDARD LVCMOS18 [get_ports gtwiz_reset_tx_done_in_0]
set_property IOSTANDARD LVCMOS18 [get_ports ch0_txprogdivresetdone_0]

####################################################################################
# Constraints from file : 'bd_ab6b_eth_buf_0.xdc'
####################################################################################

# set_property PACKAGE_PIN E39 [get_ports gtrefclk_p_0]
set_property PACKAGE_PIN L39 [get_ports gtrefclk_p_0]
set_property PACKAGE_PIN G21 [get_ports gtwiz_reset_tx_done_in_0]
