----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:45 11/10/2015 
-- Design Name: 
-- Module Name:    shift_reg - Behavioral 
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

entity shift_reg is
generic(n: natural := 4);
port(
		d_in		 : in std_logic;		--mi serve perchè nel bit msb dello shift register ci va sempre il valore contenuto dal flip flop
		I			 : in std_logic_vector(n-1 downto 0) := (others => '0');
		clock		 : in std_logic;
		clear		 : in std_logic;
		load		 : in std_logic;
		shift		 : in std_logic;
		Q			 : out std_logic_vector(n-1 downto 0);
		Q_ext		 : out std_logic;
		d_out		 : out std_logic
);
end shift_reg;

architecture Behavioral of shift_reg is

begin

	shift_proc: process(d_in, clock, clear, load)
	variable internal_value: STD_LOGIC_VECTOR (n-1 downto 0) := (others => '0');
	
	begin
		if(clear = '0')then
				internal_value := (others => '0');
				d_out <= '0';
				Q_ext <= '0';
		elsif(clock = '1' and clock'event)then
				if(load = '1')then
						internal_value := I;
				elsif(shift = '1')then
						-- shift a destra
						Q_ext <= internal_value(0);
						internal_value := d_in & internal_value(n-1 downto 1);
				end if;
		end if;
	
	Q <= internal_value;
	--la seguente  istruzione va messa all'esterno dell'if perchè quando accedo al registro prima di fare lo shift mi salvo il bit 0, che successivamente verrà buttato dallo SHIFT
	d_out <= internal_value(0);

	end process;
	end Behavioral;