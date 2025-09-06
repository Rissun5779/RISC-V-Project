module e203_soc(

// I2C signals
// i2c clock line
input  test_scl_pad_i,       // SCL-line input
output test_scl_pad_o,       // SCL-line output (always 1'b0)
output test_scl_padoen_o,    // SCL-line output enable (active low)

// i2c data line
input  test_sda_pad_i,       // SDA-line input
output test_sda_pad_o,       // SDA-line output (always 1'b0)
output test_sda_padoen_o,    // SDA-line output enable (active low

input           hfextclk,             // This clock should comes from the crystal pad generated high speed clock (16MHz)
output          hfxoscen,             // The signal to enable the crystal pad generated clock

input           lfextclk,             // This clock should comes from the crystal pad generated low speed clock (32.768KHz)
output          lfxoscen,             // The signal to enable the crystal pad generated clock

input           jtag_tck,             // The JTAG TCK is input, need to be pull-up
input           jtag_tms,             // The JTAG TMS is input, need to be pull-up
input           jtag_tdi,             // The JTAG TDI is input, need to be pull-up
output          jtag_tdo,             // The JTAG TDO is output have enable

input  [31: 0]  gpio_i_ival,
output [31: 0]  gpio_o_oval,
output [31: 0]  gpio_o_oe,
output [31: 0]  gpio_o_ie,
output [31: 0]  gpio_o_pue,
output [31: 0]  gpio_o_ds,
//inout  [31: 0]  gpio,                 // gpio

output          qspi_sck,             // qspi flash
output          qspi_cs_0,
inout  [ 3: 0]  qspi_dq,

input           aon_erst_n,           // Erst is input need to be pull-up by default

input           dbgmode0_n,           // dbgmode are inputs need to be pull-up by default
input           dbgmode1_n,
input           dbgmode2_n,

input           bootrom_n,            // BootRom is input need to be pull-up by default

input           aon_pmu_dwakeup_n,    // dwakeup is input need to be pull-up by default

output          aon_pmu_padrst,       // PMU output is just output without enable
output          aon_pmu_vddpaden
);


// jtag
wire io_pads_jtag_TDO_o_oe;
wire io_pads_jtag_TDO_o_oval;

assign jtag_tdo = io_pads_jtag_TDO_o_oe ? io_pads_jtag_TDO_o_oval : 1'bz;


// qspi
wire [ 3: 0] io_pads_qspi_dq_o_oe;
wire [ 3: 0] io_pads_qspi_dq_o_oval;
wire [ 3: 0] io_pads_qspi_dq_o_ie;
wire [ 3: 0] io_pads_qspi_dq_i_ival;
wire [ 3: 0] io_pads_qspi_dq_o_pue;
wire [ 3: 0] io_pads_qspi_dq_o_ds;

assign qspi_dq[0]                  = io_pads_qspi_dq_o_oe[0] ? io_pads_qspi_dq_o_oval[0] : 1'bz;
assign io_pads_qspi_dq_i_ival[0] = qspi_dq[0] & io_pads_qspi_dq_o_ie[0];
assign qspi_dq[1]                  = io_pads_qspi_dq_o_oe[1] ? io_pads_qspi_dq_o_oval[1] : 1'bz;
assign io_pads_qspi_dq_i_ival[1] = qspi_dq[1] & io_pads_qspi_dq_o_ie[1];
assign qspi_dq[2]                  = io_pads_qspi_dq_o_oe[2] ? io_pads_qspi_dq_o_oval[2] : 1'bz;
assign io_pads_qspi_dq_i_ival[2] = qspi_dq[2] & io_pads_qspi_dq_o_ie[2];
assign qspi_dq[3]                  = io_pads_qspi_dq_o_oe[3] ? io_pads_qspi_dq_o_oval[3] : 1'bz;
assign io_pads_qspi_dq_i_ival[3] = qspi_dq[3] & io_pads_qspi_dq_o_ie[3];

// gpio
//wire [31: 0]  gpio_i_ival;
//wire [31: 0]  gpio_o_oval;
//wire [31: 0]  gpio_o_oe;
//wire [31: 0]  gpio_o_ie;
//wire [31: 0]  gpio_o_pue;
//wire [31: 0]  gpio_o_ds;
//
//assign gpio[0]        = gpio_o_oe[0] ? gpio_o_oval[0] : 1'bz;
//assign gpio_i_ival[0] = gpio[0] & gpio_o_ie[0];
//assign gpio[1]        = gpio_o_oe[1] ? gpio_o_oval[1] : 1'bz;
//assign gpio_i_ival[1] = gpio[1] & gpio_o_ie[1];
//assign gpio[2]        = gpio_o_oe[2] ? gpio_o_oval[2] : 1'bz;
//assign gpio_i_ival[2] = gpio[2] & gpio_o_ie[2];
//assign gpio[3]        = gpio_o_oe[3] ? gpio_o_oval[3] : 1'bz;
//assign gpio_i_ival[3] = gpio[3] & gpio_o_ie[3];
//assign gpio[4]        = gpio_o_oe[4] ? gpio_o_oval[4] : 1'bz;
//assign gpio_i_ival[4] = gpio[4] & gpio_o_ie[4];
//assign gpio[5]        = gpio_o_oe[5] ? gpio_o_oval[5] : 1'bz;
//assign gpio_i_ival[5] = gpio[5] & gpio_o_ie[5];
//assign gpio[6]        = gpio_o_oe[6] ? gpio_o_oval[6] : 1'bz;
//assign gpio_i_ival[6] = gpio[6] & gpio_o_ie[6];
//assign gpio[7]        = gpio_o_oe[7] ? gpio_o_oval[7] : 1'bz;
//assign gpio_i_ival[7] = gpio[7] & gpio_o_ie[7];
//assign gpio[8]        = gpio_o_oe[8] ? gpio_o_oval[8] : 1'bz;
//assign gpio_i_ival[8] = gpio[8] & gpio_o_ie[8];
//assign gpio[9]        = gpio_o_oe[9] ? gpio_o_oval[9] : 1'bz;
//assign gpio_i_ival[9] = gpio[9] & gpio_o_ie[9];
//assign gpio[10]        = gpio_o_oe[10] ? gpio_o_oval[10] : 1'bz;
//assign gpio_i_ival[10] = gpio[10] & gpio_o_ie[10];
//assign gpio[11]        = gpio_o_oe[11] ? gpio_o_oval[11] : 1'bz;
//assign gpio_i_ival[11] = gpio[11] & gpio_o_ie[11];
//assign gpio[12]        = gpio_o_oe[12] ? gpio_o_oval[12] : 1'bz;
//assign gpio_i_ival[12] = gpio[12] & gpio_o_ie[12];
//assign gpio[13]        = gpio_o_oe[13] ? gpio_o_oval[13] : 1'bz;
//assign gpio_i_ival[13] = gpio[13] & gpio_o_ie[13];
//assign gpio[14]        = gpio_o_oe[14] ? gpio_o_oval[14] : 1'bz;
//assign gpio_i_ival[14] = gpio[14] & gpio_o_ie[14];
//assign gpio[15]        = gpio_o_oe[15] ? gpio_o_oval[15] : 1'bz;
//assign gpio_i_ival[15] = gpio[15] & gpio_o_ie[15];
//assign gpio[16]        = gpio_o_oe[16] ? gpio_o_oval[16] : 1'bz;
//assign gpio_i_ival[16] = gpio[16] & gpio_o_ie[16];
//assign gpio[17]        = gpio_o_oe[17] ? gpio_o_oval[17] : 1'bz;
//assign gpio_i_ival[17] = gpio[17] & gpio_o_ie[17];
//assign gpio[18]        = gpio_o_oe[18] ? gpio_o_oval[18] : 1'bz;
//assign gpio_i_ival[18] = gpio[18] & gpio_o_ie[18];
//assign gpio[19]        = gpio_o_oe[19] ? gpio_o_oval[19] : 1'bz;
//assign gpio_i_ival[19] = gpio[19] & gpio_o_ie[19];
//assign gpio[20]        = gpio_o_oe[20] ? gpio_o_oval[20] : 1'bz;
//assign gpio_i_ival[20] = gpio[20] & gpio_o_ie[20];
//assign gpio[21]        = gpio_o_oe[21] ? gpio_o_oval[21] : 1'bz;
//assign gpio_i_ival[21] = gpio[21] & gpio_o_ie[21];
//assign gpio[22]        = gpio_o_oe[22] ? gpio_o_oval[22] : 1'bz;
//assign gpio_i_ival[22] = gpio[22] & gpio_o_ie[22];
//assign gpio[23]        = gpio_o_oe[23] ? gpio_o_oval[23] : 1'bz;
//assign gpio_i_ival[23] = gpio[23] & gpio_o_ie[23];
//assign gpio[24]        = gpio_o_oe[24] ? gpio_o_oval[24] : 1'bz;
//assign gpio_i_ival[24] = gpio[24] & gpio_o_ie[24];
//assign gpio[25]        = gpio_o_oe[25] ? gpio_o_oval[25] : 1'bz;
//assign gpio_i_ival[25] = gpio[25] & gpio_o_ie[25];
//assign gpio[26]        = gpio_o_oe[26] ? gpio_o_oval[26] : 1'bz;
//assign gpio_i_ival[26] = gpio[26] & gpio_o_ie[26];
//assign gpio[27]        = gpio_o_oe[27] ? gpio_o_oval[27] : 1'bz;
//assign gpio_i_ival[27] = gpio[27] & gpio_o_ie[27];
//assign gpio[28]        = gpio_o_oe[28] ? gpio_o_oval[28] : 1'bz;
//assign gpio_i_ival[28] = gpio[28] & gpio_o_ie[28];
//assign gpio[29]        = gpio_o_oe[29] ? gpio_o_oval[29] : 1'bz;
//assign gpio_i_ival[29] = gpio[29] & gpio_o_ie[29];
//assign gpio[30]        = gpio_o_oe[30] ? gpio_o_oval[30] : 1'bz;
//assign gpio_i_ival[30] = gpio[30] & gpio_o_ie[30];
//assign gpio[31]        = gpio_o_oe[31] ? gpio_o_oval[31] : 1'bz;
//assign gpio_i_ival[31] = gpio[31] & gpio_o_ie[31];

 
e203_soc_top e203_soc_top_inst(
	.test_scl_pad_i(test_scl_pad_i),
	.test_scl_pad_o(test_scl_pad_o),       
	.test_scl_padoen_o(test_scl_padoen_o),    
	.test_sda_pad_i(test_sda_pad_i),       
	.test_sda_pad_o(test_sda_pad_o), 
	.test_sda_padoen_o(test_sda_padoen_o),
	
  // This clock should comes from the crystal pad generated high speed clock (16MHz)
  /*input  */    .hfextclk(hfextclk),
  /*output */    .hfxoscen(hfxoscen),// The signal to enable the crystal pad generated clock

  // This clock should comes from the crystal pad generated low speed clock (32.768KHz)
  /*input  */    .lfextclk(lfextclk),
  /*output */    .lfxoscen(lfxoscen),// The signal to enable the crystal pad generated clock


  // The JTAG TCK is input, need to be pull-up
  /*input   */    .io_pads_jtag_TCK_i_ival(jtag_tck),

  // The JTAG TMS is input, need to be pull-up
  /*input   */    .io_pads_jtag_TMS_i_ival(jtag_tms),

  // The JTAG TDI is input, need to be pull-up
  /*input   */    .io_pads_jtag_TDI_i_ival(jtag_tdi),

  // The JTAG TDO is output have enable
  /*output  */    .io_pads_jtag_TDO_o_oval(io_pads_jtag_TDO_o_oval),
  /*output  */    .io_pads_jtag_TDO_o_oe(io_pads_jtag_TDO_o_oe),

  // The GPIO are all bidir pad have enables
  /*input   */    .io_pads_gpio_0_i_ival(gpio_i_ival[0]),
  /*output  */    .io_pads_gpio_0_o_oval(gpio_o_oval[0]),
  /*output  */    .io_pads_gpio_0_o_oe(gpio_o_oe[0]),
  /*output  */    .io_pads_gpio_0_o_ie(gpio_o_ie[0]),
  /*output  */    .io_pads_gpio_0_o_pue(gpio_o_pue[0]),
  /*output  */    .io_pads_gpio_0_o_ds(gpio_o_ds[0]),
  /*input   */    .io_pads_gpio_1_i_ival(gpio_i_ival[1]),
  /*output  */    .io_pads_gpio_1_o_oval(gpio_o_oval[1]),
  /*output  */    .io_pads_gpio_1_o_oe(gpio_o_oe[1]),
  /*output  */    .io_pads_gpio_1_o_ie(gpio_o_ie[1]),
  /*output  */    .io_pads_gpio_1_o_pue(gpio_o_pue[1]),
  /*output  */    .io_pads_gpio_1_o_ds(gpio_o_ds[1]),
  /*input   */    .io_pads_gpio_2_i_ival(gpio_i_ival[2]),
  /*output  */    .io_pads_gpio_2_o_oval(gpio_o_oval[2]),
  /*output  */    .io_pads_gpio_2_o_oe(gpio_o_oe[2]),
  /*output  */    .io_pads_gpio_2_o_ie(gpio_o_ie[2]),
  /*output  */    .io_pads_gpio_2_o_pue(gpio_o_pue[2]),
  /*output  */    .io_pads_gpio_2_o_ds(gpio_o_ds[2]),
  /*input   */    .io_pads_gpio_3_i_ival(gpio_i_ival[3]),
  /*output  */    .io_pads_gpio_3_o_oval(gpio_o_oval[3]),
  /*output  */    .io_pads_gpio_3_o_oe(gpio_o_oe[3]),
  /*output  */    .io_pads_gpio_3_o_ie(gpio_o_ie[3]),
  /*output  */    .io_pads_gpio_3_o_pue(gpio_o_pue[3]),
  /*output  */    .io_pads_gpio_3_o_ds(gpio_o_ds[3]),
  /*input   */    .io_pads_gpio_4_i_ival(gpio_i_ival[4]),
  /*output  */    .io_pads_gpio_4_o_oval(gpio_o_oval[4]),
  /*output  */    .io_pads_gpio_4_o_oe(gpio_o_oe[4]),
  /*output  */    .io_pads_gpio_4_o_ie(gpio_o_ie[4]),
  /*output  */    .io_pads_gpio_4_o_pue(gpio_o_pue[4]),
  /*output  */    .io_pads_gpio_4_o_ds(gpio_o_ds[4]),
  /*input   */    .io_pads_gpio_5_i_ival(gpio_i_ival[5]),
  /*output  */    .io_pads_gpio_5_o_oval(gpio_o_oval[5]),
  /*output  */    .io_pads_gpio_5_o_oe(gpio_o_oe[5]),
  /*output  */    .io_pads_gpio_5_o_ie(gpio_o_ie[5]),
  /*output  */    .io_pads_gpio_5_o_pue(gpio_o_pue[5]),
  /*output  */    .io_pads_gpio_5_o_ds(gpio_o_ds[5]),
  /*input   */    .io_pads_gpio_6_i_ival(gpio_i_ival[6]),
  /*output  */    .io_pads_gpio_6_o_oval(gpio_o_oval[6]),
  /*output  */    .io_pads_gpio_6_o_oe(gpio_o_oe[6]),
  /*output  */    .io_pads_gpio_6_o_ie(gpio_o_ie[6]),
  /*output  */    .io_pads_gpio_6_o_pue(gpio_o_pue[6]),
  /*output  */    .io_pads_gpio_6_o_ds(gpio_o_ds[6]),
  /*input   */    .io_pads_gpio_7_i_ival(gpio_i_ival[7]),
  /*output  */    .io_pads_gpio_7_o_oval(gpio_o_oval[7]),
  /*output  */    .io_pads_gpio_7_o_oe(gpio_o_oe[7]),
  /*output  */    .io_pads_gpio_7_o_ie(gpio_o_ie[7]),
  /*output  */    .io_pads_gpio_7_o_pue(gpio_o_pue[7]),
  /*output  */    .io_pads_gpio_7_o_ds(gpio_o_ds[7]),
  /*input   */    .io_pads_gpio_8_i_ival(gpio_i_ival[8]),
  /*output  */    .io_pads_gpio_8_o_oval(gpio_o_oval[8]),
  /*output  */    .io_pads_gpio_8_o_oe(gpio_o_oe[8]),
  /*output  */    .io_pads_gpio_8_o_ie(gpio_o_ie[8]),
  /*output  */    .io_pads_gpio_8_o_pue(gpio_o_pue[8]),
  /*output  */    .io_pads_gpio_8_o_ds(gpio_o_ds[8]),
  /*input   */    .io_pads_gpio_9_i_ival(gpio_i_ival[9]),
  /*output  */    .io_pads_gpio_9_o_oval(gpio_o_oval[9]),
  /*output  */    .io_pads_gpio_9_o_oe(gpio_o_oe[9]),
  /*output  */    .io_pads_gpio_9_o_ie(gpio_o_ie[9]),
  /*output  */    .io_pads_gpio_9_o_pue(gpio_o_pue[9]),
  /*output  */    .io_pads_gpio_9_o_ds(gpio_o_ds[9]),
  /*input   */    .io_pads_gpio_10_i_ival(gpio_i_ival[10]),
  /*output  */    .io_pads_gpio_10_o_oval(gpio_o_oval[10]),
  /*output  */    .io_pads_gpio_10_o_oe(gpio_o_oe[10]),
  /*output  */    .io_pads_gpio_10_o_ie(gpio_o_ie[10]),
  /*output  */    .io_pads_gpio_10_o_pue(gpio_o_pue[10]),
  /*output  */    .io_pads_gpio_10_o_ds(gpio_o_ds[10]),
  /*input   */    .io_pads_gpio_11_i_ival(gpio_i_ival[11]),
  /*output  */    .io_pads_gpio_11_o_oval(gpio_o_oval[11]),
  /*output  */    .io_pads_gpio_11_o_oe(gpio_o_oe[11]),
  /*output  */    .io_pads_gpio_11_o_ie(gpio_o_ie[11]),
  /*output  */    .io_pads_gpio_11_o_pue(gpio_o_pue[11]),
  /*output  */    .io_pads_gpio_11_o_ds(gpio_o_ds[11]),
  /*input   */    .io_pads_gpio_12_i_ival(gpio_i_ival[12]),
  /*output  */    .io_pads_gpio_12_o_oval(gpio_o_oval[12]),
  /*output  */    .io_pads_gpio_12_o_oe(gpio_o_oe[12]),
  /*output  */    .io_pads_gpio_12_o_ie(gpio_o_ie[12]),
  /*output  */    .io_pads_gpio_12_o_pue(gpio_o_pue[12]),
  /*output  */    .io_pads_gpio_12_o_ds(gpio_o_ds[12]),
  /*input   */    .io_pads_gpio_13_i_ival(gpio_i_ival[13]),
  /*output  */    .io_pads_gpio_13_o_oval(gpio_o_oval[13]),
  /*output  */    .io_pads_gpio_13_o_oe(gpio_o_oe[13]),
  /*output  */    .io_pads_gpio_13_o_ie(gpio_o_ie[13]),
  /*output  */    .io_pads_gpio_13_o_pue(gpio_o_pue[13]),
  /*output  */    .io_pads_gpio_13_o_ds(gpio_o_ds[13]),
  /*input   */    .io_pads_gpio_14_i_ival(gpio_i_ival[14]),
  /*output  */    .io_pads_gpio_14_o_oval(gpio_o_oval[14]),
  /*output  */    .io_pads_gpio_14_o_oe(gpio_o_oe[14]),
  /*output  */    .io_pads_gpio_14_o_ie(gpio_o_ie[14]),
  /*output  */    .io_pads_gpio_14_o_pue(gpio_o_pue[14]),
  /*output  */    .io_pads_gpio_14_o_ds(gpio_o_ds[14]),
  /*input   */    .io_pads_gpio_15_i_ival(gpio_i_ival[15]),
  /*output  */    .io_pads_gpio_15_o_oval(gpio_o_oval[15]),
  /*output  */    .io_pads_gpio_15_o_oe(gpio_o_oe[15]),
  /*output  */    .io_pads_gpio_15_o_ie(gpio_o_ie[15]),
  /*output  */    .io_pads_gpio_15_o_pue(gpio_o_pue[15]),
  /*output  */    .io_pads_gpio_15_o_ds(gpio_o_ds[15]),
  /*input   */    .io_pads_gpio_16_i_ival(gpio_i_ival[16]),
  /*output  */    .io_pads_gpio_16_o_oval(gpio_o_oval[16]),
  /*output  */    .io_pads_gpio_16_o_oe(gpio_o_oe[16]),
  /*output  */    .io_pads_gpio_16_o_ie(gpio_o_ie[16]),
  /*output  */    .io_pads_gpio_16_o_pue(gpio_o_pue[16]),
  /*output  */    .io_pads_gpio_16_o_ds(gpio_o_ds[16]),
  /*input   */    .io_pads_gpio_17_i_ival(gpio_i_ival[17]),
  /*output  */    .io_pads_gpio_17_o_oval(gpio_o_oval[17]),
  /*output  */    .io_pads_gpio_17_o_oe(gpio_o_oe[17]),
  /*output  */    .io_pads_gpio_17_o_ie(gpio_o_ie[17]),
  /*output  */    .io_pads_gpio_17_o_pue(gpio_o_pue[17]),
  /*output  */    .io_pads_gpio_17_o_ds(gpio_o_ds[17]),
  /*input   */    .io_pads_gpio_18_i_ival(gpio_i_ival[18]),
  /*output  */    .io_pads_gpio_18_o_oval(gpio_o_oval[18]),
  /*output  */    .io_pads_gpio_18_o_oe(gpio_o_oe[18]),
  /*output  */    .io_pads_gpio_18_o_ie(gpio_o_ie[18]),
  /*output  */    .io_pads_gpio_18_o_pue(gpio_o_pue[18]),
  /*output  */    .io_pads_gpio_18_o_ds(gpio_o_ds[18]),
  /*input   */    .io_pads_gpio_19_i_ival(gpio_i_ival[19]),
  /*output  */    .io_pads_gpio_19_o_oval(gpio_o_oval[19]),
  /*output  */    .io_pads_gpio_19_o_oe(gpio_o_oe[19]),
  /*output  */    .io_pads_gpio_19_o_ie(gpio_o_ie[19]),
  /*output  */    .io_pads_gpio_19_o_pue(gpio_o_pue[19]),
  /*output  */    .io_pads_gpio_19_o_ds(gpio_o_ds[19]),
  /*input   */    .io_pads_gpio_20_i_ival(gpio_i_ival[20]),
  /*output  */    .io_pads_gpio_20_o_oval(gpio_o_oval[20]),
  /*output  */    .io_pads_gpio_20_o_oe(gpio_o_oe[20]),
  /*output  */    .io_pads_gpio_20_o_ie(gpio_o_ie[20]),
  /*output  */    .io_pads_gpio_20_o_pue(gpio_o_pue[20]),
  /*output  */    .io_pads_gpio_20_o_ds(gpio_o_ds[20]),
  /*input   */    .io_pads_gpio_21_i_ival(gpio_i_ival[21]),
  /*output  */    .io_pads_gpio_21_o_oval(gpio_o_oval[21]),
  /*output  */    .io_pads_gpio_21_o_oe(gpio_o_oe[21]),
  /*output  */    .io_pads_gpio_21_o_ie(gpio_o_ie[21]),
  /*output  */    .io_pads_gpio_21_o_pue(gpio_o_pue[21]),
  /*output  */    .io_pads_gpio_21_o_ds(gpio_o_ds[21]),
  /*input   */    .io_pads_gpio_22_i_ival(gpio_i_ival[22]),
  /*output  */    .io_pads_gpio_22_o_oval(gpio_o_oval[22]),
  /*output  */    .io_pads_gpio_22_o_oe(gpio_o_oe[22]),
  /*output  */    .io_pads_gpio_22_o_ie(gpio_o_ie[22]),
  /*output  */    .io_pads_gpio_22_o_pue(gpio_o_pue[22]),
  /*output  */    .io_pads_gpio_22_o_ds(gpio_o_ds[22]),
  /*input   */    .io_pads_gpio_23_i_ival(gpio_i_ival[23]),
  /*output  */    .io_pads_gpio_23_o_oval(gpio_o_oval[23]),
  /*output  */    .io_pads_gpio_23_o_oe(gpio_o_oe[23]),
  /*output  */    .io_pads_gpio_23_o_ie(gpio_o_ie[23]),
  /*output  */    .io_pads_gpio_23_o_pue(gpio_o_pue[23]),
  /*output  */    .io_pads_gpio_23_o_ds(gpio_o_ds[23]),
  /*input   */    .io_pads_gpio_24_i_ival(gpio_i_ival[24]),
  /*output  */    .io_pads_gpio_24_o_oval(gpio_o_oval[24]),
  /*output  */    .io_pads_gpio_24_o_oe(gpio_o_oe[24]),
  /*output  */    .io_pads_gpio_24_o_ie(gpio_o_ie[24]),
  /*output  */    .io_pads_gpio_24_o_pue(gpio_o_pue[24]),
  /*output  */    .io_pads_gpio_24_o_ds(gpio_o_ds[24]),
  /*input   */    .io_pads_gpio_25_i_ival(gpio_i_ival[25]),
  /*output  */    .io_pads_gpio_25_o_oval(gpio_o_oval[25]),
  /*output  */    .io_pads_gpio_25_o_oe(gpio_o_oe[25]),
  /*output  */    .io_pads_gpio_25_o_ie(gpio_o_ie[25]),
  /*output  */    .io_pads_gpio_25_o_pue(gpio_o_pue[25]),
  /*output  */    .io_pads_gpio_25_o_ds(gpio_o_ds[25]),
  /*input   */    .io_pads_gpio_26_i_ival(gpio_i_ival[26]),
  /*output  */    .io_pads_gpio_26_o_oval(gpio_o_oval[26]),
  /*output  */    .io_pads_gpio_26_o_oe(gpio_o_oe[26]),
  /*output  */    .io_pads_gpio_26_o_ie(gpio_o_ie[26]),
  /*output  */    .io_pads_gpio_26_o_pue(gpio_o_pue[26]),
  /*output  */    .io_pads_gpio_26_o_ds(gpio_o_ds[26]),
  /*input   */    .io_pads_gpio_27_i_ival(gpio_i_ival[27]),
  /*output  */    .io_pads_gpio_27_o_oval(gpio_o_oval[27]),
  /*output  */    .io_pads_gpio_27_o_oe(gpio_o_oe[27]),
  /*output  */    .io_pads_gpio_27_o_ie(gpio_o_ie[27]),
  /*output  */    .io_pads_gpio_27_o_pue(gpio_o_pue[27]),
  /*output  */    .io_pads_gpio_27_o_ds(gpio_o_ds[27]),
  /*input   */    .io_pads_gpio_28_i_ival(gpio_i_ival[28]),
  /*output  */    .io_pads_gpio_28_o_oval(gpio_o_oval[28]),
  /*output  */    .io_pads_gpio_28_o_oe(gpio_o_oe[28]),
  /*output  */    .io_pads_gpio_28_o_ie(gpio_o_ie[28]),
  /*output  */    .io_pads_gpio_28_o_pue(gpio_o_pue[28]),
  /*output  */    .io_pads_gpio_28_o_ds(gpio_o_ds[28]),
  /*input   */    .io_pads_gpio_29_i_ival(gpio_i_ival[29]),
  /*output  */    .io_pads_gpio_29_o_oval(gpio_o_oval[29]),
  /*output  */    .io_pads_gpio_29_o_oe(gpio_o_oe[29]),
  /*output  */    .io_pads_gpio_29_o_ie(gpio_o_ie[29]),
  /*output  */    .io_pads_gpio_29_o_pue(gpio_o_pue[29]),
  /*output  */    .io_pads_gpio_29_o_ds(gpio_o_ds[29]),
  /*input   */    .io_pads_gpio_30_i_ival(gpio_i_ival[30]),
  /*output  */    .io_pads_gpio_30_o_oval(gpio_o_oval[30]),
  /*output  */    .io_pads_gpio_30_o_oe(gpio_o_oe[30]),
  /*output  */    .io_pads_gpio_30_o_ie(gpio_o_ie[30]),
  /*output  */    .io_pads_gpio_30_o_pue(gpio_o_pue[30]),
  /*output  */    .io_pads_gpio_30_o_ds(gpio_o_ds[30]),
  /*input   */    .io_pads_gpio_31_i_ival(gpio_i_ival[31]),
  /*output  */    .io_pads_gpio_31_o_oval(gpio_o_oval[31]),
  /*output  */    .io_pads_gpio_31_o_oe(gpio_o_oe[31]),
  /*output  */    .io_pads_gpio_31_o_ie(gpio_o_ie[31]),
  /*output  */    .io_pads_gpio_31_o_pue(gpio_o_pue[31]),
  /*output  */    .io_pads_gpio_31_o_ds(gpio_o_ds[31]),


  //QSPI SCK and CS is output without enable
  /*output  */    .io_pads_qspi_sck_o_oval(qspi_sck),
  /*output  */    .io_pads_qspi_cs_0_o_oval(qspi_cs_0),

  //QSPI DQ is bidir I/O with enable, and need pull-up enable
  /*input   */    .io_pads_qspi_dq_0_i_ival(io_pads_qspi_dq_i_ival[0]),
  /*output  */    .io_pads_qspi_dq_0_o_oval(io_pads_qspi_dq_o_oval[0]),
  /*output  */    .io_pads_qspi_dq_0_o_oe(io_pads_qspi_dq_o_oe[0]),
  /*output  */    .io_pads_qspi_dq_0_o_ie(io_pads_qspi_dq_o_ie[0]),
  /*output  */    .io_pads_qspi_dq_0_o_pue(io_pads_qspi_dq_o_pue[0]),
  /*output  */    .io_pads_qspi_dq_0_o_ds(io_pads_qspi_dq_o_ds[0]),
  /*input   */    .io_pads_qspi_dq_1_i_ival(io_pads_qspi_dq_i_ival[1]),
  /*output  */    .io_pads_qspi_dq_1_o_oval(io_pads_qspi_dq_o_oval[1]),
  /*output  */    .io_pads_qspi_dq_1_o_oe(io_pads_qspi_dq_o_oe[1]),
  /*output  */    .io_pads_qspi_dq_1_o_ie(io_pads_qspi_dq_o_ie[1]),
  /*output  */    .io_pads_qspi_dq_1_o_pue(io_pads_qspi_dq_o_pue[1]),
  /*output  */    .io_pads_qspi_dq_1_o_ds(io_pads_qspi_dq_o_ds[1]),
  /*input   */    .io_pads_qspi_dq_2_i_ival(io_pads_qspi_dq_i_ival[2]),
  /*output  */    .io_pads_qspi_dq_2_o_oval(io_pads_qspi_dq_o_oval[2]),
  /*output  */    .io_pads_qspi_dq_2_o_oe(io_pads_qspi_dq_o_oe[2]),
  /*output  */    .io_pads_qspi_dq_2_o_ie(io_pads_qspi_dq_o_ie[2]),
  /*output  */    .io_pads_qspi_dq_2_o_pue(io_pads_qspi_dq_o_pue[2]),
  /*output  */    .io_pads_qspi_dq_2_o_ds(io_pads_qspi_dq_o_ds[2]),
  /*input   */    .io_pads_qspi_dq_3_i_ival(io_pads_qspi_dq_i_ival[3]),
  /*output  */    .io_pads_qspi_dq_3_o_oval(io_pads_qspi_dq_o_oval[3]),
  /*output  */    .io_pads_qspi_dq_3_o_oe(io_pads_qspi_dq_o_oe[3]),
  /*output  */    .io_pads_qspi_dq_3_o_ie(io_pads_qspi_dq_o_ie[3]),
  /*output  */    .io_pads_qspi_dq_3_o_pue(io_pads_qspi_dq_o_pue[3]),
  /*output  */    .io_pads_qspi_dq_3_o_ds(io_pads_qspi_dq_o_ds[3]),

  // Erst is input need to be pull-up by default
  /*input   */    .io_pads_aon_erst_n_i_ival(aon_erst_n),

  // dbgmode are inputs need to be pull-up by default
  /*input  */    .io_pads_dbgmode0_n_i_ival(dbgmode0_n),
  /*input  */    .io_pads_dbgmode1_n_i_ival(dbgmode1_n),
  /*input  */    .io_pads_dbgmode2_n_i_ival(dbgmode2_n),

  // BootRom is input need to be pull-up by default
  /*input  */    .io_pads_bootrom_n_i_ival(bootrom_n),


  // dwakeup is input need to be pull-up by default
  /*input  */    .io_pads_aon_pmu_dwakeup_n_i_ival(aon_pmu_dwakeup_n),

  // PMU output is just output without enable
  /*output */    .io_pads_aon_pmu_padrst_o_oval(aon_pmu_padrst),
  /*output */    .io_pads_aon_pmu_vddpaden_o_oval(aon_pmu_vddpaden)
);



endmodule
