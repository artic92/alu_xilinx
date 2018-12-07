----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:01 11/09/2015 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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

entity reg is
generic(N : natural := 2);
port(
		I 		: in std_logic_vector(N-1 downto 0);
		clock : in std_logic; 
		clear : in std_logic; 
		load 	: in std_logic;
		Q		: out std_logic_vector(N-1 downto 0)
);
end reg;

architecture Behavioral of reg is

	signal Q_temp : std_logic_vector(N-1 downto 0);

begin

	register_proc : process(I, clock, load, clear)

	begin
	
	if(clear = '0') then		-- uso logica negata... ovvero clear si attiva quando è 0 non quando è 1
									-- IMPORTANTE notare che il segnale di CLEAR è l'unico segnale ASINCRONO nelle nostre macchine sincrone!
									-- CLEAR ASINCRONO implica che può attivarsi in qualsiasi istante, non per forza sui fronti di salita o discesa del clock
		
		-- Q_temp <= (Q_temp'range => '0');
		Q_temp <= (others => '0');	-- questa scrittura (others) mi permette di inserire '0' in tutti gli N bit del vettore!
	elsif(clock = '1' and clock'event) then
		if(load = '1')then 
			Q_temp <= I;
		end if;
	end if;

	end process;

	--fino ad ora ho lavorato su una variabile temporanea Q_temp, però per terminare correttamente il componente ho bisogno di aggiornare la sua reale uscita:
	Q <= Q_temp;

end Behavioral;

