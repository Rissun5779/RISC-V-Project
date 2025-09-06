`timescale 1ns/1ps

module fpu_tb;

    // Clock and Reset
    reg clk;
    reg rst_n;
    reg enabled;

    // FPU Instructions
    reg instr_flw;
    reg instr_fsw;
    reg instr_fadd;
    reg instr_fdiv;
    reg instr_fmul;
    
    // Registers and immediate values
    reg [31:0] reg_rs1;
    reg [31:0] reg_rs2;
    reg [31:0] freg_rs1;
    reg [31:0] freg_rs2;
    reg [31:0] imm;
    
    // Memory Interface
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg [31:0] mem_rdata;
    wire mem_we;
    wire mem_re;
    reg mem_ready;
    
    // FPU outputs
    wire completed;
    wire [31:0] result;

    // FPU Instance
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
        .freg_rs1(freg_rs1),
        .freg_rs2(freg_rs2),
        .imm(imm),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .mem_we(mem_we),
        .mem_re(mem_re),
        .mem_ready(mem_ready),
        .completed(completed),
        .result(result)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Simple memory model
    reg [31:0] memory [0:2047];
    always @(posedge clk) begin
        if (mem_we) begin
            $display("Time %0t: Memory Write: memory[0x%03x] <= 0x%08x", $time, mem_addr[10:0], mem_wdata);
            memory[mem_addr[10:0]] <= mem_wdata;
        end
    end
    always @(posedge clk) begin
    if (mem_re) begin
        mem_rdata <= memory[mem_addr[10:0]];
        $display("Time %0t: Memory Read: memory[0x%03x] => 0x%08x", $time, mem_addr[10:0], memory[mem_addr[10:0]]);
        end
    end
    
    // Test stimulus
    initial begin
        $dumpfile("fpu_tb.vcd");
        $dumpvars(0, fpu_tb);

        // Initialize all signals
        clk = 0;
        rst_n = 0;
        enabled = 0;
        instr_flw = 0;
        instr_fsw = 0;
        instr_fadd = 0;
        instr_fdiv = 0;
        instr_fmul = 0;
        reg_rs1 = 0;
        reg_rs2 = 0;
        freg_rs1 = 0;
        freg_rs2 = 0;
        imm = 0;
        mem_rdata = 0;
        mem_ready = 0;
        
        // Reset sequence
        #20;
        rst_n = 1;
        #10;
        
        $display("\n============================================================");
        $display("                  FPU 測試平台開始");
        $display("============================================================\n");
        
        // --- Test FSW: Store 123.45 to memory address 0x400 ---
        $display("--- 測試 FSW: 儲存 123.45 到記憶體位址 0x400 ---");
        $display("    - 預期結果: 記憶體[0x400] = 0x42f6e666");
        enabled = 1;
        instr_fsw = 1;
        reg_rs1 = 32'h00000400; // Base address
        imm = 32'd0;            // Immediate offset
        freg_rs1 = 32'h42f6e666; // 123.45 in hex
        #10;                    // Delay to ensure setup
        mem_ready = 1;
        wait(completed);        // Wait for the completed signal from FPU
        #10;
        if (memory[reg_rs1[10:0]] === freg_rs1) begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (通過)", reg_rs1[10:0], memory[reg_rs1[10:0]]);
        end else begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (失敗)", reg_rs1[10:0], memory[reg_rs1[10:0]]);
        end
        enabled = 0; instr_fsw = 0; mem_ready = 0; #20;

        // --- Test FLW: Load float from memory address 0x400 ---
        $display("\n--- 測試 FLW: 從記憶體位址 0x400 載入浮點數 ---");
        $display("    - 預期結果: result = 0x42f6e666");
        enabled = 1;
        instr_flw = 1;
        reg_rs1 = 32'h00000400; // Base address
        imm = 32'd0;            // Immediate offset
        #10;                    // Delay to ensure setup
        mem_ready = 1;
        wait(completed);        // Wait for the completed signal from FPU
        #10;
        if (result === 32'h42f6e666) begin
            $display("    - 實際結果: result = 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: result = 0x%08x (失敗)", result);
        end
        enabled = 0; instr_flw = 0; mem_ready = 0; #20;
        
        // ------------------- 新增的 FSW/FLW 測試 -------------------

        // --- Test FSW with offset: Store -987.65 to 0x400 + 4 = 0x404 ---
        $display("\n--- 測試 FSW: 儲存 -987.65 到記憶體位址 0x404 (含偏移量) ---");
        $display("    - 預期結果: 記憶體[0x404] = 0xC477619a");
        enabled = 1;
        instr_fsw = 1;
        reg_rs1 = 32'h00000400;   // Base address
        imm = 32'd4;              // Offset of 4 bytes
        freg_rs1 = 32'hC477619a;  // -987.65 in hex
        #10;
        mem_ready = 1;
        wait(completed);
        #10;
        if (memory[reg_rs1[10:0] + imm[10:0]] === freg_rs1) begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (通過)", reg_rs1[10:0] + imm[10:0], memory[reg_rs1[10:0] + imm[10:0]]);
        end else begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (失敗)", reg_rs1[10:0] + imm[10:0], memory[reg_rs1[10:0] + imm[10:0]]);
        end
        enabled = 0; instr_fsw = 0; mem_ready = 0; #20;

        // --- Test FLW with offset: Load -987.65 from 0x400 + 4 = 0x404 ---
        $display("\n--- 測試 FLW: 從記憶體位址 0x404 載入浮點數 (含偏移量) ---");
        $display("    - 預期結果: result = 0xC477619a");
        enabled = 1;
        instr_flw = 1;
        reg_rs1 = 32'h00000400; // Base address
        imm = 32'd4;            // Offset of 4 bytes
        #10;
        mem_ready = 1;
        wait(completed);
        #10;
        if (result === 32'hC477619a) begin
            $display("    - 實際結果: result = 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: result = 0x%08x (失敗)", result);
        end
        enabled = 0; instr_flw = 0; mem_ready = 0; #20;

        // --- Test FSW to a new address: Store 3.14 to 0x800 ---
        $display("\n--- 測試 FSW: 儲存 3.14 到新的記憶體位址 0x800 ---");
        $display("    - 預期結果: 記憶體[0x800] = 0x4048f5c3");
        enabled = 1;
        instr_fsw = 1;
        reg_rs1 = 32'h00000800; // New base address
        imm = 32'd0;
        freg_rs1 = 32'h4048f5c3;  // 3.14 in hex
        #10;
        mem_ready = 1;
        wait(completed);
        #10;
        if (memory[reg_rs1[10:0]] === freg_rs1) begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (通過)", reg_rs1[10:0], memory[reg_rs1[10:0]]);
        end else begin
            $display("    - 實際結果: 記憶體[0x%03x] = 0x%08x (失敗)", reg_rs1[10:0], memory[reg_rs1[10:0]]);
        end
        enabled = 0; instr_fsw = 0; mem_ready = 0; #20;

        // --- Test FLW from a new address: Load 3.14 from 0x800 ---
        $display("\n--- 測試 FLW: 從新的記憶體位址 0x800 載入浮點數 ---");
        $display("    - 預期結果: result = 0x4048f5c3");
        enabled = 1;
        instr_flw = 1;
        reg_rs1 = 32'h00000800; // New base address
        imm = 32'd0;
        #10;
        mem_ready = 1;
        wait(completed);
        #10;
        if (result === 32'h4048f5c3) begin
            $display("    - 實際結果: result = 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: result = 0x%08x (失敗)", result);
        end
        enabled = 0; instr_flw = 0; mem_ready = 0; #20;
        
        // ------------------- 結束新增的 FSW/FLW 測試 -------------------

        // --- Test 1: Basic addition (2.0 + 3.0 = 5.0) ---
        $display("\n--- 測試 1: 基本加法 (2.0 + 3.0 = 5.0) ---");
        $display("    - 預期結果: 0x40A00000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h40000000; // 2.0
        freg_rs2 = 32'h40400000; // 3.0
        wait(completed);
        #10;
        if (result === 32'h40A00000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 6: Positive + Negative addition (10.0 + (-5.0) = 5.0) ---
        $display("\n--- 測試 6: 正負數相加 (10.0 + (-5.0) = 5.0) ---");
        $display("    - 預期結果: 0x40A00000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h41200000; // 10.0
        freg_rs2 = 32'hC0A00000; // -5.0
        wait(completed);
        #10;
        if (result === 32'h40A00000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 7: Fractional addition (0.5 + 0.25 = 0.75) ---
        $display("\n--- 測試 7: 小數加法 (0.5 + 0.25 = 0.75) ---");
        $display("    - 預期結果: 0x3f400000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h3f000000; // 0.5
        freg_rs2 = 32'h3e800000; // 0.25
        wait(completed);
        #10;
        if (result === 32'h3f400000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 2: Negative addition (-1.5 + -2.5 = -4.0) ---
        $display("\n--- 測試 2: 負數加法 (-1.5 + -2.5 = -4.0) ---");
        $display("    - 預期結果: 0xC0800000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'hBFC00000; // -1.5
        freg_rs2 = 32'hC0200000; // -2.5
        wait(completed);
        #10;
        if (result === 32'hC0800000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 3: Zero addition (0.0 + 4.0 = 4.0) ---
        $display("\n--- 測試 3: 零加法 (0.0 + 4.5 = 4.5) ---");
        $display("    - 預期結果: 0x40800000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h00000000; // 0.0
        freg_rs2 = 32'h40800000; // 4.0
        wait(completed);
        #10;
        if (result === 32'h40800000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 4: Infinity addition (Infinity + 100.0 = Infinity) ---
        $display("\n--- 測試 4: 無窮大加法 (Infinity + 100.0 = Infinity) ---");
        $display("    - 預期結果: 0x7F800000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h7F800000; // +Infinity
        freg_rs2 = 32'h42C80000; // 100.0
        wait(completed);
        #10;
        if (result === 32'h7F800000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;

        // --- Test 5: NaN addition (NaN + 1.0 = NaN) ---
        $display("\n--- 測試 5: 非數 (NaN) 加法 (NaN + 1.0 = NaN) ---");
        $display("    - 預期結果: 0x7FC00000");
        enabled = 1;
        instr_fadd = 1;
        freg_rs1 = 32'h7FC00000; // Quiet NaN
        freg_rs2 = 32'h3F800000; // 1.0
        wait(completed);
        #10;
        if (result === 32'h7FC00000) begin
            $display("    - 實際結果: 0x%08x (通過)", result);
        end else begin
            $display("    - 實際結果: 0x%08x (失敗)", result);
        end
        enabled = 0; instr_fadd = 0; #20;
        
        $display("\n============================================================");
        $display("                  所有測試完成");
        $display("============================================================");
        #50;
        $finish;
    end
    
    // Monitor signals for debugging
    always @(posedge clk) begin
        if (enabled) begin
            $display("Time %0t: enabled=%b instr_flw=%b instr_fsw=%b instr_fadd=%b completed=%b result=0x%08x mem_addr=0x%08x mem_rdata=0x%08x mem_ready=%b", 
                        $time, enabled, instr_flw, instr_fsw, instr_fadd, completed, result, mem_addr, mem_rdata, mem_ready);
        end
    end
endmodule
