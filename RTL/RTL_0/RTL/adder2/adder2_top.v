module adder2_top (
    A,
    B,

    res
);

  input wire [2:0] A;
  input wire [2:0] B;

  output wire [3:0] res;

  adder2 uut (
      .A(A),
      .B(B),

      .res(res)
  );
endmodule
