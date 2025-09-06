module ILED_CONTROLLER  #( 
   parameter LED_NUM  = 16 ;
	parameter ADDR_BIT = $clog2(LED_NUM )+1

)(

input                       CLK ,
input                       GO  , 
input                       RST_N, 
input      [23:0]           RGB0,
input      [(ADDR_BIT-1):0] W_END,
output reg [(ADDR_BIT-1):0] WNT,
output reg       READ_CK,

 
output reg   TDIN, 
output reg   READY, 
output reg   RST , 

//------

output reg [15:0]DELAY  , 
output reg [7:0 ]ST ,
output reg [4:0 ]CNT,
output reg DI ,
output reg [23:0]GRB_

);


//100MHZ = 10ns 

parameter us_35 = 35;     //0.35us
parameter us_90 = 90;     //0.90us
parameter us50  = 32768 ; //327us//5000;


always @(negedge RST_N  or posedge  CLK  ) 
if (!RST_N) begin 
  ST    <=0; 
  DELAY <=0;
  DI    <=0;
  TDIN  <=1;
  CNT   <=0; 
  GRB_  <=0; 
  WNT   <=0; 
  READY <=1;	
  READ_CK<=0; 
  RST    <=0; 
end 
else case (ST ) 
0:begin 
    TDIN  <=0;  //reset about 50us 
	 CNT   <=0;
    WNT   <=0; 
    READY <=0;
    if ( DELAY==us50)  begin ST<=10 ; RST <=0; end 
	 else begin  RST <=1; DELAY  <= DELAY+1   ;  end 
  end     
1:begin 
   if ( CNT==24 )  begin  ST <= 10;    WNT   <=WNT+1; end
	else   begin 
   	{ DI , GRB_ }  <= {GRB_ ,1'b0} ; 
      ST   <=2; 
	   DELAY<=0;	
		TDIN <=1;
	end  
  end 	
2:begin 
    if ((( DI ) && ( DELAY!= us_90)) ||(( !DI ) && ( DELAY!= us_35)))  DELAY<=DELAY+1 ;   //TH
	 else begin 
      ST   <=3; 
	   DELAY<=0;	
		TDIN <=0; 
	 end  
 end 	 
3:begin 
    if ((( !DI ) && ( DELAY!= us_90)) ||(( DI ) && ( DELAY!= us_35 )))  DELAY<=DELAY+1 ;   //TL
	 else begin 
      ST   <=1; 
	   DELAY<=0;	
		CNT  <=CNT+1 ;  
	 end  
  end 	
//5: begin 
//   READ_CK<=1; //address latch 
//	ST<=6;
//   end 	
//6: begin 
//   READ_CK<=0; //address latch 
//	ST<=7;
//   end 	
//7: begin 
//   READ_CK<=1; //output data latch 
//	ST<=8;	
//   end 	
//8: begin 
//   READ_CK<=0; //output data latch 
//	ST<=10;	
//   end 	
	 
//--- WORD CNT 
10:begin 
   if ( WNT ==W_END )   begin ST <=19;  READY <=1;end  //st<=0; 
	else begin 
	     READY <=0;	 
	     ST    <=11;
		  CNT   <=0; 
      //  GRB_ <={ RGB0[15:8],RGB0[23:16],RGB0[7:0]};
	end 
 end 

11: begin 
   READ_CK<=1; //address latch 
	ST<=12;
   end 	
12: begin 
   READ_CK<=0; //address latch 
	ST<=13;
   end 	
13: begin 
   READ_CK<=1; //output data latch 
	ST<=14;	
   end 	
14: begin 
   READ_CK<=0; //output data latch 
	ST<=15;	
   end  
15: begin 
	ST<=1;	
	GRB_ <={ RGB0[15:8],RGB0[23:16],RGB0[7:0]};
   end  
	
	

19:begin 
   if ( !GO )
	ST    <= 20;
 end 	
 
 
20:begin  
   if ( GO ) 
	begin ST <=0; READY <=0;  end 
end  
  
endcase 

endmodule 
