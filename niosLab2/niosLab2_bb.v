
module niosLab2 (
	clk_clk,
	leds_export,
	motor_export,
	pioin_export,
	reset_reset_n);	

	input		clk_clk;
	output	[5:0]	leds_export;
	output	[4:0]	motor_export;
	input	[4:0]	pioin_export;
	input		reset_reset_n;
endmodule
