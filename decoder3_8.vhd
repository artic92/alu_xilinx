----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:15:54 12/23/2015 
-- Design Name: 
-- Module Name:    decoder3_8 - DataFlow 
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

entity decoder3_8 is
	 Port ( input : in  STD_LOGIC_VECTOR (2 downto 0);
		    output : out  STD_LOGIC_VECTOR (7 downto 0));
end decoder3_8;

architecture DataFlow of decoder3_8 is

begin

with input select output <= x"01" when "000",
									 x"02" when "001",
									 x"04" when "010",
									 x"08" when "011",
									 x"10" when "100",
									 x"20" when "101",
									 x"40" when "110",
									 x"80" when "111",
									 x"00" when others;

end DataFlow;

