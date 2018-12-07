--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:20:10 12/28/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_controllo_tasto.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controllo_tasto
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
 
ENTITY tb_controllo_tasto IS
END tb_controllo_tasto;
 
ARCHITECTURE behavior OF tb_controllo_tasto IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controllo_tasto
    PORT(
         button : IN  std_logic;
         clock : IN  std_logic;
         segnale_controllo : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal button : std_logic := '0';
   signal clock : std_logic := '0';

 	--Outputs
   signal segnale_controllo : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controllo_tasto PORT MAP (
          button => button,
          clock => clock,
          segnale_controllo => segnale_controllo
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
		button <= '1', '0' after 10*clock_period, '1' after 12*clock_period, '0' after 22*clock_period;

      wait;
   end process;

END;
