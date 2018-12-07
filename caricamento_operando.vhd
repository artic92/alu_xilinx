----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:02:32 12/23/2015 
-- Design Name: 
-- Module Name:    caricamento_operando - Structural 
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

entity caricamento_operando is
	 generic (primo_nibble_a_b : natural range 0 to 1 := 0);
    Port ( input : in  STD_LOGIC_VECTOR (7 downto 0);
           count_en : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (63 downto 0);
           value_display : out  STD_LOGIC_VECTOR (15 downto 0));
end caricamento_operando;

architecture Structural of caricamento_operando is

	COMPONENT demultiplexer1_8
	PORT(
		input : IN std_logic_vector(7 downto 0);
		sel : IN std_logic_vector(3 downto 0);          
		output1 : OUT std_logic_vector(7 downto 0);
		output2 : OUT std_logic_vector(7 downto 0);
		output3 : OUT std_logic_vector(7 downto 0);
		output4 : OUT std_logic_vector(7 downto 0);
		output5 : OUT std_logic_vector(7 downto 0);
		output6 : OUT std_logic_vector(7 downto 0);
		output7 : OUT std_logic_vector(7 downto 0);
		output8 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT registerFile64Bit
	PORT(
		input1 : IN std_logic_vector(7 downto 0);
		input2 : IN std_logic_vector(7 downto 0);
		input3 : IN std_logic_vector(7 downto 0);
		input4 : IN std_logic_vector(7 downto 0);
		input5 : IN std_logic_vector(7 downto 0);
		input6 : IN std_logic_vector(7 downto 0);
		input7 : IN std_logic_vector(7 downto 0);
		input8 : IN std_logic_vector(7 downto 0);
		enable : IN std_logic_vector(7 downto 0);
		clock : IN std_logic;
		reset_n : IN std_logic;          
		output : OUT std_logic_vector(63 downto 0)
		);
	END COMPONENT;
	
	COMPONENT decoder4_8
	PORT(
		input : IN std_logic_vector(3 downto 0); 
		output : OUT std_logic_vector(7 downto 0)
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

	signal conteggio_out_sig : std_logic_vector ((natural(ceil(log2(real(8))))) downto 0) := (others => '0');
	signal output1_sig, output2_sig, output3_sig, output4_sig, output5_sig, output6_sig, output7_sig, output8_sig, decoder_out_sig, load_registro_i : std_logic_vector (7 downto 0) := (others => '0');
	signal output_sig : std_logic_vector (63 downto 0) := (others => '0');

	alias display_output1 is output_sig(7 downto 0);
	alias display_output2 is output_sig(15 downto 8);
	alias display_output3 is output_sig(23 downto 16);
	alias display_output4 is output_sig(31 downto 24);
	alias display_output5 is output_sig(39 downto 32);
	alias display_output6 is output_sig(47 downto 40);
	alias display_output7 is output_sig(55 downto 48);
	alias display_output8 is output_sig(63 downto 56);
 
begin

	output <= output_sig;
	
	load_registro_i <= decoder_out_sig and (decoder_out_sig'range => count_en);
	
	-- Selezione primo carattere da visualizzare in base al parametro generic
	value_display <= x"A" & conteggio_out_sig & input when primo_nibble_a_b = 0 else
											  x"B" & conteggio_out_sig & input;	
	
	input_to_registerFile: demultiplexer1_8 
	PORT MAP(
		input => input,
		sel => conteggio_out_sig,
		output1 => output1_sig,
		output2 => output2_sig,
		output3 => output3_sig,
		output4 => output4_sig,
		output5 => output5_sig,
		output6 => output6_sig,
		output7 => output7_sig,
		output8 => output8_sig
	);
	
	banco_registri: registerFile64Bit
	PORT MAP(
		input1 => output1_sig,
		input2 => output2_sig,
		input3 => output3_sig,
		input4 => output4_sig,
		input5 => output5_sig,
		input6 => output6_sig,
		input7 => output7_sig,
		input8 => output8_sig,
		enable => load_registro_i,
		clock => clock,
		reset_n => reset_n,
		output => output_sig
	);

	abilitazione_load_registro_i: decoder4_8 
	PORT MAP(
		input => conteggio_out_sig,
		output => decoder_out_sig
	);
	
	selezione_input: counter_modulo_n
	generic map(8)
	PORT MAP(
		clock => clock,
		count_en => count_en,
		reset_n => reset_n,
		up_down => '0',
		load_conteggio => open,
		conteggio_in => open,
		conteggio_out => conteggio_out_sig(2 downto 0),
		count_hit => open
	);

end Structural;

