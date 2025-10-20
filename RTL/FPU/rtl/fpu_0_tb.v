`timescale 1ps/1ps

module fpu_comprehensive_tb;
    // T-Core DE10-Lite
    // Inputs to FPU
    reg clk;
    reg rst_n;
    reg enabled;
    
    reg instr_flw;
    reg instr_fsw;
    reg instr_fadd;
    reg instr_fsub;
    reg instr_fmul;
    reg instr_fdiv;

    reg [31:0] reg_rs1, reg_rs2;
    reg [4:0]  rd_addr;
    reg [31:0] freg_rs1, freg_rs2;
    reg [4:0]  frd_addr;
    reg [31:0] imm;
    
    // Memory Interface
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg [31:0]  mem_rdata;
    wire        mem_we;
    wire        mem_re;
    reg         mem_ready;
    
    // Write-back Interface
    wire        freg_wb_enable;
    wire [4:0]  freg_wb_addr;
    wire [31:0] freg_wb_data;
    wire        reg_wb_enable;
    wire [4:0]  reg_wb_addr;
    wire [31:0] reg_wb_data;
    
    // Status Signals
    wire        completed;
    wire        fpu_busy;

    // Memory Model
    reg [31:0] memory [0:4095];
    
    // Test Statistics
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Instantiate the FPU (Unit Under Test)
    fpu uut (
        .clk(clk),
        .rst_n(rst_n),
        .enabled(enabled),
        
        .instr_flw(instr_flw),
        .instr_fsw(instr_fsw),
        .instr_fadd(instr_fadd),
        .instr_fsub(instr_fsub),
        .instr_fmul(instr_fmul),
        .instr_fdiv(instr_fdiv),
        
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

    // Clock generation
    always #5 clk = ~clk;
    
    // Simple memory model
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
    
    // Helper Tasks
    task reset_system;
        begin
            rst_n = 1'b0;
            enabled = 1'b0;
            clear_instructions();
            #20;
            rst_n = 1'b1;
            #10;
        end
    endtask
    
    task clear_instructions;
        begin
            instr_flw = 0; instr_fsw = 0;
            instr_fadd = 0; instr_fsub = 0; instr_fmul = 0; instr_fdiv = 0;
        end
    endtask
    
    task wait_cycles(input integer cycles);
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) @(posedge clk);
        end
    endtask
    
    // Test Tasks for each instruction
    task test_flw(input [31:0] base_addr, input [31:0] offset, input [31:0] expected_data, input [4:0] target_reg, input [127:0] test_name);
        begin
            $display("\n=== Testing FLW: %s ===", test_name);
            reg_rs1 = base_addr; imm = offset; frd_addr = target_reg;
            enabled = 1; instr_flw = 1;
            @(posedge clk);
            clear_instructions(); enabled = 0;
            while (!completed) @(posedge clk);
            if (freg_wb_enable && freg_wb_addr == target_reg && freg_wb_data === expected_data) begin
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
    
    task test_fsw(input [31:0] base_addr, input [31:0] offset, input [31:0] store_data, input [127:0] test_name);
        reg [31:0] check_addr;
        begin
            $display("\n=== Testing FSW: %s ===", test_name);
            reg_rs1 = base_addr; freg_rs2 = store_data; imm = offset;
            enabled = 1; instr_fsw = 1;
            @(posedge clk);
            clear_instructions(); enabled = 0;
            while (!completed) @(posedge clk);
            @(posedge clk); @(posedge clk);
            check_addr = (base_addr + offset);
            if (memory[check_addr[13:2]] === store_data) begin
                $display("✓ PASS: Memory[0x%h] = 0x%h", check_addr, memory[check_addr[13:2]]);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected Memory[0x%h] = 0x%h, Got 0x%h", 
                         check_addr, store_data, memory[check_addr[13:2]]);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    task test_fadd(input [31:0] op1, input [31:0] op2, input [31:0] expected_result, input [4:0] target_reg, input [127:0] test_name);
        begin
            $display("\n=== Testing FADD: %s ===", test_name);
            $display("FADD: 0x%h + 0x%h -> freg[%d]", op1, op2, target_reg);
            freg_rs1 = op1; freg_rs2 = op2; frd_addr = target_reg;
            enabled = 1; instr_fadd = 1;
            @(posedge clk);
            clear_instructions(); enabled = 0;
            while (!completed) @(posedge clk);
            if (freg_wb_enable && freg_wb_addr == target_reg && freg_wb_data === expected_result) begin
                $display("✓ PASS: freg[%d] = 0x%h", freg_wb_addr, freg_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected freg[%d] = 0x%h, Got freg[%d] = 0x%h", 
                         target_reg, expected_result, freg_wb_addr, freg_wb_data);
                fail_count = fail_count + 1;
            end
            @(posedge clk);
        end
    endtask

    task test_fsub(input [31:0] op1, input [31:0] op2, input [31:0] expected_result, input [4:0] target_reg, input [127:0] test_name);
        begin
            $display("\n=== Testing FSUB: %s ===", test_name);
            $display("FSUB: 0x%h - 0x%h -> freg[%d]", op1, op2, target_reg);
            freg_rs1 = op1; freg_rs2 = op2; frd_addr = target_reg;
            enabled = 1; instr_fsub = 1;
            @(posedge clk);
            clear_instructions(); enabled = 0;
            while (!completed) @(posedge clk);
            if (freg_wb_enable && freg_wb_addr == target_reg && freg_wb_data === expected_result) begin
                $display("✓ PASS: freg[%d] = 0x%h", freg_wb_addr, freg_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected freg[%d] = 0x%h, Got freg[%d] = 0x%h", 
                         target_reg, expected_result, freg_wb_addr, freg_wb_data);
                fail_count = fail_count + 1;
            end
            @(posedge clk);
        end
    endtask

    task test_fmul(input [31:0] op1, input [31:0] op2, input [31:0] expected_result, input [4:0] target_reg, input [127:0] test_name);
        begin
            $display("\n=== Testing FMUL: %s ===", test_name);
            $display("FMUL: 0x%h * 0x%h -> freg[%d]", op1, op2, target_reg);
            freg_rs1 = op1; freg_rs2 = op2; frd_addr = target_reg;
            enabled = 1; instr_fmul = 1;
            @(posedge clk);
            clear_instructions(); enabled = 0;
            while (!completed) @(posedge clk);
            if (freg_wb_enable && freg_wb_addr == target_reg && freg_wb_data === expected_result) begin
                $display("✓ PASS: freg[%d] = 0x%h", freg_wb_addr, freg_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL: Expected freg[%d] = 0x%h, Got freg[%d] = 0x%h", 
                         target_reg, expected_result, freg_wb_addr, freg_wb_data);
                fail_count = fail_count + 1;
            end
            @(posedge clk);
        end
    endtask
    
    // Main Test Sequence
    initial begin
        $dumpfile("build/fpu_tb.vcd");
        $dumpvars(0, fpu_comprehensive_tb);
        
        clk = 0;
        mem_rdata = 0;
        
        $display("=== FPU Comprehensive Testbench Started ===");
        
        reset_system();
        
        // ==========================================================
        // YOUR NEW TEST SEQUENCE STARTS HERE
        // ==========================================================

        test_fsub(32'h40000000, 32'h3F800000, 32'h3F800000, 5'd17, "x_new=2.0-1.0=1.0");
        wait_cycles(5);
        
        test_fadd(32'h40490FDB, 32'h3FB504F3, 32'h408C4A9E, 5'd18, "π + √2");
        wait_cycles(3);
        test_fadd(32'h408C4A9E, 32'h402DF854, 32'h40B3295C, 5'd19, "(π + √2) + e");
        wait_cycles(5);
        
        $display("\n========================================");
        $display("========== FSUB INSTRUCTION TESTS ==========");
        $display("========================================");
        
        $display("\n========== FSUB 基本精密小數測試 ==========");
        $display("\n--- 基本精密小數減法 ---");
        test_fsub(32'h3F000000, 32'h3E800000, 32'h3E800000, 5'd1, "0.5 - 0.25 = 0.25");
        wait_cycles(5);
        test_fsub(32'h3F800000, 32'h3F000000, 32'h3F000000, 5'd2, "1.0 - 0.5 = 0.5");
        wait_cycles(5);
        test_fsub(32'h3E99999A, 32'h3DCCCCCD, 32'h3E4CCCCD, 5'd3, "0.3 - 0.1 ≈ 0.2");
        wait_cycles(5);
        
        $display("\n--- 高精度小數減法 ---");
        test_fsub(32'h3CA3D70A, 32'h3C23D70A, 32'h3C23D70A, 5'd4, "0.02 - 0.01 = 0.01");
        wait_cycles(5);
        test_fsub(32'h3C23D70A, 32'h3BA3D70A, 32'h3B83D70A, 5'd5, "0.01 - 0.005 = 0.005");
        wait_cycles(5);
        test_fsub(32'h3B03126F, 32'h3A83126F, 32'h3A83126F, 5'd6, "0.002 - 0.001 = 0.001");
        wait_cycles(5);
        
        $display("\n--- 結果為負數的減法 ---");
        test_fsub(32'h3E800000, 32'h3F000000, 32'hBE800000, 5'd7, "0.25 - 0.5 = -0.25");
        wait_cycles(5);
        test_fsub(32'h3DCCCCCD, 32'h3E4CCCCD, 32'hBDCCCCCD, 5'd8, "0.1 - 0.2 ≈ -0.1");
        wait_cycles(5);
        test_fsub(32'h3C23D70A, 32'h3CA3D70A, 32'hBC23D70A, 5'd9, "0.01 - 0.02 = -0.01");
        wait_cycles(5);
        
        $display("\n--- 數學常數減法 ---");
        test_fsub(32'h40490FDB, 32'h402DF854, 32'h3F860A92, 5'd10, "π - e ≈ 0.423311");
        wait_cycles(5);
        test_fsub(32'h3FDDB3D7, 32'h3FB504F3, 32'h3E4AEFC4, 5'd11, "√3 - √2 ≈ 0.317837");
        wait_cycles(5);
        test_fsub(32'h3F800000, 32'h3F106EBE, 32'h3F50C152, 5'd12, "1 - 1/π ≈ 0.681690");
        wait_cycles(5);
        
        $display("\n--- 相消測試 ---");
        test_fsub(32'h3F800000, 32'h3F800000, 32'h00000000, 5'd13, "1.0 - 1.0 = 0.0");
        wait_cycles(5);
        test_fsub(32'h3F7FFFFF, 32'h3F7FFFFE, 32'h33800000, 5'd14, "接近1的數相減");
        wait_cycles(5);
        test_fsub(32'h40490FDB, 32'h40490FDA, 32'h2F800000, 5'd15, "π - (π-ε) = ε");
        wait_cycles(5);
        
        $display("\n--- 負數減法 ---");
        test_fsub(32'hBF000000, 32'h3E800000, 32'hBF400000, 5'd16, "-0.5 - 0.25 = -0.75");
        wait_cycles(5);
        test_fsub(32'hBDCCCCCD, 32'hBE4CCCCD, 32'h3DCCCCCD, 5'd17, "-0.1 - (-0.2) ≈ 0.1");
        wait_cycles(5);
        test_fsub(32'hBF800000, 32'hBF000000, 32'hBF000000, 5'd18, "-1.0 - (-0.5) = -0.5");
        wait_cycles(5);
        
        $display("\n--- 零值減法 ---");
        test_fsub(32'h3F800000, 32'h00000000, 32'h3F800000, 5'd19, "1.0 - 0.0 = 1.0");
        wait_cycles(5);
        test_fsub(32'h00000000, 32'h3F800000, 32'hBF800000, 5'd20, "0.0 - 1.0 = -1.0");
        wait_cycles(5);
        test_fsub(32'h00000000, 32'h00000000, 32'h00000000, 5'd21, "0.0 - 0.0 = 0.0");
        wait_cycles(5);
        
        $display("\n--- 無窮大和 NaN 減法 ---");
        test_fsub(32'h7F800000, 32'h3F800000, 32'h7F800000, 5'd22, "+Inf - 1.0 = +Inf");
        wait_cycles(5);
        test_fsub(32'h3F800000, 32'h7F800000, 32'hFF800000, 5'd23, "1.0 - (+Inf) = -Inf");
        wait_cycles(5);
        test_fsub(32'h7F800000, 32'h7F800000, 32'h7FC00000, 5'd24, "+Inf - (+Inf) = NaN");
        wait_cycles(5);
        test_fsub(32'h7FC00000, 32'h3F800000, 32'h7FC00000, 5'd25, "NaN - 1.0 = NaN");
        wait_cycles(5);
        
        $display("\n--- 精度邊界減法測試 ---");
        test_fsub(32'h3F800001, 32'h3F800000, 32'h33800000, 5'd26, "1.0000001 - 1.0 = 0.0000001");
        wait_cycles(5);
        test_fsub(32'h42C8051F, 32'h42C80000, 32'h3C23D70A, 5'd27, "100.01 - 100.0 = 0.01");
        wait_cycles(5);
        
        $display("\n--- 不同量級減法 ---");
        test_fsub(32'h42C80000, 32'h3F800000, 32'h42C70000, 5'd28, "100.0 - 1.0 = 99.0");
        wait_cycles(5);
        test_fsub(32'h3F800000, 32'h3C23D70A, 32'h3F7EB852, 5'd29, "1.0 - 0.01 ≈ 0.99");
        wait_cycles(5);
        
        $display("\n--- 下溢減法測試 ---");
        test_fsub(32'h00800001, 32'h00800000, 32'h00000001, 5'd30, "極小數減法接近下溢");
        wait_cycles(5);
        
        $display("\n========================================");
        $display("========== FMUL INSTRUCTION TESTS ==========");
        $display("========================================");
        
        $display("\n========== FMUL 基本精密小數測試 ==========");
        $display("\n--- 基本精密小數乘法 ---");
        test_fmul(32'h3F000000, 32'h3F000000, 32'h3E800000, 5'd1, "0.5 * 0.5 = 0.25");
        wait_cycles(5);
        test_fmul(32'h3DCCCCCD, 32'h40400000, 32'h3E99999A, 5'd2, "0.1 * 3.0 ≈ 0.3");
        wait_cycles(5);
        test_fmul(32'h3E4CCCCD, 32'h40000000, 32'h3ECCCCCD, 5'd3, "0.2 * 2.0 ≈ 0.4");
        wait_cycles(5);
        
        $display("\n--- 高精度小數乘法 ---");
        test_fmul(32'h3C23D70A, 32'h41A00000, 32'h3E800000, 5'd4, "0.01 * 20 = 0.2");
        wait_cycles(5);
        test_fmul(32'h3BA3D70A, 32'h42C80000, 32'h3F000000, 5'd5, "0.005 * 100 = 0.5");
        wait_cycles(5);
        test_fmul(32'h3DCCCCCD, 32'h3DCCCCCD, 32'h3C23D70A, 5'd6, "0.1 * 0.1 = 0.01");
        wait_cycles(5);
        
        $display("\n--- 數學常數乘法 ---");
        test_fmul(32'h40490FDB, 32'h40000000, 32'h40C90FDB, 5'd7, "π * 2 ≈ 6.283185");
        wait_cycles(5);
        test_fmul(32'h402DF854, 32'h402DF854, 32'h4117B0AF, 5'd8, "e * e ≈ 7.389056");
        wait_cycles(5);
        test_fmul(32'h3FB504F3, 32'h3FB504F3, 32'h40000000, 5'd9, "√2 * √2 = 2.0");
        wait_cycles(5);
        test_fmul(32'h3FDDB3D7, 32'h3FDDB3D7, 32'h40400000, 5'd10, "√3 * √3 = 3.0");
        wait_cycles(5);
        
        $display("\n--- 與 1 和 0 相乘 ---");
        test_fmul(32'h3F800000, 32'h3F800000, 32'h3F800000, 5'd11, "1.0 * 1.0 = 1.0");
        wait_cycles(5);
        test_fmul(32'h40490FDB, 32'h3F800000, 32'h40490FDB, 5'd12, "π * 1.0 = π");
        wait_cycles(5);
        test_fmul(32'h40490FDB, 32'h00000000, 32'h00000000, 5'd13, "π * 0.0 = 0.0");
        wait_cycles(5);
        test_fmul(32'h00000000, 32'h00000000, 32'h00000000, 5'd14, "0.0 * 0.0 = 0.0");
        wait_cycles(5);
        
        $display("\n--- 負數乘法 ---");
        test_fmul(32'hBF000000, 32'h40000000, 32'hBF800000, 5'd15, "-0.5 * 2.0 = -1.0");
        wait_cycles(5);
        test_fmul(32'hBDCCCCCD, 32'hBE4CCCCD, 32'h3C23D70A, 5'd16, "-0.1 * (-0.2) = 0.02");
        wait_cycles(5);
        test_fmul(32'hBF800000, 32'hBF800000, 32'h3F800000, 5'd17, "-1.0 * (-1.0) = 1.0");
        wait_cycles(5);
        test_fmul(32'h3F800000, 32'hBF800000, 32'hBF800000, 5'd18, "1.0 * (-1.0) = -1.0");
        wait_cycles(5);
        
        $display("\n--- 分數乘法 ---");
        test_fmul(32'h3EAAAAAB, 32'h3E800000, 32'h3E088889, 5'd19, "1/3 * 0.25 ≈ 0.0833");
        wait_cycles(5);
        test_fmul(32'h3F106EBE, 32'h40490FDB, 32'h3F800000, 5'd20, "1/π * π = 1.0");
        wait_cycles(5);
        
        $display("\n--- 冪次計算 (平方) ---");
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd21, "2.0 * 2.0 = 4.0");
        wait_cycles(5);
        test_fmul(32'h40400000, 32'h40400000, 32'h41100000, 5'd22, "3.0 * 3.0 = 9.0");
        wait_cycles(5);
        test_fmul(32'h40800000, 32'h40800000, 32'h41800000, 5'd23, "4.0 * 4.0 = 16.0");
        wait_cycles(5);
        test_fmul(32'h40A00000, 32'h40A00000, 32'h41C80000, 5'd24, "5.0 * 5.0 = 25.0");
        wait_cycles(5);
        
        $display("\n--- 極小數乘法 ---");
        test_fmul(32'h39D1B717, 32'h41200000, 32'h3A51B717, 5'd25, "0.0001 * 10 = 0.001");
        wait_cycles(5);
        test_fmul(32'h3C23D70A, 32'h3C23D70A, 32'h37A6B5F3, 5'd26, "0.01 * 0.01 = 0.0001");
        wait_cycles(5);
        
        $display("\n--- 無窮大和 NaN 乘法 ---");
        test_fmul(32'h7F800000, 32'h40000000, 32'h7F800000, 5'd27, "+Inf * 2.0 = +Inf");
        wait_cycles(5);
        test_fmul(32'hFF800000, 32'h40000000, 32'hFF800000, 5'd28, "-Inf * 2.0 = -Inf");
        wait_cycles(5);
        test_fmul(32'h7F800000, 32'hBF800000, 32'hFF800000, 5'd29, "+Inf * (-1.0) = -Inf");
        wait_cycles(5);
        test_fmul(32'h7F800000, 32'h00000000, 32'h7FC00000, 5'd30, "+Inf * 0.0 = NaN");
        wait_cycles(5);
        test_fmul(32'h7FC00000, 32'h3F800000, 32'h7FC00000, 5'd31, "NaN * 1.0 = NaN");
        wait_cycles(5);
        
        $display("\n--- 溢位測試 ---");
        test_fmul(32'h7F000000, 32'h40000000, 32'h7F800000, 5'd1, "大數 * 2 = +Inf (溢位)");
        wait_cycles(5);
        test_fmul(32'h5F000000, 32'h5F000000, 32'h7F800000, 5'd2, "大數 * 大數 = +Inf");
        wait_cycles(5);
        
        $display("\n--- 下溢測試 ---");
        test_fmul(32'h00800000, 32'h3F000000, 32'h00400000, 5'd3, "最小正規化數 * 0.5");
        wait_cycles(5);
        test_fmul(32'h01000000, 32'h3E800000, 32'h00400000, 5'd4, "小數 * 0.25 接近下溢");
        wait_cycles(5);
        
        $display("\n--- 精度邊界乘法測試 ---");
        test_fmul(32'h3F800000, 32'h3F800001, 32'h3F800001, 5'd5, "1.0 * 1.0000001");
        wait_cycles(5);
        test_fmul(32'h42C80000, 32'h3C23D70A, 32'h3F800000, 5'd6, "100.0 * 0.01 = 1.0");
        wait_cycles(5);
        
        $display("\n--- 累積乘法 ---");
        test_fmul(32'h40000000, 32'h3F000000, 32'h3F800000, 5'd7, "2.0 * 0.5 = 1.0 (step 1)");
        wait_cycles(3);
        test_fmul(32'h3F800000, 32'h40400000, 32'h40400000, 5'd8, "1.0 * 3.0 = 3.0 (step 2)");
        wait_cycles(3);
        test_fmul(32'h40400000, 32'h3EAAAAAB, 32'h3F800000, 5'd9, "3.0 * 0.333... = 1.0 (step 3)");
        wait_cycles(5);
        
        $display("\n--- 科學計算乘法 ---");
        test_fmul(32'h40000000, 32'h40490FDB, 32'h40C90FDB, 5'd10, "2 * π = 2π");
        wait_cycles(5);
        test_fmul(32'h3F000000, 32'h40490FDB, 32'h3FC90FDB, 5'd11, "0.5 * π = π/2");
        wait_cycles(5);
        test_fmul(32'h3E800000, 32'h40490FDB, 32'h3F490FDB, 5'd12, "0.25 * π = π/4");
        wait_cycles(5);
        
        $display("\n--- 三角函數相關乘法 ---");
        test_fmul(32'h3F000000, 32'h3F5DB3D7, 32'h3F2DB3D7, 5'd13, "sin(30°) * cos(30°)");
        wait_cycles(5);
        
        $display("\n--- 對數指數相關乘法 ---");
        test_fmul(32'h3F317218, 32'h40000000, 32'h3FB17218, 5'd14, "log10(2) * 2");
        wait_cycles(5);
        
        $display("\n--- 幾何計算 (面積/體積) ---");
        test_fmul(32'h40A00000, 32'h40A00000, 32'h41C80000, 5'd15, "5.0 * 5.0 = 25.0 (正方形面積)");
        wait_cycles(5);
        test_fmul(32'h40490FDB, 32'h40000000, 32'h40C90FDB, 5'd16, "π * r² 中的 π * 2");
        wait_cycles(5);
        
        $display("\n--- 歸一化邊界乘法測試 ---");
        test_fmul(32'h00800000, 32'h40000000, 32'h01000000, 5'd17, "最小正規化數 * 2");
        wait_cycles(5);
        test_fmul(32'h007FFFFF, 32'h40000000, 32'h00FFFFFE, 5'd18, "最大非正規化數 * 2");
        wait_cycles(5);
        
        $display("\n========== 混合運算測試 (FADD, FSUB, FMUL) ==========");
        
        $display("\n--- 序列 1: 數學表達式 (a+b)*(c-d) 的部分 ---");
        test_fadd(32'h3DCCCCCD, 32'h3E4CCCCD, 32'h3E99999A, 5'd1, "a+b: 0.1 + 0.2 = 0.3");
        wait_cycles(3);
        test_fsub(32'h3F000000, 32'h3E800000, 32'h3E800000, 5'd2, "c-d: 0.5 - 0.25 = 0.25");
        wait_cycles(3);
        test_fmul(32'h3E99999A, 32'h3E800000, 32'h3E19999A, 5'd3, "(a+b)*(c-d): 0.3 * 0.25 = 0.075");
        wait_cycles(5);
        
        $display("\n--- 序列 2: 二次方程式 ax²+bx+c 的部分項 ---");
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd4, "x²: 2.0 * 2.0 = 4.0");
        wait_cycles(3);
        test_fmul(32'h40400000, 32'h40800000, 32'h41400000, 5'd5, "ax²: 3.0 * 4.0 = 12.0");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd6, "bx: 2.0 * 2.0 = 4.0");
        wait_cycles(3);
        test_fadd(32'h41400000, 32'h40800000, 32'h41800000, 5'd7, "ax²+bx: 12.0 + 4.0 = 16.0");
        wait_cycles(3);
        test_fadd(32'h41800000, 32'h3F800000, 32'h41880000, 5'd8, "ax²+bx+c: 16.0 + 1.0 = 17.0");
        wait_cycles(5);
        
        $display("\n--- 序列 3: 平均值計算 (a+b+c)/3 ---");
        test_fadd(32'h3F800000, 32'h40000000, 32'h40400000, 5'd9, "a+b: 1.0 + 2.0 = 3.0");
        wait_cycles(3);
        test_fadd(32'h40400000, 32'h40400000, 32'h40C00000, 5'd10, "(a+b)+c: 3.0 + 3.0 = 6.0");
        wait_cycles(3);
        test_fmul(32'h40C00000, 32'h3EAAAAAB, 32'h40000000, 5'd11, "sum/3: 6.0 * 0.333... = 2.0");
        wait_cycles(5);
        
        $display("\n--- 序列 4: 距離公式 √((x2-x1)²+(y2-y1)²) 的平方部分 ---");
        test_fsub(32'h40A00000, 32'h40000000, 32'h40400000, 5'd12, "x2-x1: 5.0 - 2.0 = 3.0");
        wait_cycles(3);
        test_fmul(32'h40400000, 32'h40400000, 32'h41100000, 5'd13, "(x2-x1)²: 3.0 * 3.0 = 9.0");
        wait_cycles(3);
        test_fsub(32'h41000000, 32'h3F800000, 32'h40E00000, 5'd14, "y2-y1: 8.0 - 1.0 = 7.0");
        wait_cycles(3);
        test_fmul(32'h40E00000, 32'h40E00000, 32'h42440000, 5'd15, "(y2-y1)²: 7.0 * 7.0 = 49.0");
        wait_cycles(3);
        test_fadd(32'h41100000, 32'h42440000, 32'h42680000, 5'd16, "dx²+dy²: 9.0 + 49.0 = 58.0");
        wait_cycles(5);
        
        $display("\n--- 序列 5: 圓面積 A = πr² ---");
        test_fmul(32'h40400000, 32'h40400000, 32'h41100000, 5'd17, "r²: 3.0 * 3.0 = 9.0");
        wait_cycles(3);
        test_fmul(32'h40490FDB, 32'h41100000, 32'h421AD0E5, 5'd18, "πr²: π * 9.0 ≈ 28.274");
        wait_cycles(5);
        
        $display("\n--- 序列 6: 指數增長 P(1+r)ⁿ 的部分 ---");
        test_fadd(32'h3F800000, 32'h3DCCCCCD, 32'h3F8CCCCD, 5'd19, "1+r: 1.0 + 0.1 = 1.1");
        wait_cycles(3);
        test_fmul(32'h3F8CCCCD, 32'h3F8CCCCD, 32'h3F9D70A4, 5'd20, "(1+r)²: 1.1 * 1.1 = 1.21");
        wait_cycles(3);
        test_fmul(32'h42C80000, 32'h3F9D70A4, 32'h42F28F5C, 5'd21, "P(1+r)²: 100 * 1.21 = 121");
        wait_cycles(5);
        
        $display("\n--- 序列 7: 向量運算 ---");
        test_fmul(32'h40000000, 32'h40400000, 32'h40C00000, 5'd22, "x1*x2: 2.0 * 3.0 = 6.0");
        wait_cycles(3);
        test_fmul(32'h40800000, 32'h3F800000, 32'h40800000, 5'd23, "y1*y2: 4.0 * 1.0 = 4.0");
        wait_cycles(3);
        test_fadd(32'h40C00000, 32'h40800000, 32'h41200000, 5'd24, "dot product: 6.0 + 4.0 = 10.0");
        wait_cycles(5);
        
        $display("\n--- 序列 8: 溫度轉換 C = (F-32)*5/9 ---");
        test_fsub(32'h42200000, 32'h42000000, 32'h41880000, 5'd25, "F-32: 40 - 32 = 8");
        wait_cycles(3);
        test_fmul(32'h41880000, 32'h40A00000, 32'h42200000, 5'd26, "(F-32)*5: 8 * 5 = 40");
        wait_cycles(3);
        test_fmul(32'h42200000, 32'h3E38E38E, 32'h4088E38E, 5'd27, "result/9: 40 * 0.111... ≈ 4.44");
        wait_cycles(5);
        
        $display("\n--- 序列 9: 百分比計算 ---");
        test_fmul(32'h42C80000, 32'h3DCCCCCD, 32'h41200000, 5'd28, "10% of 100: 100 * 0.1 = 10");
        wait_cycles(3);
        test_fsub(32'h42C80000, 32'h41200000, 32'h42B40000, 5'd29, "100 - 10%: 100 - 10 = 90");
        wait_cycles(5);
        
        $display("\n--- 序列 10: 複利計算鏈 ---");
        test_fmul(32'h447A0000, 32'h3D4CCCCD, 32'h41C80000, 5'd30, "利息: 1000 * 0.05 = 50");
        wait_cycles(3);
        test_fadd(32'h447A0000, 32'h41C80000, 32'h44834000, 5'd31, "本利和: 1000 + 50 = 1050");
        wait_cycles(5);
        
        $display("\n========== 邊界混合測試 ==========");
        
        $display("\n--- 精度損失與恢復 ---");
        test_fadd(32'h4B800000, 32'h3F800000, 32'h4B800000, 5'd1, "大數+1 損失精度");
        wait_cycles(3);
        test_fsub(32'h4B800000, 32'h4B800000, 32'h00000000, 5'd2, "相減恢復為0");
        wait_cycles(5);
        
        $display("\n--- 符號處理混合 ---");
        test_fmul(32'hBF800000, 32'hBF800000, 32'h3F800000, 5'd3, "(-1)*(-1)=1");
        wait_cycles(3);
        test_fadd(32'h3F800000, 32'hBF800000, 32'h00000000, 5'd4, "1+(-1)=0");
        wait_cycles(3);
        test_fsub(32'h3F800000, 32'hBF800000, 32'h40000000, 5'd5, "1-(-1)=2");
        wait_cycles(5);
        
        $display("\n--- 連續小數精密運算鏈 ---");
        test_fmul(32'h3DCCCCCD, 32'h41200000, 32'h3F800000, 5'd6, "0.1 * 10 = 1.0");
        wait_cycles(3);
        test_fadd(32'h3F800000, 32'h3C23D70A, 32'h3F8147AE, 5'd7, "1.0 + 0.01 = 1.01");
        wait_cycles(3);
        test_fsub(32'h3F8147AE, 32'h3C23D70A, 32'h3F800000, 5'd8, "1.01 - 0.01 = 1.0");
        wait_cycles(3);
        test_fmul(32'h3F800000, 32'h3DCCCCCD, 32'h3DCCCCCD, 5'd9, "1.0 * 0.1 = 0.1");
        wait_cycles(5);
        
        $display("\n========== 壓力測試 (混合運算) ==========");
        
        $display("\n--- 快速連續混合操作 ---");
        test_fadd(32'h3F800000, 32'h40000000, 32'h40400000, 5'd10, "1+2=3");
        test_fsub(32'h40400000, 32'h3F800000, 32'h40000000, 5'd11, "3-1=2");
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd12, "2*2=4");
        wait_cycles(5);
        
        $display("\n--- 極限精度混合測試 ---");
        test_fmul(32'h7F7FFFFF, 32'h3F000000, 32'h7F000000, 5'd13, "最大數 * 0.5");
        wait_cycles(3);
        test_fadd(32'h7F000000, 32'h7F000000, 32'h7F800000, 5'd14, "大數 + 大數 = Inf");
        wait_cycles(5);
        
        test_fmul(32'h00800000, 32'h3F800000, 32'h00800000, 5'd15, "最小正規化數 * 1");
        wait_cycles(3);
        test_fsub(32'h00800000, 32'h00000001, 32'h007FFFFF, 5'd16, "接近下溢");
        wait_cycles(5);
        
        $display("\n========== FSUB/FMUL 特殊組合測試 ==========");
        
        $display("\n--- 差的平方 (a-b)² ---");
        test_fsub(32'h40A00000, 32'h40400000, 32'h40000000, 5'd17, "5-3=2");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd18, "2²=4");
        wait_cycles(5);
        
        $display("\n--- 平方差 (a-b)(a+b) ---");
        test_fsub(32'h40A00000, 32'h40400000, 32'h40000000, 5'd19, "a-b: 5-3=2");
        wait_cycles(3);
        test_fadd(32'h40A00000, 32'h40400000, 32'h41000000, 5'd20, "a+b: 5+3=8");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h41000000, 32'h41800000, 5'd21, "(a-b)(a+b)=16");
        wait_cycles(5);
        
        $display("\n--- 比例與百分比變化 ---");
        test_fsub(32'h42480000, 32'h42200000, 32'h41200000, 5'd22, "新值-舊值: 50-40=10");
        wait_cycles(3);
        test_fmul(32'h41200000, 32'h42C80000, 32'h447A0000, 5'd23, "差值*100: 10*100=1000");
        wait_cycles(3);
        test_fmul(32'h447A0000, 32'h3CA3D70A, 32'h41C80000, 5'd24, "百分比: 1000*0.02=20");
        wait_cycles(5);
        
        $display("\n========== 錯誤情況和邊界測試 (FSUB/FMUL) ==========");
        
        test_fsub(32'h3F800000, 32'h3F000000, 32'h3F000000, 5'd0, "FSUB to f0");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h40400000, 32'h40C00000, 5'd31, "FMUL to f31");
        wait_cycles(5);
        
        $display("\n--- 完整集成: Load-Compute-Store (FSUB) ---");
        test_flw(32'h1000, 32'h8, 32'h40400000, 5'd1, "Load 3.0");
        wait_cycles(3);
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd2, "Load 1.0");
        wait_cycles(3);
        test_fsub(32'h40400000, 32'h3F800000, 32'h40000000, 5'd3, "3.0 - 1.0 = 2.0");
        wait_cycles(3);
        test_fsw(32'h5000, 32'h0, 32'h40000000, "Store result");
        wait_cycles(5);
        
        $display("\n--- 完整集成: Load-Compute-Store (FMUL) ---");
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd4, "Load 2.0");
        wait_cycles(3);
        test_flw(32'h1000, 32'h8, 32'h40400000, 5'd5, "Load 3.0");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h40400000, 32'h40C00000, 5'd6, "2.0 * 3.0 = 6.0");
        wait_cycles(3);
        test_fsw(32'h5004, 32'h0, 32'h40C00000, "Store result");
        wait_cycles(5);
        
        $display("\n========== 最終統合測試 (所有指令) ==========");
        
        $display("\n--- 表達式: (a+b)*(c-d) 完整計算 ---");
        test_flw(32'h1014, 32'h0, 32'h3F000000, 5'd1, "Load a=0.5");
        wait_cycles(3);
        test_flw(32'h1018, 32'h0, 32'h3E800000, 5'd2, "Load b=0.25");
        wait_cycles(3);
        test_fadd(32'h3F000000, 32'h3E800000, 32'h3F400000, 5'd3, "a+b=0.75");
        wait_cycles(3);
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd4, "Load c=2.0");
        wait_cycles(3);
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd5, "Load d=1.0");
        wait_cycles(3);
        test_fsub(32'h40000000, 32'h3F800000, 32'h3F800000, 5'd6, "c-d=1.0");
        wait_cycles(3);
        test_fmul(32'h3F400000, 32'h3F800000, 32'h3F400000, 5'd7, "(a+b)*(c-d)=0.75");
        wait_cycles(3);
        test_fsw(32'h6000, 32'h0, 32'h3F400000, "Store final result");
        wait_cycles(5);
        
        $display("\n--- 表達式: a²-b² 完整計算 ---");
        test_flw(32'h100C, 32'h0, 32'h40800000, 5'd8, "Load a=4.0");
        wait_cycles(3);
        test_fmul(32'h40800000, 32'h40800000, 32'h41800000, 5'd9, "a²=16.0");
        wait_cycles(3);
        test_flw(32'h1008, 32'h0, 32'h40400000, 5'd10, "Load b=3.0");
        wait_cycles(3);
        test_fmul(32'h40400000, 32'h40400000, 32'h41100000, 5'd11, "b²=9.0");
        wait_cycles(3);
        test_fsub(32'h41800000, 32'h41100000, 32'h40E00000, 5'd12, "a²-b²=7.0");
        wait_cycles(3);
        test_fsw(32'h6004, 32'h0, 32'h40E00000, "Store result");
        wait_cycles(5);
        
        $display("\n--- 數值方法示例: 迭代步驟 ---");
        test_flw(32'h1004, 32'h0, 32'h40000000, 5'd13, "Load x=2.0");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h40000000, 32'h40800000, 5'd14, "x²=4.0");
        wait_cycles(3);
        test_fsub(32'h40800000, 32'h40000000, 32'h40000000, 5'd15, "x²-2=2.0");
        wait_cycles(3);
        test_fmul(32'h40000000, 32'h3F000000, 32'h3F800000, 5'd16, "delta=2.0*0.5=1.0");
        wait_cycles(3);
        test_fsub(32'h40000000, 32'h3F800000, 32'h3F800000, 5'd17, "x_new=2.0-1.0=1.0");
        wait_cycles(5);
        
        // ==========================================================
        // FINAL SUMMARY
        // ==========================================================
        $display("\n========== 測試結果統計 ==========");
        $display("Total Tests: %d", pass_count + fail_count);
        $display("✓ Passed:    %d", pass_count);
        $display("✗ Failed:    %d", fail_count);
        if (pass_count + fail_count > 0) begin
            $display("Pass Rate:   %.2f%%", (pass_count * 100.0) / (pass_count + fail_count));
        end
        
        if (fail_count == 0) begin
            $display("\n🎉 所有測試都通過了！FPU 功能完全正常！");
        end else begin
            $display("\n⚠️  有 %d 個測試失敗，請檢查 FPU 實作", fail_count);
        end
        
        $display("\n=== FPU Testbench Finished ===");
        #100;
        $finish;
    end
    
endmodule
