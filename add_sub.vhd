----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:34 11/21/2015 
-- Design Name: 
-- Module Name:    add_sub - structural 
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

entity add_sub is
generic(
			n : integer := 4;
			rca_cla : natural := 0
		);
port(
		A : in std_logic_vector(n-1 downto 0);
		B : in std_logic_vector(n-1 downto 0);
		subtract : in std_logic;
		overflow : out std_logic;
		R : out std_logic_vector(n-1 downto 0)
);
end add_sub;

architecture structural of add_sub is

COMPONENT ripple_carry_adder
generic ( N : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  c_in : in STD_LOGIC;
			  ovfl : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (N-1 downto 0));
END COMPONENT;

component cla_adder
generic(n : integer := 4);
port(
		I1 : in std_logic_vector(n-1 downto 0);
		I2 : in std_logic_vector(n-1 downto 0);
		C_in : in std_logic;
		C_out : out std_logic_vector(1 downto 0);
		S : out std_logic_vector(n-1 downto 0)
);
end component;

--segnali ausiliari
signal c_temp : std_logic_vector(1 downto 0) := (others => '0');
signal B_temp : std_logic_vector(n-1 downto 0) := (others => '0');

begin

xor_B: B_temp <= B xor (B'range => subtract);

rca_gen : if rca_cla = 0 generate
		rca: ripple_carry_adder
		generic map(n)
		port map(A, B_temp, subtract, overflow, R);
end generate;

cla_gen : if rca_cla = 1 generate
		cla: cla_adder
		generic map(n)
		port map(A, B_temp, subtract, c_temp, R);
		
		overflow <= c_temp(0) xor c_temp(1);
end generate;

end structural;