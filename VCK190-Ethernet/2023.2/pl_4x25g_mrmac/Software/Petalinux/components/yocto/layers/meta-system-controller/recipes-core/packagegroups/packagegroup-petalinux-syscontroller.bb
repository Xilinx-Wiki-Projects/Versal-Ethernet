DESCRIPTION = "Required packages for system controller"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

SYSTEM_CONTROLLER_PACKAGES = " \
        python3-flask \
        python3-flask-restful \
        python3-werkzeug \
        python3-jinja2 \
        python3-markupsafe \
        python3-itsdangerous \
        python3-twisted \
        python3-gevent \
        python3-matplotlib \
        packagegroup-petalinux-lmsensors \
        i2c-tools \
        libgpiod \
        libgpiod-tools \
        system-controller-app \
        python3-loguru \
        python3-rich \
        python3-chipscopy \
        "

RDEPENDS:${PN} = "${SYSTEM_CONTROLLER_PACKAGES}"

SYSTEM_CONTROLLER_PACKAGES:append:vck-sc-zynqmp = " power-advantage-tool"