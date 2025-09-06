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


module LED1_Blink(

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


//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

///////////////////////////
// LED Blink
wire blink;

heart_beat heart_beat_50(
	.clk(MAX10_CLK1_50),
	.led(blink)
);

assign LED = {1'b1, 1'b1, blink, 1'b1};


///////////////////////////
// Dual Boot
    dual_boot u0 (
        .clk_clk       (MAX10_CLK1_50),       //   clk.clk
        .reset_reset_n (1'b1)  // reset.reset_n
    );



endmodule
