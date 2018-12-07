--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:30:57 12/22/2015
-- Design Name:   
-- Module Name:   C:/Users/Cristian/Desktop/ALU/Alu/tb_alu.vhd
-- Project Name:  Alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
	 generic (n : natural := 64;
	          rca_cla : natural := 1;
				 mac_moltCombinatorio : natural := 0);
    PORT(
			A : in  STD_LOGIC_VECTOR (n-1 downto 0);
         B : in  STD_LOGIC_VECTOR (n-1 downto 0);
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         add : IN  std_logic;
         sub : IN  std_logic;
         mul : IN  std_logic;
         div : IN  std_logic;
         pow : IN  std_logic;
         sqrt : IN  std_logic;
         negA : IN  std_logic;
         AandB : IN  std_logic;
         R : OUT  std_logic_vector(n-1 downto 0);
         done : OUT  std_logic;
         ovfl : OUT  std_logic;
         z : OUT  std_logic;
         div_per_zero : OUT  std_logic
        );
    END COMPONENT;
	 
	-- Architettura con moltiplicatori sequenziali (NB: il parametro generic mac_moltCombinatorio non ha effetto)
	for all : alu use entity work.alu(mulSequenziale);
	-- Architettura con moltiplicatori combinatori
--	for all : alu use entity work.alu(mulCombinatoria);
   
	constant n : natural := 64;

   --Inputs
   signal A : std_logic_vector(n-1 downto 0) := (others => '0');
   signal B : std_logic_vector(n-1 downto 0) := (others => '0');
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal add : std_logic := '0';
   signal sub : std_logic := '0';
   signal mul : std_logic := '0';
   signal div : std_logic := '0';
   signal pow : std_logic := '0';
   signal sqrt : std_logic := '0';
   signal negA : std_logic := '0';
   signal AandB : std_logic := '0';

 	--Outputs
   signal R : std_logic_vector(n-1 downto 0);
   signal done : std_logic;
   signal ovfl : std_logic;
   signal z : std_logic;
   signal div_per_zero : std_logic;

   -- Clock period definitions
   constant clock_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu 
	generic map(64, rca_cla => 0, mac_moltCombinatorio => 1)
	PORT MAP (
          A => A,
          B => B,
          clock => clock,
          reset_n => reset_n,
          add => add,
          sub => sub,
          mul => mul,
          div => div,
          pow => pow,
          sqrt => sqrt,
          negA => negA,
          AandB => AandB,
          R => R,
          done => done,
          ovfl => ovfl,
          z => z,
          div_per_zero => div_per_zero
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

--      wait for clock_period*10;

      -- insert stimulus here
		reset_n <= '1';
		
		-- Operazioni:
--		add <= '1';
--		sub <= '1';
--		mul <= '1';
		pow <= '1';
--		div <= '1';
--		sqrt <= '1';
--		negA <= '1';
--		AandB <= '1';

		-- zero addizione:
--		A <= x"0000000000000000";
--		B <= x"0000000000000000";
		-- overflow addizione:
--		A <= x"8000000000000000";
--		B <= x"FFFFFFFFFFFFFFFF";
		-- zero sottrazione:
--		A <= x"1000000000000000";
--		B <= x"1000000000000000";
		-- overflow sottrazione:
--		A <= x"8000000000000000";
--		B <= x"0000000000000001";
		-- moltiplicazione per zero:
--		A <= x"8000000000000000";
--		B <= x"0000000000000000";
--		caso particolare 1 potenza
--		A <= x"00000000FFFFFFFF"; 
--		B <= x"0000000000000001";		
--		caso particolare 2 potenza
--		A <= x"0000000000000002";
--		B <= x"0000000000000000";	
--		overflow potenza 			  
		A <= x"0000000000000002";
		B <= x"0000000001000000";			
		-- divisione per zero:
--		A <= x"8000000FFFFFFFFF";
--		B <= x"0000000000000000";
		-- radice nulla (ca 1500 ns per terminare):
--		A <= x"0000000000000000";
--		A <= x"0000000000000020"; -- sqrt(32) = 5
		-- NOT:
--		A <= x"0000000000000000";
--		A <= x"FFFFFFFFFFFFFFFF";
		-- AND nulla:
--		A <= x"0000000000000000";
--		B <= x"0000000000000000";

      wait;
   end process;

END;
