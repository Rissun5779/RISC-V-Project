
//•	Function: 控制N 個RGB LED 的顏色.
//•	內含一個RAM-2Port Memory, 裡面存放N 個RGB LED 的顏色.
//•	memory write port: caller 透過此介面將N 個RGB 顏色寫入Memory.
//•	LED control output port: 為1 pin serial port, 用來傳送RGB 資料給N 個LED.

module  WS2812 #( 
   parameter LED_NUM  = 16 ;
	parameter ADDR_BIT = $clog2(LED_NUM )+1
	) (
    input clk100,   // 100Mhz
    input reset_n ,

    // Write Port of a RAM-2PORT, a table to store RGB LED color data
    input                  ram_wrclock,
    input[(ADDR_BIT-1):0]  ram_wraddress,
    input  [23:0]          ram_data, // read latency = 1
    input  update_reqeust,
    output update_done   ,
   // serial control output
    output DOUT,
    output RST // 1 when reset-code is sending in DOUT port. recommend to update data when RST=1
);
//parameter LED_NUM = 16;


	wire [(ADDR_BIT-1):0]  rdaddress;
	wire	                 rdclock;
	wire [23:0]            q;
	
	
	
TWO_PORT_RAM  #(
  .LED_NUM   (LED_NUM ),
  .DATA_WIDTH(24)                 //width of data bus
)tp(
  .data      (ram_data ),       //data to be written
  .read_addr (rdaddress),//address for read operation
  .read_clk  (rdclock),   //clock signal for read operation
  .write_addr(ram_wraddress), //address for write operation
  .we        (1),         //write enable signal
  .write_clk (ram_wrclock), //clock signal for write operation
  .q         (q)      //read data
);
	

ILED_CONTROLLER  #( 
    .LED_NUM (LED_NUM)  
)id( 
    .RST_N   ( reset_n     ), 
    .CLK     ( clk100    ), 
	 .WNT     ( rdaddress ),
	 .READ_CK ( rdclock) , 
	 .GO      ( update_reqeust), 
	 .READY   ( update_done   ), 
    .RGB0    ( q), 
	 .W_END   ( LED_NUM ),
    .TDIN    ( DOUT  ),
	 .RST     ( RST)
); 

endmodule 
