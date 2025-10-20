`default_nettype none

module fmul(
    input  wire [31:0] x1,
    input  wire [31:0] x2,
    output wire [31:0] y,
    output wire        ovf
);
    // 1. 取指數部分
    wire [7:0] e1 = x1[30:23];
    wire [7:0] e2 = x2[30:23];

    // 2. 計算尾數相乘 (mantissa multiplication)
    wire [47:0] mye = {1'b1, x1[22:0]} * {1'b1, x2[22:0]};

    // 3. 計算結果指數
    // 如果最高位47為1 或者位46到22都是1，指數加總後減126，否則減127
    wire [9:0] ey = (mye[47] || &mye[46:22]) ?
                     {2'b0, e1} + {2'b0, e2} - 10'd126 :
                     {2'b0, e1} + {2'b0, e2} - 10'd127;

    // 4. 計算尾數 (mantissa)
    wire [22:0] my = (mye[47]) ?
                      ((&mye[46:23]) ? 23'b0 :
                       (mye[23] && (mye[24] || |mye[22:0])) ? mye[46:24] + 23'b1 : mye[46:24]) :
                      ((&mye[45:22]) ? 23'b0 :
                       (mye[22] && (mye[23] || |mye[21:0])) ? mye[45:23] + 23'b1 : mye[45:23]);

    // 5. 計算符號
    wire sy = x1[31] ^ x2[31];

    // 6. 組合輸出
    assign y = (~&e1 && ~&e2 && ~|ey && &mye[46:23]) ?
               {sy, 8'b1, 23'b0} :      // 尾數全1導致進位，指數變為1
               (~&e1 && ~&e2 && (ey[9] || ~|ey)) ?
               {sy, 31'b0} :            // 指數為0，輸出零
               (~&e1 && ~&e2 && ey[8]) ?
               {sy, 8'd255, 23'b0} :    // overflow，輸出無限大
               {sy, ey[7:0], my};       // 正常情況

    // 7. 計算溢位訊號
    assign ovf = (~&e1 && ~&e2 && ~ey[9] && ey[8]) ? 1'b1 : 1'b0;

endmodule

`default_nettype wire
