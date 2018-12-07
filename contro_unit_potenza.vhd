----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:03:25 12/18/2015 
-- Design Name: 
-- Module Name:    contro_unit_potenza - Behavioral 
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

entity control_unit_potenza is
    Port ( reset : in  STD_LOGIC;
			  counter_en : out STD_LOGIC;
           clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           is_zero : in  STD_LOGIC;
           is_one : in  STD_LOGIC;
           are_equal : in  STD_LOGIC;
           booth_done : in  STD_LOGIC;
			  reset_all : out STD_LOGIC;
			  reset_booth : out STD_LOGIC;
           done : out  STD_LOGIC;
			  booth_en : out STD_LOGIC;
           sel_input_booth : out  STD_LOGIC;
			  sel_output : out STD_LOGIC_VECTOR(1 downto 0);
			  sel_in : in std_logic;
			  overflow_in : in std_logic;
			  overflow_out : out std_logic
			  );
end control_unit_potenza;

architecture Behavioral of control_unit_potenza is

type state is (idle,esp_control,count_up,test,finish,booth_reset);
signal stato_corrente, stato_prossimo : state := idle;

begin

aggiornamento_stato : process(stato_corrente,stato_prossimo,reset,clock)
begin

if(reset = '0')then
	stato_corrente<=idle;
elsif(rising_edge(clock))then
	stato_corrente<=stato_prossimo;
end if;
end process;


stato_uscita: process(stato_corrente,stato_prossimo,overflow_in,enable,is_zero,sel_in,is_one,are_equal,booth_done)
begin

reset_all<='1';
done<='0';
booth_en<='0';
sel_output<="11";
counter_en<='0';
reset_booth<='1';
sel_input_booth <= '0';
overflow_out <= '0';

case stato_corrente is

when idle =>
								reset_all<='0';
								sel_input_booth<='1';
								sel_output<="11";
								done<='0';
								booth_en<='0';
								if(enable='1')then
									stato_prossimo<=esp_control;
								else
									stato_prossimo<=idle;
								end if;

when esp_control =>
								reset_all<='1';
								reset_booth<='1';
								sel_input_booth<='1';
								if(is_zero='1' or is_one='1')then
									stato_prossimo<=finish;
								else
									stato_prossimo<=count_up;
								end if;
when count_up =>			
								booth_en<='1';
								counter_en<='1';
								reset_booth<='1';
								sel_input_booth <= sel_in;
								stato_prossimo<=test;
when test => 				
								counter_en<='0';
								reset_booth<='1';
								if(booth_done='1')then
									if overflow_in = '1' then
										stato_prossimo <= finish;
									elsif(are_equal='1')then
										stato_prossimo<=finish;
									else
										stato_prossimo<=booth_reset;
									end if;
								else
									sel_input_booth <= sel_in;
									stato_prossimo<=test;
								end if;
								
when booth_reset =>
								reset_booth<='0';
								stato_prossimo<=count_up;
									
when finish =>
								done<='1';
								reset_booth<='0';
								if overflow_in = '1' then
									overflow_out <= '1';
								elsif(is_zero='1')then
									sel_output<="00";
								elsif(is_one='1')then
									sel_output<="01";
								elsif(are_equal='1')then
									sel_output<="10";
								end if;
								stato_prossimo<=finish;
end case;
end process;

end Behavioral;

