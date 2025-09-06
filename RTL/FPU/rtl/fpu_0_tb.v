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
        
        // 小數
        memory[32'h1014 >> 2] = 32'h3F000000;  // 0.5
        memory[32'h1018 >> 2] = 32'h3E800000;  // 0.25
        memory[32'h101C >> 2] = 32'h3F400000;  // 0.75
        
        // 負數
        memory[32'h1020 >> 2] = 32'hBF800000;  // -1.0
        memory[32'h1024 >> 2] = 32'hC0000000;  // -2.0
        memory[32'h1028 >> 2] = 32'hC0400000;  // -3.0
        
        // 特殊值
        memory[32'h1030 >> 2] = 32'h00000000;  // +0.0
        memory[32'h1034 >> 2] = 32'h80000000;  // -0.0
        memory[32'h1038 >> 2] = 32'h7F800000;  // +Infinity
        memory[32'h103C >> 2] = 32'hFF800000;  // -Infinity
        memory[32'h1040 >> 2] = 32'h7FC00000;  // NaN
        
        // 非常小的數 (denormalized)
        memory[32'h1044 >> 2] = 32'h00000001;  // 最小正非規格化數
        memory[32'h1048 >> 2] = 32'h007FFFFF;  // 最大非規格化數
        
        // 非常大的數
        memory[32'h104C >> 2] = 32'h7F7FFFFF;  // 最大正規格化數
        memory[32'h1050 >> 2] = 32'hFF7FFFFF;  // 最小負規格化數
        
        $display("\n========== FLW INSTRUCTION TESTS ==========");
        
        // 基本 FLW 測試
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd1, "Load 1.0");
        wait_cycles(5);
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd2, "Load 2.0");
        wait_cycles(5);
        test_flw(32'h1000, 32'h8, 32'h40400000, 5'd3, "Load 3.0");
        wait_cycles(5);
        
        // 小數測試
        test_flw(32'h1014, 32'h0, 32'h3F000000, 5'd4, "Load 0.5");
        wait_cycles(5);
        test_flw(32'h1018, 32'h0, 32'h3E800000, 5'd5, "Load 0.25");
        wait_cycles(5);
        
        // 負數測試
        test_flw(32'h1020, 32'h0, 32'hBF800000, 5'd6, "Load -1.0");
        wait_cycles(5);
        test_flw(32'h1024, 32'h0, 32'hC0000000, 5'd7, "Load -2.0");
        wait_cycles(5);
        
        // 特殊值測試
        test_flw(32'h1030, 32'h0, 32'h00000000, 5'd8, "Load +0.0");
        wait_cycles(5);
        test_flw(32'h1034, 32'h0, 32'h80000000, 5'd9, "Load -0.0");
        wait_cycles(5);
        test_flw(32'h1038, 32'h0, 32'h7F800000, 5'd10, "Load +Infinity");
        wait_cycles(5);
        test_flw(32'h103C, 32'h0, 32'hFF800000, 5'd11, "Load -Infinity");
        wait_cycles(5);
        test_flw(32'h1040, 32'h0, 32'h7FC00000, 5'd12, "Load NaN");
        wait_cycles(5);
        
        // 邊界值測試
        test_flw(32'h1044, 32'h0, 32'h00000001, 5'd13, "Load Min Denormalized");
        wait_cycles(5);
        test_flw(32'h1048, 32'h0, 32'h007FFFFF, 5'd14, "Load Max Denormalized");
        wait_cycles(5);
        test_flw(32'h104C, 32'h0, 32'h7F7FFFFF, 5'd15, "Load Max Normalized");
        wait_cycles(5);
        
        $display("\n========== FSW INSTRUCTION TESTS ==========");
        
        // 基本 FSW 測試
        test_fsw(32'h2000, 32'h0, 32'h3F800000, "Store 1.0");
        wait_cycles(5);
        test_fsw(32'h2000, 32'h4, 32'h40000000, "Store 2.0");
        wait_cycles(5);
        test_fsw(32'h2000, 32'h8, 32'hBF800000, "Store -1.0");
        wait_cycles(5);
        
        // 特殊值儲存
        test_fsw(32'h2010, 32'h0, 32'h00000000, "Store +0.0");
        wait_cycles(5);
        test_fsw(32'h2010, 32'h4, 32'h80000000, "Store -0.0");
        wait_cycles(5);
        test_fsw(32'h2010, 32'h8, 32'h7F800000, "Store +Infinity");
        wait_cycles(5);
        test_fsw(32'h2010, 32'hC, 32'hFF800000, "Store -Infinity");
        wait_cycles(5);
        test_fsw(32'h2010, 32'h10, 32'h7FC00000, "Store NaN");
        wait_cycles(5);
        
        // 邊界值儲存
        test_fsw(32'h2020, 32'h0, 32'h7F7FFFFF, "Store Max Float");
        wait_cycles(5);
        test_fsw(32'h2020, 32'h4, 32'h00000001, "Store Min Denorm");
        wait_cycles(5);
        
        $display("\n========== FADD INSTRUCTION TESTS ==========");
        
        // 基本加法測試
        test_fadd(32'h3F800000, 32'h40000000, 32'h40400000, 5'd16, "1.0 + 2.0 = 3.0");
        wait_cycles(5);
        test_fadd(32'h40000000, 32'h40400000, 32'h40A00000, 5'd17, "2.0 + 3.0 = 5.0");
        wait_cycles(5);
        test_fadd(32'h3F000000, 32'h3F000000, 32'h3F800000, 5'd18, "0.5 + 0.5 = 1.0");
        wait_cycles(5);
        
        // 減法測試 (負數加法)
        test_fadd(32'h40400000, 32'hBF800000, 32'h40000000, 5'd19, "3.0 + (-1.0) = 2.0");
        wait_cycles(5);
        test_fadd(32'h3F800000, 32'hBF800000, 32'h00000000, 5'd20, "1.0 + (-1.0) = 0.0");
        wait_cycles(5);
        
        // 零值測試
        test_fadd(32'h3F800000, 32'h00000000, 32'h3F800000, 5'd21, "1.0 + 0.0 = 1.0");
        wait_cycles(5);
        test_fadd(32'h00000000, 32'h00000000, 32'h00000000, 5'd22, "0.0 + 0.0 = 0.0");
        wait_cycles(5);
        test_fadd(32'h00000000, 32'h80000000, 32'h00000000, 5'd23, "+0.0 + (-0.0) = +0.0");
        wait_cycles(5);
        
        // 無窮大測試
        test_fadd(32'h7F800000, 32'h3F800000, 32'h7F800000, 5'd24, "+Inf + 1.0 = +Inf");
        wait_cycles(5);
        test_fadd(32'hFF800000, 32'h3F800000, 32'hFF800000, 5'd25, "-Inf + 1.0 = -Inf");
        wait_cycles(5);
        test_fadd(32'h7F800000, 32'h7F800000, 32'h7F800000, 5'd26, "+Inf + +Inf = +Inf");
        wait_cycles(5);
        test_fadd(32'h7F800000, 32'hFF800000, 32'h7FC00000, 5'd27, "+Inf + (-Inf) = NaN");
        wait_cycles(5);
        
        // NaN 測試
        test_fadd(32'h7FC00000, 32'h3F800000, 32'h7FC00000, 5'd28, "NaN + 1.0 = NaN");
        wait_cycles(5);
        test_fadd(32'h3F800000, 32'h7FC00000, 32'h7FC00000, 5'd29, "1.0 + NaN = NaN");
        wait_cycles(5);
        
        // 非規格化數測試
        test_fadd(32'h00000001, 32'h00000001, 32'h00000002, 5'd30, "Min_Denorm + Min_Denorm");
        wait_cycles(5);
        
        // 大數加法測試
        test_fadd(32'h7F000000, 32'h7F000000, 32'h7F800000, 5'd31, "Large + Large = Overflow to Inf");
        wait_cycles(5);
        
        $display("\n========== 混合操作測試 ==========");
        
        // 複雜的載入-計算-儲存序列
        $display("\n--- 序列 1: 載入兩個數，相加，儲存結果 ---");
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd1, "Load 1.0 to f1");
        wait_cycles(3);
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd2, "Load 2.0 to f2");
        wait_cycles(3);
        test_fadd(32'h3F800000, 32'h40000000, 32'h40400000, 5'd3, "f1 + f2 = 3.0");
        wait_cycles(3);
        test_fsw(32'h3000, 32'h0, 32'h40400000, "Store result 3.0");
        wait_cycles(5);
        
        $display("\n--- 序列 2: 連續加法 ---");
        test_fadd(32'h3F800000, 32'h3F800000, 32'h40000000, 5'd4, "1.0 + 1.0 = 2.0");
        wait_cycles(3);
        test_fadd(32'h40000000, 32'h3F800000, 32'h40400000, 5'd5, "2.0 + 1.0 = 3.0");
        wait_cycles(3);
        test_fadd(32'h40400000, 32'h3F800000, 32'h40800000, 5'd6, "3.0 + 1.0 = 4.0");
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
        
        // 精度測試
        test_fadd(32'h3F800000, 32'h33800000, 32'h3F800000, 5'd8, "1.0 + very_small (precision test)");
        wait_cycles(5);
        
        $display("\n========== 壓力測試 ==========");
        
        // 快速連續操作
        $display("\n--- 快速連續 FLW 操作 ---");
        test_flw(32'h1000, 32'h0, 32'h3F800000, 5'd10, "Fast FLW 1");
        test_flw(32'h1000, 32'h4, 32'h40000000, 5'd11, "Fast FLW 2");
        test_flw(32'h1000, 32'h8, 32'h40400000, 5'd12, "Fast FLW 3");
        wait_cycles(5);
        
        $display("\n--- 快速連續 FADD 操作 ---");
        test_fadd(32'h3F800000, 32'h3F800000, 32'h40000000, 5'd13, "Fast FADD 1");
        test_fadd(32'h40000000, 32'h3F800000, 32'h40400000, 5'd14, "Fast FADD 2");
        test_fadd(32'h40400000, 32'h3F800000, 32'h40800000, 5'd15, "Fast FADD 3");
        wait_cycles(10);
        
        $display("\n========== 測試結果統計 ==========");
        $display("總測試數: %d", pass_count + fail_count);
        $display("通過: %d", pass_count);
        $display("失敗: %d", fail_count);
        if (fail_count == 0) begin
            $display("🎉 所有測試都通過了！");
        end else begin
            $display("⚠️  有 %d 個測試失敗", fail_count);
        end
        
        $display("\n=== 測試完成 ===");
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
        
        // 錯誤檢測
        if (fpu_busy && enabled) begin
            $display("Time: %t | WARNING: New instruction while FPU is busy!", $time);
        end
    end
    
    // 超時檢測
    initial begin
        #50000; // 50000 ps timeout
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule