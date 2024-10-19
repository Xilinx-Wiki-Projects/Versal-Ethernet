require xen-xilinx.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://example-passnet.cfg \
    file://example-pvnet.cfg \
    file://example-simple.cfg \
    file://passthrough-example-part.dts \
    "

RDEPENDS:${PN}-efi += "bash python3"

do_compile:append() {
    dtc -I dts -O dtb ${WORKDIR}/passthrough-example-part.dts -o ${WORKDIR}/passthrough-example-part.dtb
}

do_deploy:append() {
    # Mimic older behavior for compatibility
    if [ -f ${DEPLOYDIR}/xen-${MACHINE} ]; then
        ln -s xen-${MACHINE} ${DEPLOYDIR}/xen
    fi

    if [ -f ${DEPLOYDIR}/xen-${MACHINE}.gz ]; then
        ln -s xen-${MACHINE}.gz ${DEPLOYDIR}/xen.gz
    fi

    if [ -f ${DEPLOYDIR}/xen-${MACHINE}.efi ]; then
        ln -s xen-${MACHINE}.efi ${DEPLOYDIR}/xen.efi
    fi
}

do_install:append() {
    install -d -m 0755 ${D}${sysconfdir}/xen
    install -m 0644 ${WORKDIR}/example-passnet.cfg ${D}${sysconfdir}/xen/example-passnet.cfg
    install -m 0644 ${WORKDIR}/example-pvnet.cfg ${D}${sysconfdir}/xen/example-pvnet.cfg
    install -m 0644 ${WORKDIR}/example-simple.cfg ${D}${sysconfdir}/xen/example-simple.cfg
    install -m 0644 ${WORKDIR}/passthrough-example-part.dtb ${D}${sysconfdir}/xen/passthrough-example-part.dtb
}

FILES:${PN} += " \
    ${sysconfdir}/xen/example-passnet.cfg \
    ${sysconfdir}/xen/example-pvnet.cfg \
    ${sysconfdir}/xen/example-simple.cfg \
    ${sysconfdir}/xen/passthrough-example-part.dtb \
    "
