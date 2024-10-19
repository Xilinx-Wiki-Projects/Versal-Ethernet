
  
DESCRIPTION = "Init script to load and apply the rpm package by getting \
		the information  using fru_print application"
SUMMARY = "Init script to load and apply the rpm package by getting \
		the information using fru_print application and \
		"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://rpm-autoload.sh \
	   file://rpm-autoload.service \
"

inherit update-rc.d systemd

RDEPENDS:${PN} += " \
	fpga-manager-script \
	rpm \
	freeipmi \
	python3 \
	"

INSANE_SKIP:${PN} += "installed-vs-shipped"

INITSCRIPT_NAME = "rpm-autoload.sh"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "rpm-autoload.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:zynqmp = "zynqmp"

do_install () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d/
		install -m 0755 ${WORKDIR}/rpm-autoload.sh ${D}${sysconfdir}/init.d/
	fi

	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/rpm-autoload.sh ${D}${bindir}/
	install -d ${D}${systemd_system_unitdir} 
	install -m 0644 ${WORKDIR}/rpm-autoload.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/rpm-autoload.sh', '', d)}"
