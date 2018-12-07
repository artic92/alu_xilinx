----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:58:53 11/15/2015 
-- Design Name: 
-- Module Name:    cla_adder - structural 
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

entity cla_adder is
generic(n : integer := 4);
port(
		I1 : in std_logic_vector(n-1 downto 0);
		I2 : in std_logic_vector(n-1 downto 0);
		C_in : in std_logic;
		C_out : out std_logic_vector(1 downto 0);
		S : out std_logic_vector(n-1 downto 0)
);
end cla_adder;

architecture structural of cla_adder is

component generation_propagation
generic(n : integer := 4);
port(
		A : in std_logic_vector(n-1 downto 0);
		B : in std_logic_vector(n-1 downto 0);
		P : out std_logic_vector(n-1 downto 0);
		G : out std_logic_vector(n-1 downto 0)
);
end component;

component cla_block
generic(n : integer := 4);
port(
		P : in std_logic_vector(n-1 downto 0);
		G : in std_logic_vector(n-1 downto 0);
		c_in : in std_logic;
		C : out std_logic_vector(n downto 0)
);
end component;

component full_adder
port(
		x,y,c_in : in STD_LOGIC;
		c_out,sum  : out STD_LOGIC
);
end component;

--segnali ausiliari
signal p_temp, g_temp : std_logic_vector(n-1 downto 0) := (others => '0');
signal c_temp : std_logic_vector(n downto 0) := (others => '0');

begin

gen_prop: generation_propagation 
	generic map(n)
	port map(I1, I2, p_temp, g_temp);
	--abbiamo ottenuto i 2 vettori p_temp e g_temp

--adesso dobbiamo usare p_temp e g_temp per calcolare gli n+1 RIPORTI
calc_carry: cla_block
	generic map(n)
	port map(p_temp, g_temp, C_in, c_temp);
	--abbiamo ottenuto il vettore c_temp contenente gli n+1 RIPORTI

cycle: for i in 0 to n-1 generate
		f_a: full_adder
			port map(I1(i), I2(i), c_temp(i), open, S(i));
end generate;

C_out(0) <= c_temp(n-1);
C_out(1) <= c_temp(n);

end structural;

