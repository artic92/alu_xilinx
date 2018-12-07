--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:16:18 12/23/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_registerFile64Bit.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: registerFile64Bit
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
 
ENTITY tb_registerFile64Bit IS
END tb_registerFile64Bit;
 
ARCHITECTURE behavior OF tb_registerFile64Bit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT registerFile64Bit
    PORT(
         input1 : IN  std_logic_vector(7 downto 0);
         input2 : IN  std_logic_vector(7 downto 0);
         input3 : IN  std_logic_vector(7 downto 0);
         input4 : IN  std_logic_vector(7 downto 0);
         input5 : IN  std_logic_vector(7 downto 0);
         input6 : IN  std_logic_vector(7 downto 0);
         input7 : IN  std_logic_vector(7 downto 0);
         input8 : IN  std_logic_vector(7 downto 0);
         enable : IN  std_logic_vector(7 downto 0);
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         output : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input1 : std_logic_vector(7 downto 0) := (others => '0');
   signal input2 : std_logic_vector(7 downto 0) := (others => '0');
   signal input3 : std_logic_vector(7 downto 0) := (others => '0');
   signal input4 : std_logic_vector(7 downto 0) := (others => '0');
   signal input5 : std_logic_vector(7 downto 0) := (others => '0');
   signal input6 : std_logic_vector(7 downto 0) := (others => '0');
   signal input7 : std_logic_vector(7 downto 0) := (others => '0');
   signal input8 : std_logic_vector(7 downto 0) := (others => '0');
   signal enable : std_logic_vector(7 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: registerFile64Bit PORT MAP (
          input1 => input1,
          input2 => input2,
          input3 => input3,
          input4 => input4,
          input5 => input5,
          input6 => input6,
          input7 => input7,
          input8 => input8,
          enable => enable,
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
		
		input1 <= x"10";
		input2 <= x"5E";
		input3 <= x"F3";
		input4 <= x"10";
		input5 <= x"FF";
		input6 <= x"F0";
		input7 <= x"C0";
		input8 <= x"1A";
		
		enable <= (others => '1');

      wait;
   end process;

END;
