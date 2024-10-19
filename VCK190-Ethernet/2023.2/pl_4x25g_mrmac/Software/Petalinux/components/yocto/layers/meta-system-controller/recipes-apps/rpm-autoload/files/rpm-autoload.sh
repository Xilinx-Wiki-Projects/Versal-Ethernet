#!/bin/sh

dev_eeprom=$(find /sys/bus/i2c/devices/*54/ -name eeprom | head -1)
board=$(ipmi-fru --fru-file=${dev_eeprom} --interpret-oem-data | awk -F": " '/^  *FRU Board Product*/ { print tolower ($2) }')
revision=$(ipmi-fru --fru-file=${dev_eeprom} --interpret-oem-data | awk -F": " '/^  *FRU Board Custom*/ { print tolower ($2); exit }')
revision_ps=$(echo $revision | cut -b 1 | tr '[:lower:]' '[:upper:]')

echo "BOARD:$board REVISION:$revision"

base_path="/lib/firmware/xilinx/${board}-${revision}*/"
dtbo_file="${board}-${revision}*.dtbo"
psdtbo_file="zynqmp-sc-$board-rev$revision_ps.dtbo"
bit_file="${board}-${revision}*.bit.bin"

if [ -d "/rpm-files" ]; then
        partition_path="/rpm-files"
elif [ -d "/mnt/sd-mmcblk0p2/" ]; then
        partition_path="/mnt/sd-mmcblk0p2/"
fi


if [ -d ${base_path} ]  && [ -f ${base_path}/$dtbo_file ] && [ -f ${base_path}/$bit_file ] && [ -f ${base_path}/$psdtbo_file ]; then
        echo "RPM Already installed at ${base_path}"
else
        if [ -f ${partition_path}/${board}-${revision}*.rpm ]; then
                echo "Installing RPM for ${board}-${revision}"
                /usr/bin/rpm -U --ignorearch ${partition_path}/${board}-${revision}*.rpm
        else
                echo "Board: ${board}-${revision} Specific RPM not found in ${partition_path}"
        fi
fi

if [ -f ${base_path}/$dtbo_file ] && [ -f ${base_path}/$bit_file ] && [ -f ${base_path}/$psdtbo_file ]; then
        echo "Applying $bit_file and $dtbo_file"
	fpgautil -b ${base_path}/$bit_file -o ${base_path}/$dtbo_file -f Full -n Full
	echo "Applying $psdtbo_file"
	fpgautil -o ${base_path}/$psdtbo_file -n psdtbo
else
        echo "RPM did not install properly, please check ${base_path}"
fi
