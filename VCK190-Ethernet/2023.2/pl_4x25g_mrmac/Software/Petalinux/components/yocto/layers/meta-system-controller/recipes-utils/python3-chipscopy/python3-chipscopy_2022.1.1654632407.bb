SUMMARY = "Recipe to add 2022.1 ChipScopy Python Package"
LICENSE = "Apache-2.0 & EPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e044f1626fcb471118a71a253d550cb1 \
                    file://epl-v20.html;md5=84283fa8859daf213bdda5a9f8d1be1d \
"

inherit  python3-dir

SRC_URI = "https://files.pythonhosted.org/packages/85/99/3a5cf9f45ca1d4f4e9efad620240f50b53755d6cba5cd9bf754301fccf7a/chipscopy-2022.1.1654632407-py3-none-any.whl;downloadfilename=chipscopy-2022.1.1648747406-py3-none-any.zip;subdir=${BP}"


SRC_URI[md5sum] = "2aa741076d66dba27e4f23ba0923376b"
SRC_URI[sha256sum] = "da205edb7c915d7d76fcb6347f96fd78876bcf5ddd0dae9c18ae71a38ad852b2"

PN = "python3-chipscopy"

RDEPENDS:${PN} += " \
        ${PYTHON_PN}-click \
        ${PYTHON_PN}-importlib-metadata \
        ${PYTHON_PN}-loguru \
        ${PYTHON_PN}-more-itertools \
        ${PYTHON_PN}-rich \
        ${PYTHON_PN}-typing-extensions \
        ${PYTHON_PN}-pprint \
        ${PYTHON_PN}-json \
        ${PYTHON_PN}-matplotlib \
        ${PYTHON_PN}-plotly \
        ${PYTHON_PN}-regex \
        ${PYTHON_PN}-pandas \
        "

DEPENDS += " \
	python3-wheel-native \
	python3-pip-native \
"

FILES:${PN} += "\
    ${libdir}/${PYTHON_DIR}/site-packages/* \
"

do_install() {
    install -d ${D}${libdir}/${PYTHON_DIR}/site-packages/chipscopy-2022.1.1654632407.dist-info
    install -d ${D}${libdir}/${PYTHON_DIR}/site-packages/chipscopy

    cp -r ${S}/chipscopy/* ${D}${libdir}/${PYTHON_DIR}/site-packages/chipscopy/
    cp -r ${S}/chipscopy-2022.1.1654632407.dist-info/* ${D}${libdir}/${PYTHON_DIR}/site-packages/chipscopy-2022.1.1654632407.dist-info/
}
