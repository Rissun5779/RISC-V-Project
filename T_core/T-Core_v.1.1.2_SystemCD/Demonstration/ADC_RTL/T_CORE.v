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


//=======================================================
//  REG/WIRE declarations
//=======================================================

wire reset_n;
wire sys_clk;


//=======================================================
//  Structural coding
//=======================================================

assign reset_n = 1'b1;



adc_qsys u0 (
    .clk_clk                              (MAX10_CLK1_50),                              //                    clk.clk
    .reset_reset_n                        (reset_n),                        //                  reset.reset_n
    .modular_adc_0_command_valid          (command_valid),          //  modular_adc_0_command.valid
    .modular_adc_0_command_channel        (command_channel),        //                       .channel
    .modular_adc_0_command_startofpacket  (command_startofpacket),  //                       .startofpacket
    .modular_adc_0_command_endofpacket    (command_endofpacket),    //                       .endofpacket
    .modular_adc_0_command_ready          (command_ready),          //                       .ready
    .modular_adc_0_response_valid         (response_valid),         // modular_adc_0_response.valid
    .modular_adc_0_response_channel       (response_channel),       //                       .channel
    .modular_adc_0_response_data          (response_data),          //                       .data
    .modular_adc_0_response_startofpacket (response_startofpacket), //                       .startofpacket
    .modular_adc_0_response_endofpacket   (response_endofpacket),    //                       .endofpacket
    .clock_bridge_sys_out_clk_clk         (sys_clk)          // clock_bridge_sys_out_clk.clk
);


////////////////////////////////////////////
// command
wire  command_valid;
wire  [4:0] command_channel;
wire  command_startofpacket;
wire  command_endofpacket;
wire command_ready;

// continused send command
assign command_startofpacket = 1'b1; // // ignore in altera_adc_control core
assign command_endofpacket = 1'b1; // ignore in altera_adc_control core
assign command_valid = 1'b1; //
assign command_channel = SW[2: 0] + 1; // SW2/SW1/SW0 down: map to ADC_IN0

////////////////////////////////////////////
// response
wire response_valid/* synthesis keep */;
wire [4:0] response_channel;
wire [11:0] response_data;
wire response_startofpacket;
wire response_endofpacket;
reg [4:0]  cur_adc_ch /* synthesis noprune */;
reg [11:0] adc_sample_data /* synthesis noprune */;
reg [11:0] vol_mV /* synthesis noprune */;


always @ (posedge sys_clk)
begin
    if (response_valid)
    begin
        adc_sample_data <= response_data;
        cur_adc_ch <= response_channel;

        vol_mV <= response_data * 2500 / 4096;
    end
end

// adc_sample_data: hold 12-bit adc sample value
// Vout = Vin (12-bit x 2500mV / 4096)


assign LED[3: 0] = vol_mV[11-:4];  // led is high active


endmodule
