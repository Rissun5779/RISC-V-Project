module adder (
    a,
    b,

    res
);
    input  [2:0] a;
    input  [2:0] b;

    output [3:0] res;

    assign res = a+b;
endmodule