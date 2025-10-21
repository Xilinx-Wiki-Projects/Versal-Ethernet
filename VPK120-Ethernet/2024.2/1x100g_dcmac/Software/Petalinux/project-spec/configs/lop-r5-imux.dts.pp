# 0 "/proj/gsd/petalinux/2024.2/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-r5-imux.dts"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/proj/gsd/petalinux/2024.2/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-r5-imux.dts"
# 10 "/proj/gsd/petalinux/2024.2/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-r5-imux.dts"
/dts-v1/;

/ {
        compatible = "system-device-tree-v1,lop";
        lops {
                compatible = "system-device-tree-v1,lop";
                lop_0 {
                        compatible = "system-device-tree-v1,lop,assist-v1";
                        node = "/axi/imux";
                        id = "imux,imux-v1";
                        noexec;
                };
                lop_1 {
                      compatible = "system-device-tree-v1,lop,select-v1";

                      select_1;
                      select_2 = "/.*:interrupt-parent:&imux";
                };
                lop_2 {
                      compatible = "system-device-tree-v1,lop,modify";

                      modify = ":interrupt-parent:&gic_r5";
                };
                lop_3 {
                        compatible = "system-device-tree-v1,lop,modify";

                        modify = "/axi/interrupt-multiplex::";
                };
        };
};
