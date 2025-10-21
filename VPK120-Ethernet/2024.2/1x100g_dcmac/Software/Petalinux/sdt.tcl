set xsa [lindex $argv 0]
set outdir [lindex $argv 1]
exec rm -rf $outdir
sdtgen set_dt_param -xsa $xsa -dir $outdir -board_dts versal-vpk120-reva
sdtgen generate_sdt
