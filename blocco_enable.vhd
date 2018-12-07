----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:00:23 12/28/2015 
-- Design Name: 
-- Module Name:    blocco_enable - DataFlow 
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

entity blocco_enable is
    Port ( operazione_in : in  STD_LOGIC_VECTOR (7 downto 0);
           enable : in  STD_LOGIC;
           operazione_out : out  STD_LOGIC_VECTOR (7 downto 0));
end blocco_enable;

architecture DataFlow of blocco_enable is

signal enable_sig : std_logic_vector(7 downto 0) := (others => '0');

begin

enable_sig <= (enable_sig'range => enable);

operazione_out <= enable_sig and operazione_in;

end DataFlow;

