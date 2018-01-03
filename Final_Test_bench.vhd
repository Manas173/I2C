--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:00:02 12/31/2017
-- Design Name:   
-- Module Name:   /home/ise/Documents/Temperature_block/Test_bench.vhd
-- Project Name:  Temperature_block
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: I2C_master_simple
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
 
ENTITY Test_bench IS
END Test_bench;
 
ARCHITECTURE behavior OF Test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT I2C_master_simple
    PORT(
         sys_clk : IN  std_logic;
         clk : INOUT  std_logic;
         reset : IN  std_logic;
         i2c_scl : INOUT  std_logic;
         i2c_sda : OUT  std_logic;
         Sensor1 : INOUT  std_logic_vector(15 downto 0);
         Sensor2 : INOUT  std_logic_vector(15 downto 0);
         Sensor3 : INOUT  std_logic_vector(15 downto 0);
         Sensor4 : INOUT  std_logic_vector(15 downto 0);
         Sensor_input1 : IN  integer range 0 to 4303;
			Sensor_input2 : IN  integer range 0 to 4303;
			Sensor_input3 : IN  integer range 0 to 4303;
			Sensor_input4 : IN  integer range 0 to 4303
        );
    END COMPONENT;
    

   --Inputs
   signal sys_clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal Sensor_input1 : integer range 0 to 4303:=0;
   signal Sensor_input2 : integer range 0 to 4303:=0;
   signal Sensor_input3 : integer range 0 to 4303:=0;
   signal Sensor_input4 : integer range 0 to 4303:=0;

	--BiDirs
   signal clk : std_logic;
   signal i2c_scl : std_logic;
   signal Sensor1 : std_logic_vector(15 downto 0);
   signal Sensor2 : std_logic_vector(15 downto 0);
   signal Sensor3 : std_logic_vector(15 downto 0);
   signal Sensor4 : std_logic_vector(15 downto 0);

 	--Outputs
   signal i2c_sda : std_logic;

   -- Clock period definitions
   constant sys_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: I2C_master_simple PORT MAP (
          sys_clk => sys_clk,
          clk => clk,
          reset => reset,
          i2c_scl => i2c_scl,
          i2c_sda => i2c_sda,
          Sensor1 => Sensor1,
          Sensor2 => Sensor2,
          Sensor3 => Sensor3,
          Sensor4 => Sensor4,
          Sensor_input1 => Sensor_input1,
          Sensor_input2 => Sensor_input2,
          Sensor_input3 => Sensor_input3,
          Sensor_input4 => Sensor_input4
        );

   -- Clock process definitions
   sys_clk_process :process
   begin
		sys_clk <= '0';
		wait for sys_clk_period/2;
		sys_clk <= '1';
		wait for sys_clk_period/2;
   end process;
 
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
		Sensor_input1<=40;
		Sensor_input2<=30;
		Sensor_input3<=20;
		Sensor_input4<=10;
		wait for 10 us;
		reset<='0';
		wait for 10 us;
      wait;
   end process;

END;
