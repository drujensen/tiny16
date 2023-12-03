##
## Make and program TinyFPGA BX
##

PROJ = tiny16

RTL_USB_DIR = usb

SOURCES = \
	pll.v \
	alu.v \
	bus.v \
	clock_divider.v \
	controller.v \
	display.v \
	memory.v \
	registers.v \
	step.v

SRC = $(PROJ).v $(SOURCES)

PIN_DEF = pins.pcf

DEVICE = lp8k
PACKAGE = cm81

CLK_MHZ = 48

all: $(PROJ).bin $(PROJ).tb

pll.v:
	icepll -i 16 -o $(CLK_MHZ) -m -f $@

synth: $(PROJ).json

$(PROJ).json: $(SRC)
	yosys -p 'synth_ice40 -top $(PROJ) -json $@' $<

%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --$(DEVICE) --freq $(CLK_MHZ) --package $(PACKAGE) --pcf $(PIN_DEF) --json $*.json --asc $@

%.bin: %.asc
	icepack $< $@

%.tb: %_tb.v %.v
	iverilog -o $@ $^

prog: $(PROJ).bin
	tinyprog -p $<

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).bin $(PROJ).tb $(PROJ).vcd pll.v

.SECONDARY:
.PHONY: all prog clean synth
