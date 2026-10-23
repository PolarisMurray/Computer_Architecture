filename = top
pcf_file = iceBlinkPico.pcf

build:
	yosys -p "synth_ice40 -top top -json $(filename).json" $(filename).sv
	nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
	icepack $(filename).asc $(filename).bin

sim:
	iverilog -g2012 -o gameOfLife_tb gameOfLife_tb.sv
	vvp gameOfLife_tb

prog:
	dfu-util --device 1d50:6146 --alt 0 -D $(filename).bin -R

clean:
	rm -rf $(filename).asc $(filename).json $(filename).bin gameOfLife_tb gameOfLife.vcd
