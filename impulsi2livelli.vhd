----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:24:36 12/29/2015 
-- Design Name: 
-- Module Name:    inpulsi2livelli - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inpulsi2livelli is
    Port ( input : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           output : out  STD_LOGIC);
end inpulsi2livelli;

architecture Behavioral of inpulsi2livelli is

	type state is (stateA, stateB);
	signal current_state, next_state : state := stateA;

begin

	registro_stato: process(clock, reset_n)
	begin
		if(reset_n = '0') then
			current_state <= stateA;
		elsif(rising_edge(clock)) then
			current_state <= next_state;
		end if;
	end process;

	fsm: process(current_state, input)
	begin
		case current_state is
			when stateA => 
				output <= '0';
				if(input = '1') then
					next_state <= stateB;
				else
					next_state <= stateA;
				end if;
			when stateB => 
				output <= '1';
				if(input = '1') then
					next_state <= stateA;
				else
					next_state <= stateB;
				end if;
		end case;
	end process;

end Behavioral;

