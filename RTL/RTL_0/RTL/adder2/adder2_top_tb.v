module adder2_top_tb;

  reg  [2:0] A;
  reg  [2:0] B;
  wire [3:0] res;

  adder2_top uut (
      .A  (A),
      .B  (B),
      .res(res)
  );

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, adder2_top_tb);

    // 初始化
    A = 0;
    B = 0;
    #10;

    // 測試案例
    // TODO: Add stimulus here
    #100;
    $finish;
  end

endmodule
