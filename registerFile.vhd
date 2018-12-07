----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:57 12/23/2015 
-- Design Name: 
-- Module Name:    registerFile64Bit - Behavioral 
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

entity registerFile64Bit is
    Port ( input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           input2 : in  STD_LOGIC_VECTOR (7 downto 0);
           input3 : in  STD_LOGIC_VECTOR (7 downto 0);
           input4 : in  STD_LOGIC_VECTOR (7 downto 0);
           input5 : in  STD_LOGIC_VECTOR (7 downto 0);
           input6 : in  STD_LOGIC_VECTOR (7 downto 0);
           input7 : in  STD_LOGIC_VECTOR (7 downto 0);
           input8 : in  STD_LOGIC_VECTOR (7 downto 0);
           enable : in  STD_LOGIC_VECTOR (7 downto 0);
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0));
end registerFile64Bit;

architecture Behavioral of registerFile64Bit is

COMPONENT registry_n_bit
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

signal input_vector : std_logic_vector (63 downto 0) := (others => '0');

attribute KEEP : string;
attribute KEEP of input_vector : signal is "true";

begin

input_vector <= input8 & input7 & input6 & input5 & input4 & input3 & input2 & input1;

reg_gen : for i in 0 to 7 generate
registro_i : registry_n_bit
	generic map(8)
	PORT MAP(I => input_vector(((i+1)*8)-1 downto 8*i), clock => clock,	load => enable(i), reset_n => reset_n, O => output(((i+1)*8)-1 downto 8*i));	
end generate;

end Behavioral;

