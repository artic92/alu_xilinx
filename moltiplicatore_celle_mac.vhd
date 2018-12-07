----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:10:20 11/19/2015 
-- Design Name: 
-- Module Name:    moltiplicatore_celle_mac - Behavioral 
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

entity moltiplicatore_celle_mac is
	generic ( N : natural := 32;
				 M : natural := 32);
    Port ( A : in  STD_LOGIC_VECTOR(N-1 downto 0);
           B : in  STD_LOGIC_VECTOR(M-1 downto 0);
           P : out  STD_LOGIC_VECTOR(M+N-1 downto 0));
end moltiplicatore_celle_mac;

architecture Behavioral of moltiplicatore_celle_mac is

	COMPONENT mac_riga
		generic ( N : natural := N);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR (N-1 downto 0);
           S_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           c_out : out  STD_LOGIC);
	END COMPONENT;
	
	signal sig_s : std_logic_vector(N*(M+1)+M downto 0);

begin
	
	sig_s(N downto 0) <= (others => '0');
	
	ff_1 : for j in 0 to M-1 generate
		riga_mac_1 : mac_riga
				port map(
					A => A,
					b => B(j),
					--prendo le somme allo stadio precedente scritte nelle prime N posizioni e traslo di ogni riga da passo a passo
					S =>sig_s((N+1)*(j+1)-1 downto (N+1)*j+1),
					--scrivo le somme allo stadio successivvo
					S_out =>sig_s((N+1)*(j+2)-2 downto (N+1)*(j+1)),
					--scrivo il riporto nell'ultima locazione delle somme dello stadio successivo cosi me lo trovo in ingresso
					c_out =>sig_s((N+1)*(j+2)-1));
		-- ogni riga scrive SEMPRE nella medesima posizione una cifra del prodotto
		P(j) <= sig_s((N+1)*(j+1));
	end generate;
	--ultima serie di N bit della matriciona
	P(N+M-1 downto M) <= sig_s(N*(M+1)+M downto N*(M+1)+M-N+1);
end Behavioral;

