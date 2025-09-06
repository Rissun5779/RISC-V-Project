BUILD_DIR = ./build
SIM_EXE = $(BUILD_DIR)/SIM
VERILOG_DIR = ./rtl
VERILOG_SOURCES = $(VERILOG_DIR)/adder.v $(VERILOG_DIR)/adder_tb.v

all: $(SIM_EXE)

$(SIM_EXE): $(VERILOG_SOURCES) | $(BUILD_DIR)
	iverilog -o $(SIM_EXE) $(VERILOG_SOURCES)
	vvp $(SIM_EXE)

clean:
	rm -f $(SIM_EXE) tb.vcd
