// ============================================================================
// Copyright (c) 2019 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Fri Apr 26 16:45:57 2019
// ============================================================================


module T_CORE_Default(

      ///////// Clocks /////////
      input              ADC_CLK_10,
      input              MAX10_CLK1_50,
      input              MAX10_CLK2_50,

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 3: 0]   SW,

      ///////// LED /////////
      output   [ 3: 0]   LED,

      ///////// GPIO /////////
      inout    [23: 0]   GPIO,

      ///////// TMD /////////
      inout    [ 7: 0]   TMD_D,

      ///////// EX /////////
      output             EX_LED_RGB_D,

      ///////// OB /////////
      output             OB_LED_RGB_D,

      ///////// QSPI /////////
      output             QSPI_FLASH_SCLK,
      inout    [ 3: 0]   QSPI_FLASH_DATA,
      output             QSPI_FLASH_CE_n,

      ///////// RISCV /////////
      input              RISCV_JTAG_TCK,
      input              RISCV_JTAG_TDI,
      output             RISCV_JTAG_TDO,
      input              RISCV_JTAG_TMS 

);

parameter LED_NUM   = 4;
parameter ADDR_BIT  = $clog2(LED_NUM );

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire                    ram_wrclock;
wire  [(ADDR_BIT-1):0]  ram_wraddress;
wire  [23:0]            ram_data;
wire [23:0]             COLOR     ; 
wire  					   DOUT ; 
wire  					   RST ;         // 1 when reset-code is sending in DOUT port. recommend to update data when RST=1
wire 			            CLK_100 ; 
wire  			         update_reqeust;
wire 			            update_done   ;
wire 			            SYNC_LED ; 
wire                    LOCK ;
wire  [9:0]             Hue;

//=======================================================
//  Structural coding
//=======================================================


//---- 1 SEC flicker ---
LED_flicker fl( 
     .CLK_50 (MAX10_CLK1_50), 
     .KEY    (KEY[0]), 
     .LOCK   (LOCK), 
     .SYNC   (SYNC_LED), 
     .LED    (LED)
 );


//----100Mhz
PLL100 pl100(
	.areset (~KEY[1] ) ,
	.inclk0 (MAX10_CLK1_50),
	.c0     (CLK_100  ),
	.locked (LOCK) );
	
//----WS2812 Controller
WS2812 #(
    .LED_NUM ( LED_NUM ) 
)ws(
       .clk100         ( CLK_100       ),        // 100Mhz
       .reset_n        ( KEY[1]             ),
		 .update_reqeust ( update_reqeust), // assert when request ip to update table to RGB LED
       .update_done    ( update_done   ), // assert when table data is update tot RGB LED
       .ram_wrclock    ( ram_wrclock  ),
       .ram_wraddress  ( ram_wraddress),
       .ram_data       ( ram_data     ),    // write latency = 1
//       .DOUT           ( EX_LED_RGB_D),
       .DOUT           ( OB_LED_RGB_D),
       .RST            ( RST )              // 1 when reset-code is sending in DOUT port. recommend to update data when RST=1
);

//----OB_LED by pass  EX_LED
assign EX_LED_RGB_D = OB_LED_RGB_D  ; 

//----- RGB color slection ----
Color_selection  sl( 
 .SW        (SW[1:0]), 
 .KEY       (KEY[0]), 
 .Hue       (Hue), 
 .COLOR     (COLOR)
); 

//----- Processer ----
COLOR_Processer #( 
    .LED_NUM     ( LED_NUM ),
	 .Delay_Time  ( 100000000/(35*4) ) //test 5
)pr(
    .CLK           (CLK_100), 
    .RST_N         (KEY[1]), 
    .Hue           (Hue), 	 
    .update_reqeust(update_reqeust),
    .update_done   (update_done   ),
    .ram_wrclock   (ram_wrclock   ),
    .ram_wraddress (ram_wraddress  ),
    .ram_data      (ram_data      ), 
	 .COLOR         (COLOR),  
);


endmodule
