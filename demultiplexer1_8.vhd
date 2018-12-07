----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:01 12/23/2015 
-- Design Name: 
-- Module Name:    demultiplexer1_8 - Behavioral 
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

entity demultiplexer1_8 is
    Port ( input : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (3 downto 0);
           output1 : out  STD_LOGIC_VECTOR (7 downto 0);
           output2 : out  STD_LOGIC_VECTOR (7 downto 0);
           output3 : out  STD_LOGIC_VECTOR (7 downto 0);
           output4 : out  STD_LOGIC_VECTOR (7 downto 0);
           output5 : out  STD_LOGIC_VECTOR (7 downto 0);
           output6 : out  STD_LOGIC_VECTOR (7 downto 0);
           output7 : out  STD_LOGIC_VECTOR (7 downto 0);
           output8 : out  STD_LOGIC_VECTOR (7 downto 0));
end demultiplexer1_8;

architecture Behavioral of demultiplexer1_8 is

begin

output1 <= input when sel = x"0"
			           else (others => '0');
output2 <= input when sel = x"1"
			            else (others => '0');
output3 <= input when sel = x"2"
							else (others => '0');
output4 <= input when sel = x"3"
							else (others => '0');
output5 <= input when sel = x"4"
							else (others => '0');
output6 <= input when sel = x"5"
							else (others => '0');
output7 <= input when sel = x"6"
							else (others => '0');
output8 <= input when sel = x"7"
							else (others => '0');
			  
end Behavioral;

