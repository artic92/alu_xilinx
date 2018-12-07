--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:42:25 12/23/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_caricamento_operando.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: caricamento_operando
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
 
ENTITY tb_caricamento_operando IS
END tb_caricamento_operando;
 
ARCHITECTURE behavior OF tb_caricamento_operando IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT caricamento_operando
    PORT(
         input : IN  std_logic_vector(7 downto 0);
         count_en : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         output : OUT  std_logic_vector(63 downto 0);
         value_display : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic_vector(7 downto 0) := (others => '0');
   signal count_en : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(63 downto 0);
   signal value_display : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: caricamento_operando PORT MAP (
          input => input,
          count_en => count_en,
          clock => clock,
          reset_n => reset_n,
          output => output,
          value_display => value_display
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
		input <= x"F0";
		count_en <= '1', '0' after 3*clock_period, '1' after 11*clock_period, '0' after 13*clock_period;

      wait;
   end process;

END;
