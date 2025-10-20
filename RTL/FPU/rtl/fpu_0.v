`timescale 1ns/10ps

module fpu #(
    parameter NONE           = 5'd0,
    parameter FLW_MEM_ACCESS = 5'd1,
    parameter FLW_WAIT_READY = 5'd2,
    parameter FLW_WAIT_DATA  = 5'd3,
    parameter FLW_STABILIZE  = 5'd4,
    parameter FLW_SAMPLE     = 5'd5,
    parameter FLW_COMPLETE   = 5'd6,
    parameter FSW_MEM_ACCESS = 5'd7,
    parameter FSW_WAIT_READY = 5'd8,
    parameter FSW_COMPLETE   = 5'd9,
    parameter FADD_START     = 5'd10,
    parameter FADD_WAIT      = 5'd11,
    parameter FADD_COMPLETE  = 5'd12,
    parameter FMUL_START     = 5'd13,
    parameter FMUL_COMPLETE  = 5'd14,
    // --- NEW STATES FOR FSUB ---
    parameter FSUB_START     = 5'd15,
    parameter FSUB_WAIT      = 5'd16,
    parameter FSUB_COMPLETE  = 5'd17
) (
    clk, 
    rst_n, 
    enabled,
    
    instr_flw, 
    instr_fsw, 
    instr_fadd, 
    instr_fsub, 
    instr_fmul, 
    instr_fdiv,
    
    reg_rs1, 
    reg_rs2, 
    rd_addr, 
    
    freg_rs1, 
    freg_rs2, 
    frd_addr, 
    imm,
    
    mem_addr, 
    mem_wdata, 
    mem_rdata, 
    mem_we, 
    mem_re, 
    mem_ready,

    freg_wb_enable, 
    freg_wb_addr, 
    freg_wb_data, 
    reg_wb_enable, 
    reg_wb_addr, 
    reg_wb_data,
    
    completed, 
    fpu_busy
);
    // Port declarations
    input              clk;
    input              rst_n;
    input              enabled;

    input              instr_flw;
    input              instr_fsw;
    input              instr_fadd;
    input              instr_fsub;
    input              instr_fmul;
    input              instr_fdiv;

    input  [31:0]      reg_rs1;
    input  [31:0]      reg_rs2;
    input  [4:0]       rd_addr;

    input  [31:0]      freg_rs1;
    input  [31:0]      freg_rs2;
    input  [4:0]       frd_addr;
    input  [31:0]      imm;

    output reg [31:0]  mem_addr;
    output reg [31:0]  mem_wdata;
    input  [31:0]      mem_rdata;
    output reg         mem_we;
    output reg         mem_re;
    input              mem_ready;

    output wire        freg_wb_enable;
    output wire [4:0]  freg_wb_addr;
    output wire [31:0] freg_wb_data;

    output reg         reg_wb_enable;
    output reg [4:0]   reg_wb_addr;
    output reg [31:0]  reg_wb_data;

    output reg         completed;
    output reg         fpu_busy;
    
    // 狀態暫存器
    reg [4:0] state, next_state;
    reg [4:0] target_frd;
    reg [31:0] temp_mem_addr, temp_mem_wdata, temp_freg_rs1, temp_freg_rs2;

    // --- FADD Unit ---
    reg         fadd_start;
    wire        fadd_enable_out;
    wire [31:0] fadd_result;
    wire        fadd_ovf;
    fadd_s uut_fadd(
        .x1(temp_freg_rs1),
        .x2(temp_freg_rs2),
        .clk(clk),
        .rst_n(rst_n),
        .enable_in(fadd_start),
        .enable_out(fadd_enable_out),
        .y(fadd_result),
        .ovf(fadd_ovf)
    );

    // --- FSUB Unit ---
    reg         fsub_start;
    wire        fsub_enable_out;
    wire [31:0] fsub_result;
    wire        fsub_ovf;
    fsub uut_fsub(
        .x1(temp_freg_rs1),
        .x2(temp_freg_rs2),
        .clk(clk),
        .rstn(rst_n),
        .enable_in(fsub_start),
        .enable_out(fsub_enable_out),
        .y(fsub_result),
        .ovf(fsub_ovf)
    );

    // --- FMUL Unit ---
    wire [31:0] fmul_result;
    wire        fmul_ovf;
    fmul uut_fmul(
        .x1(temp_freg_rs1),
        .x2(temp_freg_rs2),
        .y(fmul_result),
        .ovf(fmul_ovf)
    );

    // Next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            NONE: begin
                if (enabled) begin
                    if (instr_flw)      next_state = FLW_MEM_ACCESS;
                    else if (instr_fsw) next_state = FSW_MEM_ACCESS;
                    else if (instr_fadd)next_state = FADD_START;
                    else if (instr_fsub)next_state = FSUB_START;
                    else if (instr_fmul)next_state = FMUL_START;
                end
            end
            FLW_MEM_ACCESS: next_state = FLW_WAIT_READY;
            FLW_WAIT_READY: if (mem_ready) next_state = FLW_WAIT_DATA;
            FLW_WAIT_DATA:  next_state = FLW_STABILIZE;
            FLW_STABILIZE:  next_state = FLW_SAMPLE;
            FLW_SAMPLE:     next_state = FLW_COMPLETE;
            FLW_COMPLETE:   next_state = NONE;
            FSW_MEM_ACCESS: next_state = FSW_WAIT_READY;
            FSW_WAIT_READY: if (mem_ready) next_state = FSW_COMPLETE;
            FSW_COMPLETE:   next_state = NONE;
            FADD_START:     next_state = FADD_WAIT;
            FADD_WAIT:      if (fadd_enable_out) next_state = FADD_COMPLETE;
            FADD_COMPLETE:  next_state = NONE;
            FSUB_START:     next_state = FSUB_WAIT;
            FSUB_WAIT:      if (fsub_enable_out) next_state = FSUB_COMPLETE;
            FSUB_COMPLETE:  next_state = NONE;
            FMUL_START:     next_state = FMUL_COMPLETE;
            FMUL_COMPLETE:  next_state = NONE;
            default:        next_state = NONE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= NONE;
        else        state <= next_state;
    end

    // Write-back signals
    reg        temp_freg_wb_enable;
    reg [4:0]  temp_freg_wb_addr;
    reg [31:0] temp_freg_wb_data;
    assign freg_wb_enable = temp_freg_wb_enable;
    assign freg_wb_addr   = temp_freg_wb_addr;
    assign freg_wb_data   = temp_freg_wb_data;

    // FPU busy flag
    always @(*) fpu_busy = (state != NONE);

    // Sequential output and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {mem_addr, mem_wdata, reg_wb_data, temp_mem_addr, temp_mem_wdata, temp_freg_rs1, temp_freg_rs2, temp_freg_wb_data} <= 256'b0;
            {mem_we, mem_re, completed, reg_wb_enable, fadd_start, fsub_start, temp_freg_wb_enable} <= 7'b0;
            {reg_wb_addr, target_frd, temp_freg_wb_addr} <= 15'b0;
        end else begin
            completed           <= 1'b0;
            mem_we              <= 1'b0;
            mem_re              <= 1'b0;
            temp_freg_wb_enable <= 1'b0;
            fadd_start          <= 1'b0;
            fsub_start          <= 1'b0;
            reg_wb_enable       <= 1'b0;

            // 暫存輸入
            if (state == NONE && enabled) begin
                if (instr_fadd || instr_fsub || instr_fmul) begin
                    temp_freg_rs1 <= freg_rs1;
                    temp_freg_rs2 <= freg_rs2;
                    target_frd    <= frd_addr;
                end else if (instr_flw) begin
                    temp_mem_addr <= reg_rs1 + imm;
                    target_frd    <= frd_addr;
                end else if (instr_fsw) begin
                    temp_mem_addr  <= reg_rs1 + imm;
                    temp_mem_wdata <= freg_rs2;
                end
            end

            // 狀態對應輸出
            case (state)
                FLW_MEM_ACCESS: {mem_re, mem_addr} <= {1'b1, temp_mem_addr};
                FLW_SAMPLE:     {temp_freg_wb_addr, temp_freg_wb_data} <= {target_frd, mem_rdata};
                FLW_COMPLETE:   {temp_freg_wb_enable, completed} <= 2'b11;
                FSW_MEM_ACCESS: {mem_we, mem_addr, mem_wdata} <= {1'b1, temp_mem_addr, temp_mem_wdata};
                FSW_COMPLETE:   completed <= 1'b1;
                FADD_START:     fadd_start <= 1'b1;
                FADD_WAIT:      if (fadd_enable_out) {temp_freg_wb_addr, temp_freg_wb_data} <= {target_frd, fadd_result};
                FADD_COMPLETE:  {temp_freg_wb_enable, completed} <= 2'b11;
                FSUB_START:     fsub_start <= 1'b1;
                FSUB_WAIT:      if (fsub_enable_out) {temp_freg_wb_addr, temp_freg_wb_data} <= {target_frd, fsub_result};
                FSUB_COMPLETE:  {temp_freg_wb_enable, completed} <= 2'b11;
                FMUL_START:     {temp_freg_wb_addr, temp_freg_wb_data} <= {target_frd, fmul_result};
                FMUL_COMPLETE:  {temp_freg_wb_enable, completed} <= 2'b11;
            endcase
        end
    end

endmodule

