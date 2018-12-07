----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:51 11/15/2015 
-- Design Name: 
-- Module Name:    cla_block - structural 
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

entity cla_block is
generic(n : integer := 4);
port(
		P : in std_logic_vector(n-1 downto 0);
		G : in std_logic_vector(n-1 downto 0);
		c_in : in std_logic;
		C : out std_logic_vector(n downto 0)
);
end cla_block;

architecture structural of cla_block is

signal c_temp : std_logic_vector(n downto 0) := (others => '0');


begin

c_temp(0) <= c_in;
cycle: for i in 1 to n generate
		c_temp(i) <= (G(i-1) or (P(i-1) and c_temp(i-1)));
end generate;

C <= c_temp;

end structural;

