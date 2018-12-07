--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:27:28 12/28/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_alu_onBoard.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu_onBoard
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
 
ENTITY tb_alu_onBoard IS
END tb_alu_onBoard;
 
ARCHITECTURE behavior OF tb_alu_onBoard IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu_onBoard
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         switch : IN  std_logic_vector(7 downto 0);
         change_mod : IN  std_logic;
         button1 : IN  std_logic;
         button2 : IN  std_logic;
         leds : OUT  std_logic_vector(7 downto 0);
         anodes : OUT  std_logic_vector(3 downto 0);
         cathodes : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal switch : std_logic_vector(7 downto 0) := (others => '0');
   signal change_mod : std_logic := '0';
   signal button1 : std_logic := '0';
   signal button2 : std_logic := '0';

 	--Outputs
   signal leds : std_logic_vector(7 downto 0);
   signal anodes : std_logic_vector(3 downto 0);
   signal cathodes : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_onBoard PORT MAP (
          clock => clock,
          reset => reset,
          switch => switch,
          change_mod => change_mod,
          button1 => button1,
          button2 => button2,
          leds => leds,
          anodes => anodes,
          cathodes => cathodes
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
		switch <= x"FF";
		button1 <= '1', '0' after clock_period;
		wait for 20*clock_period;
		button2 <= '1', '0' after clock_period;

      wait;
   end process;

END;
