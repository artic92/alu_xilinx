----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:39:58 11/23/2015 
-- Design Name: 
-- Module Name:    divisore_non_restoring - Structural 
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

-- Divisione tra numeri interi SENZA segno
entity divisore_non_restoring is
	 generic ( n : natural := 4 );
    Port ( D : in  STD_LOGIC_VECTOR ((2*n)-2 downto 0);
           V : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  enable : in STD_LOGIC;
			  reset_n : in STD_LOGIC;
			  clock : in STD_LOGIC;
			  done : out STD_LOGIC;
			  div_per_zero : out STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (n-1 downto 0);
			  R : out STD_LOGIC_VECTOR (n-1 downto 0));
end divisore_non_restoring;

architecture Structural of divisore_non_restoring is

COMPONENT parte_controllo
PORT( clock : in  STD_LOGIC;
		  reset_n_all : in  STD_LOGIC;
		  enable : in STD_LOGIC;
		  segno : in  STD_LOGIC;
		  v_nullo : in  STD_LOGIC;
		  conteggio : in  STD_LOGIC;
		  load_a : out  STD_LOGIC;
		  load_v : out  STD_LOGIC;
		  load_q : out  STD_LOGIC;
		  reset_n : out  STD_LOGIC;
		  qi : out  STD_LOGIC;
		  shift : out  STD_LOGIC;
		  sub : out  STD_LOGIC;
		  sel_input : out STD_LOGIC;
		  count_en : out  STD_LOGIC;
		  div_per_zero : out  STD_LOGIC;
		  done : out  STD_LOGIC);
END COMPONENT;
	
COMPONENT parte_operativa
generic ( n : natural := 4 );
PORT( D : in  STD_LOGIC_VECTOR ((2*n)-2 downto 0);
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
END COMPONENT;

COMPONENT contatore_modulo_n
 generic (n : natural := 4);
 PORT ( clock : in  STD_LOGIC;
		  reset_n : in  STD_LOGIC;
		  count_en : in  STD_LOGIC;
		  up_down : in STD_LOGIC;
		  mod_n : out  STD_LOGIC);
END COMPONENT;

signal segno_sig, mod_n_sig, load_a_sig, load_v_sig, load_q_sig, reset_n_sig, qi_sig, shift_sig, 
			 sub_sig, cnt_en_sig, done_sig, sel_input_sig, v_nullo_sig : std_logic := '0';
signal q_sig, r_sig: std_logic_vector(n-1 downto 0);

begin

done <= done_sig;
Q <= (others => '0') when (V = (V'range => '0')) else
			q_sig and (q_sig'range => done_sig);
R <= (others => '0') when (V = (V'range => '0')) else
			r_sig and (r_sig'range => done_sig);

PC: parte_controllo 
	PORT MAP(
		clock => clock,
		reset_n_all => reset_n,
		enable => enable,
		segno => segno_sig,
		v_nullo => v_nullo_sig,
		conteggio => mod_n_sig,
		load_a => load_a_sig,
		load_v => load_v_sig,
		load_q => load_q_sig,
		reset_n => reset_n_sig,
		qi => qi_sig,
		shift => shift_sig,
		sub => sub_sig,
		sel_input=>sel_input_sig,
		count_en => cnt_en_sig,
		div_per_zero => div_per_zero,
		done => done_sig
);
	
PO: parte_operativa
	generic map(n)
	PORT MAP(
		D => D,
		V => V,
		load_a => load_a_sig,
		load_q => load_q_sig,
		load_v => load_v_sig,
		clock => clock,
		reset_n => reset_n_sig,
		qi => qi_sig,
		shift => shift_sig,
		sub => sub_sig,
		sel_input => sel_input_sig,
		segno => segno_sig,
		v_nullo => v_nullo_sig,
		Q => q_sig,
		R => r_sig
);

contatore: contatore_modulo_n
generic map(n+1) 
PORT MAP(
		clock => clock,
		reset_n => reset_n_sig,
		count_en => cnt_en_sig,
		up_down => '0',
		mod_n => mod_n_sig
	);

end Structural;
