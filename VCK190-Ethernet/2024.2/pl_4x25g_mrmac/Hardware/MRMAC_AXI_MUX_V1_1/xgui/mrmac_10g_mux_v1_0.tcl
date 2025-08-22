# (C) Copyright 2020 - 2021 Xilinx, Inc.
# SPDX-License-Identifier: Apache-2.0
# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}


