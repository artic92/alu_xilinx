----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:22 12/19/2015 
-- Design Name: 
-- Module Name:    contatore - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contatore is
	generic(n : natural :=8);
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           counter_en : in  STD_LOGIC;
           counting : out  STD_LOGIC_VECTOR (n-1 downto 0));
end contatore;

architecture Behavioral of contatore is

signal pre_counting : std_logic_vector(n-1 downto 0) := (others => '0');

begin

process(clock,reset,pre_counting)
begin
if(reset = '0')then
	pre_counting<=(others => '0');
elsif(rising_edge(clock))then
	if(counter_en='1')then
		pre_counting<=pre_counting+ 1;
	end if;
end if;
counting<=pre_counting;
end process;

end Behavioral;

