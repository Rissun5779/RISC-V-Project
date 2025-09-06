module adder2 (
    A,
    B,

    res
);
  input wire [2:0] A;
  input wire [2:0] B;

  output wire [3:0] res;

  assign res = A + B;
endmodule
