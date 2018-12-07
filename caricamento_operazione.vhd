----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:07:31 12/23/2015 
-- Design Name: 
-- Module Name:    caricamento_operazione - Structural 
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

entity caricamento_operazione is
    Port ( operazione_in : in  STD_LOGIC_VECTOR (2 downto 0);
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           load_operazione : in  STD_LOGIC;
           operazione_out : out  STD_LOGIC_VECTOR (2 downto 0);
           operazione_decodificata : out STD_LOGIC_VECTOR (7 downto 0));
end caricamento_operazione;

architecture Structural of caricamento_operazione is

	COMPONENT decoder3_8
	PORT(
		input : IN std_logic_vector(2 downto 0);          
		output : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT registry_n_bit
		generic (n : natural := 8;
						delay : time := 0 ns);
		 Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
				  clock : in  STD_LOGIC;
				  load : in  STD_LOGIC;
				  reset_n : in  STD_LOGIC;
				  O : out  STD_LOGIC_VECTOR (n-1 downto 0));
	END COMPONENT;
	
	signal operazione_out_sig : std_logic_vector (2 downto 0) := (others => '0');

begin

	operazione_out <= operazione_out_sig;

	registro_operazione : registry_n_bit
		generic map(3)
		PORT MAP(I => operazione_in, clock => clock,	load => load_operazione, reset_n => reset_n, O => operazione_out_sig);

	codifica_one_hot: decoder3_8 
		PORT MAP(input => operazione_out_sig, output => operazione_decodificata);

end Structural;

