`timescale 1ns/10ps

module fpu_tb;
    reg         clk;
    reg         rst_n;
    reg         enabled;
    
    reg         instr_flw;
    reg         instr_fsw;
    reg         instr_fadd;
    reg         instr_fdiv;
    reg         instr_fmul;
    
    reg  [31:0] reg_rs1;
    reg  [31:0] reg_rs2;
    reg  [4:0]  rd_addr;
    reg  [31:0] freg_rs1;
    reg  [31:0] freg_rs2;
    reg  [4:0]  frd_addr;
    reg  [31:0] imm;
    
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg  [31:0] mem_rdata;
    wire        mem_we;
    wire        mem_re;
    reg         mem_ready;
    
    wire        freg_wb_enable;
    wire [4:0]  freg_wb_addr;
    wire [31:0] freg_wb_data;
    wire        reg_wb_enable;
    wire [4:0]  reg_wb_addr;
    wire [31:0] reg_wb_data;
    
    wire        completed;
    wire        fpu_busy;
    
    // memory for test fpu
    reg  [31:0] memory[0:4095];

    // counter
    integer pass_count = 0;
    integer fail_count = 0;

    fpu_0 uut (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(enabled),

        .instr_flw(instr_flw),
        .instr_fsw(instr_fsw),
        .instr_fadd(instr_fadd),
        .instr_fdiv(instr_fdiv),
        .instr_fmul(instr_fmul),

        .reg_rs1(reg_rs1),
        .reg_rs2(reg_rs2),
        .rd_addr(rd_addr),
        .freg_rs1(freg_rs1),
        .freg_rs2(freg_rs2),
        .frd_addr(frd_addr),
        .imm(imm),

        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .mem_we(mem_we),
        .mem_re(mem_re),
        .mem_ready(mem_ready),

        .freg_wb_enable(freg_wb_enable),
        .freg_wb_addr(freg_wb_addr),
        .freg_wb_data(freg_wb_data),
        .reg_wb_enable(reg_wb_enable),
        .reg_wb_addr(reg_wb_addr),
        .reg_wb_data(reg_wb_data),

        .completed(completed),
        .fpu_busy(fpu_busy)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n) begin
            mem_ready <= 1'b0;
            mem_rdata <= 32'd0;
        end else begin
            if (mem_re) begin
               mem_rdata <= memory[mem_addr[13:2]];
               mem_ready <= 1'b1; 
            end else if (mem_we) begin
               memory[mem_addr[13:2]] <= mem_wdata;
               mem_ready <= 1'b1; 
            end else begin
               mem_ready <= 1'b0;
            end
        end
    end

    task reset_system;
        begin
           rst_n   = 1'b0;
           enabled = 1'b0;
           clear_instructions();
           #20;
           rst_n   = 1'b1;
           #10; 
        end
    endtask

    task clear_instructions;
        begin
            instr_flw  = 0;
            instr_fsw  = 0;
            instr_fadd = 0;
            instr_fmul = 0;
            instr_fdiv = 0;
        end
    endtask

    task test_flw(
        input [31:0]  base_addr,
        input [31:0]  offset,
        input [31:0]  expected_data,
        input [4:0]   target_reg,
        input [127:0] test_name
    );
        begin
            $display("\n=== Testing FLW: %s ===", test_name);

            reg_rs1   = base_addr;
            imm       = offset;
            frd_addr  = target_reg;
            enabled   = 1'b1;
            instr_flw = 1'b1;

            @(posedge clk);
            clear_instructions();
            enabled = 0;

            while (!completed) 
                @(posedge clk);

            @(posedge clk);
            if (freg_wb_enable && 
                (freg_wb_addr ==  target_reg) && 
                (freg_wb_data ===  expected_data)
            ) begin
                $display("✓ PASS: freg[%d] = 0x%h", freg_wb_addr, freg_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected freg[%d] = 0x%h, Got freg[%d] = 0x%h", 
                    target_reg, expected_data, freg_wb_addr, freg_wb_data);
                fail_count = fail_count + 1;
            end
            
            @(posedge clk);
        end
    endtask

    task test_fsw(
        input [31:0]  base_addr,
        input [31:0]  offset,
        input [31:0]  store_data,
        input [127:0] test_name
    );
        begin
            $display("\n=== Testing FSW: %s ===", test_name);

            reg_rs1   = base_addr;
            freg_rs2  = store_data;
            imm       = offset;
            enabled   = 1'b1;
            instr_fsw = 1'b1;

            @(posedge clk);
            clear_instructions();
            enabled = 0;

            while (!completed) 
                @(posedge clk);

            @(posedge clk);
            @(posedge clk);

            check_addr = (base_addr + offset);
            if (memory[check_addr[13:2]] === store_data) begin
                $display("✓ PASS: Memory[0x%h] = 0x%h", check_addr, memory[check_addr[13:2]]);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected Memory[0x%h] = 0x%h, Got 0x%h", 
                         check_addr, store_data, memory[check_addr[13:2]]);
                fail_count = fail_count + 1;
            end
            @(posedge clk);
        end
        .-
        
    endtask

    task test_fadd(
        input [31:0]  op1,
        input [31:0]  op2,
        input [31:0]  expected_result,
        input [4:0]   target_reg,
        input [127:0] test_name
    );
        begin
            else begin
                $display("✗ FAIL: Expected Memory[0x%h] = 0x%h, Got 0x%h", 
                         check_addr, store_data, memory[check_addr[13:2]]);
                fail_count = fail_count + 1;
            end
        end
    endtask
endmodule