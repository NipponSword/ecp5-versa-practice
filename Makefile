# ECP5-5G Versa 用ビルド（OSS CAD Suite）
# 使い方: make LESSON=sw prog   → boards/versa5g/top_sw.v を使う

LESSON ?= blink
TOP    = top
SRCS   = boards/versa5g/top_$(LESSON).v $(wildcard boards/versa5g/ip/*.v) $(wildcard hdl/*.v)
LPF    = boards/versa5g/constraints/versa5g.lpf
BUILD  = build/$(LESSON)

all: $(BUILD)/$(TOP).bit

$(BUILD)/$(TOP).json: $(SRCS)
	mkdir -p $(BUILD)
	yosys -q -p "synth_ecp5 -top $(TOP) -json $@" $(SRCS)

$(BUILD)/$(TOP).config: $(BUILD)/$(TOP).json $(LPF)
	nextpnr-ecp5 --um5g-45k --package CABGA381 --speed 8 \
	    --json $< --lpf $(LPF) --textcfg $@

$(BUILD)/$(TOP).bit: $(BUILD)/$(TOP).config
	ecppack $< $@

prog: $(BUILD)/$(TOP).bit
	openFPGALoader -c ft2232 $<

clean:
	rm -rf build

.PHONY: all prog clean