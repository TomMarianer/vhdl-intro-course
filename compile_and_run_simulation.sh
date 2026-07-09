ghdl -a <entity>.vhd
ghdl -a <testbecnh_entity>.vhd
ghdl -m <testbecnh_entity>
ghdl -r <testbecnh_entity> --stop-time=2us --wave=<testbench_entity>.ghw
gtkwave