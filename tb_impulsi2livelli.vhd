--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:48:34 12/29/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_impulsi2livelli.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: inpulsi2livelli
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
 
ENTITY tb_impulsi2livelli IS
END tb_impulsi2livelli;
 
ARCHITECTURE behavior OF tb_impulsi2livelli IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT inpulsi2livelli
    PORT(
         input : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         output : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal output : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: inpulsi2livelli PORT MAP (
          input => input,
          clock => clock,
          reset_n => reset_n,
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
		input <= '1', '0' after clock_period;
		wait for 3*clock_period;
		input <= '1', '0' after clock_period;

      wait;
   end process;

END;
