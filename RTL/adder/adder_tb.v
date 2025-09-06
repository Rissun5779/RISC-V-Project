module adder_tb;

    reg [2:0] a;
    reg [2:0] b;
    wire [3:0] res;

    adder uut (
        .a(a),
        .b(b),
        .res(res)
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, adder_tb);

        // 初始化
        a = 0;
        b = 0;
        #10;
        $display("the result %d + %d is:", a, b, res);


        a = 2;
        #10;
        $display("the result %d + %d is:", a, b, res);

        b = 1;
        // 測試案例
        // TODO: Add stimulus here
        #100;
        $display("the result %d + %d is:", a, b, res);
        $finish;
    end

endmodule