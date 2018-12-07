----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:34 11/22/2015 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

type state is (RST, INIT, ADD, RSHIFT, VERIFY, SUB, OUTPUT);
signal stato_corrente, stato_prossimo : state := RST;

begin

clock_process: process(clock, reset_in)
begin
	if(reset_in = '0')then
			stato_corrente <= RST;
	elsif(clock = '1' and clock'event)then
			stato_corrente <= stato_prossimo;
	end if;
end process;

--il clock mi tempifica il passaggio da stato corrente a stato prossimo, 
--mi serve un process che mi stabilisca l'evoluzione degli stati prossimi in funzione dello stato in cui mi trovo
next_state_process: process(Q_0, count_in, stato_corrente, enable, Q_ext)

begin

	load_A <= '0';
	load_Q <= '0';
	load_M <= '0';
	count_out <= '0';
	reset_out <= '1';		
	shift <= '0';
	load_sign <= '0';
	subtract <= '0';
	done <= '0';

case stato_corrente is
		when RST =>
					reset_out <= '0';		
					if enable = '1' then
							stato_prossimo <= INIT;
					else
							stato_prossimo <= RST;
					end if;
		when INIT =>
					load_Q <= '1';
					load_M <= '1';
					stato_prossimo <= VERIFY;
		when VERIFY =>
					if count_in = '0' then		--significa che devo fare il passo ADD
							if	Q_0 = Q_ext then
									stato_prossimo <= RSHIFT;
							elsif Q_0 = '0' then
									stato_prossimo <= ADD;
							else	
									stato_prossimo <= SUB;
							end if;
					else
							load_sign <= '1';
							stato_prossimo <= OUTPUT;
					end if;
		when ADD =>
					load_A <= '1';
					stato_prossimo <= RSHIFT;
		when RSHIFT =>
					shift <= '1';
					count_out <= '1';
					stato_prossimo <= VERIFY;
		when SUB => 
					subtract <= '1';
					load_A <= '1';
					stato_prossimo <= RSHIFT;
		when OUTPUT =>
					load_sign <= '1';
					done <= '1';
					stato_prossimo <= OUTPUT;
end case;
end process;
end Behavioral;

