----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:05 11/15/2015 
-- Design Name: 
-- Module Name:    generation_propagation - data_flow 
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

entity generation_propagation is
generic(n : integer := 4);
port(
		A : in std_logic_vector(n-1 downto 0);
		B : in std_logic_vector(n-1 downto 0);
		P : out std_logic_vector(n-1 downto 0);
		G : out std_logic_vector(n-1 downto 0)
);
end generation_propagation;

architecture data_flow of generation_propagation is


begin

P <= A xor B;	--uso XOR anzichè OR è la stessa identica cosa, poichè il caso in cui or e xor differiscono abbiamo G=1, quindi il tutto diventa irrilevante !!!
G <= A and B;

end data_flow;

