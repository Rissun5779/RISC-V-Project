	component Qsys is
		port (
			altpll_areset_conduit_export           : in  std_logic                    := 'X'; -- export
			altpll_locked_conduit_export           : out std_logic;                           -- export
			clk_clk                                : in  std_logic                    := 'X'; -- clk
			led_external_connection_export         : out std_logic_vector(3 downto 0);        -- export
			reset_reset_n                          : in  std_logic                    := 'X'; -- reset_n
			ws2812_control_conduit_end_dout_export : out std_logic                            -- export
		);
	end component Qsys;

	u0 : component Qsys
		port map (
			altpll_areset_conduit_export           => CONNECTED_TO_altpll_areset_conduit_export,           --           altpll_areset_conduit.export
			altpll_locked_conduit_export           => CONNECTED_TO_altpll_locked_conduit_export,           --           altpll_locked_conduit.export
			clk_clk                                => CONNECTED_TO_clk_clk,                                --                             clk.clk
			led_external_connection_export         => CONNECTED_TO_led_external_connection_export,         --         led_external_connection.export
			reset_reset_n                          => CONNECTED_TO_reset_reset_n,                          --                           reset.reset_n
			ws2812_control_conduit_end_dout_export => CONNECTED_TO_ws2812_control_conduit_end_dout_export  -- ws2812_control_conduit_end_dout.export
		);

