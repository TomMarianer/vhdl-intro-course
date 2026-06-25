ghdl -a <entity>.vhd
ghdl -a <testbecnh_entity>.vhd
ghdl -m <testbecnh_entity>
ghdl -r --stop-time=2us --wave=<testbench_entity>.ghw
gtkwave