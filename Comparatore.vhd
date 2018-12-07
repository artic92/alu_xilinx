----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:57:46 12/18/2015 
-- Design Name: 
-- Module Name:    Comparatore - Behavioral 
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

entity Comparatore is
	generic( n : natural :=3);
    Port ( a : in  STD_LOGIC_VECTOR (n-1 downto 0);
           b : in  STD_LOGIC_VECTOR (n-1 downto 0);
           is_equal : out  STD_LOGIC);
end Comparatore;

architecture Behavioral of Comparatore is


begin

process(a,b)
begin
if(a=b)then
	is_equal<='1';
else
	is_equal<='0';
end if;
end process;
end Behavioral;

