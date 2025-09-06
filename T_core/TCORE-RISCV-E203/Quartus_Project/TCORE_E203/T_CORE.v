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

`default_nettype none

module T_CORE(

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

		output		SIF_UART_TX,
		input			SIF_UART_RX,
		
		inout			SIF_I2C_SCL,
		inout			SIF_I2C_SDA,
		
		output		SIF_SPI_CS,
		output		SIF_SPI_SCK,
		output		SIF_SPI_MOSI,
		input			SIF_SPI_MISO,
		

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



wire clk_16m;
wire pll_16m_locked;
pll_16m pll_16m_inst (
/*input 	*/    .areset  (1'b0),
/*input 	*/    .inclk0  (MAX10_CLK1_50),
/*output	*/    .c0      (clk_16m),
/*output	*/    .locked  (pll_16m_locked),
);


wire clk_8m388;
wire pll_8m388_locked;
pll_8m388 pll_8m388_inst (
/*input 	*/    .areset  (1'b0),
/*input 	*/    .inclk0  (MAX10_CLK2_50),
/*output	*/    .c0      (clk_8m388),
/*output	*/    .locked  (pll_8m388_locked),
);
wire slowclk;
clkdivider slowclkgen(
/*input  wire  */    .clk     (clk_8m388),                // We use this clock divide to 32.768KHz
/*input  wire  */    .reset   (~pll_8m388_locked),

/*output wire  */    .clk_out (slowclk)
);

// generate reset_n
reg reset_n;
always @(posedge clk_8m388) 
begin
    if( KEY[0]  == 1'b0 || pll_16m_locked == 1'b0  || pll_8m388_locked == 1'b0)  
	 begin
        reset_n <= 1'b0;
    end 
	 else 
	 begin
        reset_n <= 1'b1;
    end 
end


wire [31:0] gpio;

wire test_scl_pad_i;
wire test_scl_pad_o;
wire test_scl_padoen_o;
wire test_sda_pad_i;
wire test_sda_pad_o;
wire test_sda_padoen_o;

e203_soc e203_soc_inst(

.test_scl_pad_i(test_scl_pad_i),
.test_scl_pad_o(test_scl_pad_o),       
.test_scl_padoen_o(test_scl_padoen_o),    
.test_sda_pad_i(test_sda_pad_i),       
.test_sda_pad_o(test_sda_pad_o), 
.test_sda_padoen_o(test_sda_padoen_o),

/*input           */    .hfextclk           (clk_16m),             
/*output          */    .hfxoscen           (),             

/*input           */    .lfextclk           (slowclk),             
/*output          */    .lfxoscen           (),             

/*input           */    .jtag_tck           (RISCV_JTAG_TCK),             
/*input           */    .jtag_tms           (RISCV_JTAG_TMS),             
/*input           */    .jtag_tdi           (RISCV_JTAG_TDI),             
/*output          */    .jtag_tdo           (RISCV_JTAG_TDO),             

/*input  [31: 0]  */    .gpio_i_ival        (gpio_i_ival),
/*output [31: 0]  */    .gpio_o_oval        (gpio_o_oval),
/*output [31: 0]  */    .gpio_o_oe          (gpio_o_oe),
/*output [31: 0]  */    .gpio_o_ie          (gpio_o_ie),
/*output [31: 0]  */    .gpio_o_pue         (),
/*output [31: 0]  */    .gpio_o_ds          (),              

/*output          */    .qspi_sck           (QSPI_FLASH_SCLK),             
/*output          */    .qspi_cs_0          (QSPI_FLASH_CE_n),
/*inout  [ 3: 0]  */    .qspi_dq            (QSPI_FLASH_DATA),

/*input           */    .aon_erst_n         (reset_n),           

/*input           */    .dbgmode0_n         (1'b1),           
/*input           */    .dbgmode1_n         (1'b1),
/*input           */    .dbgmode2_n         (1'b1),

/*input           */    .bootrom_n          (1'b1),            

/*input           */    .aon_pmu_dwakeup_n  (1'b1),    

/*output          */    .aon_pmu_padrst     (),       
/*output          */    .aon_pmu_vddpaden   (),
);

wire [31: 0]  gpio_i_ival;
wire [31: 0]  gpio_o_oval;
wire [31: 0]  gpio_o_oe;
wire [31: 0]  gpio_o_ie;

////////////////////////////////
// GPIO 0-31 map
/////////////////////
//
// GPIO,  IOF0  ,  IOF1
//  0  ,        ,pwn0_0 
//  1  ,        ,pwn0_1 
//  2  ,spi0_cs0,pwn0_2 
//  3  ,spi0_dq0,pwn0_3 
//  4  ,spi0_dq1,
//  5  ,spi0_sck,
//  6  ,spi0_dq2,
//  7  ,spi0_dq3,
//  8  ,spi0_cs1,
//  9  ,spi0_cs2,
// 10  ,spi0_cs3,pwn2_0
// 11  ,        ,pwn2_1
// 12  ,        ,pwn2_2
// 13  ,        ,pwn2_3
// 14  ,i2c0_sda,
// 15  ,i2c0_scl,
// 16  ,uart0_rx,
// 17  ,uart0_tx,
// 18  ,        ,
// 19  ,        ,pwn1_0
// 20  ,        ,pwn1_1
// 21  ,        ,pwn1_2
// 22  ,        ,pwn1_3
// 23  ,        ,
// 24  ,uart1_rx,
// 25  ,uart1_tx,
// 26  ,spi1_cs0,
// 27  ,spi1_dq0/mosi,
// 28  ,spi1_dq1/miso,
// 29  ,spi1_sck,
// 30  ,spi1_dq2,
// 31  ,spi1_dq3,
/////  to Use GPIO, iof_en = 0 
////   to Use IOF0, iof_en = 1, iof_sel = 0
////   to Use IOF1, iof_en = 1, iof_sel = 1


// connect to SIF 
//uart, UART_TX (fpga to PC), UART_RX (pc to FPGA),
assign SIF_UART_TX     = gpio_o_oe[17] ? gpio_o_oval[17] :1'bz;         
assign gpio_i_ival[16] = gpio_o_ie[16] & SIF_UART_RX;

//spi, gpio 26~~31,spi1
assign SIF_SPI_CS		= gpio_o_oe[26] ? gpio_o_oval[26] : 1'bz;
assign SIF_SPI_SCK	= gpio_o_oe[29] ? gpio_o_oval[29] : 1'bz;
assign SIF_SPI_MOSI	= gpio_o_oe[27] ? gpio_o_oval[27] : 1'bz; 
assign gpio_i_ival[28] 	= gpio_o_ie[28] & SIF_SPI_MISO;

//i2c, gpio 12,13,i2c0
assign SIF_I2C_SCL= (~test_scl_padoen_o) ? (test_scl_pad_o?1'bz:1'b0):1'bz; 
assign test_scl_pad_i = SIF_I2C_SCL & (test_scl_padoen_o);
assign SIF_I2C_SDA= (~test_sda_padoen_o) ? (test_sda_pad_o?1'bz:1'b0):1'bz; 
assign test_sda_pad_i = SIF_I2C_SDA & (test_sda_padoen_o);

// LEDs
assign LED[0] = gpio_o_oe[0] ? gpio_o_oval[0] : 1'bz;
assign LED[1] = gpio_o_oe[1] ? gpio_o_oval[1] : 1'bz;
assign LED[2] = gpio_o_oe[2] ? gpio_o_oval[2] : 1'bz;
assign LED[3] = gpio_o_oe[3] ? gpio_o_oval[3] : 1'bz;

// SWs
assign gpio_i_ival[4] = gpio_o_ie[4] & SW[0];
assign gpio_i_ival[5] = gpio_o_ie[5] & SW[1];
assign gpio_i_ival[6] = gpio_o_ie[6] & SW[2];
assign gpio_i_ival[7] = gpio_o_ie[7] & SW[3];

assign gpio_i_ival[8] = gpio_o_ie[8] & KEY[0];
assign gpio_i_ival[9] = gpio_o_ie[9] & KEY[1];

// TCORE LEDS
assign EX_LED_RGB_D=1'b0;
assign OB_LED_RGB_D=1'b0;

endmodule
