----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:57:02 11/19/2015 
-- Design Name: 
-- Module Name:    mac_riga - Behavioral 
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

entity mac_riga is
	generic ( N : natural := 8);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR (N-1 downto 0);
           S_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           c_out : out  STD_LOGIC);
end mac_riga;

architecture Behavioral of mac_riga is

	COMPONENT cella_mac
		 Port ( a_in : in  STD_LOGIC;
           b_in : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           s_in : in  STD_LOGIC;
           c_out : out  STD_LOGIC;
           s_out : out  STD_LOGIC);
	END COMPONENT;
	
	signal sig_c : std_logic_vector(N downto 0);
begin
	
	sig_c(0) <= '0';

	ff_1 : for i in 0 to N-1 generate 
		cella_mac_1	: cella_mac
					port map
						( a_in => A(i),
						  b_in => b,
						  c_in => sig_c(i),
						  s_in => S(i),
						  c_out => sig_c(i+1),
						  s_out =>S_out(i));
	end generate;

	c_out <= sig_c(N);

end Behavioral;

