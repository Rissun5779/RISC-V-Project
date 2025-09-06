`timescale 1ps/1ps

module fpu_0 #(
    parameter S_NONE           = 4'd0,
    parameter S_FLW_MEM_ACCESS = 4'd1,
    parameter S_FLW_WAIT_READY = 4'd2,
    parameter S_FLW_WAIT_DATA  = 4'd3,
    parameter S_FLW_STABILIZE  = 4'd4,
    parameter S_FLW_SAMPLE     = 4'd5,
    parameter S_FLW_COMPLETE   = 4'd6,
    parameter S_FSW_MEM_ACCESS = 4'd7,
    parameter S_FSW_WAIT_READY = 4'd8,
    parameter S_FSW_COMPLETE   = 4'd9,
    parameter S_FADD_START     = 4'd10,
    parameter S_FADD_WAIT      = 4'd11,
    parameter S_FADD_COMPLETE  = 4'd12
) (
    clk,
    rst_n,
    enabled,

    // instr
    instr_flw,
    instr_fsw,
    instr_fadd,
    instr_fdiv,
    instr_fmul,

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

    // write back
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

input clk, rst_n, enabled;
input instr_flw, instr_fsw, instr_fadd, instr_fdiv, instr_fmul;
input [31:0] reg_rs1, reg_rs2, freg_rs1, freg_rs2, imm;
input [4:0] rd_addr, frd_addr;

output reg [31:0] mem_addr, mem_wdata;
input [31:0] mem_rdata;
output reg mem_we, mem_re;
input mem_ready;

output wire freg_wb_enable;
output wire [4:0] freg_wb_addr;
output wire [31:0] freg_wb_data;
output reg reg_wb_enable;
output reg [4:0] reg_wb_addr;
output reg [31:0] reg_wb_data;

output reg completed, fpu_busy;

// 狀態機
reg [3:0] state;
reg [3:0] next_state;

// 臨時保存
reg [4:0]  target_frd;
reg [31:0] saved_mem_addr, saved_mem_wdata;
reg [31:0] saved_freg_rs1, saved_freg_rs2;

// FADD 控制
reg fadd_start;
wire fadd_enable_out;
wire [31:0] fadd_result;
wire fadd_ovf;

// 實例化浮點加法器
fadd_s fadd_s (
    .clk        (clk),
    .rst_n      (rst_n),
    .x1         (saved_freg_rs1),
    .x2         (saved_freg_rs2),
    .enable_in  (fadd_start),
    .enable_out (fadd_enable_out),
    .y          (fadd_result),
    .ovf        (fadd_ovf)
);

// fpu_busy
always @(*) fpu_busy = (state != S_NONE);

// next_state 邏輯
always @(*) begin
    next_state = state;
    case (state)
        S_NONE: begin
            if (enabled) begin
                if (instr_flw)        next_state = S_FLW_MEM_ACCESS;
                else if (instr_fsw)   next_state = S_FSW_MEM_ACCESS;
                else if (instr_fadd)  next_state = S_FADD_START;
            end
        end
        S_FLW_MEM_ACCESS: next_state = S_FLW_WAIT_READY;
        S_FLW_WAIT_READY: if (mem_ready) next_state = S_FLW_WAIT_DATA;
        S_FLW_WAIT_DATA:  next_state = S_FLW_STABILIZE;
        S_FLW_STABILIZE:  next_state = S_FLW_SAMPLE;
        S_FLW_SAMPLE:     next_state = S_FLW_COMPLETE;
        S_FLW_COMPLETE:   next_state = S_NONE;

        S_FSW_MEM_ACCESS: next_state = S_FSW_WAIT_READY;
        S_FSW_WAIT_READY: if (mem_ready) next_state = S_FSW_COMPLETE;
        S_FSW_COMPLETE:   next_state = S_NONE;

        S_FADD_START:     next_state = S_FADD_WAIT;
        S_FADD_WAIT:      if (fadd_enable_out) next_state = S_FADD_COMPLETE;
        S_FADD_COMPLETE:  next_state = S_NONE;

        default: next_state = S_NONE;
    endcase
end

// 狀態跳轉
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= S_NONE;
    else
        state <= next_state;
end

// 寫回信號註冊
reg freg_wb_enable_reg;
reg [4:0] freg_wb_addr_reg;
reg [31:0] freg_wb_data_reg;

assign freg_wb_enable = freg_wb_enable_reg;
assign freg_wb_addr   = freg_wb_addr_reg;
assign freg_wb_data   = freg_wb_data_reg;

// 主控制邏輯
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mem_addr         <= 32'd0;
        mem_wdata        <= 32'd0;
        mem_we           <= 1'b0;
        mem_re           <= 1'b0;
        completed        <= 1'b0;
        reg_wb_enable    <= 1'b0;
        reg_wb_addr      <= 5'd0;
        reg_wb_data      <= 32'd0;
        target_frd       <= 5'd0;
        saved_mem_addr   <= 32'd0;
        saved_mem_wdata  <= 32'd0;
        saved_freg_rs1   <= 32'd0;
        saved_freg_rs2   <= 32'd0;
        fadd_start       <= 1'b0;
        // 初始化寫回信號
        freg_wb_enable_reg <= 1'b0;
        freg_wb_addr_reg   <= 5'd0;
        freg_wb_data_reg   <= 32'd0;
    end else begin
        completed        <= 1'b0;
        mem_we           <= 1'b0;
        mem_re           <= 1'b0;
        reg_wb_enable    <= 1'b0;
        fadd_start       <= 1'b0;
        
        // 預設清除寫回信號，除非在特定狀態設定
        freg_wb_enable_reg <= 1'b0;

        // 在 next_state 時鎖存參數
        case (next_state)
            S_FLW_MEM_ACCESS: begin
                saved_mem_addr <= reg_rs1 + imm;
                target_frd     <= frd_addr;
            end
            S_FSW_MEM_ACCESS: begin
                saved_mem_addr <= reg_rs1 + imm;
                saved_mem_wdata<= freg_rs2;
            end
            S_FADD_START: begin
                saved_freg_rs1 <= freg_rs1;
                saved_freg_rs2 <= freg_rs2;
                target_frd     <= frd_addr;
            end
        endcase

        case (state)
            // FLW
            S_FLW_MEM_ACCESS: begin
                mem_re   <= 1'b1;
                mem_addr <= saved_mem_addr;
            end
            S_FLW_SAMPLE: begin
                // 在 SAMPLE 狀態準備寫回數據
                freg_wb_data_reg <= mem_rdata;
                freg_wb_addr_reg <= target_frd;
            end
            S_FLW_COMPLETE: begin
                // 啟用寫回
                freg_wb_enable_reg <= 1'b1;
                completed          <= 1'b1;
            end

            // FSW
            S_FSW_MEM_ACCESS: begin
                mem_we     <= 1'b1;
                mem_addr   <= saved_mem_addr;
                mem_wdata  <= saved_mem_wdata;
            end
            S_FSW_COMPLETE: begin
                completed <= 1'b1;
            end

            // FADD
            S_FADD_START: begin
                fadd_start <= 1'b1;
            end
            S_FADD_WAIT: begin
                if (fadd_enable_out) begin
                    freg_wb_data_reg <= fadd_result;
                    freg_wb_addr_reg <= target_frd;
                end
            end
            S_FADD_COMPLETE: begin
                freg_wb_enable_reg <= 1'b1;
                completed          <= 1'b1;
            end
        endcase
    end
end

endmodule