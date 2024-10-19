# Override fancontrol configuration file, making this SC specific
SRC_URI:append = " file://0001-Restart-the-fancontrol-service-on-failure.patch"
FILESEXTRAPATHS:append := "${THISDIR}/lmsensors:"

PACKAGE_ARCH = "${MACHINE_ARCH}"
SYSTEMD_AUTO_ENABLE = "enable"
