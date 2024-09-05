library IEEE;
use IEEE.std_logic_1164.all;

entity LAB2_FPGA_NIOS is
    port (
        -- Globals
        fpga_clk_50        : in  std_logic;             -- clock.clk

        -- I/Os
		  fpga_sw            : in std_logic_vector(3 downto 0);
		  fpga_stepmotor_io  : out std_logic_vector(3 downto 0);
        fpga_led_pio       : out std_logic_vector(5 downto 0);
		  push_button        : in std_logic
  );
end entity LAB2_FPGA_NIOS;

architecture rtl of LAB2_FPGA_NIOS is

signal motor_pio : std_logic_vector(4 downto 0);

component niosLab2 is
  port (
            clk_clk       : in  std_logic                    := 'X';             -- clk
            leds_export   : out std_logic_vector(5 downto 0);                    -- export
            motor_export  : out std_logic_vector(4 downto 0);                    -- export
            pioin_export  : in  std_logic_vector(4 downto 0) := (others => 'X'); -- export
            reset_reset_n : in  std_logic                    := 'X'              -- reset_n
	  );
end component niosLab2;
begin
u0 : component niosLab2
  port map (
		clk_clk       => fpga_clk_50,       --   clk.clk
		leds_export   => fpga_led_pio,   --  leds.export
		reset_reset_n => '1',  -- reset.reset_n
		pioin_export  => fpga_sw & push_button,
		motor_export  => motor_pio
  );
  
stp_motor : entity work.stepmotor
	port map (
		 clk => fpga_clk_50,
       en  => motor_pio(0),
       dir => motor_pio(1),
       vel => motor_pio(3 downto 2),
		 phases => fpga_stepmotor_io,
	    reset_motor => motor_pio(4)
  );

end rtl;