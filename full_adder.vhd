----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:17:43 11/14/2015 
-- Design Name: 
-- Module Name:    full_adder - Behavioral 
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

entity full_adder is
port(
		x,y,c_in : in STD_LOGIC;
		c_out,sum  : out STD_LOGIC
);
end full_adder;

architecture structural of full_adder is

--il component va definito una sola volta, se voglio più istanze posso usare diverse etichette nella sezione 'BEGIN'
component half_adder
port(
		a,b: in STD_LOGIC;
		carry_out,s : out STD_LOGIC
);
end component;

--segnali di assistenza
signal c1_temp, s_temp, c2_temp : STD_LOGIC;

begin
--faccio 2 istanze del componente half_adder perchè me ne serviranno 2
half_adder_1: half_adder 
port map(x,y,c1_temp,s_temp);

half_adder_2: half_adder 
port map(c_in, s_temp, c2_temp, sum);

c_out <= c1_temp or c2_temp;

end structural;

