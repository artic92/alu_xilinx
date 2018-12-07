----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:51:14 12/22/2015 
-- Design Name: 
-- Module Name:    alu - Structural 
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

entity alu is
	 generic (n : natural := 64;
	          rca_cla : natural := 1;
				 mac_moltCombinatorio : natural := 0);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  clock : in STD_LOGIC;
			  reset_n : in STD_LOGIC;
           add : in  STD_LOGIC;
           sub : in  STD_LOGIC;
           mul : in  STD_LOGIC;
           div : in  STD_LOGIC;
           pow : in  STD_LOGIC;
           sqrt : in  STD_LOGIC;
           negA : in  STD_LOGIC;
           AandB : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (n-1 downto 0);
           done : out  STD_LOGIC;
           ovfl : out  STD_LOGIC;
           z : out  STD_LOGIC;
           div_per_zero : out  STD_LOGIC);
end alu;

architecture mulSequenziale of alu is

COMPONENT square_root
generic (n : natural := 8);
PORT(
	clock : IN std_logic;
	reset_n : IN std_logic;
	enable : IN std_logic;
	D : in STD_LOGIC_VECTOR (n-1 downto 0);
	root : out STD_LOGIC_VECTOR ((n/2)-1 downto 0);
	done : OUT std_logic
	);
END COMPONENT;

COMPONENT add_sub
generic(n : integer := 4;
		  rca_cla : natural := 1);
PORT(
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(n-1 downto 0);
	subtract : IN std_logic;          
	overflow : OUT std_logic;
	R : OUT std_logic_vector(n-1 downto 0)
	);
END COMPONENT;

COMPONENT potenza
generic(n :natural := 32);
PORT(
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(n-1 downto 0);
	mode : IN std_logic;
	clock : IN std_logic;
	reset : IN std_logic;
	enable : IN std_logic;          
	done : OUT std_logic;
	potenza : OUT std_logic_vector(2*n-1 downto 0);
	overflow : OUT std_logic
	);
END COMPONENT;

COMPONENT divisore_non_restoring
generic (n : natural := 4);
PORT(
	D : in  STD_LOGIC_VECTOR ((2*n)-2 downto 0);
	V : in  STD_LOGIC_VECTOR (n-1 downto 0);
	enable : IN std_logic;
	reset_n : IN std_logic;
	clock : IN std_logic;          
	done : OUT std_logic;
	div_per_zero : OUT std_logic;
	Q : out STD_LOGIC_VECTOR (n-1 downto 0);
	R : out STD_LOGIC_VECTOR (n-1 downto 0)
	);
END COMPONENT;

signal a_bus, b_bus, out_bus, out_bus_0, out_add_sub_sig, out_div_sig, out_mul_pow_sig, out_sqrt_sig: std_logic_vector (n-1 downto 0) := (others => '0');
signal enable_mul_pow, overflow_add_sub, overflow_pow, done_sqrt, done_div, done_mul_pow : std_logic := '0';

begin

a_bus <= A;
b_bus <= B;
R <= out_bus;

enable_mul_pow <= pow xor mul;

----------- Collegamenti al bus di output ------------																 
out_bus <= out_sqrt_sig when done_sqrt = '1' 
			  else (others => 'Z');
	
out_bus <= out_add_sub_sig when (add or sub) = '1' 
			  else (others => 'Z');
			  
out_bus <= out_mul_pow_sig when done_mul_pow = '1' 
           else (others => 'Z');

out_bus <= out_div_sig when done_div = '1' 
           else (others => 'Z');
								 
out_bus <= (a_bus and b_bus) when AandB = '1' 
           else (others => 'Z');
								 
out_bus <= (not a_bus) when negA = '1' 
           else (others => 'Z');
---------------------------------------------------------

----------------------------- Flag di stato ------------------------------------------------
z <= '1' when out_bus = out_bus_0
	      else '0';
								 
ovfl <= (overflow_add_sub xor overflow_pow) when (add or sub or pow) = '1'
		   else '0';  
done_setting: process(clock, reset_n)
variable state : std_logic := '0';
begin
	if(reset_n = '0') then
		done <= '0';
		state := '0';
	elsif(rising_edge(clock)) then
		if(state = '1' and (add = '1' or sub = '1' or AandB = '1' or negA = '1' or done_div = '1' or = '1' done_mul_pow = '1' or done_sqrt = '1')) then
			done <= '1';
		else
			state := '1';
		end if;
	end if;
end process;		  
---------------------------------------------------------------------------------------------

radice_quadrata: square_root 
generic map(n)
PORT MAP(
	clock => clock,
	reset_n => reset_n,
	enable => sqrt,
	D => a_bus,
	root => out_sqrt_sig((n/2)-1 downto 0),
	done => done_sqrt
);

somma_differenza: add_sub 
generic map(n, rca_cla)
PORT MAP(
	A => a_bus,
	B => b_bus,
	subtract => sub,
	overflow => overflow_add_sub,
	R => out_add_sub_sig
);

moltiplicazione_potenza: potenza 
generic map(n/2)
PORT MAP(
	A => a_bus((n/2)-1 downto 0),
	B => b_bus((n/2)-1 downto 0),
	mode => pow,
	clock => clock,
	reset => reset_n,
	enable => enable_mul_pow,
	done => done_mul_pow,
	potenza => out_mul_pow_sig,
	overflow => overflow_pow
);

divisore: divisore_non_restoring
generic map(n/2) 
PORT MAP(
	D => a_bus(n-2 downto 0),
	V => b_bus((n/2)-1 downto 0),
	enable => div,
	reset_n => reset_n,
	clock => clock,
	done => done_div,
	div_per_zero => div_per_zero,
	Q => out_div_sig(n-1 downto (n/2)),
	R => out_div_sig((n/2)-1 downto 0)
);
	  
end mulSequenziale;

architecture mulCombinatoria of alu is

COMPONENT square_root
generic (n : natural := 8);
PORT(
	clock : IN std_logic;
	reset_n : IN std_logic;
	enable : IN std_logic;
	D : in STD_LOGIC_VECTOR (n-1 downto 0);
	root : out STD_LOGIC_VECTOR ((n/2)-1 downto 0);
	done : OUT std_logic
	);
END COMPONENT;

COMPONENT add_sub
generic(n : integer := 4;
		  rca_cla : natural := 1);
PORT(
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(n-1 downto 0);
	subtract : IN std_logic;          
	overflow : OUT std_logic;
	R : OUT std_logic_vector(n-1 downto 0)
	);
END COMPONENT;

COMPONENT moltiplicatore_celle_mac
generic ( N : natural := 2;
			 M : natural := 2);
PORT( 
	A : IN std_logic_vector(N-1 downto 0);
	B : IN std_logic_vector(M-1 downto 0);
	P : OUT std_logic_vector(M+N-1 downto 0));
END COMPONENT;

COMPONENT moltiplicatore
generic(n : natural := 2;
		  m : natural := 2);
PORT( 
	A : IN std_logic_vector(n-1 downto 0);
	B : IN std_logic_vector(m-1 downto 0);
	P : OUT std_logic_vector(n+m-1 downto 0));
END COMPONENT;

COMPONENT divisore_non_restoring
generic (n : natural := 4);
PORT(
	D : in  STD_LOGIC_VECTOR ((2*n)-2 downto 0);
	V : in  STD_LOGIC_VECTOR (n-1 downto 0);
	enable : IN std_logic;
	reset_n : IN std_logic;
	clock : IN std_logic;          
	done : OUT std_logic;
	div_per_zero : OUT std_logic;
	Q : out STD_LOGIC_VECTOR (n-1 downto 0);
	R : out STD_LOGIC_VECTOR (n-1 downto 0)
	);
END COMPONENT;

signal a_bus, b_bus, out_bus, out_bus_0, out_add_sub_sig, out_div_sig, out_mul_sig, out_sqrt_sig: std_logic_vector (n-1 downto 0) := (others => '0');
signal overflow_add_sub, done_sqrt, done_div : std_logic := '0';

begin

a_bus <= A;
b_bus <= B;
R <= out_bus;

----------- Collegamenti al bus di output ------------
-- NB: in questo caso il segnale pow non è collegato																 
out_bus <= out_sqrt_sig when done_sqrt = '1' 
			  else (others => 'Z');
	
out_bus <= out_add_sub_sig when (add or sub) = '1' 
			  else (others => 'Z');
			  
out_bus <= out_mul_sig when mul = '1' 
           else (others => 'Z');

out_bus <= out_div_sig when done_div = '1' 
           else (others => 'Z');
								 
out_bus <= (a_bus and b_bus) when AandB = '1' 
           else (others => 'Z');
								 
out_bus <= (not a_bus) when negA = '1' 
           else (others => 'Z');
---------------------------------------------------------

----------------------------- Flag di stato ------------------------------------
z <= '1' when out_bus = out_bus_0
	  else '0';
								 
ovfl <= overflow_add_sub when (add or sub) = '1'
		  else '0';  
		  
done_setting: process(clock, reset_n)
variable state : std_logic := '0';
begin
	if(reset_n = '0') then
		done <= '0';
		state := '0';
	elsif(rising_edge(clock)) then
		if((state = '1') and ((add or sub or mul or AandB or negA or done_div or done_sqrt) = '1')) then
			done <= '1';
		else
			state := '1';
		end if;
	end if;
end process;
---------------------------------------------------------------------------------

radice_quadrata: square_root 
generic map(n)
PORT MAP(
	clock => clock,
	reset_n => reset_n,
	enable => sqrt,
	D => a_bus,
	root => out_sqrt_sig((n/2)-1 downto 0),
	done => done_sqrt
);

somma_differenza: add_sub 
generic map(n, rca_cla)
PORT MAP(
	A => a_bus,
	B => b_bus,
	subtract => sub,
	overflow => overflow_add_sub,
	R => out_add_sub_sig
);

sel_mult_mac: if (mac_moltCombinatorio = 0) generate
	mac: moltiplicatore_celle_mac 
	generic map(n/2, n/2)
	PORT MAP(
		A => a_bus(n/2-1 downto 0),
		B => b_bus(n/2-1 downto 0),
		P => out_mul_sig
	);
end generate;

sel_mult_comb: if (mac_moltCombinatorio = 1) generate
	moltiplicatoreCombinatorio: moltiplicatore 
	generic map(n/2, n/2)
	PORT MAP(
		A => a_bus(n/2-1 downto 0),
		B => b_bus(n/2-1 downto 0),
		P => out_mul_sig
	);
end generate;

divisore: divisore_non_restoring
generic map(n/2) 
PORT MAP(
	D => a_bus(n-2 downto 0),
	V => b_bus((n/2)-1 downto 0),
	enable => div,
	reset_n => reset_n,
	clock => clock,
	done => done_div,
	div_per_zero => div_per_zero,
	Q => out_div_sig(n-1 downto (n/2)),
	R => out_div_sig((n/2)-1 downto 0)
);
	  
end mulCombinatoria;
