require gstreamer-xilinx-1.20.5.inc

SRC_URI:append = " \
    file://0001-connect-has-a-different-signature-on-musl.patch \
"

S = "${WORKDIR}/git/subprojects/gst-devtools"
