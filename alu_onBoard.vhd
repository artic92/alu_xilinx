----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:23 12/23/2015 
-- Design Name: 
-- Module Name:    alu_onBoard - Structural 
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

entity alu_onBoard is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           switch : in  STD_LOGIC_VECTOR (7 downto 0);
           change_mod : in  STD_LOGIC;
           button1 : in  STD_LOGIC;
           button2 : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0);
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           cathodes : out  STD_LOGIC_VECTOR (7 downto 0));
end alu_onBoard;

architecture Structural of alu_onBoard is

	COMPONENT clock80MHz
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT clock10MHz
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;

	COMPONENT decoder2_4
	PORT(
		input : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT blocco_enable
	PORT(
		operazione_in : IN std_logic_vector(7 downto 0);
		enable : IN std_logic;          
		operazione_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT livelli2impulsi
	PORT(
		input : IN std_logic;
		clock : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;

	COMPONENT cambio_modalita
	PORT(
		change_mod : IN std_logic;
		button1 : IN std_logic;
		button2 : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;
		conteggio : OUT STD_LOGIC_VECTOR(1 downto 0);
		sel_a_b : OUT std_logic;
		load : OUT std_logic;
		load_operation : OUT std_logic;
		start : OUT std_logic;
		display_up : OUT std_logic;
		display_down : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT caricamento_operazione
	PORT(
		operazione_in : IN std_logic_vector(2 downto 0);
		clock : IN std_logic;
		reset_n : IN std_logic;
		load_operazione : IN std_logic;          
		operazione_out : OUT std_logic_vector(2 downto 0);
		operazione_decodificata : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT caricamento_operando
	generic (primo_nibble_a_b : natural range 0 to 1 := 0);
	PORT(
		input : IN std_logic_vector(7 downto 0);
		count_en : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;          
		output : OUT std_logic_vector(63 downto 0);
		value_display : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT alu
	generic ( n : natural := 64;
				rca_cla : natural := 1;
				mac_moltCombinatorio : natural := 0);
	PORT(
		A : IN std_logic_vector(n-1 downto 0);
		B : IN std_logic_vector(n-1 downto 0);
		clock : IN std_logic;
		reset_n : IN std_logic;
		add : IN std_logic;
		sub : IN std_logic;
		mul : IN std_logic;
		div : IN std_logic;
		pow : IN std_logic;
		sqrt : IN std_logic;
		negA : IN std_logic;
		AandB : IN std_logic;          
		R : OUT std_logic_vector(n-1 downto 0);
		done : OUT std_logic;
		ovfl : OUT std_logic;
		z : OUT std_logic;
		div_per_zero : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT visualizzazione_risultato
	PORT(
		input : IN std_logic_vector(63 downto 0);
		count_en : IN std_logic;
		load_risultato : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;
		display_up_down : IN std_logic;          
      conteggio : out  STD_LOGIC_VECTOR (1 downto 0);         
		output : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT up_or_down
	PORT(
		up : IN std_logic;
		down : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;          
		set_up_down : OUT std_logic;
		count_en : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT display_seven_segments
	generic(
				clock_frequency_in : integer := 50000000;
				clock_frequency_out : integer := 5000000);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		value : IN std_logic_vector(15 downto 0);
		enable : IN std_logic_vector(3 downto 0);
		dots : IN std_logic_vector(3 downto 0);          
		anodes : OUT std_logic_vector(3 downto 0);
		cathodes : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	-- Architettura con moltiplicatori sequenziali (NB: il parametro generic mac_moltCombinatorio non ha effetto)
	for all : alu use entity work.alu(mulSequenziale);
	-- Architettura con moltiplicatori combinatori
--	for all : alu use entity work.alu(mulCombinatoria);
	
	constant alu_seq_comb : natural range 0 to 1 := 0;
	
	signal dcm_clock_out, change_mod_sig, button1_sig, button2_sig, load_sig, load_a_sig, load_b_sig, load_operazione_sig, start_sig, display_up_sig, display_down_sig, done_sig, ovfl_sig, z_sig, div_per_zero_sig, reset_n, set_up_down_sig, count_en_sig, sel_a_b_sig, enable_decoder_risultato : std_logic := '0';
	signal operandoA_value, operandoB_value, risultato_sig : std_logic_vector(63 downto 0);
	signal operandoA_toDisplay, operandoB_toDisplay, risultato_toDisplay, value_sig, a_b_sig : std_logic_vector(15 downto 0);
	signal operazione_toDisplay : std_logic_vector(2 downto 0);
	signal output_decoder_risultato, enable_sig : std_logic_vector(3 downto 0) := (others => '0');
	signal operazione_decodificata_sig, operazione_decodificata_abilitata : std_logic_vector(7 downto 0);
	signal conteggio_sig, sel_input_toDisplay : std_logic_vector(1 downto 0);

begin

	reset_n <= not reset;

	-- Configurazione led con flag di stato
	leds(3 downto 0) <= done_sig & z_sig & div_per_zero_sig & ovfl_sig;

	-- Multiplexer per la selezione di quali dei due ingressi visualizzare sul display nella modalità di inserimento
	with sel_a_b_sig select a_b_sig <= operandoA_toDisplay when '0',
												  operandoB_toDisplay when '1',
												  (others => 'X') when others;
												  
	-- Multiplexer per la visualizzazione sul display delle cifre corrette in base alla modalità
	with sel_input_toDisplay select enable_sig <= "1111" when "00",
																 "1001" when "01",
																 "1111" when "10",
																 (others => 'X') when others;
													
	-- Multiplexer per la visualizzazione sul display dei dati corretti in base alla modalità
	with sel_input_toDisplay select value_sig <= a_b_sig when "00",
																x"000" & '0' & operazione_toDisplay when "01",
																risultato_toDisplay when "10",
																(others => 'X') when others;

	----------------------- Controllo led per la visualizzazione del risultato ---------------------------------------
	leds(7 downto 4) <= output_decoder_risultato and (output_decoder_risultato'range => enable_decoder_risultato);
	
	enable_decoder_risultato <= '1' when sel_input_toDisplay = "10"
										 else '0';
	
	stampa_su_led_posizione_word_risultato: decoder2_4 
	PORT MAP(input => conteggio_sig, output => output_decoder_risultato);
	------------------------------------------------------------------------------------------------------------------
	
	dcm_alu_seq: if (alu_seq_comb = 0) generate
		clock_alu_sequenziale: clock80MHz 
		PORT MAP(
			CLKIN_IN => clock,
			CLKFX_OUT => dcm_clock_out,
			CLK0_OUT => open
		);
	end generate;
	
	dcm_alu_comb: if (alu_seq_comb = 1) generate
		clock_alu_combinatoria: clock10MHz 
		PORT MAP(
			CLKIN_IN => clock,
			CLKFX_OUT => dcm_clock_out,
			CLK0_OUT => open
		);
	end generate;

	abilitazione_operazione_con_pulsante: blocco_enable 
	PORT MAP(
		operazione_in => operazione_decodificata_sig,
		enable => start_sig,
		operazione_out => operazione_decodificata_abilitata
	);
	
	stabilizzazione_pulsante_chmod: livelli2impulsi 
	PORT MAP(
		input => change_mod,
		clock => dcm_clock_out,
		output => change_mod_sig
	);
	
	stabilizzazione_pulsante_button1: livelli2impulsi 
	PORT MAP(
		input => button1,
		clock => dcm_clock_out,
		output => button1_sig
	);
	
	stabilizzazione_pulsante_button2: livelli2impulsi 
	PORT MAP(
		input => button2,
		clock => dcm_clock_out,
		output => button2_sig
	);

	controllo_pulsanti: cambio_modalita 
	PORT MAP(
		change_mod => change_mod_sig,
		button1 => button1_sig,
		button2 => button2_sig,
		clock => dcm_clock_out,
		reset_n => reset_n,
		conteggio => sel_input_toDisplay,
		sel_a_b => sel_a_b_sig,
		load => load_sig,
		load_operation => load_operazione_sig,
		start => start_sig,
		display_up => display_up_sig,
		display_down => display_down_sig
	);
	
	controllo_operazione: caricamento_operazione 
	PORT MAP(
		operazione_in => switch(2 downto 0),
		clock => dcm_clock_out,
		reset_n => reset_n,
		load_operazione => load_operazione_sig,
		operazione_out => operazione_toDisplay,
		operazione_decodificata => operazione_decodificata_sig
	);
	
	-- Demultiplexer per selezionare quale operando caricare
	load_a_sig <= load_sig when sel_a_b_sig = '0' 
						else '0';
	load_b_sig <= load_sig when sel_a_b_sig = '1' 
						else '0';
	
	-- Operando A
	caricamento_operando_a: caricamento_operando 
	generic map(primo_nibble_a_b => 0)
	PORT MAP(
		input => switch,
		count_en => load_a_sig,
		clock => dcm_clock_out,
		reset_n => reset_n,
		output => operandoA_value,
		value_display => operandoA_toDisplay
	);
	
	-- Operando B
	caricamento_operando_b: caricamento_operando 
	generic map(primo_nibble_a_b => 1)
	PORT MAP(
		input => switch,
		count_en => load_b_sig,
		clock => dcm_clock_out,
		reset_n => reset_n,
		output => operandoB_value,
		value_display => operandoB_toDisplay
	);
	
	Inst_alu: alu
	generic map(64, rca_cla => 1, mac_moltCombinatorio => 1)
	PORT MAP(
		A => operandoA_value,
		B => operandoB_value,
		clock => dcm_clock_out,
		reset_n => reset_n,
		add => operazione_decodificata_abilitata(0),
		sub => operazione_decodificata_abilitata(1),
		mul => operazione_decodificata_abilitata(2),
		div => operazione_decodificata_abilitata(3),
		pow => operazione_decodificata_abilitata(4),
		sqrt => operazione_decodificata_abilitata(5),
		negA => operazione_decodificata_abilitata(6),
		AandB => operazione_decodificata_abilitata(7),
		R => risultato_sig,
		done => done_sig,
		ovfl => ovfl_sig,
		z => z_sig,
		div_per_zero => div_per_zero_sig 
	);
	
	visualizzazione_risultato_alu: visualizzazione_risultato 
	PORT MAP(
		input => risultato_sig,
		count_en => count_en_sig,
		load_risultato => done_sig,
		clock => dcm_clock_out,
		reset_n => reset_n,
		display_up_down => set_up_down_sig,
		conteggio => conteggio_sig,
		output => risultato_toDisplay
	);
	
	controllo_modalita_visualizzazione_risultato_up_down: up_or_down 
	PORT MAP(
		up => display_up_sig,
		down => display_down_sig,
		clock => dcm_clock_out,
		reset_n => reset_n,
		set_up_down => set_up_down_sig,
		count_en => count_en_sig
	);
	
	display: display_seven_segments
	generic map(50000000, 500)
	PORT MAP(
		clock => clock,
		reset_n => reset_n,
		value => value_sig,
		enable => enable_sig,
		dots => "0000",
		anodes => anodes,
		cathodes => cathodes
	);

end Structural;

