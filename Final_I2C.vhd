--Author: Manas Ranjan Swain

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

--To write data to a address 50 

entity I2C_master_simple is
    Port ( sys_clk: in STD_LOGIC;
			  clk : inout STD_LOGIC;
           reset : in  STD_LOGIC;
           i2c_scl : inout  STD_LOGIC:='1';
           i2c_sda : out  STD_LOGIC;
			  
			  Sensor1: inout STD_LOGIC_VECTOR(15 downto 0);
			  Sensor2: inout STD_LOGIC_VECTOR(15 downto 0);
		     Sensor3: inout STD_LOGIC_VECTOR(15 downto 0);
		     Sensor4: inout STD_LOGIC_VECTOR(15 downto 0);
			  Sensor_input1: in INTEGER range 0 to 4303;
			  Sensor_input2: in INTEGER range 0 to 4303;
		     Sensor_input3: in INTEGER range 0 to 4303;
		     Sensor_input4: in INTEGER range 0 to 4303
			  );
end I2C_master_simple;

--Hot coding is done for implementing Finite State machine
 
architecture code_starts of I2C_master_simple is
signal state:STD_LOGIC_VECTOR(7 downto 0):="00000001";
constant initial_idle_state:STD_LOGIC_VECTOR(7 downto 0):="00000001";
constant initial_start_state:STD_LOGIC_VECTOR(7 downto 0):="00000010";
constant address_state:STD_LOGIC_VECTOR(7 downto 0):="00000100";
constant acknowledge_state:STD_LOGIC_VECTOR(7 downto 0):="00001000";
constant acknowledge_state_2:STD_LOGIC_VECTOR(7 downto 0):="00010000";
constant stop_state:STD_LOGIC_VECTOR(7 downto 0):="00100000";
constant address:STD_LOGIC_VECTOR(6 downto 0):="1010000";
constant data_state:STD_LOGIC_VECTOR(7 downto 0):="01000000";
signal I2C_enable:STD_LOGIC:='0';
shared variable count:INTEGER range 0 to 15;
shared variable start:STD_LOGIC:='0';
shared variable data:STD_LOGIC_VECTOR(15 downto 0);
shared variable cal:INTEGER range 0 to 65535;

COMPONENT I2C_clock_divider	--Lowers the frequency from the default system frequency to the frequency ideal for I2c i.e, 100Khz
	PORT(sys_clk : IN std_logic;       
		  i2c_clk : INOUT std_logic);
end component;

COMPONENT Tem_sensor_sampleblock
	PORT(
		Sensor : IN INTEGER range 0 to 4303;          
		output_vector : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
begin
block1: Tem_sensor_sampleblock PORT MAP(
		Sensor => Sensor_input1,
		output_vector => Sensor1
	);
block2: Tem_sensor_sampleblock PORT MAP(
		Sensor => Sensor_input2,
		output_vector => Sensor2
	);
block3: Tem_sensor_sampleblock PORT MAP(
		Sensor => Sensor_input3,
		output_vector => Sensor3
	);
block4: Tem_sensor_sampleblock PORT MAP(
		Sensor => Sensor_input4,
		output_vector => Sensor4
	);
divider: I2C_clock_divider PORT MAP(
		sys_clk =>sys_clk ,
		i2c_clk => clk
	);
process(Sensor1,Sensor2,Sensor3,Sensor4)
begin
	cal:=conv_integer(unsigned(Sensor1))+conv_integer(unsigned(Sensor2))+conv_integer(unsigned(Sensor3))+conv_integer(unsigned(Sensor4));
	data:=conv_std_logic_vector(cal,16);
	start:='1';
end process;
	
process(clk,i2c_enable) --Implemented for clock synchronization
 begin
	if(i2c_enable='0') then
		i2c_scl<='1';
	else
		i2c_scl<=not clk;
	end if;
end process;

process(clk,reset,state)-- Chnage of i2c_enable which is later used for clock synchronization
	begin
	if(clk'event and clk='1')then
		if(reset='1') then
			i2c_enable<='0';
		else
			if(state=initial_idle_state or state=initial_start_state or state=stop_state) then
				i2c_enable<='0';

			else
				i2c_enable<='1';
			end if;
		end if;
		end if;
	end process;
process(reset,clk,state)
begin
if(clk'event and clk='1') then
	if(reset='1') then
		state<=initial_idle_state;
		i2c_sda<='1';
	else
		case state is
		  when initial_idle_state=>
				i2c_sda<='1';
				if(start='1') then
				state<=initial_start_state;
				end if;
		  when initial_start_state=>
				i2c_sda<='1';
				state<=address_state;
				count:=6;
		  when address_state=> --Address reach state
				i2c_sda<=address(count);
				if (count=0) then
					state<=acknowledge_state;
				else
					count:=count-1;
				end if;
			when acknowledge_state=>	--This state is left blank , Will be modified later when needed
				state<=data_state;
				count:=15;
			when data_state=>	--In this state data transfer takes place
				i2c_sda<=data(count);
				if(count=0) then
					state<=acknowledge_state_2;
				else
					count:=count-1;
				end if;
			when acknowledge_state_2=> --This state is left blank , Will be modified later when needed
				state<=stop_state;
			when stop_state=> 
				i2c_sda<='1';
				state<=initial_idle_state;
			when others=>
				state<=initial_idle_state;
		end case;
	end if;
	end if;
	end process;
end code_starts;
