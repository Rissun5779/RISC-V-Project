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



//for jtag
wire jtag_tck;
wire jtag_tms;
wire jtag_tdi;
wire jtag_tdo;
wire SRST_n;
//for pll_sys
wire clk_8388;
wire clk_32M;
wire ip_mmcm_8388m_locked;
wire ip_mmcm_32m_locked;
wire ip_mmcm_locked;
//for clkdivider
wire slowclk;
//for reset
reg  reset_periph_t;
wire ip_reset_sys_peripheral_reset;
wire fpga_power_on_power_on_reset; 
wire ip_reset_sys_mb_debug_sys_rst;


pll_sys ip_mmcm(
/*input  wire  */    .inclk0    (MAX10_CLK1_50),   
/*input  wire  */    .areset    (1'b0),                // ~CPU_RESET_n),      

/*output wire  */    .c0        (clk_8388), 
/*output wire  */    .locked    (ip_mmcm_8388m_locked)    
);

pll_sys_32m ip_mmcm_32m(
/*input  wire  */    .inclk0    (MAX10_CLK1_50),   
/*input  wire  */    .areset    (1'b0),                // ~CPU_RESET_n),      

/*output wire  */    .c0        (clk_32M), 
/*output wire  */    .locked    (ip_mmcm_32m_locked)    
);

assign ip_mmcm_locked = ip_mmcm_8388m_locked && ip_mmcm_32m_locked;

 
clkdivider slowclkgen(
/*input  wire  */    .clk     (clk_8388),                // use this clock divide to 32.768KHz
/*input  wire  */    .reset   (~ip_mmcm_locked),

/*output wire  */    .clk_out (slowclk)
);


//
always @(posedge clk_8388) 
begin
    if( KEY[0]  == 1'b0 || ip_mmcm_locked == 1'b0  || /*SRST_n == 1'b0 || */ip_reset_sys_mb_debug_sys_rst == 1'b1)  
	 begin
        reset_periph_t <= 1'b1;
    end 
	 else 
	 begin
        reset_periph_t <= 1'b0;
    end 
end
assign ip_reset_sys_peripheral_reset = reset_periph_t;


PowerOnResetFPGAOnly fpga_power_on ( 
/*input  wire  */    .clock           (clk_32M),
/*output wire  */    .power_on_reset  (fpga_power_on_power_on_reset)
);
  


Freedom_E300_Wrapper E300_SoC_Wrapped(
/*input  wire */           .clock             (clk_32M),
/*input  wire */           .aon_lfextclk      (slowclk),

/*input  wire */           .aon_erst_n        (~ip_reset_sys_peripheral_reset),
/*input  wire */           .jtag_reset        (fpga_power_on_power_on_reset),
/*output wire */           .io_ndreset        (ip_reset_sys_mb_debug_sys_rst),

/*input  wire */           .jtag_tck          (RISCV_JTAG_TCK),
/*input  wire */           .jtag_tms          (RISCV_JTAG_TMS),
/*input  wire */           .jtag_tdi          (RISCV_JTAG_TDI),
/*output wire */           .jtag_tdo          (RISCV_JTAG_TDO),

/*output wire */           .qspi_sck          (QSPI_FLASH_SCLK),
/*output wire */           .qspi_cs_0         (QSPI_FLASH_CE_n),
/*inout  wire [3:0] */     .qspi_dq           (QSPI_FLASH_DATA),

/*input  wire [31:0] */    .e300_gpio_i_ival  (e300_gpio_i_ival),
/*output wire [31:0] */    .e300_gpio_o_ie    (e300_gpio_o_ie),
/*output wire [31:0] */    .e300_gpio_o_oval  (e300_gpio_o_oval),
/*output wire [31:0] */    .e300_gpio_o_oe    (e300_gpio_o_oe)
    
);


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
// 12  ,i2c0_sda,pwn2_2
// 13  ,i2c0_scl,pwn2_3
// 14  ,        ,
// 15  ,        ,
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
// 27  ,spi1_dq0,
// 28  ,spi1_dq1,
// 29  ,spi1_sck,
// 30  ,spi1_dq2,
// 31  ,spi1_dq3,
/////  to Use GPIO, iof_en = 0 
////   to Use IOF0, iof_en = 1, iof_sel = 0www
////   to Use IOF1, iof_en = 1, iof_sel = 1


wire [31:0] e300_gpio_i_ival;
wire [31:0] e300_gpio_o_ie;
wire [31:0] e300_gpio_o_oval;
wire [31:0] e300_gpio_o_oe;


//uart, TMD_D[7]: UART_TX (fpga to PC), TMD_D[6]: UART_RX (pc to FPGA),
assign TMD_D[7]             = e300_gpio_o_oe[17] ? e300_gpio_o_oval[17] :1'bz;         
assign e300_gpio_i_ival[16] = e300_gpio_o_ie[16] & TMD_D[6];

//LEDs
assign LED[0] = e300_gpio_o_oe[0] ? e300_gpio_o_oval[0] : 1'bz;
assign LED[1] = e300_gpio_o_oe[1] ? e300_gpio_o_oval[1] : 1'bz;
assign LED[2] = e300_gpio_o_oe[2] ? e300_gpio_o_oval[2] : 1'bz;
assign LED[3] = e300_gpio_o_oe[3] ? e300_gpio_o_oval[3] : 1'bz;

//SWs
assign e300_gpio_i_ival[4] = e300_gpio_o_ie[4] & SW[0];
assign e300_gpio_i_ival[5] = e300_gpio_o_ie[5] & SW[1];
assign e300_gpio_i_ival[6] = e300_gpio_o_ie[6] & SW[2];
assign e300_gpio_i_ival[7] = e300_gpio_o_ie[7] & SW[3];

//KEYs
assign e300_gpio_i_ival[8] = e300_gpio_o_ie[8] & KEY[0];
assign e300_gpio_i_ival[9] = e300_gpio_o_ie[9] & KEY[1];





endmodule
