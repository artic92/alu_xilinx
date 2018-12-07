----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:30 12/29/2015 
-- Design Name: 
-- Module Name:    decoder2_4 - DataFlow 
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

entity decoder2_4 is
    Port ( input : in  STD_LOGIC_VECTOR(1 downto 0);
           output : out  STD_LOGIC_VECTOR(3 downto 0));
end decoder2_4;

architecture DataFlow of decoder2_4 is

begin

with input select output <= x"1" when "00",
									 x"2" when "01",
									 x"4" when "10",
									 x"8" when "11",
									 x"0" when others;
									 
end DataFlow;

