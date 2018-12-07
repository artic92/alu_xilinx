----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:46:07 12/23/2015 
-- Design Name: 
-- Module Name:    visualizzazione_risultato - Structural 
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
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity visualizzazione_risultato is
    Port ( input : in  STD_LOGIC_VECTOR (63 downto 0);
           count_en : in  STD_LOGIC;
           load_risultato : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           display_up_down : in  STD_LOGIC;
           conteggio : out  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end visualizzazione_risultato;

architecture Structural of visualizzazione_risultato is

	COMPONENT livelli2impulsi
	PORT(
		input : IN std_logic;
		clock : IN std_logic;          
		output : OUT std_logic
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
	
	COMPONENT mux4n_1
   generic ( n : natural := 4 );
	PORT(
		A : IN std_logic_vector(n-1 downto 0);
		B : IN std_logic_vector(n-1 downto 0);
		C : IN std_logic_vector(n-1 downto 0);
		D : IN std_logic_vector(n-1 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		O : OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;	

	COMPONENT counter_modulo_n
   generic ( n : natural := 16 );
	PORT(
		clock : IN std_logic;
		count_en : IN std_logic;
		reset_n : IN std_logic;
		up_down : IN std_logic;
		load_conteggio : IN std_logic := '0';
	   conteggio_in : in STD_LOGIC_VECTOR (natural(ceil(log2(real(n))))-1 downto 0) := (others => '0');
	   conteggio_out : out  STD_LOGIC_VECTOR ((natural(ceil(log2(real(n)))))-1 downto 0);
		count_hit : OUT std_logic
		);
	END COMPONENT;

	signal conteggio_out_sig : std_logic_vector ((natural(ceil(log2(real(4)))))-1 downto 0) := (others => '0');
	signal load_risultato_impulsivo : std_logic := '0';
	signal out_registro_sig : std_logic_vector (63 downto 0);
			
	alias prima_word is out_registro_sig(15 downto 0);
	alias seconda_word is out_registro_sig(31 downto 16);
	alias terza_word is out_registro_sig(47 downto 32);
	alias quarta_word is out_registro_sig(63 downto 48);

begin

	conteggio <= conteggio_out_sig;
	
	set_load: livelli2impulsi 
	PORT MAP(
		input => load_risultato,
		clock => clock,
		output => load_risultato_impulsivo
	);
	
	registro_risultato : registry_n_bit
	generic map(64)
	PORT MAP(
		I => input, 
		clock => clock, 
		load => load_risultato_impulsivo, 
		reset_n => reset_n, 
		O => out_registro_sig
	);	
	
	risultato_to_display: mux4n_1
	generic map(16)
	PORT MAP(
		A => prima_word,
		B => seconda_word,
		C => terza_word,
		D => quarta_word,
		sel => conteggio_out_sig,
		O => output
	);

	selezione_word_risultato: counter_modulo_n
	generic map(4)
	PORT MAP(
		clock => clock,
		count_en => count_en,
		reset_n => reset_n,
		up_down => display_up_down,
		load_conteggio => open,
		conteggio_in => open,
		conteggio_out => conteggio_out_sig,
		count_hit => open
	);
	
end Structural;

