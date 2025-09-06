# target
TESTS = run_sim

VERILOG_SOURCES = adder.v adder_tb.v
SIM_EXE = run_sim

$(SIM_EXE): $(VERILOG_SOURCES)
	@echo "Compiling Verilog with iverilog..."
	$(IVERILOG) -o $(SIM_EXE) $(VERILOG_SOURCES)
	@echo "Running simulation with $(VVP)..."
	$(VVP) $(SIM_EXE)

.PHONY: clean
clean:
	rm -f $(SIM_EXE) tb.vcd
