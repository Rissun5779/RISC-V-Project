module  WS2812_Control(

			input						s_clk,	
			input						s_reset_n,
			input	[1:0]				s_address,
			input						s_write_en,
			input	[31:0]			s_write_data,
			input						s_read_en,
			output reg [31:0]		s_read_data,
			
			//input    		exp_ws2818_clk,
			output			exp_dout

);

parameter LED_NUM = 32;


`define REG_REM_ADDR		2'b00
`define REG_REM_DATA 	2'b01
`define REG_REM_REQUEST	2'b10
`define REG_REM_DONE		2'b11

parameter ADDR_BIT = $clog2(LED_NUM );

reg [(ADDR_BIT-1):0]		ram_addr;
reg [31:0]		ram_data;
reg 				ram_request;


always@(posedge s_clk or negedge s_reset_n)
begin

	if(!s_reset_n)
	begin
		ram_addr <= 0;
		ram_data <= 0;
	
	end
	else
	begin
		if(s_write_en==1 && s_address == `REG_REM_ADDR)
		begin
			ram_addr <= s_write_data;
		end
		else if(s_write_en==1 && s_address == `REG_REM_DATA)
		begin
			ram_data <= s_write_data;
		end
		else if(s_write_en==1 && s_address == `REG_REM_REQUEST)
		begin
			ram_request <= s_write_data;
		end
		else
			ram_data <= ram_data;
	end
end
			

wire	ram_done;
			
always@(posedge s_clk or negedge s_reset_n)
begin

	if(!s_reset_n)
	begin
		s_read_data <= 0;	
	end
	else
	begin
		if(s_read_en==1 && s_address == `REG_REM_DONE)
		begin
			s_read_data  <= ram_done;
		end
		else
			s_read_data <= s_read_data;
	end
end


WS2812 WS2812_Inst(
   .clk100(s_clk),   // 50Mhz
   .reset_n(s_reset_n),
   
	// Write Port of a RAM-2PORT, a table to store RGB LED color data
   .ram_wrclock(s_clk),
   .ram_wraddress(ram_addr),
   .ram_data(ram_data), // read latency = 1
	.update_reqeust(ram_request),
	.update_done(ram_done),
   // serial control output
   .DOUT(exp_dout),
   .RST()
);
defparam WS2812_Inst.LED_NUM = LED_NUM;

endmodule 
