COMPATIBLE_HOST = ".*-elf"
COMPATIBLE_HOST:arm = "[^-]*-[^-]*-eabi"

EXTRA_OECONF:append:xilinx-standalone = " \
	--enable-newlib-io-c99-formats \
	--enable-newlib-io-long-long \
	--enable-newlib-io-float \
	--enable-newlib-io-long-double \
"
