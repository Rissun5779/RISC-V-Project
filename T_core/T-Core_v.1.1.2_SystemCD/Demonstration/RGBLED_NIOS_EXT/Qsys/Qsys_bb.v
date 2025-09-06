
module Qsys (
	altpll_areset_conduit_export,
	altpll_locked_conduit_export,
	clk_clk,
	led_external_connection_export,
	reset_reset_n,
	ws2812_control_conduit_end_dout_export);	

	input		altpll_areset_conduit_export;
	output		altpll_locked_conduit_export;
	input		clk_clk;
	output	[3:0]	led_external_connection_export;
	input		reset_reset_n;
	output		ws2812_control_conduit_end_dout_export;
endmodule
