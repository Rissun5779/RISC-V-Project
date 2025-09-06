//HSL to RGB conversion formula
//When 0 ≤ H < 360, 0 ≤ S ≤ 1 and 0 ≤ L ≤ 1:
//C = (1 - |2L - 1|) × S
//X = C × (1 - |(H / 60°) mod 2 - 1|)
//m = L - C/2
//(R,G,B) = ((R'+m)×255, (G'+m)×255,(B'+m)×255)


module HSLtoRGB (
	input	 [9:0]	H,   // 0 ≤ H < 360 Hue
	input	 [9:0]	S,   // 0 ≤ S ≤ 1 * 1024 , Saturation, 
	input	 [9:0]	L,   // 0 ≤ L ≤ 1 * 1024 , Lightness;
	output [7:0]   Red, // 
	output [7:0]   Green, 
	output [7:0]   Blue,
	
   output  [19:0] C ,C1,X ,H1 ,H0,
   output  [10:0] L1 , m,
   output  [10:0] RR ,GG, BB,
   output  [8:0]  remain , diff 
	);
	

assign L1 = ( 2*L >= 1024)?  2*L -1024 : 1024-2*L ; //Absolute
assign C1 = ( 1024 - L1 ) * S ; 
assign C  = C1[19:10] ; 
assign H0 = ( remain  )? 60-diff : diff  ; 
assign H1 = ( C * H0 );

assign X  = H1/60 ; 
assign m  = L- C/2     ; 

//--Red output
assign RR = (
  ((H >= 0  ) && (H < 60 )) ? C : ( 
  ((H >= 60 ) && (H < 120)) ? X : ( 
  ((H >= 120) && (H < 180)) ? 0 : ( 
  ((H >= 180) && (H < 240)) ? 0 : ( 
  ((H >= 240) && (H < 300)) ? X : ( 
  ((H >= 300) && (H < 360)) ? C : C
))))));
assign Red =  ( 255 * ( RR + m ))/1024 ; 

//--Green output
assign GG = (
  ((H >= 0  ) && (H < 60 )) ? X : ( 
  ((H >= 60 ) && (H < 120)) ? C : ( 
  ((H >= 120) && (H < 180)) ? C : ( 
  ((H >= 180) && (H < 240)) ? X : ( 
  ((H >= 240) && (H < 300)) ? 0 : ( 
  ((H >= 300) && (H < 360)) ? 0 : 0
))))));
assign Green =  ( 255 * ( GG+ m ))/1024 ; 

//--Blue output
assign BB = (
  ((H >= 0  ) && (H < 60 )) ? 0 : ( 
  ((H >= 60 ) && (H < 120)) ? 0 : ( 
  ((H >= 120) && (H < 180)) ? X : ( 
  ((H >= 180) && (H < 240)) ? C : ( 
  ((H >= 240) && (H < 300)) ? C : ( 
  ((H >= 300) && (H < 360)) ? X : X
))))));
assign Blue =  ( 255 * ( BB+ m ))/1024 ; 


DIV DV1(
	.numer   ( H/60  ), //被除
	.denom   ( 2     ), //除
	.quotient(       ), //商
	.remain  ( remain)  //餘
	);

	
DIV DV2(
	.numer   ( H     ), //被除
	.denom   ( 60    ), //除
	.quotient(       ), //商
	.remain  ( diff  )  //餘
	);
	
	
endmodule 