module LED_flicker ( 
 input  CLK_50 , 
 input  KEY , 
 input  LOCK , 
 output SYNC , 
 output [3:0] LED
 );
 

//----1sec flicker 
CLOCKMEM  KKL (.RESET_n (1), .CLK(CLK_50), .CLK_FREQ(50000000) , .CK_1HZ  (SYNC) );

//---on-board 4 LED Display 
assign LED = (!KEY)?4'hf:( LOCK? { SYNC,SYNC,SYNC ,SYNC } :4'h0) ;

endmodule 