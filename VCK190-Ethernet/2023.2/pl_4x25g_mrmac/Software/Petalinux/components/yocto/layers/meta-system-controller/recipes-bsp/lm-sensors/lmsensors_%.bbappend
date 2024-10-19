SC_ADDITIONAL_INCLUDE = ""

# The following change is only for system controller boards
SC_ADDITIONAL_INCLUDE:eval-brd-sc = "${@'sc-fancontrol.inc' if d.getVar('MACHINE') == 'eval-brd-sc' else ''}"

require ${SC_ADDITIONAL_INCLUDE}
