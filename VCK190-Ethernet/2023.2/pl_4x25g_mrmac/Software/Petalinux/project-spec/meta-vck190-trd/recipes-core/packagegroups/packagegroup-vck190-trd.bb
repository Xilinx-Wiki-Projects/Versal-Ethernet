DESCRIPTION = "VCK190 TRD related Packages"

inherit packagegroup


VCK190_TRD_PACKAGES = " \
	testptp \
	ptp1stepcfg \
	ptp1stepp2pcfg \	
	"

RDEPENDS:${PN} = "${VCK190_TRD_PACKAGES}"
