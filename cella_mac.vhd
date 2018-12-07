----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:03:30 11/19/2015 
-- Design Name: 
-- Module Name:    cella_mac - Behavioral 
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

entity cella_mac is
    Port ( a_in : in  STD_LOGIC;
           b_in : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           s_in : in  STD_LOGIC;
           c_out : out  STD_LOGIC;
           s_out : out  STD_LOGIC);
end cella_mac;

architecture Behavioral of cella_mac is

component full_adder
port(
		x,y,c_in : in STD_LOGIC;
		c_out,sum  : out STD_LOGIC
);
end component;

signal u_and : std_logic := '0';

begin
	u_and<= a_in and b_in;

	full_adder_i : full_adder
		port map(s_in,u_and,c_in,c_out,s_out);

end Behavioral;

