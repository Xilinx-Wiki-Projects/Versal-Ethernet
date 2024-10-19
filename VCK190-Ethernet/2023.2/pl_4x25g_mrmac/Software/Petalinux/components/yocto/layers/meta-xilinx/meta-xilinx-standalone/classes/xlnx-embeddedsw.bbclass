# Automatically determnine the version from the bb file
ESW_VER ?= "${@bb.parse.vars_from_file(d.getVar('FILE', False),d)[1] or 'master'}"

REPO ??= "git://github.com/Xilinx/embeddedsw.git;protocol=https"

ESW_BRANCH[2023.1] = "xlnx_rel_v2023.1"
ESW_BRANCH[2023.2] = "xlnx_rel_v2023.2"
BRANCH ??= "${@d.getVarFlag('ESW_BRANCH', d.getVar('ESW_VER')) or '${ESW_VER}'}"

ESW_REV[2023.1] = "e24fe92b5517ee447e560790e798cad792f53bab"
ESW_REV[2023.2] = "c9a0ee31b2a14cbcfcb56ca369037319b4ad4847"
SRCREV ??= "${@d.getVarFlag('ESW_REV', d.getVar('ESW_VER')) or '${AUTOREV}'}"

EMBEDDEDSW_BRANCHARG ?= "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"
EMBEDDEDSW_SRCURI ?= "${REPO};${EMBEDDEDSW_BRANCHARG}"

LICENSE = "MIT"
LIC_FILES_CHKSUM[xlnx_rel_v2023.1] = '3c310a3ee2197a4c92c6a0e2937c207c'
LIC_FILES_CHKSUM[xlnx_rel_v2023.2] = '9fceecdbcad88698f265578f3d4cb26c'
LIC_FILES_CHKSUM ??= "file://license.txt;md5=${@d.getVarFlag('LIC_FILES_CHKSUM', d.getVar('BRANCH')) or '0'}"

SRC_URI = "${EMBEDDEDSW_SRCURI}"
PV .= "+git${SRCPV}"
