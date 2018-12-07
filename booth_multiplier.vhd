----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:09:11 11/21/2015 
-- Design Name: 
-- Module Name:    booth_multiplier - structural 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity booth_multiplier is
generic(n : integer := 4);
port(
		X, Y : in std_logic_vector(n-1 downto 0);
		clock : in std_logic;
		enable, reset_in : in std_logic; 
		done : out std_logic;
		R : out std_logic_vector(2*n-1 downto 0)
);
end booth_multiplier;

architecture structural of booth_multiplier is

--dichiaro tutti i componenti
component add_sub 
generic(n : integer := 4);
port(
		A : in std_logic_vector(n-1 downto 0);
		B : in std_logic_vector(n-1 downto 0);
		subtract : in std_logic;
		overflow : out std_logic;
		R : out std_logic_vector(n-1 downto 0)
);
end component;

-----
component AQ_register
generic(n:integer := 4);
port(
		A_in, Q_in : in std_logic_vector(n-1 downto 0);
		clock, reset_n, load_A, load_Q, shift : in std_logic;
		Q_ext, A_7 : out std_logic;
		A_out, Q_out : out std_logic_vector(n-1 downto 0)
);
end component;

-----
component reg
generic(N : integer := 2);
port(
		I 		: in std_logic_vector(N-1 downto 0);
		clock : in std_logic; 
		clear : in std_logic; 
		load 	: in std_logic;
		Q		: out std_logic_vector(N-1 downto 0)
);
end component;

-----
component counter
generic(n: natural :=2);
port(	clock:	in std_logic;
	clear_n:	in std_logic;
	count:	in std_logic;
	Q:	out std_logic
);
end component;

-----
component control_unit
port(
		Q_0, Q_ext : in std_logic;
		reset_in : in std_logic;
		enable : in std_logic;
		clock : in std_logic;
		count_in : in std_logic;
		count_out : out std_logic;
		subtract : out std_logic;
		shift : out std_logic;
		load_A, load_Q : out std_logic;
		load_M : out std_logic;
		reset_out : out std_logic;
		done : out std_logic;
		load_sign : out std_logic
);
end component;

-----

--definizione costante m
constant m : integer := 2*n;

--segnali ausiliari
signal shift : std_logic := '0';
signal load_A, load_Q, load_M  : std_logic := '1';
signal A_in, A_out, Q_in, Q_out : std_logic_vector(n-1 downto 0);
signal M_in, M_out : std_logic_vector(n-1 downto 0);
signal count_out : std_logic := '0';  
signal reset_out : std_logic;-- := '1';  
signal subtract, count_in : std_logic := '0'; 
signal A_7, load_sign, Q_ext, sign : std_logic; 

begin

Q_in <= X;
M_in <= Y;

--controllo se una delle due stringhe è tutti zero così da mettere 0 in A_7
sign <= '0' when (X = (X'range => '0')) or (Y = (Y'range => '0')) else
		  X(n-1) xor Y(n-1);

R <=  not (A_out(n-1 downto 0) & Q_out) + 1 when (Y(Y'left) = '1') AND (unsigned(Y(Y'left-1 downto 0)) = 0) else 
		sign & A_out(n-2 downto 0) & Q_out when load_sign = '1' else
		A_7 & A_out(n-2 downto 0) & Q_out;


AQ_reg: AQ_register
	generic map(n)
	port map(A_in, Q_in, clock, reset_out, load_A, load_Q, shift, Q_ext, A_7, A_out, Q_out);	

regist: reg
	generic map(n)
	port map(M_in, clock, reset_out, load_M, M_out);

adder_sub: add_sub
	generic map(n)
	port map(A_out, M_out, subtract, open, A_in);
	
count: counter
	generic map(n)
	port map(clock, reset_out, count_in, count_out);
	
ctrl_unit: control_unit
	port map(Q_out(0), Q_ext, reset_in, enable, clock, count_out, count_in, subtract, shift, load_A, load_Q, load_M, reset_out, done, load_sign);

end structural;
