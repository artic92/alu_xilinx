----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:37:36 11/22/2015 
-- Design Name: 
-- Module Name:    AQ_register - structural 
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

entity AQ_register is
generic(n:integer := 4);
port(
		A_in, Q_in : in std_logic_vector(n-1 downto 0);
		clock, reset_n, load_A, load_Q, shift : in std_logic;
		Q_ext, A_7 : out std_logic;
		A_out, Q_out : out std_logic_vector(n-1 downto 0)
);
end AQ_register;

architecture structural of AQ_register is

component shift_reg
generic(n: natural := 4);
port(
		d_in		 : in std_logic;	
		I			 : in std_logic_vector(n-1 downto 0) := (others => '0');
		clock		 : in std_logic;
		clear		 : in std_logic;
		load		 : in std_logic;
		shift		 : in std_logic;
		Q			 : out std_logic_vector(n-1 downto 0);
		Q_ext		 : out std_logic;
		d_out		 : out std_logic
);
end component;

signal d_temp : std_logic;
signal A_temp, Q_temp : std_logic_vector(n-1 downto 0) := (others => '0');

begin

A_out <= A_temp;
Q_out <= Q_temp;

A_7 <= A_temp(n-1);

A: shift_reg
generic map(n)
port map(A_temp(n-1), A_in, clock, reset_n, load_A, shift, A_temp, open, d_temp);

B: shift_reg
generic map(n)
port map(d_temp, Q_in, clock, reset_n, load_Q, shift, Q_temp, Q_ext, open);

end structural;

