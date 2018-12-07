----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:30 11/09/2015 
-- Design Name: 
-- Module Name:    D_edge_triggered - Behavioral 
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

entity D_edge_triggered is
port(
		data_in 	: in STD_LOGIC;
		clock 	: in STD_LOGIC;
		data_out : out STD_LOGIC
);
end D_edge_triggered;

architecture Behavioral of D_edge_triggered is

begin

	d_edge: process(data_in, clock)
	begin
	
		--esistono 2 modi per controllare il fronte di salita o discesa di un clock
		-- if(rising_edge(clock)) then
		--oppure
		if(clock = '1' and clock'event) then 	-- clock'event, event è un campo esistente in ogni segnale, è ALTO quando si è appena verificato un evento sul segnale associato!
				data_out <= data_in;
		end if;
	
	end process;

end Behavioral;

