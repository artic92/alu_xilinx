----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:53:19 11/16/2015 
-- Design Name: 
-- Module Name:    mux2n_1 - DataFlow 
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

entity mux2n_1 is
	 generic ( n : natural := 4 );
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           sel : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
end mux2n_1;

architecture Behavioral of mux2n_1 is

begin

with sel select O <= A when '0',
										  B when '1',
										 (others =>'X') when others;

end Behavioral;

