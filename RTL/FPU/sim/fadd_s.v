module fadd_s(
    x1,
    x2,

    clk,
    rst_n,

    enable_in,
    enable_out,

    y,
    ovf
);
    // declare
    input [31:0] x1;
    input [31:0] x2;

    input clk;
    input rst_n;

    input  enable_in;
    output enable_out;

    output [31:0] y;
    output ovf;
    
    // preprocess
    /* IEEE-754 format
      bit31       bit30-23       bit22-0
      symbol(s)   exponent(e)    mantissa(m)
    */
    // x1
    wire symbol_init_x1 = x1[31];
    wire [7:0] exp_init_x1 = x1[30:23];
    wire [22:0] man_init_x1 = x1[22:0];
    // x2
    wire symbol_init_x2 = x2[31];
    wire [7:0] exp_init_x2 = x2[30:23];
    wire [22:0] man_init_x2 = x2[22:0];

    // extented
    wire [24:0] man_ext_x1 = (exp_init_x1 == 8'd0) ? {2'b0, man_init_x1} : {2'b1, man_init_x1};
    wire [24:0] man_ext_x2 = (exp_init_x2 == 8'd0) ? {2'b0, man_init_x2} : {2'b1, man_init_x2};

    // normalize_exp
    wire [7:0] exp_norm_x1 = (exp_init_x1 == 8'd0) ? {8'd1} : exp_init_x1;
    wire [7:0] exp_norm_x2 = (exp_init_x2 == 8'd0) ? {8'd1} : exp_init_x2;
    wire [7:0] exp_norm_x2_i = ~exp_norm_x2;
    
    // exponent diff
    wire [8:0] te_diff = {1'b0, exp_norm_x1} - {1'b0, exp_norm_x2};
    wire ce = (te_diff[8] == 1'b1) ? 1'b0 : 1'b1;
    wire [7:0] tde = (te_diff[8] == 1'b1) ? (~te_diff[7:0] + 8'd1) : te_diff[7:0];
    wire [4:0] de = (tde >= 8'd24) ? 5'd24 : tde[4:0];
    
    // sel => if sel=1 x1 is main, else x2 is main
    wire sel = (exp_norm_x2 > exp_norm_x1) ? 1'b1 :
               (exp_norm_x1 > exp_norm_x2) ? 1'b0 :
               (man_ext_x2 > man_ext_x1) ? 1'b1 : 1'b0;

    // Pipelining Stage 1
    reg [22:0] man_init_x1_st1;
    reg [22:0] man_init_x2_st1;
    reg [24:0] man_st1_x1;
    reg [24:0] man_st1_x2;
    reg symbol_st1_x1;
    reg symbol_st1_x2;
    reg [4:0] de_st1;
    reg sel_st1;
    reg [7:0] exp_init_x1_st1;
    reg [7:0] exp_init_x2_st1;
    reg [7:0] exp_st1_x1;
    reg [7:0] exp_st1_x2;
    reg enable_in_st1;

    always @(posedge clk) begin
        if (~rst_n) begin
            man_init_x1_st1 <= 23'd0;
            man_init_x2_st1 <= 23'd0;
            man_st1_x1 <= 25'd0;
            man_st1_x2 <= 25'd0;
            symbol_st1_x1 <= 1'b0;
            symbol_st1_x2 <= 1'b0;
            de_st1 <= 5'd0;
            sel_st1 <= 1'b0;
            exp_init_x1_st1 <= 8'd0;
            exp_init_x2_st1 <= 8'd0;
            exp_st1_x1 <= 8'd0;
            exp_st1_x2 <= 8'd0;
            enable_in_st1 <= 1'b0;
        end else begin
            man_init_x1_st1 <= man_init_x1;
            man_init_x2_st1 <= man_init_x2;
            man_st1_x1 <= man_ext_x1;
            man_st1_x2 <= man_ext_x2;
            symbol_st1_x1 <= symbol_init_x1;
            symbol_st1_x2 <= symbol_init_x2;
            de_st1 <= de;
            sel_st1 <= sel;
            exp_init_x1_st1 <= exp_init_x1;
            exp_init_x2_st1 <= exp_init_x2;
            exp_st1_x1 <= exp_norm_x1;
            exp_st1_x2 <= exp_norm_x2;
            enable_in_st1 <= enable_in;
        end
    end

    // sel significant and insignificant
    wire [24:0] man_signi     = (sel_st1 == 1'b0) ? man_st1_x1 : man_st1_x2;
    wire [24:0] man_insigni   = (sel_st1 == 1'b0) ? man_st1_x2 : man_st1_x1;
    wire [7:0] exp_signi      = (sel_st1 == 1'b0) ? exp_st1_x1 : exp_st1_x2;
    wire symbol_signi         = (sel_st1 == 1'b0) ? symbol_st1_x1 : symbol_st1_x2;
    wire symbol_insigni       = (sel_st1 == 1'b0) ? symbol_st1_x2 : symbol_st1_x1;

    // mantissa align
    wire [55:0] man_insigni_ext = {man_insigni, 31'd0};
    wire [55:0] man_signi_ext = {man_signi, 31'd0};
    wire [55:0] man_insigni_align = man_insigni_ext >> de_st1;

    // Sticky Bit process
    wire tstck = |(man_insigni_align[28:0]);

    // Addition and Subtraction
    // Using a wider datapath to handle mantissa overflow correctly
    wire [26:0] man_y_sum = (symbol_st1_x1 == symbol_st1_x2) ?
                            {man_signi, 2'b00} + man_insigni_align[55:29] :
                            {man_signi, 2'b00} - man_insigni_align[55:29];
    
    // Check for mantissa overflow
    wire man_overflow = man_y_sum[26];
    
    // Corrected exponent and mantissa after addition/subtraction, before normalization
    wire [7:0] exp_pre_norm = exp_signi + man_overflow;
    wire [26:0] man_pre_norm = man_overflow ? (man_y_sum >> 1) : man_y_sum;
    
    // Corrected sticky bit logic
    wire stck = (man_overflow) ? (man_y_sum[0] | tstck) : tstck;

    // normalized
    // search leading
    wire [4:0] search_leading_zeros;
    assign search_leading_zeros = (man_pre_norm[25] == 1'b1) ? 5'd0 :
                                   (man_pre_norm[24] == 1'b1) ? 5'd1 :
                                   (man_pre_norm[23] == 1'b1) ? 5'd2 :
                                   (man_pre_norm[22] == 1'b1) ? 5'd3 :
                                   (man_pre_norm[21] == 1'b1) ? 5'd4 :
                                   (man_pre_norm[20] == 1'b1) ? 5'd5 :
                                   (man_pre_norm[19] == 1'b1) ? 5'd6 :
                                   (man_pre_norm[18] == 1'b1) ? 5'd7 :
                                   (man_pre_norm[17] == 1'b1) ? 5'd8 :
                                   (man_pre_norm[16] == 1'b1) ? 5'd9 :
                                   (man_pre_norm[15] == 1'b1) ? 5'd10 :
                                   (man_pre_norm[14] == 1'b1) ? 5'd11 :
                                   (man_pre_norm[13] == 1'b1) ? 5'd12 :
                                   (man_pre_norm[12] == 1'b1) ? 5'd13 :
                                   (man_pre_norm[11] == 1'b1) ? 5'd14 :
                                   (man_pre_norm[10] == 1'b1) ? 5'd15 :
                                   (man_pre_norm[9] == 1'b1) ? 5'd16 :
                                   (man_pre_norm[8] == 1'b1) ? 5'd17 :
                                   (man_pre_norm[7] == 1'b1) ? 5'd18 :
                                   (man_pre_norm[6] == 1'b1) ? 5'd19 :
                                   (man_pre_norm[5] == 1'b1) ? 5'd20 :
                                   (man_pre_norm[4] == 1'b1) ? 5'd21 :
                                   (man_pre_norm[3] == 1'b1) ? 5'd22 :
                                   (man_pre_norm[2] == 1'b1) ? 5'd23 :
                                   (man_pre_norm[1] == 1'b1) ? 5'd24 :
                                   (man_pre_norm[0] == 1'b1) ? 5'd25 : 5'd27;

    // Pipelining Stage 2
    reg stck_st2;
    reg [4:0] slz_st2;
    reg [7:0] exp_pre_norm_st2;
    reg symbol_signi_st2;
    reg symbol_st2_x1;
    reg symbol_st2_x2;
    reg [26:0] man_pre_norm_st2;
    reg [7:0] exp_init_x1_st2;
    reg [7:0] exp_init_x2_st2;
    reg [22:0] man_st2_x1;
    reg [22:0] man_st2_x2;
    reg enable_in_st2;

    always @(posedge clk) begin
        if (!rst_n) begin
            stck_st2 <= 1'b0;
            slz_st2 <= 5'd0;
            exp_pre_norm_st2 <= 8'd0;
            symbol_signi_st2 <= 1'b0;
            symbol_st2_x1 <= 1'b0;
            symbol_st2_x2 <= 1'b0;
            man_pre_norm_st2 <= 27'd0;
            exp_init_x1_st2 <= 8'd0;
            exp_init_x2_st2 <= 8'd0;
            man_st2_x1 <= 23'd0;
            man_st2_x2 <= 23'd0;
            enable_in_st2 <= 1'b0;
        end else begin
            stck_st2 <= stck;
            slz_st2 <= search_leading_zeros;
            exp_pre_norm_st2 <= exp_pre_norm;
            symbol_signi_st2 <= symbol_signi;
            symbol_st2_x1 <= symbol_st1_x1;
            symbol_st2_x2 <= symbol_st1_x2;
            man_pre_norm_st2 <= man_pre_norm;
            exp_init_x1_st2 <= exp_init_x1;
            exp_init_x2_st2 <= exp_init_x2;
            man_st2_x1 <= man_init_x1_st1;
            man_st2_x2 <= man_init_x2_st1;
            enable_in_st2 <= enable_in_st1;
        end
    end
    
    // final exp normalization
    wire [8:0] exp_norm_temp = {1'b0, exp_pre_norm_st2} - {4'b0, slz_st2};
    wire [7:0] exp_norm = (exp_norm_temp[8] == 1'b0) ? exp_norm_temp[7:0] : 8'd0;
    
    wire [26:0] man_y_norm = (exp_norm_temp[8] == 1'b0) ?
                             man_pre_norm_st2 << slz_st2 :
                             (man_pre_norm_st2 << (exp_pre_norm_st2 - 8'd1));

    // Rounding logic (round to nearest, tie to even)
    wire round_bit = man_y_norm[1];
    wire sticky_bit_final = stck_st2 | man_y_norm[0];
    wire tie_even = man_y_norm[2];
    
    wire round_up = (round_bit && sticky_bit_final) || (round_bit && tie_even && !sticky_bit_final);

    wire [24:0] man_y_finorm_unrounded = man_y_norm[26:2];
    wire [24:0] man_y_finorm = man_y_finorm_unrounded + round_up;
    
    // final result assembly
    wire [7:0] exp_y = (man_y_finorm[24] == 1'b1) ? exp_norm + 1 : exp_norm;
    wire [22:0] man_y = (man_y_finorm[24] == 1'b1) ? man_y_finorm[22:0] : man_y_finorm[22:0];
    wire symbol_y = (exp_y==8'b0 && man_y==23'd0) ? (symbol_st2_x1 & symbol_st2_x2) : symbol_signi_st2;
    
    // special case hanfling (NaN, Infinity)
    wire nzm1 = |man_st2_x1;
    wire nzm2 = |man_st2_x2;

    assign y =
        (exp_init_x1_st2 == 8'd255 && exp_init_x2_st2 != 8'd255) ?
            {symbol_st2_x1, 8'd255, nzm1, man_st2_x1[21:0]} :
        (exp_init_x2_st2 == 8'd255 && exp_init_x1_st2 != 8'd255) ?
            {symbol_st2_x2, 8'd255, nzm2, man_st2_x2[21:0]} :
        (exp_init_x1_st2 == 8'd255 && exp_init_x2_st2 == 8'd255 && nzm2) ?
            {symbol_st2_x2, 8'd255, 1'b1, man_st2_x2[21:0]} :
        (exp_init_x1_st2 == 8'd255 && exp_init_x2_st2 == 8'd255 && nzm1) ?
            {symbol_st2_x1, 8'd255, 1'b1, man_st2_x1[21:0]} :
        (exp_init_x1_st2 == 8'd255 && exp_init_x2_st2 == 8'd255 && symbol_st2_x1 == symbol_st2_x2) ?
            {symbol_st2_x1, 8'd255, 23'd0} :
        (exp_init_x1_st2 == 8'd255 && exp_init_x2_st2 == 8'd255) ?
            {1'b1, 8'd255, 1'b1, 22'd0} : {symbol_y, exp_y, man_y};
    
    assign ovf = (exp_init_x1_st2 < 8'd255 && exp_init_x2_st2 < 8'd255 &&
                  (exp_pre_norm_st2 == 8'd255 || exp_y == 8'd255));

    reg enable_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) enable_out_reg <= 1'b0;
        else        enable_out_reg <= enable_in_st2;
    end
    assign enable_out = enable_out_reg;
endmodule
