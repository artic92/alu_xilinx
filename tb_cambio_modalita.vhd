--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:03:06 12/28/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_cambio_modalita.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cambio_modalita
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
 
ENTITY tb_cambio_modalita IS
END tb_cambio_modalita;
 
ARCHITECTURE behavior OF tb_cambio_modalita IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cambio_modalita
    PORT(
         change_mod : IN  std_logic;
         button1 : IN  std_logic;
         button2 : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         conteggio : OUT  std_logic_vector(1 downto 0);
         sel_a_b : OUT  std_logic;
         load_a : OUT  std_logic;
         load_b : OUT  std_logic;
         load_operation : OUT  std_logic;
         start : OUT  std_logic;
         display_up : OUT  std_logic;
         display_down : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal change_mod : std_logic := '0';
   signal button1 : std_logic := '0';
   signal button2 : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal conteggio : std_logic_vector(1 downto 0);
   signal sel_a_b : std_logic;
   signal load_a : std_logic;
   signal load_b : std_logic;
   signal load_operation : std_logic;
   signal start : std_logic;
   signal display_up : std_logic;
   signal display_down : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cambio_modalita PORT MAP (
          change_mod => change_mod,
          button1 => button1,
          button2 => button2,
          clock => clock,
          reset_n => reset_n,
          conteggio => conteggio,
          sel_a_b => sel_a_b,
          load_a => load_a,
          load_b => load_b,
          load_operation => load_operation,
          start => start,
          display_up => display_up,
          display_down => display_down
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
		change_mod <= '0';
		button1 <= '1', '0' after clock_period;

      wait;
   end process;

END;
