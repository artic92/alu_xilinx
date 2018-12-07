--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:33:18 12/29/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_set_sel_a_b.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: set_sel_a_b
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
 
ENTITY tb_set_sel_a_b IS
END tb_set_sel_a_b;
 
ARCHITECTURE behavior OF tb_set_sel_a_b IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT set_sel_a_b
    PORT(
         load_a : IN  std_logic;
         load_b : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         sel_a_b : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal load_a : std_logic := '0';
   signal load_b : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal sel_a_b : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: set_sel_a_b PORT MAP (
          load_a => load_a,
          load_b => load_b,
          clock => clock,
          reset_n => reset_n,
          sel_a_b => sel_a_b
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
		load_a <= '1', '0' after clock_period, '1' after 10*clock_period, '0' after 11*clock_period;
		wait for 4*clock_period;
		load_b <= '1', '0' after clock_period;

      wait;
   end process;

END;
