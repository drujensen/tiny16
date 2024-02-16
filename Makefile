##
## Make and program TinyFPGA BX
##

PROJ = tiny16

RTL_USB_DIR = usb

SOURCES = \
	alu.v \
	bus.v \
	clock_divider.v \
	controller.v \
	display.v \
	keyboard.v \
	memory.v \
	registers.v \
	step.v

SRC = $(PROJ).v $(SOURCES)

PIN_DEF = pins.pcf

DEVICE = 8k
PACKAGE = cm81

CLK_MHZ = 48

all: $(PROJ).bin $(PROJ).tb

%.blif: $(SRC)
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(DEVICE) -P $(PACKAGE) -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.tb: %_tb.v %.v
	iverilog -o $@ $^

upload: $(PROJ).bin
	tinyprog -p $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin $(PROJ).tb $(PROJ).vcd

.SECONDARY:
.PHONY: all upload clean
