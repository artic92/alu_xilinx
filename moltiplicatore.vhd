----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:06 11/18/2015 
-- Design Name: 
-- Module Name:    moltiplicatore - Structural 
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

entity moltiplicatore is
	 generic( n : natural := 2;
						m : natural := 2);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (m-1 downto 0);
           P : out  STD_LOGIC_VECTOR (n+m-1 downto 0));
end moltiplicatore;

architecture Structural of moltiplicatore is

COMPONENT prodotto_parziale
	 generic ( n: natural := 4;
						 m : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (m-1 downto 0);
           O : out  STD_LOGIC_VECTOR (n*m-1 downto 0));
END COMPONENT;

COMPONENT somma_righe
	 generic ( n: natural := 4;
						 m : natural := 4);
    Port ( PROD_PARZIALI : in  STD_LOGIC_VECTOR (n*m-1 downto 0);
				  P : out  STD_LOGIC_VECTOR (n+m-1 downto 0));
END COMPONENT;

-- Per usare il metodo della somma per righe
--for all : somma_righe use entity work.somma_righe(sommaPerRighe);
-- Per usare il metodo della somma per diagonali
for all : somma_righe use entity work.somma_righe(sommaPerDiagonali);

signal p_parziali : STD_LOGIC_VECTOR (n*m-1 downto 0);

begin

circuito_prodotto_parziale: prodotto_parziale 
	generic map(n, m)
	PORT MAP(A => A, B => B, O => p_parziali);
	
circuito_somma_righe: somma_righe 
	generic map(n, m)
	PORT MAP(PROD_PARZIALI => p_parziali, P => P);

end Structural;

