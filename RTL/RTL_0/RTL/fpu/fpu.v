`timescale 1ns / 1ps

module fpu (
    input               clk,
    input               rst_n,
    input               enabled,

    // Instr
    input               instr_flw,
    input               instr_fsw,
    input               instr_fadd,
    input               instr_fdiv,
    input               instr_fmul,
    
    input [31:0]        reg_rs1,
    input [31:0]        reg_rs2,
    input [31:0]        freg_rs1,
    input [31:0]        freg_rs2,
    input [31:0]        imm,

    // Memory interface
    output reg [31:0]   mem_addr,
    output     [31:0]   mem_wdata,
    input      [31:0]   mem_rdata,
    output reg          mem_we,
    output reg          mem_re,
    input               mem_ready,

    output reg          completed,
    output reg [31:0]   result
);

    // State Machine
    parameter S_IDLE              = 4'd0;
    parameter S_FLW_MEM_ACCESS    = 4'd1;
    parameter S_FLW_WAIT_READY    = 4'd2;
    parameter S_FLW_SAMPLE        = 4'd3;
    parameter S_FLW_COMPLETE      = 4'd4;
    parameter S_FSW_MEM_ACCESS    = 4'd5;
    parameter S_FSW_COMPLETE      = 4'd6;
    parameter S_FADD_START        = 4'd7;
    parameter S_FADD_WAIT         = 4'd8;
    parameter S_FADD_COMPLETE     = 4'd9;

    reg [3:0] state;

    // --- Internal Signals for FPU Operations ---
    wire                fadd_enable_in;
    wire                fadd_enable_out;
    wire [31:0]         fadd_result;
    wire                fadd_ovf;

    // Instantiate floating-point adder
    fadd_s fadd_inst (
        .x1         (freg_rs1),
        .x2         (freg_rs2),
        .clk        (clk),
        .rst_n      (rst_n),
        .enable_in  (fadd_enable_in),
        .enable_out (fadd_enable_out),
        .y          (fadd_result),
        .ovf        (fadd_ovf)
    );

    // Default assignments
    assign mem_wdata = freg_rs1;
    assign fadd_enable_in = (state == S_FADD_START);

    // --- Main State Machine ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= S_IDLE;
            mem_addr    <= 32'd0;
            mem_we      <= 1'b0;
            mem_re      <= 1'b0;
            completed   <= 1'b0;
            result      <= 32'd0;
        end else begin
            // Default outputs to avoid latches
            completed   <= 1'b0;
            mem_we      <= 1'b0;
            mem_re      <= 1'b0;

            case (state)
                // Idle: wait for instruction
                S_IDLE: begin
                    if (enabled) begin
                        if (instr_flw) begin
                            mem_addr <= reg_rs1 + imm;
                            state    <= S_FLW_MEM_ACCESS;
                        end else if (instr_fsw) begin
                            mem_addr <= reg_rs1 + imm;
                            state    <= S_FSW_MEM_ACCESS;
                        end else if (instr_fadd) begin
                            state    <= S_FADD_START;
                        end
                    end
                end

                // FLW: Request memory read
                S_FLW_MEM_ACCESS: begin
                    mem_re <= 1'b1;  // Assert read enable
                    if (mem_ready) begin
                        state <= S_FLW_WAIT_READY;  // Wait next cycle
                    end
                end

                // FLW: Wait one cycle to ensure mem_rdata is stable
                S_FLW_WAIT_READY: begin
                    state <= S_FLW_SAMPLE;
                end

                // FLW: Sample the data (now stable)
                S_FLW_SAMPLE: begin
                    result <= mem_rdata;
                    state  <= S_FLW_COMPLETE;
                end

                // FLW: Signal completion
                S_FLW_COMPLETE: begin
                    completed <= 1'b1;
                    state     <= S_IDLE;
                end

                // FSW: Request memory write
                S_FSW_MEM_ACCESS: begin
                    mem_we <= 1'b1;
                    if (mem_ready) begin
                        state <= S_FSW_COMPLETE;
                    end
                end

                // FSW: Signal completion
                S_FSW_COMPLETE: begin
                    completed <= 1'b1;
                    state     <= S_IDLE;
                end

                // FADD: Start computation
                S_FADD_START: begin
                    state <= S_FADD_WAIT;
                end

                // FADD: Wait for fadd_s to finish
                S_FADD_WAIT: begin
                    if (fadd_enable_out) begin
                        result <= fadd_result;
                        state  <= S_FADD_COMPLETE;
                    end
                end

                // FADD: Signal completion
                S_FADD_COMPLETE: begin
                    completed <= 1'b1;
                    state     <= S_IDLE;
                end

                // Fallback
                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule