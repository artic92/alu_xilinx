 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:36:01 11/23/2015 
-- Design Name: 
-- Module Name:    parte_controllo - Behavioral 
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

entity parte_controllo is
    Port ( clock : in  STD_LOGIC;
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
end parte_controllo;

architecture Behavioral of parte_controllo is

type state is (reset, init, lshift, subtract, add, test, correction, output);
signal current_state, next_state : state := reset; 

begin

registro_stato : process(clock, reset_n_all)
begin
	if(reset_n_all = '0') then
		current_state <= reset;
	elsif(clock = '1' and clock'event) then
		current_state <= next_state;
	end if;
end process;

fsm : process(current_state, reset_n_all, enable, segno, v_nullo, conteggio)
begin

	load_a <= '0';
	load_v <= '0';
	load_q <= '0';
	reset_n <= '1';
	qi <= '0';
	shift <= '0';
	sub <= '0';
	sel_input <= '1';
	count_en <= '0';
	div_per_zero <= '0';
	done <= '0';
	
	case current_state is
		when reset =>
										reset_n <= '0';
										if(enable = '1') then
											next_state <= init;
										else
											next_state <= reset;
										end if;
		when init =>
									sel_input <= '0';
									load_a <= '1';
									load_v <= '1';
									load_q <= '1';
									--Controllo per la divisione per zero
									if(v_nullo = '1') then
										next_state <= output;
									else
										next_state <= lshift;
									end if;
		when lshift =>
										shift <= '1';
										count_en <= '1';
										if(segno = '0') then
											next_state <= subtract;
										else
											next_state <= add;
										end if;
		when subtract =>
												sub <= '1';
												load_a <= '1';
												next_state <= test;
		when add =>
									load_a <= '1';
									next_state <= test;
		when test =>
									load_q <= '1';
									if(conteggio = '0') then
										if(segno = '1') then
											qi <= '0';
										else
											qi <= '1';
										end if;
										next_state <= lshift;
									else
										if(segno = '1') then
											qi <= '0';
											next_state <= correction;
										else
											qi <= '1';
											next_state <= output;
										end if;
									end if;
		when correction => 
												 load_a <= '1';
												 next_state <= output;
		when output => 
											-- Stato che mostra solo il risultato
											done <= '1';
											if(v_nullo = '1') then
													div_per_zero <= '1';
											else
													div_per_zero <= '0';
											end if;
											next_state <= output;
	end case;
end process;

end Behavioral;
