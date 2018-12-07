----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:34 11/21/2015 
-- Design Name: 
-- Module Name:    counter - behavioral 
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
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
generic(n: natural :=2);
port(	clock:	in std_logic;
	clear_n:	in std_logic;
	count:	in std_logic;
	Q:	out std_logic := '0'
);
end counter;

----------------------------------------------------
architecture behv of counter is		 	  
signal cnt : std_logic_vector(natural(ceil(log2(real(n)))) downto 0);

begin
	
    process(clock, count, clear_n)
    begin
			if clear_n = '0' then
				cnt <= (others => '0');
				Q <= '0';
			elsif (clock='1' and clock'event) then
				if (count = '1' and cnt < n-1) then
					cnt <= cnt + 1;
				elsif cnt = n-1 then
					Q <= '1';
				end if;
			end if;
    end process;	
	
end behv;
