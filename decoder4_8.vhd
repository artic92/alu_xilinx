----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:20 12/23/2015 
-- Design Name: 
-- Module Name:    decoder4_8 - DataFlow 
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

entity decoder4_8 is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end decoder4_8;

architecture DataFlow of decoder4_8 is

signal output_sig : std_logic_vector(7 downto 0) := (others => '0');

begin

with input select output <= x"01" when x"0",
									 x"02" when x"1",
									 x"04" when x"2",
									 x"08" when x"3",
									 x"10" when x"4",
									 x"20" when x"5",
									 x"40" when x"6",
									 x"80" when x"7",
									 x"00" when others;

end DataFlow;

