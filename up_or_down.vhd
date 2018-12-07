----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:38 12/28/2015 
-- Design Name: 
-- Module Name:    up_or_down - Behavioral 
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

entity up_or_down is
    Port ( up : in  STD_LOGIC;
           down : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           set_up_down : out  STD_LOGIC;
           count_en : out  STD_LOGIC);
end up_or_down;

architecture Behavioral of up_or_down is

type state is (stateUp,stateDown);
signal current_state, next_state : state := stateUp;

begin

count_en <= up or down;

registro_stato : process(clock,reset_n)
begin
	if reset_n = '0' then
		current_state <= stateUp;
	elsif rising_edge(clock) then
		current_state <= next_state;
	end if;
end process;

fsm : process (current_state,up,down)
begin
	case current_state is
		when stateUp =>
			if down = '1' then
				set_up_down <= '1';
				next_state <= stateDown;
			else
				set_up_down <= '0';
				next_state <= stateUp; 
			end if;
		when stateDown =>
			if up = '1' then
				set_up_down <= '0';
				next_state <= stateUp;
			else
				set_up_down <= '1';
				next_state <= stateDown; 
			end if;
	end case;
end process;

end Behavioral;

