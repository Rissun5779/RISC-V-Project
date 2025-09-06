module Color_selection  ( 
 input    [1:0]   SW , 
 input            KEY , 
 input    [9:0]   Hue , 
 output   [23:0]  COLOR
); 

//=======================================================
//  Color Table
//=======================================================
parameter Y         =8'h20 ; //LEVEL0 
parameter Y1        =8'h14 ; //LEVEL1 
parameter Y2        =8'h9  ; //LEVEL2 

parameter Red       ={ Y1   ,8'h0 ,8'h0 }; 
parameter Green     ={ 8'h0 ,Y1   ,8'h0 }; 
parameter Blue      ={ 8'h0 ,8'h0 ,Y    }; 
parameter Gray      ={ Y2   ,Y2   ,Y2   };
parameter Black     =24'h000000 ; 

//=======================================================
//  REG/WIRE declarations
//=======================================================
 
wire [23:0] COR ; 
wire [7:0]  RR,GG,BB ;

//=======================================================
//  Structural coding
//=======================================================
 
//-----RGB color slection ----
assign COR= (
(SW[1:0] ==0)?Red   :(
(SW[1:0] ==1)?Green :(
(SW[1:0] ==2)?Blue  :(
(SW[1:0] ==3)?Gray  :Gray
))));


//-----RGB output----
assign COLOR  =  (!KEY) ? COR :{RR, GG, BB } ;


//-----HSL to RGB conversion formula---

//When 0 ≤ H < 360, 0 ≤ S ≤ 1 and 0 ≤ L ≤ 1:
//C = (1 - |2L - 1|) × S
//X = C × (1 - |(H / 60°) mod 2 - 1|)
//m = L - C/2
//(R,G,B) = ((R'+m)×255, (G'+m)×255,(B'+m)×255)
 
HSLtoRGB  hsl(
	.H         (Hue    ), // Hue       ,0 ≤ H < 360
	.S         (10'h3ff) ,// Saturat   ,0 ≤ S < 1024
	.L         (10'h16),  // Lightness ,0 ≤ L < 1024:
	.Red       (RR[7:0]), 
	.Green     (GG[7:0]), 
	.Blue      (BB[7:0])  
	);

endmodule 
