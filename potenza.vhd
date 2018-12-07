----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:46:40 12/18/2015 
-- Design Name: 
-- Module Name:    potenza - Behavioral 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity potenza is
	 generic(n :natural :=32);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
			  mode: in STD_LOGIC;
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
			  done : out STD_LOGIC;
           potenza : out  STD_LOGIC_VECTOR (2*n-1 downto 0);
			  overflow : out STD_LOGIC
			  );
end potenza;

architecture Behavioral of potenza is

component contatore is
	generic(n : natural :=32);
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           counter_en : in  STD_LOGIC;
           counting : out  STD_LOGIC_VECTOR (n-1 downto 0));
end component;

component D_edge_triggered
port(
		data_in 	: in STD_LOGIC;
		clock 	: in STD_LOGIC;
		data_out : out STD_LOGIC
);
end component;


component booth_multiplier
generic(n : integer := 32);
port(
		X, Y : in std_logic_vector(n-1 downto 0);
		clock : in std_logic;
		enable, reset_in : in std_logic; 
		done : out std_logic;
		R : out std_logic_vector(2*n-1 downto 0)
		);
end component;

component Comparatore 
	generic( n : natural :=32);
    Port ( a : in  STD_LOGIC_VECTOR (n-1 downto 0);
           b : in  STD_LOGIC_VECTOR (n-1 downto 0);
           is_equal : out  STD_LOGIC
			  );
end component;

component mux
	 generic(N :natural :=32);
    Port ( a : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           o : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component mux_binary
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           sel : in  STD_LOGIC;
           o : out  STD_LOGIC);
end component;

component control_unit_potenza
    Port ( reset : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           is_zero : in  STD_LOGIC;
           is_one : in  STD_LOGIC;
           are_equal : in  STD_LOGIC;
           booth_done : in  STD_LOGIC;
			  reset_booth : out STD_LOGIC;
			  counter_en : out STD_LOGIC;
			  reset_all : out STD_LOGIC;
           done : out  STD_LOGIC;
			  booth_en : out STD_LOGIC;
           sel_input_booth : out  STD_LOGIC;
			  sel_output : out STD_LOGIC_VECTOR(1 downto 0);
			  sel_in : in std_logic;
			  overflow_in : in std_logic;
			  overflow_out : out std_logic
			  );
end component;

component reg 
generic(N : natural := 64);
port(
		I 		: in std_logic_vector(N-1 downto 0);
		clock : in std_logic; 
		clear : in std_logic; 
		load 	: in std_logic;
		Q		: out std_logic_vector(N-1 downto 0)
		);
end component;

signal out_mux_A : std_logic_vector(n-1 downto 0);
signal out_mux_B : std_logic_vector(n-1 downto 0);
signal out_pot_sig : std_logic_vector(2*n-1 downto 0);
signal out_booth_sig : std_logic_vector(2*n-1 downto 0);
signal booth_en_from_fsm : std_logic;
signal booth_en_sig : std_logic;
signal booth_reset_sig : std_logic;
signal booth_done_sig : std_logic;
--signal load_pot_sig : std_logic;
signal sel_input_booth_sig, sel_in_sig : std_logic;
signal is_one_sig : std_logic;
signal is_zero_sig : std_logic;
signal is_equal_sig : std_logic;
signal reset_all_sig : std_logic;
signal sel_output_sig : std_logic_vector(1 downto 0);
signal out_counter_sig : std_logic_vector(n-1 downto 0);
signal counter_en_sig : std_logic;
signal enable_fsm : std_logic;
signal done_fsm : std_logic;
signal comparator_in_sig : std_logic_vector(n-1 downto 0);
signal reset_booth_from_fsm : std_logic;
signal overflow_sig, overflow_sig_out : std_logic;

begin

------------------------------------------------------------
--MODALITA 0 MOLTIPLICAZIONE 
--			  1 POTENZA
------------------------------------------------------------


comparator_in_sig<=out_counter_sig +1;

enable_fsm <= enable and mode;

contator: contatore 
	port map(
				clock=>clock,
				reset=>reset_all_sig,
				counter_en=>counter_en_sig,
				counting=>out_counter_sig
	);

moltiplicatore: booth_multiplier
	port map(
				X=>out_mux_A,
				Y=>out_mux_B,
				clock=>clock,
				enable=>booth_en_sig,
				reset_in=>booth_reset_sig,
				done=>booth_done_sig,
				R=>out_booth_sig
	);
						
reg_pot: reg
	port map(
				I=>out_booth_sig,
				clock=>clock, 
				clear=>reset_all_sig, 
				load=>booth_done_sig,
				Q=>out_pot_sig
	);
							
mux_enable_booth : mux_binary
	Port map ( 
				a=>booth_en_from_fsm,
				b=>enable,
				sel=>mode,
				o=>booth_en_sig
	);							

mux_reset_booth : mux_binary
	Port map ( 
				a=>reset_booth_from_fsm,
				b=>reset,
				sel=>mode,
				o=>booth_reset_sig
	);

mux_input_booth_B : mux
	Port map ( 
				a=>A,
				b=>B,
				sel=>mode,
				o=>out_mux_B
	);

mux_input_booth_A : mux
	Port map ( 
				a=>A,
				b=>out_pot_sig(n-1 downto 0),
				sel=>sel_input_booth_sig,
				o=>out_mux_A
	);

controllo_esp_0 : Comparatore 
	Port map (
				a=>B,
				b=>(b'range => '0'),
				is_equal=>is_zero_sig
	);
										
controllo_esp_1 : Comparatore 
	Port map (
				a=>B,
				b=> CONV_STD_LOGIC_VECTOR(1, n),
				is_equal=>is_one_sig
	);
										
controllo_esp_counter : Comparatore 
	Port map (
				a=>B,
				b=>comparator_in_sig,
				is_equal=>is_equal_sig
	);
										
control_unit: control_unit_potenza
	Port map (
				  reset=>reset,
				  counter_en=>counter_en_sig,
				  clock=>clock,
				  enable=>enable_fsm,
				  is_zero=>is_zero_sig,
				  is_one=>is_one_sig,
				  are_equal=>is_equal_sig,
				  booth_done=>booth_done_sig,
				  reset_all=>reset_all_sig,
				  done=>done_fsm,
				  booth_en=>booth_en_from_fsm,
				  sel_input_booth=>sel_input_booth_sig,
				  sel_output=>sel_output_sig,
				  reset_booth=>reset_booth_from_fsm,
				  sel_in => sel_in_sig,
				  overflow_in => overflow_sig,
				  overflow_out =>overflow_sig_out
	);
			  
ff : D_edge_triggered
port map(sel_input_booth_sig, clock, sel_in_sig);

--PROCESS PER LA SCELTA DELLE USCITE
scelta_uscita : process(sel_output_sig,A,out_pot_sig,mode,booth_done_sig,out_booth_sig,done_fsm)
begin
if(mode<='0')then
	done<=booth_done_sig;
	potenza<=out_booth_sig;
else
	done<=done_fsm;
	if(sel_output_sig = "00")then
			for i in 2*n-1 downto 1 loop
			potenza(i)<='0';
			end loop;
			potenza(0)<='1';
	elsif(sel_output_sig = "01")then
		for i in 2*n-1 downto n loop
			if A(n-1)='0' then
				potenza(i)<='0';
			else
				potenza(i)<='1';
			end if;
		end loop;
		potenza(n-1 downto 0)<=A;
	elsif(sel_output_sig = "10")then
		potenza<=out_pot_sig;
	else
		potenza<=(others =>'0');
	end if;
end if;
end process scelta_uscita;


--MUX PER LA SCELTA DELL'USCITA 'OVERFLOW'

Inst_mux_binary: mux_binary PORT MAP(
	a => overflow_sig_out,
	b => '0',
	sel => mode,
	o => overflow 
);

--PROCESS PER LA SCELTA DELL'USCITA 'OVERFLOW'
--settaggio_overflow : process(mode, overflow_sig_out)
--begin
--if(mode='0')then
--	overflow<='0';
--else
--	overflow<=overflow_sig_out;
--end if;
--end process;

--PROCESS PER LA SCELTA DELLE USCITE
calcolo_overflow : process(out_pot_sig, clock, done_fsm)
variable msb_out_pot, i : integer := 0;

begin 
msb_out_pot := conv_integer(out_pot_sig(2*n-1 downto n));
if (rising_edge(clock) AND done_fsm = '0') then
	if out_pot_sig(2*n-1)='0' then		--quando è positivo
		if ((msb_out_pot /= 0) OR (out_pot_sig(n)='0' AND out_pot_sig(n-1)='1')) then
			overflow_sig <= '1';
		else
			overflow_sig <= '0';
		end if;
	elsif out_pot_sig(2*n-1)='1' then	--quando è negativo
		for i in 2*n-2 downto n loop
			if out_pot_sig(i)='0' then
				overflow_sig <= overflow_sig or '1';
			else 
				overflow_sig <= overflow_sig or '0';
			end if;
		end loop;
	end if;
end if;

end process;

end Behavioral;