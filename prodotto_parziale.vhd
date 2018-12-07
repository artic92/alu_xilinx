----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:03:27 11/18/2015 
-- Design Name: 
-- Module Name:    prodotto_parziale - Structural 
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

entity prodotto_parziale is
	 generic ( n: natural := 4;
						 m : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (m-1 downto 0);
           O : out  STD_LOGIC_VECTOR (n*m-1 downto 0));
end prodotto_parziale;

architecture Structural of prodotto_parziale is

COMPONENT and2
PORT(
	a : IN std_logic;
	b : IN std_logic;          
	o : OUT std_logic
	);
END COMPONENT;

begin

and_inst_j : for j in m-1 downto 0 generate
	and_inst_i :for i in n-1 downto 0 generate
		inst_and2: and2 PORT MAP(a => A(i), b => B(j), o => O(n*j+i));
	end generate;
end generate;

end Structural;

