----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:15:55 12/18/2015 
-- Design Name: 
-- Module Name:    parte_operativa_sqrt - Structural 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parte_operativa_sqrt is
	 generic ( n : natural := 8 );
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (n-1 downto 0);
           load_qd : in  STD_LOGIC;
           load_r : in STD_LOGIC;
           shift: in  STD_LOGIC;
           count_en: in  STD_LOGIC;
           mod_n: out  STD_LOGIC;
           root : out  STD_LOGIC_VECTOR ((n/2)-1 downto 0));
end parte_operativa_sqrt;

architecture Structural of parte_operativa_sqrt is

COMPONENT registry_n_bit
	generic (n : natural := 8;
					delay : time := 0 ns);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (n-1 downto 0));
END COMPONENT;

COMPONENT add_sub
	 generic ( n : integer := 4);
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

COMPONENT contatore_modulo_n
	 generic (n : natural := 4);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           count_en : in  STD_LOGIC;
			  up_down : in STD_LOGIC;
           mod_n : out  STD_LOGIC);
END COMPONENT;

signal d_sig : std_logic_vector (n-1 downto 0) := (others => '0');
signal q_sig : std_logic_vector ((n/2)-1 downto 0) := (others => '0');
signal r_sig_in, r_sig_out, a_sig, b_sig : std_logic_vector ((n/2)+1 downto 0) := (others => '0');
signal not_segno : std_logic := '0';

begin

root <= q_sig;
a_sig <= r_sig_out((n/2)-1 downto 0) & d_sig(n-1) & d_sig(n-2);
b_sig <= q_sig & r_sig_out((n/2)+1) & '1';
not_segno <= not r_sig_out((n/2)+1);				

registro_d : process(clock, reset_n)
begin
	if (reset_n = '0') then
		d_sig <= (others => '0');
	elsif rising_edge(clock) then
		if (load_qd = '1') then
			d_sig <= D;
		elsif (shift = '1') then
			-- shift di due
			d_sig <= d_sig(n-3 downto 0) & "00";
		end if;
	end if;
end process;

registro_q : shift_register_n_bit
	generic map(n/2)
	PORT MAP(D_IN => q_sig, clock => clock, reset_n => reset_n, load => load_qd, 
								shift => shift, lt_rt => '0', sh_in => not_segno, sh_out => open,  D_OUT => q_sig);										

adder_subtractor : add_sub
	generic map((n/2)+2)
	PORT MAP(A => a_sig,	B => b_sig, subtract => not_segno, overflow => open, R => r_sig_in);
	
registro_r : registry_n_bit
	generic map((n/2)+2)
	PORT MAP(I => r_sig_in, clock => clock, load => load_r, reset_n => reset_n, O => r_sig_out);
	
contatore: contatore_modulo_n
	generic map(n/2+1) 
	PORT MAP(clock => clock, reset_n => reset_n, count_en => count_en, up_down => '0', mod_n => mod_n);
								
end Structural;

