`timescale 1ns/10ps

module fpu #(
    parameter NONE           = 4'd0,
    parameter FLW_MEM_ACCESS = 4'd1,
    parameter FLW_WAIT_READY = 4'd2,
    parameter FLW_WAIT_DATA  = 4'd3,
    parameter FLW_STABILIZE  = 4'd4,
    parameter FLW_SAMPLE     = 4'd5,
    parameter FLW_COMPLETE   = 4'd6,
    parameter FSW_MEM_ACCESS = 4'd7,
    parameter FSW_WAIT_READY = 4'd8,
    parameter FSW_COMPLETE   = 4'd9,
    parameter FADD_START     = 4'd10,
    parameter FADD_WAIT      = 4'd11,
    parameter FADD_COMPLETE  = 4'd12
) (
    clk,
    rst_n,
    enabled,

    // instr
    instr_flw,
    instr_fsw,
    instr_fadd,
    instr_fmul,
    instr_fdiv,

    // reg
    reg_rs1,
    reg_rs2,
    rd_addr,
    freg_rs1,
    freg_rs2,
    frd_addr,
    imm,

    // memory
    mem_addr,
    mem_wdata,
    mem_rdata,
    mem_we,
    mem_re,
    mem_ready,

    // WB
    freg_wb_enable,
    freg_wb_addr,
    freg_wb_data,
    reg_wb_enable,
    reg_wb_addr,
    reg_wb_data,

    // result
    completed,
    fpu_busy
);
    
// declare
    input              clk;
    input              rst_n;
    input              enabled;

    // instr
    input              instr_flw;
    input              instr_fsw;
    input              instr_fadd;
    input              instr_fmul;
    input              instr_fdiv;

    // reg
    input [31:0]       reg_rs1;
    input [31:0]       reg_rs2;
    input [4:0]        rd_addr;
    input [31:0]       freg_rs1;
    input [31:0]       freg_rs2;
    input [4:0]        frd_addr;
    input [31:0]       imm;

    // memory
    output reg [31:0]  mem_addr;
    output reg [31:0]  mem_wdata;
    input      [31:0]  mem_rdata;
    output reg         mem_we;
    output reg         mem_re;
    input              mem_ready;

    // WB
    output wire        freg_wb_enable;
    output wire [4:0]  freg_wb_addr;
    output wire [31:0] freg_wb_data;
    output reg         reg_wb_enable;
    output reg [4:0]   reg_wb_addr;
    output reg [31:0]  reg_wb_data;

    // result
    output reg         completed;
    output reg         fpu_busy;

// state machine
    reg [3:0]  state;
    reg [3:0]  next_state;
    
    // temp
    reg [4:0]  target_frd;
    reg [31:0] temp_mem_addr;
    reg [31:0] temp_mem_wdata;
    reg [31:0] temp_freg_rs1;
    reg [31:0] temp_freg_rs2;
    
    // -----------
    // FADD
    // -----------
    reg         fadd_start;
    wire        fadd_enable_out;
    wire [31:0] fadd_result;
    wire        fadd_ovf;

    fadd_s uut_fadd(
        .x1         (temp_freg_rs1),
        .x2         (temp_freg_rs2),

        .clk        (clk),
        .rst_n      (rst_n),

        .enable_in  (fadd_start),
        .enable_out (fadd_enable_out),

        .y          (fadd_result),
        .ovf        (fadd_ovf)
    );

    // next state logic
    always @(*) begin
        next_state = state;

        case (state)
            NONE: begin
                if (enabled) begin
                    if (instr_flw) begin
                        next_state = FLW_MEM_ACCESS;
                    end else if (instr_fsw) begin
                        next_state = FSW_MEM_ACCESS;
                    end else if (instr_fadd) begin
                        next_state = FADD_START;
                    end
                end
            end 

            // FLW
            FLW_MEM_ACCESS: next_state = FLW_WAIT_READY;
            FLW_WAIT_READY: begin
                if (mem_ready) begin
                    next_state = FLW_WAIT_DATA;
                end
            end
            FLW_WAIT_DATA: next_state = FLW_STABILIZE;
            FLW_STABILIZE: next_state = FLW_SAMPLE;
            FLW_SAMPLE:    next_state = FLW_COMPLETE;
            FLW_COMPLETE:  next_state = NONE;
            
            // FSW
            FSW_MEM_ACCESS: next_state = FSW_WAIT_READY;
            FSW_WAIT_READY: begin
                if (mem_ready) begin
                    next_state = FSW_COMPLETE;
                end
            end
            FSW_COMPLETE:   next_state = NONE;

            // FADD
            FADD_START:     next_state = FADD_WAIT;
            FADD_WAIT: begin
                if (fadd_enable_out) begin
                    next_state = FADD_COMPLETE;
                end
            end
            FADD_COMPLETE: next_state = NONE;

            default: next_state = NONE;
        endcase
    end

    // state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= NONE;
        end else begin
            state <= next_state;
        end
    end

    // output 
    reg        temp_freg_wb_enable;
    reg [4:0]  temp_freg_wb_addr;
    reg [31:0] temp_freg_wb_data;

    assign freg_wb_enable = temp_freg_wb_enable;
    assign freg_wb_addr   = temp_freg_wb_addr;
    assign freg_wb_data   = temp_freg_wb_data;

    always @(*) begin
        fpu_busy = (state!=NONE);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_addr            <= 32'd0;
            mem_wdata           <= 32'd0;
            mem_we              <= 1'b0;
            mem_re              <= 1'b0;
            completed           <= 1'b0;
            reg_wb_enable       <= 1'b0;
            reg_wb_addr         <= 5'd0;
            reg_wb_data         <= 32'd0;
            target_frd          <= 5'd0;
            temp_mem_addr       <= 32'd0;
            temp_mem_wdata      <= 32'd0;
            temp_freg_rs1       <= 32'd0;
            temp_freg_rs2       <= 32'd0;
            fadd_start          <= 1'b0;
            temp_freg_wb_enable <= 1'b0;
            temp_freg_wb_addr   <= 5'd0;
            temp_freg_wb_data   <= 32'd0;
        end else begin
            completed           <= 1'b0;
            mem_we              <= 1'b0;
            mem_re              <= 1'b0;
            temp_freg_wb_enable <= 1'b0;
            fadd_start          <= 1'b0;
            reg_wb_enable       <= 1'b0;

            case (next_state)
                FLW_MEM_ACCESS: begin
                    temp_mem_addr  <= reg_rs1 + imm;
                    target_frd     <= frd_addr;
                end 
                FSW_MEM_ACCESS: begin
                    temp_mem_addr  <= reg_rs1 + imm;
                    temp_mem_wdata <= freg_rs2;
                end
                FADD_START: begin
                    temp_freg_rs1  <= freg_rs1;
                    temp_freg_rs2  <= freg_rs2;
                    target_frd     <= frd_addr;
                end     
            endcase

            case (state)
                // FLW
                FLW_MEM_ACCESS: begin
                    mem_re   <= 1'b1;
                    mem_addr <= temp_mem_addr;
                end 
                FLW_SAMPLE: begin
                    temp_freg_wb_addr <= target_frd;
                    temp_freg_wb_data <= mem_rdata;
                end
                FLW_COMPLETE: begin
                    temp_freg_wb_enable <= 1'b1;
                    completed           <= 1'b1;
                end 

                // FSW
                FSW_MEM_ACCESS: begin
                    mem_we    <= 1'b1;
                    mem_addr  <= temp_mem_addr;
                    mem_wdata <= temp_mem_wdata;
                end
                FSW_COMPLETE: begin
                    completed <= 1'b1;
                end
    
                // FADD
                FADD_START: begin
                    fadd_start <= 1'b1;
                end
                FADD_WAIT: begin
                    if (fadd_enable_out) begin
                        temp_freg_wb_addr <= target_frd;
                        temp_freg_wb_data <= fadd_result;
                    end
                end
                FADD_COMPLETE: begin
                    temp_freg_wb_enable <= 1'b1;
                    completed           <= 1'b1;
                end 
            endcase
        end 
    end
endmodule
