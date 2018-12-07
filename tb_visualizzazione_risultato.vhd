--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:56:43 12/23/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_visualizzazione_risultato.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: visualizzazione_risultato
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_visualizzazione_risultato IS
END tb_visualizzazione_risultato;
 
ARCHITECTURE behavior OF tb_visualizzazione_risultato IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT visualizzazione_risultato
    PORT(
         input : IN  std_logic_vector(63 downto 0);
         count_en : IN  std_logic;
         load_risultato : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         display_up_down : IN  std_logic;
         output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic_vector(63 downto 0) := (others => '0');
   signal count_en : std_logic := '0';
   signal load_risultato : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal display_up_down : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: visualizzazione_risultato PORT MAP (
          input => input,
          count_en => count_en,
          load_risultato => load_risultato,
          clock => clock,
          reset_n => reset_n,
          display_up_down => display_up_down,
          output => output
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here
		reset_n <= '1';
		display_up_down <= '0';
		load <= '1', '0' after 5*clock_period, '1' after 10*clock_period;
		count_en <= '1';
		input <= x"0000FFFF0000FFFF";

      wait;
   end process;

END;
