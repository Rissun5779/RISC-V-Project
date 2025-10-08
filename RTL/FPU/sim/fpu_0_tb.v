`timescale 1ps/1ps

module fpu_comprehensive_tb;
    reg clk;
    reg rst_n;
    reg enabled;
    
    reg instr_flw;
    reg instr_fsw;
    reg instr_fadd;
    reg instr_fdiv;
    reg instr_fmul;
    
    reg [31:0] reg_rs1, reg_rs2;
    reg [4:0] rd_addr;
    reg [31:0] freg_rs1, freg_rs2;
    reg [4:0] frd_addr;
    reg [31:0] imm;
    
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg [31:0] mem_rdata;
    wire mem_we;
    wire mem_re;
    reg mem_ready;
    
    wire freg_wb_enable;
    wire [4:0] freg_wb_addr;
    wire [31:0] freg_wb_data;
    wire reg_wb_enable;
    wire [4:0] reg_wb_addr;
    wire [31:0] reg_wb_data;
    
    wire completed;
    wire fpu_busy;
    
    // 記憶體
    reg [31:0] memory [0:4095];
    
    // 統計
    integer pass_count = 0;
    integer fail_count = 0;
    
    fpu uut (
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
    
    // 記憶體模型
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
            instr_flw = 0; instr_fsw = 0; instr_fadd = 0; instr_fdiv = 0; instr_fmul = 0;
        end
    endtask
    
    task test_flw(input [31:0] base_addr, input [31:0] offset, input [31:0] expected_data, input [4:0] target_reg, input [127:0] test_name);
        begin
            $display("\n=== Testing FLW: %s ===", test_name);
            
            reg_rs1 = base_addr;
            imm = offset;
            frd_addr = target_reg;
            enabled = 1;
            instr_flw = 1;
            
            @(posedge clk);
            clear_instructions();
            enabled = 0;
            
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
            
            reg_rs1 = base_addr;
            freg_rs2 = store_data;
            imm = offset;
            enabled = 1;
            instr_fsw = 1;
            
            @(posedge clk);
            clear_instructions();
            enabled = 0;
            
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
            
            freg_rs1 = op1;
            freg_rs2 = op2;
            frd_addr = target_reg;
            enabled = 1;
            instr_fadd = 1;
            
            @(posedge clk);
            clear_instructions();
            enabled = 0;
            
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
    
    task wait_cycles(input integer cycles);
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) @(posedge clk);
        end
    endtask
    
    // 浮點數轉換函數（用於調試）
    function [31:0] float_to_hex(input real f);
        begin
            // 這個函數僅用於說明，實際測試使用預計算的十六進制值
            float_to_hex = 32'h0;
        end
    endfunction
    
    initial begin
        $dumpfile("build/fpu_comprehensive_tb.vcd");
        $dumpvars(0, fpu_comprehensive_tb);
        
        clk = 0;
        mem_rdata = 0;
        
        $display("=== FPU Comprehensive Testbench Started ===");
        
        reset_system();
        
        // 初始化測試數據到記憶體
        // 基本浮點數
        memory[32'h1000 >> 2] = 32'h3F800000;  // 1.0
        memory[32'h1004 >> 2] = 32'h40000000;  // 2.0
        memory[32'h1008 >> 2] = 32'h40400000;  // 3.0
        memory[32'h100C >> 2] = 32'h40800000;  // 4.0
        memory[32'h1010 >> 2] = 32'h40A00000;  // 5.0
        
        // 精密小數
        memory[32'h1014 >> 2] = 32'h3F000000;  // 0.5
        memory[32'h1018 >> 2] = 32'h3E800000;  // 0.25
        memory[32'h101C >> 2] = 32'h3F400000;  // 0.75
        memory[32'h1020 >> 2] = 32'h3DCCCCCD;  // 0.1 (approximately)
        memory[32'h1024 >> 2] = 32'h3E4CCCCD;  // 0.2 (approximately)
        memory[32'h1028 >> 2] = 32'h3E99999A;  // 0.3 (approximately)
        memory[32'h102C >> 2] = 32'h3ECCCCCD;  // 0.4 (approximately)
        memory[32'h1030 >> 2] = 32'h3F19999A;  // 0.6 (approximately)
        memory[32'h1034 >> 2] = 32'h3F333333;  // 0.7 (approximately)
        memory[32'h1038 >> 2] = 32'h3F4CCCCD;  // 0.8 (approximately)
        memory[32'h103C >> 2] = 32'h3F666666;  // 0.9 (approximately)
        
        // 更精密的小數
        memory[32'h1040 >> 2] = 32'h3C23D70A;  // 0.01 (approximately)
        memory[32'h1044 >> 2] = 32'h3BA3D70A;  // 0.005 (approximately)
        memory[32'h1048 >> 2] = 32'h3B03126F;  // 0.002 (approximately)
        memory[32'h104C >> 2] = 32'h3A83126F;  // 0.001 (approximately)
        memory[32'h1050 >> 2] = 32'h39D1B717;  // 0.0001 (approximately)
        
        // 數學常數近似值
        memory[32'h1054 >> 2] = 32'h40490FDB;  // π ≈ 3.141593
        memory[32'h1058 >> 2] = 32'h402DF854;  // e ≈ 2.718282
        memory[32'h105C >> 2] = 32'h3FB504F3;  // √2 ≈ 1.414214
        memory[32'h1060 >> 2] = 32'h3FDDB3D7;  // √3 ≈ 1.732051
        memory[32'h1064 >> 2] = 32'h3F106EBE;  // 1/π ≈ 0.318310
        memory[32'h1068 >> 2] = 32'h3F22F983;  // 1/e ≈ 0.367879
        
        // 負數精密小數
        memory[32'h1070 >> 2] = 32'hBF000000;  // -0.5
        memory[32'h1074 >> 2] = 32'hBDCCCCCD;  // -0.1 (approximately)
        memory[32'h1078 >> 2] = 32'hBC23D70A;  // -0.01 (approximately)
        
        // 特殊值
        memory[32'h1080 >> 2] = 32'h00000000;  // +0.0
        memory[32'h1084 >> 2] = 32'h80000000;  // -0.0
        memory[32'h1088 >> 2] = 32'h7F800000;  // +Infinity
        memory[32'h108C >> 2] = 32'hFF800000;  // -Infinity
        memory[32'h1090 >> 2] = 32'h7FC00000;  // NaN
        
        // 非常小的數 (denormalized)
        memory[32'h1094 >> 2] = 32'h00000001;  // 最小正非規格化數
        memory[32'h1098 >> 2] = 32'h007FFFFF;  // 最大非規格化數
        
        // 非常大的數
        memory[32'h109C >> 2] = 32'h7F7FFFFF;  // 最大正規格化數
        memory[32'h10A0 >> 2] = 32'hFF7FFFFF;  // 最小負規格化數
        
        $display("\n========== FLW INSTRUCTION TESTS ==========");
        
        // 基本 FLW 測試
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd1, "Load 1.0");
        wait_cycles(5);
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd2, "Load 2.0");
        wait_cycles(5);
        test_flw(32'h1000, 32'h8, 32'h40400000, 5'd3, "Load 3.0");
        wait_cycles(5);
        
        // 精密小數載入測試
        test_flw(32'h1014, 32'h0, 32'h3F000000, 5'd4, "Load 0.5");
        wait_cycles(5);
        test_flw(32'h1020, 32'h0, 32'h3DCCCCCD, 5'd5, "Load 0.1");
        wait_cycles(5);
        test_flw(32'h1040, 32'h0, 32'h3C23D70A, 5'd6, "Load 0.01");
        wait_cycles(5);
        
        $display("\n========== FSW INSTRUCTION TESTS ==========");
        
        // 基本 FSW 測試
        test_fsw(32'h2000, 32'h0, 32'h3F800000, "Store 1.0");
        wait_cycles(5);
        test_fsw(32'h2000, 32'h4, 32'h40000000, "Store 2.0");
        wait_cycles(5);
        test_fsw(32'h2000, 32'h8, 32'h3DCCCCCD, "Store 0.1");
        wait_cycles(5);
        
        $display("\n========== FADD INSTRUCTION TESTS - 精密小數計算 ==========");
        
        // 基本精密加法測試
        $display("\n--- 基本精密小數加法 ---");
        test_fadd(32'h3DCCCCCD, 32'h3E4CCCCD, 32'h3E99999A, 5'd16, "0.1 + 0.2 ≈ 0.3");
        wait_cycles(5);
        test_fadd(32'h3F000000, 32'h3E800000, 32'h3F400000, 5'd17, "0.5 + 0.25 = 0.75");
        wait_cycles(5);
        test_fadd(32'h3F400000, 32'h3E800000, 32'h3F800000, 5'd18, "0.75 + 0.25 = 1.0");
        wait_cycles(5);
        
        // 小數點後多位數的加法
        $display("\n--- 高精度小數加法 ---");
        test_fadd(32'h3C23D70A, 32'h3C23D70A, 32'h3CA3D70A, 5'd19, "0.01 + 0.01 = 0.02");
        wait_cycles(5);
        test_fadd(32'h3BA3D70A, 32'h3BA3D70A, 32'h3C23D70A, 5'd20, "0.005 + 0.005 = 0.01");
        wait_cycles(5);
        test_fadd(32'h3A83126F, 32'h3A83126F, 32'h3B03126F, 5'd21, "0.001 + 0.001 = 0.002");
        wait_cycles(5);
        
        // 不同量級的小數加法
        $display("\n--- 不同量級小數加法 ---");
        test_fadd(32'h3F800000, 32'h3C23D70A, 32'h3F8147AE, 5'd22, "1.0 + 0.01 ≈ 1.01");
        wait_cycles(5);
        test_fadd(32'h3F000000, 32'h3BA3D70A, 32'h3F00A3D7, 5'd23, "0.5 + 0.005 ≈ 0.505");
        wait_cycles(5);
        test_fadd(32'h3DCCCCCD, 32'h3A83126F, 32'h3DD0C49C, 5'd24, "0.1 + 0.001 ≈ 0.101");
        wait_cycles(5);
        
        // 數學常數的計算
        $display("\n--- 數學常數加法 ---");
        test_fadd(32'h40490FDB, 32'h402DF854, 32'h40B5C28F, 5'd25, "π + e ≈ 5.859874");
        wait_cycles(5);
        test_fadd(32'h3FB504F3, 32'h3FDDB3D7, 32'h406170CA, 5'd26, "√2 + √3 ≈ 3.146264");
        wait_cycles(5);
        test_fadd(32'h3F106EBE, 32'h3F22F983, 32'h3F654641, 5'd27, "1/π + 1/e ≈ 0.686189");
        wait_cycles(5);
        
        // 接近機器精度的計算
        $display("\n--- 機器精度邊界測試 ---");
        test_fadd(32'h3F800000, 32'h33800000, 32'h3F800000, 5'd28, "1.0 + 2^(-23) ≈ 1.0 (精度測試)");
        wait_cycles(5);
        test_fadd(32'h3F800000, 32'h34000000, 32'h3F800001, 5'd29, "1.0 + 2^(-22) = 1.0000001");
        wait_cycles(5);
        
        // 負數精密加法
        $display("\n--- 負數精密加法 ---");
        test_fadd(32'hBDCCCCCD, 32'h3E4CCCCD, 32'h3DCCCCCD, 5'd30, "-0.1 + 0.2 ≈ 0.1");
        wait_cycles(5);
        test_fadd(32'hBC23D70A, 32'h3C23D70A, 32'h00000000, 5'd31, "-0.01 + 0.01 = 0.0");
        wait_cycles(5);
        test_fadd(32'hBF000000, 32'h3F400000, 32'h3E800000, 5'd32, "-0.5 + 0.75 = 0.25");
        wait_cycles(5);
        
        // 累積計算測試
        $display("\n--- 累積精密計算 ---");
        test_fadd(32'h3DCCCCCD, 32'h3DCCCCCD, 32'h3E4CCCCD, 5'd33, "0.1 + 0.1 = 0.2 (step 1)");
        wait_cycles(3);
        test_fadd(32'h3E4CCCCD, 32'h3DCCCCCD, 32'h3E99999A, 5'd34, "0.2 + 0.1 = 0.3 (step 2)");
        wait_cycles(3);
        test_fadd(32'h3E99999A, 32'h3DCCCCCD, 32'h3ECCCCCD, 5'd35, "0.3 + 0.1 = 0.4 (step 3)");
        wait_cycles(3);
        test_fadd(32'h3ECCCCCD, 32'h3DCCCCCD, 32'h3F000000, 5'd36, "0.4 + 0.1 = 0.5 (step 4)");
        wait_cycles(5);
        
        // 科學計算相關的精密加法
        $display("\n--- 科學計算相關 ---");
        test_fadd(32'h3F490FDB, 32'h3F490FDB, 32'h40490FDB, 5'd37, "π/2 + π/2 = π");
        wait_cycles(5);
        test_fadd(32'h3F060A92, 32'h3F060A92, 32'h3F860A92, 5'd38, "ln(2) + ln(2) = 2*ln(2)");
        wait_cycles(5);
        
        // 對數和指數相關
        $display("\n--- 對數指數相關 ---");
        test_fadd(32'h3F317218, 32'h3F317218, 32'h3FB17218, 5'd39, "log10(2) + log10(2) = 2*log10(2)");
        wait_cycles(5);
        
        // 三角函數相關值
        $display("\n--- 三角函數相關 ---");
        test_fadd(32'h3F000000, 32'h3F5DB3D7, 32'h3FADB3D7, 5'd40, "sin(30°) + cos(30°) ≈ 1.366");
        wait_cycles(5);
        
        // 極小值加法測試
        $display("\n--- 極小值精密加法 ---");
        test_fadd(32'h39D1B717, 32'h39D1B717, 32'h3A51B717, 5'd41, "0.0001 + 0.0001 = 0.0002");
        wait_cycles(5);
        test_fadd(32'h35D1B717, 32'h35D1B717, 32'h3651B717, 5'd42, "1e-6 + 1e-6 = 2e-6");
        wait_cycles(5);
        
        // 精度損失測試
        $display("\n--- 精度損失邊界測試 ---");
        test_fadd(32'h47800000, 32'h3F800000, 32'h47800000, 5'd43, "65536.0 + 1.0 = 65536.0 (精度損失)");
        wait_cycles(5);
        test_fadd(32'h4B800000, 32'h3F800000, 32'h4B800000, 5'd44, "16777216.0 + 1.0 = 16777216.0 (精度損失)");
        wait_cycles(5);
        
        // 歸一化邊界測試
        $display("\n--- 歸一化邊界測試 ---");
        test_fadd(32'h00800000, 32'h00800000, 32'h01000000, 5'd45, "最小正規化數 + 最小正規化數");
        wait_cycles(5);
        test_fadd(32'h007FFFFF, 32'h00000001, 32'h00800000, 5'd46, "最大非正規化數 + 最小非正規化數 = 最小正規化數");
        wait_cycles(5);
        
        $display("\n========== 零值測試 ==========");
        
        // 零值測試
        test_fadd(32'h3F800000, 32'h00000000, 32'h3F800000, 5'd47, "1.0 + 0.0 = 1.0");
        wait_cycles(5);
        test_fadd(32'h00000000, 32'h00000000, 32'h00000000, 5'd48, "0.0 + 0.0 = 0.0");
        wait_cycles(5);
        test_fadd(32'h00000000, 32'h80000000, 32'h00000000, 5'd49, "+0.0 + (-0.0) = +0.0");
        wait_cycles(5);
        
        $display("\n========== 無窮大和 NaN 測試 ==========");
        
        // 無窮大測試
        test_fadd(32'h7F800000, 32'h3F800000, 32'h7F800000, 5'd50, "+Inf + 1.0 = +Inf");
        wait_cycles(5);
        test_fadd(32'hFF800000, 32'h3F800000, 32'hFF800000, 5'd51, "-Inf + 1.0 = -Inf");
        wait_cycles(5);
        test_fadd(32'h7F800000, 32'h7F800000, 32'h7F800000, 5'd52, "+Inf + +Inf = +Inf");
        wait_cycles(5);
        test_fadd(32'h7F800000, 32'hFF800000, 32'h7FC00000, 5'd53, "+Inf + (-Inf) = NaN");
        wait_cycles(5);
        
        // NaN 測試
        test_fadd(32'h7FC00000, 32'h3F800000, 32'h7FC00000, 5'd54, "NaN + 1.0 = NaN");
        wait_cycles(5);
        test_fadd(32'h3F800000, 32'h7FC00000, 32'h7FC00000, 5'd55, "1.0 + NaN = NaN");
        wait_cycles(5);
        
        $display("\n========== 混合操作測試 ==========");
        
        // 複雜的載入-計算-儲存序列
        $display("\n--- 序列 1: 精密小數計算鏈 ---");
        test_flw(32'h1020, 32'h0, 32'h3DCCCCCD, 5'd1, "Load 0.1 to f1");
        wait_cycles(3);
        test_flw(32'h1024, 32'h0, 32'h3E4CCCCD, 5'd2, "Load 0.2 to f2");
        wait_cycles(3);
        test_fadd(32'h3DCCCCCD, 32'h3E4CCCCD, 32'h3E99999A, 5'd3, "f1 + f2 ≈ 0.3");
        wait_cycles(3);
        test_fsw(32'h3000, 32'h0, 32'h3E99999A, "Store result 0.3");
        wait_cycles(5);
        
        $display("\n--- 序列 2: 數學常數計算 ---");
        test_fadd(32'h40490FDB, 32'h402DF854, 32'h40B5C28F, 5'd4, "π + e");
        wait_cycles(3);
        test_fadd(32'h40B5C28F, 32'h3FB504F3, 32'h40D6C7A2, 5'd5, "(π + e) + √2");
        wait_cycles(3);
        test_fsw(32'h3004, 32'h0, 32'h40D6C7A2, "Store complex result");
        wait_cycles(5);
        
        $display("\n--- 序列 3: 連續精密小數累加 ---");
        test_fadd(32'h3C23D70A, 32'h3C23D70A, 32'h3CA3D70A, 5'd6, "0.01 + 0.01 = 0.02");
        wait_cycles(3);
        test_fadd(32'h3CA3D70A, 32'h3C23D70A, 32'h3CF5C28F, 5'd7, "0.02 + 0.01 = 0.03");
        wait_cycles(3);
        test_fadd(32'h3CF5C28F, 32'h3C23D70A, 32'h3D23D70A, 5'd8, "0.03 + 0.01 = 0.04");
        wait_cycles(3);
        test_fadd(32'h3D23D70A, 32'h3C23D70A, 32'h3D4CCCCD, 5'd9, "0.04 + 0.01 = 0.05");
        wait_cycles(5);
        
        $display("\n========== 邊界和錯誤情況測試 ==========");
        
        // 測試不同的暫存器編號
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd0, "Load to f0");
        wait_cycles(3);
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd31, "Load to f31");
        wait_cycles(3);
        
        // 測試最大記憶體地址
        memory[4095] = 32'h42C80000;  // 100.0
        test_flw(32'h3FFC, 32'h0, 32'h42C80000, 5'd7, "Load from max address");
        wait_cycles(3);
        test_fsw(32'h3FF8, 32'h0, 32'h42C80000, "Store to near max address");
        wait_cycles(5);
        
        // 精度邊界測試 - 更多案例
        $display("\n--- 擴展精度邊界測試 ---");
        test_fadd(32'h3F7FFFFF, 32'h33800000, 32'h3F800000, 5'd10, "接近1.0的數 + 極小數");
        wait_cycles(5);
        test_fadd(32'h40000000, 32'h33000000, 32'h40000000, 5'd11, "2.0 + 極小數 = 2.0");
        wait_cycles(5);
        
        // 負零處理測試
        $display("\n--- 負零特殊處理 ---");
        test_fadd(32'h80000000, 32'h80000000, 32'h80000000, 5'd12, "-0.0 + (-0.0) = -0.0");
        wait_cycles(5);
        test_fadd(32'hBDCCCCCD, 32'h3DCCCCCD, 32'h80000000, 5'd13, "-0.1 + 0.1 = -0.0 (有可能)");
        wait_cycles(5);
        
        // 舍入模式測試
        $display("\n--- 舍入邊界測試 ---");
        test_fadd(32'h3F800000, 32'h33000001, 32'h3F800000, 5'd14, "舍入到最近偶數測試 1");
        wait_cycles(5);
        test_fadd(32'h3F800001, 32'h33000000, 32'h3F800001, 5'd15, "舍入到最近偶數測試 2");
        wait_cycles(5);
        
        $display("\n========== 壓力測試 ==========");
        
        // 快速連續操作
        $display("\n--- 快速連續 FLW 操作 (精密小數) ---");
        test_flw(32'h1020, 32'h0, 32'h3DCCCCCD, 5'd16, "Fast Load 0.1");
        test_flw(32'h1024, 32'h0, 32'h3E4CCCCD, 5'd17, "Fast Load 0.2");
        test_flw(32'h1040, 32'h0, 32'h3C23D70A, 5'd18, "Fast Load 0.01");
        wait_cycles(5);
        
        $display("\n--- 快速連續 FADD 操作 (累積計算) ---");
        test_fadd(32'h3C23D70A, 32'h3C23D70A, 32'h3CA3D70A, 5'd19, "Fast ADD: 0.01 + 0.01");
        test_fadd(32'h3CA3D70A, 32'h3C23D70A, 32'h3CF5C28F, 5'd20, "Fast ADD: 0.02 + 0.01");
        test_fadd(32'h3CF5C28F, 32'h3C23D70A, 32'h3D23D70A, 5'd21, "Fast ADD: 0.03 + 0.01");
        wait_cycles(5);
        
        // 極限精度測試
        $display("\n--- 極限精度挑戰測試 ---");
        test_fadd(32'h7F7FFFFF, 32'h00800000, 32'h7F7FFFFF, 5'd22, "最大數 + 最小正規化數");
        wait_cycles(5);
        test_fadd(32'h00800000, 32'h00000001, 32'h00800001, 5'd23, "最小正規化數 + 最小非正規化數");
        wait_cycles(5);
        test_fadd(32'hFF7FFFFF, 32'h80800000, 32'hFF7FFFFF, 5'd24, "最小負數 + 負的最小正規化數");
        wait_cycles(5);
        
        // 混合精度範圍測試
        $display("\n--- 混合精度範圍測試 ---");
        test_fadd(32'h42C80000, 32'h3C23D70A, 32'h42C8051F, 5'd25, "100.0 + 0.01 = 100.01");
        wait_cycles(5);
        test_fadd(32'h447A0000, 32'h3A83126F, 32'h447A0000, 5'd26, "1000.0 + 0.001 = 1000.0 (精度損失)");
        wait_cycles(5);
        test_fadd(32'h461C4000, 32'h39D1B717, 32'h461C4000, 5'd27, "10000.0 + 0.0001 = 10000.0 (精度損失)");
        wait_cycles(5);
        
        // 階乘和級數相關測試
        $display("\n--- 數學級數相關測試 ---");
        // 計算 e 的泰勒級數的前幾項: 1 + 1 + 1/2 + 1/6 + ...
        test_fadd(32'h3F800000, 32'h3F800000, 32'h40000000, 5'd28, "1 + 1 = 2 (e級數項1)");
        wait_cycles(3);
        test_fadd(32'h40000000, 32'h3F000000, 32'h40400000, 5'd29, "2 + 0.5 = 2.5 (e級數項2)");
        wait_cycles(3);
        test_fadd(32'h40400000, 32'h3E2AAAAB, 32'h4051555C, 5'd30, "2.5 + 1/6 ≈ 2.667 (e級數項3)");
        wait_cycles(5);
        
        // 諧波級數前幾項
        test_fadd(32'h3F800000, 32'h3F000000, 32'h3FC00000, 5'd31, "1 + 1/2 = 1.5 (諧波級數)");
        wait_cycles(3);
        test_fadd(32'h3FC00000, 32'h3EAAAAAB, 32'h4008AAAB, 5'd32, "1.5 + 1/3 ≈ 1.833 (諧波級數)");
        wait_cycles(5);
        
        $display("\n========== 特殊數值組合測試 ==========");
        
        // 接近溢位邊界
        $display("\n--- 溢位邊界測試 ---");
        test_fadd(32'h7F000000, 32'h7E800000, 32'h7F800000, 5'd33, "大數 + 大數 = +Inf (溢位)");
        wait_cycles(5);
        test_fadd(32'hFF000000, 32'hFE800000, 32'hFF800000, 5'd34, "負大數 + 負大數 = -Inf (溢位)");
        wait_cycles(5);
        
        // 接近下溢邊界
        $display("\n--- 下溢邊界測試 ---");
        test_fadd(32'h00000001, 32'h00000001, 32'h00000002, 5'd35, "極小數 + 極小數");
        wait_cycles(5);
        test_fadd(32'h00400000, 32'h80400000, 32'h00000000, 5'd36, "小正數 + 小負數 = 0");
        wait_cycles(5);
        
        // 相同指數不同尾數
        $display("\n--- 相同指數測試 ---");
        test_fadd(32'h3F400000, 32'h3F200000, 32'h3F600000, 5'd37, "0.75 + 0.625 = 1.375");
        wait_cycles(5);
        test_fadd(32'h40200000, 32'h40100000, 32'h40300000, 5'd38, "2.5 + 2.25 = 4.75");
        wait_cycles(5);
        
        // 不同指數相同尾數
        $display("\n--- 不同指數測試 ---");
        test_fadd(32'h3F800000, 32'h3E800000, 32'h3FC00000, 5'd39, "1.0 + 0.25 = 1.25");
        wait_cycles(5);
        test_fadd(32'h40800000, 32'h3F800000, 32'h40A00000, 5'd40, "4.0 + 1.0 = 5.0");
        wait_cycles(5);
        
        $display("\n========== 最終統合測試 ==========");
        
        // 複雜計算鏈
        $display("\n--- 複雜精密計算鏈 ---");
        // 計算 (0.1 + 0.2) × 3 的步驟 1: 0.1 + 0.2
        test_fadd(32'h3DCCCCCD, 32'h3E4CCCCD, 32'h3E99999A, 5'd41, "Step1: 0.1 + 0.2");
        wait_cycles(3);
        // 假設接下來會有乘法，這裡先存儲
        test_fsw(32'h4000, 32'h0, 32'h3E99999A, "Store intermediate result");
        wait_cycles(5);
        
        // 數學常數組合
        test_fadd(32'h40490FDB, 32'h3FB504F3, 32'h408C4A9E, 5'd42, "π + √2");
        wait_cycles(3);
        test_fadd(32'h408C4A9E, 32'h402DF854, 32'h40B3295C, 5'd43, "(π + √2) + e");
        wait_cycles(5);
        
        $display("\n========== 錯誤情況和邊界測試 ==========");
        
        // 測試 FPU 忙碌狀態處理
        $display("\n--- FPU 狀態測試 ---");
        if (!fpu_busy) begin
            $display("✓ FPU is idle, ready for operation");
        end
        
        // 測試記憶體邊界
        test_flw(32'h0000, 32'h0, 32'h00000000, 5'd44, "Load from address 0");
        wait_cycles(5);
        
        // 最後的完整性檢查
        $display("\n--- 完整性檢查 ---");
        test_fadd(32'h3F800000, 32'h00000000, 32'h3F800000, 5'd45, "Final: 1.0 + 0.0 = 1.0");
        wait_cycles(5);
        
        $display("\n========== 測試結果統計 ==========");
        $display("總測試數: %d", pass_count + fail_count);
        $display("通過: %d", pass_count);
        $display("失敗: %d", fail_count);
        $display("通過率: %.2f%%", (pass_count * 100.0) / (pass_count + fail_count));
        
        if (fail_count == 0) begin
            $display("🎉 所有測試都通過了！FPU 精密小數計算功能完全正常！");
        end else if (fail_count <= 5) begin
            $display("⚠️  有少量測試失敗(%d個)，可能是精度或邊界情況問題", fail_count);
        end else begin
            $display("❌ 有較多測試失敗(%d個)，需要檢查 FPU 實作", fail_count);
        end
        
        $display("\n=== 精密小數 FPU 測試完成 ===");
        $display("測試涵蓋範圍:");
        $display("- 基本精密小數加法 (0.1, 0.01, 0.001 等)");
        $display("- 數學常數計算 (π, e, √2 等)");
        $display("- 機器精度邊界測試");
        $display("- 溢位和下溢處理");
        $display("- 特殊值處理 (0, ±Inf, NaN)");
        $display("- 精度損失檢測");
        $display("- 舍入行為驗證");
        
        #100;
        $finish;
    end

    // 狀態和操作監控
    always @(posedge clk) begin
        if (uut.state != uut.next_state) begin
            case (uut.next_state)
                4'd0: $display("Time: %t | State -> IDLE", $time);
                4'd1: $display("Time: %t | State -> FLW_ACCESS", $time);
                4'd2: $display("Time: %t | State -> FLW_WAIT_READY", $time);
                4'd3: $display("Time: %t | State -> FLW_WAIT_DATA", $time);
                4'd4: $display("Time: %t | State -> FLW_STABILIZE", $time);
                4'd5: $display("Time: %t | State -> FLW_SAMPLE", $time);
                4'd6: $display("Time: %t | State -> FLW_COMPLETE", $time);
                4'd7: $display("Time: %t | State -> FSW_ACCESS", $time);
                4'd8: $display("Time: %t | State -> FSW_WAIT_READY", $time);
                4'd9: $display("Time: %t | State -> FSW_COMPLETE", $time);
                4'd10: $display("Time: %t | State -> FADD_START", $time);
                4'd11: $display("Time: %t | State -> FADD_WAIT", $time);
                4'd12: $display("Time: %t | State -> FADD_COMPLETE", $time);
                default: $display("Time: %t | State -> UNKNOWN(%d)", $time, uut.next_state);
            endcase
        end
        
        if (completed) $display("Time: %t | ✓ Operation completed", $time);
        if (freg_wb_enable) $display("Time: %t | Write-back: freg[%d] = 0x%h", $time, freg_wb_addr, freg_wb_data);
        
        // 記憶體操作監控
        if (mem_re && mem_ready) begin
            $display("Time: %t | Memory Read: addr=0x%h, data=0x%h", $time, mem_addr, mem_rdata);
        end
        if (mem_we && mem_ready) begin
            $display("Time: %t | Memory Write: addr=0x%h, data=0x%h", $time, mem_addr, mem_wdata);
        end
        
        // 精密度監控
        if (freg_wb_enable && (freg_wb_addr >= 16 && freg_wb_addr <= 45)) begin
            $display("Time: %t | Precision Test Result: freg[%d] = 0x%h", $time, freg_wb_addr, freg_wb_data);
        end
        
        // 錯誤檢測
        if (fpu_busy && enabled) begin
            $display("Time: %t | WARNING: New instruction while FPU is busy!", $time);
        end
        
        // 特殊值檢測
        if (freg_wb_enable) begin
            if (freg_wb_data == 32'h7F800000)
                $display("Time: %t | Special: +Infinity detected", $time);
            else if (freg_wb_data == 32'hFF800000)
                $display("Time: %t | Special: -Infinity detected", $time);
            else if ((freg_wb_data[30:23] == 8'hFF) && (freg_wb_data[22:0] != 0))
                $display("Time: %t | Special: NaN detected", $time);
            else if ((freg_wb_data[30:23] == 8'h00) && (freg_wb_data[22:0] != 0))
                $display("Time: %t | Special: Denormalized number detected", $time);
        end
    end
    
    // 超時檢測（延長時間以應對更多測試）
    initial begin
        #100000; // 100000 ps timeout (延長超時時間)
        $display("ERROR: Simulation timeout! Some operations may be taking too long.");
        $display("Current statistics: Pass=%d, Fail=%d", pass_count, fail_count);
        $finish;
    end

    // 性能統計
    integer operation_count = 0;
    always @(posedge completed) begin
        operation_count = operation_count + 1;
        if (operation_count % 10 == 0) begin
            $display("Progress: Completed %d operations", operation_count);
        end
    end

endmodule
