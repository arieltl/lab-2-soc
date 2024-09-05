--
-- Rafael C.
-- ref:
--   - https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vhdl/vhdl_pro_state_machines.htm
--   - https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--   - https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4096117

library IEEE;
use IEEE.std_logic_1164.all;

entity stepmotor is
    port (
        -- Gloabals
        clk   : in  std_logic;

        -- controls
        en      : in std_logic;                     -- 1 on/ 0 of
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast

        -- I/Os
		  
        phases  : out std_logic_vector(3 downto 0);
		  reset_motor: in std_logic
  );
end entity stepmotor;

architecture rtl of stepmotor is

   TYPE STATE_TYPE IS (s0, s1, s2, s3);
   SIGNAL state  : STATE_TYPE := s0;
   signal nextState : std_logic  := '0';
   signal topCounter : integer range 0 to 50000000;
  
begin

  process(clk)
  begin
  if (rising_edge(clk) and en='1') then
            CASE state IS
                WHEN s0 =>
                    if (nextState = '1') then
                        if dir = '1' then
                            state <= s1;
                        else
                            state <= s3;
                        end if;
                    end if;
                WHEN s1 =>
                    if (nextState = '1') then
                        if dir = '1' then
                            state <= s2;
                        else
                            state <= s0;
                        end if;
                    end if;
                WHEN s2 =>
                    if (nextState = '1') then
                        if dir = '1' then
                            state <= s3;
                        else
                            state <= s1;
                        end if;
                    end if;
                WHEN s3 =>
                    if (nextState = '1') then
                        if dir = '1' then
                            state <= s0;
                        else
                            state <= s2;
                        end if;
                    end if;
                when others =>
                    state <= s0;
            END CASE;
        end if;
    end process;
	 
	 
  PROCESS (state)
   BEGIN
      CASE state IS
        WHEN s0 =>
          phases <= "0001";
        WHEN s1 =>
          phases <= "0010";
        WHEN s2 =>
          phases <= "0100";
        when s3 =>
          phases <= "1000";
        when others =>
          phases <= "0000";
      END CASE;
   END PROCESS;

  topCounter <=   900000 when vel = "00" else
                  500000 when vel = "01" else
						100000 when vel = "10" else
						 88000;

  process(clk)
	 variable accelCount : integer range 0 to 50000 := 0;
	 variable maxCount   : integer range 0 to 50000000 := 0;
    variable counter    : integer range 0 to 50000000 := 0;
	  variable countSteps : integer range 0 to 20000 := 0;
  begin
  
	 
	
    if (rising_edge(clk)) then
		if (reset_motor='0') then
			countSteps := 0;
		end if;
		if (not (maxCount = topCounter)) then 
			accelCount := accelCount +1;
		end if;
		if (accelCount > 1000) then
			accelCount := 0;
		end if;
		
		if (maxCount > topCounter and accelCount = 0) then
			maxCount := maxCount - 1;
		elsif (maxCount < topCounter and accelCount = 0) then
			maxCount := maxCount + 1;
		end if;
		
      if (counter < maxCount and countSteps<1500) then
        counter := counter + 1;
        nextState  <= '0';
		  
      elsif (countSteps<1500)then
        counter := 0;
		  countSteps := countSteps + 1;
        nextState  <= '1';
      end if;
    end if;
  end process;

end rtl;
