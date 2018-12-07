----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:58 11/21/2015 
-- Design Name: 
-- Module Name:    parte_operativa - Structural 
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

entity parte_operativa is
	 generic ( n : natural := 4 );
    Port ( D : in  STD_LOGIC_VECTOR ((2*n)-2 downto 0);
           V : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  load_a : in STD_LOGIC;
           load_q : in  STD_LOGIC;
           load_v : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           qi : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           sub : in  STD_LOGIC;
			  sel_input : in STD_LOGIC;
			  segno : out  STD_LOGIC;
			  v_nullo : out STD_LOGIC;
			  Q : out STD_LOGIC_VECTOR (n-1 downto 0);
			  R : out STD_LOGIC_VECTOR (n-1 downto 0));
end parte_operativa;

architecture Structural of parte_operativa is

COMPONENT registry_n_bit
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT mux2n_1
	 generic ( n : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           sel : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT add_sub
	 generic ( n : natural := 4);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           subtract : in  STD_LOGIC;
           overflow : out  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT shift_register_n_bit
	 generic (n : natural := 8;
						delay : time := 0 ns);
    Port (D_IN : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  clock : in STD_LOGIC;
	        reset_n : in  STD_LOGIC;
           load : in  STD_LOGIC;
           shift : in  STD_LOGIC;
           lt_rt : in  STD_LOGIC;
			  sh_in : in STD_LOGIC;
			  sh_out : out STD_LOGIC;
           D_OUT : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

signal ingresso_q, uscita_q, divisore, qu_qi : std_logic_vector(n-1 downto 0)  := (others => '0');
signal divisore_con_0, ingresso_a, uscita_a, uscita_add_sub : std_logic_vector(n downto 0)  := (others => '0');
signal d_con_00, uscita_mux, ingresso_b_mux : std_logic_vector((2*n) downto 0)  := (others => '0');
signal sh_out_q_a: std_logic := '0';

begin

segno <= uscita_a(n);
v_nullo <= '1' when (V = (V'range => '0')) else '0';
Q <= uscita_q;
R <= uscita_a(n-1 downto 0);

-- Adatto dividendo e divisore alla dimensione del registro A: aggiungendo due zeri in testa al dividendo
-- ed uno in testa al divisore
d_con_00 <= "00" & D;
divisore_con_0 <= '0' & divisore;

qu_qi <= uscita_q(n-1 downto 1) & qi;
ingresso_b_mux <= uscita_add_sub & qu_qi;
ingresso_a <= uscita_mux((2*n) downto n);
ingresso_q <= uscita_mux(n-1 downto 0);

registro_divisore : registry_n_bit
	generic map(n)
	PORT MAP(I => V, clock => clock,	load => load_v, reset_n => reset_n, O => divisore);
	
sel_d_other : mux2n_1 
	generic map((2*n)+1)
	PORT MAP(A => d_con_00, B => ingresso_b_mux, sel => sel_input, O => uscita_mux);
	
registro_a : shift_register_n_bit
	generic map(n+1)
	PORT MAP(D_IN => ingresso_a, clock => clock, reset_n => reset_n, load => load_a, shift => shift,   
								lt_rt => '0', sh_in => sh_out_q_a, sh_out =>  open, D_OUT => uscita_a);								

registro_q : shift_register_n_bit
	generic map(n)
	PORT MAP(D_IN => ingresso_q, clock => clock, reset_n => reset_n, load => load_q, 
								shift => shift, lt_rt => '0', sh_in => '0', sh_out => sh_out_q_a,  D_OUT => uscita_q);										

adder_subtractor : add_sub
	generic map(n+1)
	PORT MAP(A => uscita_a,	B => divisore_con_0, subtract => sub, overflow => open, R => uscita_add_sub);
								
end Structural;
