require gcc-configure-xilinx-standalone.inc

COMPATIBLE_HOST = "${HOST_SYS}"

python do_multilib_install:xilinx-standalone:class-target () {
    pass
}

standalone_fixup () {
	(
		cd ${D}${libdir}
		for each in ${TARGET_SYS}/*/* ; do
			ln -s $each $(basename $each)
		done
	)

	# Apparently we can end up with an empty /lib occasionally
        find ${D}/lib -type d | sort -r | xargs rmdir || :
}

FIXUP_FUNCTION = ""
FIXUP_FUNCTION:xilinx-standalone:class-target = " standalone_fixup"

do_install[postfuncs] .= "${FIXUP_FUNCTION}"

FILES:${PN}-dev:append:xilinx-standalone:class-target = " \
	${libdir}/*.a \
	${libdir}/*.o \
"
