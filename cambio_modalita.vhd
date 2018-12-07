----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:17:28 12/23/2015 
-- Design Name: 
-- Module Name:    cambio_modalita - Structural 
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

entity cambio_modalita is
    Port ( change_mod : in  STD_LOGIC;
           button1 : in  STD_LOGIC;
           button2 : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           conteggio : out  STD_LOGIC_VECTOR(1 downto 0);
			  sel_a_b : out STD_LOGIC;
           load : out  STD_LOGIC;
           load_operation : out  STD_LOGIC;
           start : out  STD_LOGIC;
           display_up : out  STD_LOGIC;
           display_down : out  STD_LOGIC);
end cambio_modalita;

architecture Structural of cambio_modalita is
	
	COMPONENT inpulsi2livelli
	PORT(
		input : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;          
		output : OUT std_logic
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
	
	signal conteggio_out_sig : std_logic_vector ((natural(ceil(log2(real(3)))))-1 downto 0) := (others => '0');
	signal start_sig_impulsivo, sel_a_b_sig_impulsivo : std_logic := '0';

begin

	conteggio <= conteggio_out_sig;

	------------- Configurazione pulsanti in base alla modalità --------------------
	load <= button1 when conteggio_out_sig = "00" else '0';
	sel_a_b_sig_impulsivo <= button2 when conteggio_out_sig = "00" else '0';

	load_operation <= button1 when conteggio_out_sig = "01" else '0';
	start_sig_impulsivo <= button2 when conteggio_out_sig = "01" else '0';

	display_up <= button2 when conteggio_out_sig = "10" else '0';
	display_down <= button1 when conteggio_out_sig = "10" else '0';
	---------------------------------------------------------------------------------

	set_start: inpulsi2livelli 
	PORT MAP(
		input => start_sig_impulsivo,
		clock => clock,
		reset_n => reset_n,
		output => start
	);
	
	set_sel_a_b: inpulsi2livelli 
	PORT MAP(
		input => sel_a_b_sig_impulsivo,
		clock => clock,
		reset_n => reset_n,
		output => sel_a_b
	);

	sel_modalita: counter_modulo_n
	generic map(3)
	PORT MAP(
		clock => clock,
		count_en => change_mod,
		reset_n => reset_n,
		up_down => '0',
		load_conteggio => open,
		conteggio_in => open,
		conteggio_out => conteggio_out_sig,
		count_hit => open
	);

end Structural;

