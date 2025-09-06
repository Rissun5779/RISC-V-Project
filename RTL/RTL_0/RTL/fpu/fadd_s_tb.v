`timescale 1ns / 10ps

module fadd_s_tb;

    // 定義輸入輸出訊號
    reg [31:0] x1;
    reg [31:0] x2;
    reg clk;
    reg rst_n;
    reg enable_in;
    wire enable_out;
    wire [31:0] res;
    wire ovf;

    // 實例化 fadd 模組
    fadd_s uut (
        .x1(x1),
        .x2(x2),
        .clk(clk),
        .rst_n(rst_n),
        .enable_in(enable_in),
        .enable_out(enable_out),
        .y(res),
        .ovf(ovf)
    );

    // 時脈產生
    always #5 clk = ~clk;

    // 波形輸出
    initial begin
        $dumpfile("fadd_tb.vcd");
        $dumpvars(0, fadd_s_tb);
    end

    // 測試主程式
    initial begin
        // 初始化訊號
        clk = 0;
        rst_n = 1;
        enable_in = 0;

        #10 rst_n = 0; // reset
        #10 rst_n = 1;

        $display("-----------------------------------------");
        $display("Testing fadd module...");

        // ------------------------------
        // 測資 1: 2.5 + 1.5 = 4.0
        x1 = 32'h40200000;
        x2 = 32'h3fc00000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 1: 2.5 + 1.5 -> Expected: 0x40800000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        // ------------------------------
        // 測資 2: 10.0 + 0.125 = 10.125
        x1 = 32'h41200000;
        x2 = 32'h3e000000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 2: 10.0 + 0.125 -> Expected: 0x41220000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        // ------------------------------
        // 測資 3: 10.0 + (-5.0) = 5.0
        x1 = 32'h41200000;
        x2 = 32'hc0a00000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 3: 10.0 + (-5.0) -> Expected: 0x40a00000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        // ------------------------------
        // 測資 4: 2.0 + 2.0 = 4.0
        x1 = 32'h40000000;
        x2 = 32'h40000000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 4: 2.0 + 2.0 -> Expected: 0x40800000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        // ------------------------------
        // 測資 5: 0.0 + 0.0 = 0.0
        x1 = 32'h0;
        x2 = 32'h0;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 5: 0.0 + 0.0 -> Expected: 0x00000000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        // ------------------------------
        // 測資 6: 大數相加
        x1 = 32'h42F75349;
        x2 = 32'h44232A62;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 6: 123.66 + 652.66 -> Expected: 0x444214CB, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");
        
        // ------------------------------
        // 測資 7: Infinity + 1.0 = Infinity
        x1 = 32'h7f800000;
        x2 = 32'h3f800000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 7: inf + 1.0 -> Expected: 0x7f800000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");
        
        // ------------------------------
        // 測資 8: NaN + 1.0 = NaN
        x1 = 32'h7fc00000;
        x2 = 32'h3f800000;
        enable_in = 1;
        #20;
        enable_in = 0;
        $display("Test Case 8: NaN + 1.0 -> Expected: 0x7fc00000, Actual: 0x%h, OVF: %b", res, ovf);
        $display("-----------------------------------------");

        #20;
        $finish;
    end
endmodule