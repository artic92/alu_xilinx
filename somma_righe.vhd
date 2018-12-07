----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:31:51 11/18/2015 
-- Design Name: 
-- Module Name:    somma_righe - Structural 
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

entity somma_righe is
	 generic ( n: natural := 4;
						 m : natural := 4);
    Port ( PROD_PARZIALI : in  STD_LOGIC_VECTOR (n*m-1 downto 0);
				  P : out  STD_LOGIC_VECTOR (n+m-1 downto 0));
end somma_righe;

architecture sommaPerRighe of somma_righe is

COMPONENT ripple_carry_adder
generic ( n : natural := 4 );
PORT(
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(n-1 downto 0);
	c_in : IN std_logic;          
	c_out : OUT std_logic;
	S : OUT std_logic_vector(n-1 downto 0)
	);
END COMPONENT;

signal prodotto_parziale_primo_livello_A : std_logic_vector(n-1 downto 0) := (others => '0'); 
signal somme_parziali : std_logic_vector(((n+1)*(m-1))-1 downto 0);

begin

P(0) <= PROD_PARZIALI(0);
prodotto_parziale_primo_livello_A(n-2 downto 0) <= PROD_PARZIALI(n-1 downto 1); 

ripple_carry_adder_livello0: ripple_carry_adder
	generic map(n)
	PORT MAP(A => prodotto_parziale_primo_livello_A,
								B => PROD_PARZIALI(2*n-1 downto n),
								c_in => '0',
								c_out => somme_parziali(n),
								S => somme_parziali(n-1 downto 0)
);

P(1) <= somme_parziali(0);

other_levels_gen : for i in 1 to m-2 generate
	ripple_carry_adder_livello_i: ripple_carry_adder
	generic map(n)
	PORT MAP(A => PROD_PARZIALI(n*(i+1)+n-1 downto n*(i+1)),
								B => somme_parziali(((n+1)*i)-1 downto (n+1)*(i-1)+1),
								c_in => '0',
								c_out => somme_parziali((n+1)*(i+1)-1),
								S => somme_parziali((n+1)*(i+1)-2 downto (n+1)*i)
	);
	
	P(i+1) <= somme_parziali((n+1)*i);
end generate;

P(n+m-1 downto m) <= somme_parziali(((n+1)*(m-1))-1 downto ((n+1)*(m-1))-n);

end sommaPerRighe;

architecture sommaPerDiagonali of somma_righe is

COMPONENT carry_save_logic
generic (n : natural := 4);
PORT(
	A : IN std_logic_vector(n-1 downto 0):= (others => '0');
	B : IN std_logic_vector(n-1 downto 0);
	C : IN std_logic_vector(n-1 downto 0);          
	CS : OUT std_logic_vector(n-1 downto 0);
	T : OUT std_logic_vector(n-1 downto 0)
	);
END COMPONENT;

COMPONENT ripple_carry_adder
generic ( n : natural := 4 );
PORT(
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(n-1 downto 0);
	c_in : IN std_logic;          
	c_out : OUT std_logic;
	S : OUT std_logic_vector(n-1 downto 0)
	);
END COMPONENT;

signal somme_parziali : std_logic_vector((((n-1)*(m-1))-2)+m downto 0);
signal riporti_parziali : std_logic_vector(((n-1)*(m-1))-1 downto 0);

begin

P(0) <= PROD_PARZIALI(0);

csl_primo_livello: carry_save_logic 
generic map(n-1)
PORT MAP(
	A => open,
	B => PROD_PARZIALI(n-1 downto 1),
	C => PROD_PARZIALI(2*(n-1) downto n),
	CS => riporti_parziali(n-2 downto 0),
	T => somme_parziali(n-2 downto 0));

P(1) <= somme_parziali(0);
somme_parziali(n-1) <= PROD_PARZIALI(2*(n-1)+1);

other_levels_gen : for i in 1 to m-2 generate
	csl_livello_i : carry_save_logic
	generic map(n-1) 
	port map(
			A => PROD_PARZIALI(2*(n-1)+(i*n) downto (2*(n-1))+(n*(i-1))+2),
			B => riporti_parziali(((n-1)*i)-1 downto (n-1)*(i-1)),
			C => somme_parziali((n*i)-1 downto (n*(i-1))+1),
			CS => riporti_parziali((n-2)+((n-1)*i) downto (n-1)+((n-1)*(i-1))),
			T => somme_parziali((n-1)+(n*i)-1 downto n+(n*(i-1))));
			
	P(i+1) <= somme_parziali(n*i);
	somme_parziali((2*(n-1))+(n*(i-1))+1) <= PROD_PARZIALI((3*(n-1))+(n*(i-1))+2);
end generate;

rca_ulitmo_livello: ripple_carry_adder
generic map(n-1)
PORT MAP(A => riporti_parziali(((m-1)*(n-1))-1 downto ((m-1)*(n-1))-n+1),
							B => somme_parziali(((m-1)*(n-1))-2+m downto ((m-1)*(n-1))+m-n),
							c_in => '0',
							c_out => P(n+m-1),
							S => P(n+m-2 downto m));
							
end sommaPerDiagonali;