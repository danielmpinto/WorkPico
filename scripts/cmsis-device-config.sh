TESTER=E6633861A3529338
cd /pico/openocd/tcl/interface
cp cmsis-dap.cfg tester.cfg
sed -i '11i\adapter serial E6633861A3529338' tester.cfg
