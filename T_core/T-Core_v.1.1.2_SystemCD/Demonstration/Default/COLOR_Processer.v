
module COLOR_Processer #( 
   parameter Delay_Time    = 100000000/140; 
   parameter LED_NUM  = 16 ;
	parameter ADDR_BIT = $clog2(LED_NUM )+1
)(
    input                       CLK , 
    input                       RST_N , 
    output reg    [9:0]         Hue, 	 
    output reg                  ram_wrclock,
    output reg[(ADDR_BIT-1):0]  ram_wraddress,
    output reg    [23:0]        ram_data, 
    output reg                  update_reqeust,
    input                       update_done   ,
	 input         [23:0]        COLOR , 
    output reg    [5:0]         ST ,
    output reg    [31:0]        DELAY ,
    output reg                  OK,
    output reg    [23:0]        COLOR0 	 
);


always @(negedge  RST_N or posedge CLK ) 
if (!RST_N )  begin 
 ST				 <=0; 
 update_reqeust <=0;
 ram_wraddress <=0; 
 ram_wrclock   <=0; 
 OK            <=0;  
 Hue           <=0;
 COLOR0        <=0;
end 
else  begin 
case (ST)
0:begin 
  if ( update_done)  begin 
     ST            <=20; 
 	  DELAY         <=0;
	  update_reqeust<=0;
     ram_wraddress <=0; 
     ram_wrclock   <=0; 
  end 	  
end  
1:begin 
      ram_data <= COLOR0;
      ST<=2;
end  
2:begin 
 ST<=3;
 ram_wrclock   <=1; 
end  
3:begin 
 ST<=4;
 ram_wrclock   <=0; 
end  
4:begin   
 ST<=5;
end  
5:begin
  if ( ram_wraddress ==  LED_NUM-1 ) begin update_reqeust<=1 ;   ST<=6; DELAY <=0; end 
  else begin 
   ST    <=20; 
	DELAY <=0;
   ram_wraddress <= ram_wraddress +1 ; 
	end 
end  
6:begin 
 if (DELAY==10)  begin ST<=7; update_reqeust<=0 ; end 
 else DELAY <=DELAY +1 ;
 
end  
7:begin 
 if (update_done)  ST<=8; 
end  
8:begin  
  ST     <=9 ;
  DELAY  <=0; 
end  
9:begin 
   if ( DELAY > Delay_Time )  begin 
            ST      <= 0 ;
		 	   if ( Hue >= 359 ) Hue <=  0;
	             else Hue <= Hue + 1 ; 
	end
	else  DELAY <=DELAY +1 ;
end  

//delay latch 
20:begin 
 if (DELAY==10)  ST<=21;  
 else   DELAY <=DELAY +1 ;
 end
21:begin 
     ST<=1;  
     COLOR0 <= COLOR; //color data latch 
	end  

 
 
endcase
end

endmodule 
