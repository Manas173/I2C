--Author: Manas Ranjan Swain
--To make a clock divider that converts the default clock speed to 100KHz i.e., the clock frequency for I2C (although max is 400KHz)

library IEEE;			
use IEEE.STD_LOGIC_1164.ALL;


entity I2C_clock_divider is
port(sys_clk: in STD_LOGIC;				
		i2c_clk: inout STD_LOGIC:='0');
end I2C_clock_divider;

architecture clock_divider of I2C_clock_divider is
shared variable count:INTEGER range 1 to 1001:=1;
begin
	process(sys_clk)
	begin
		if(count=1001) then		
			count:=1;
			i2c_clk<=not i2c_clk;
		else
			count:= count+1;
		end if;
	end process;
end clock_divider;

