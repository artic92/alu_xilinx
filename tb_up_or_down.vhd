--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:25:12 12/28/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_up_or_down.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: up_or_down
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
 
ENTITY tb_up_or_down IS
END tb_up_or_down;
 
ARCHITECTURE behavior OF tb_up_or_down IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT up_or_down
    PORT(
         up : IN  std_logic;
         down : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         set_up_down : OUT  std_logic;
         count_en : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal up : std_logic := '0';
   signal down : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal set_up_down : std_logic;
   signal count_en : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: up_or_down PORT MAP (
          up => up,
          down => down,
          clock => clock,
          reset_n => reset_n,
          set_up_down => set_up_down,
          count_en => count_en
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
		reset_n <= '1';
		up <= '1';
      wait for clock_period;
		up <= '0';
		wait for clock_period*10;
		down <= '1';
      wait for clock_period;
		down <= '0';
      wait for clock_period;
      wait;
   end process;

END;
