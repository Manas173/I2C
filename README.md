
I2C master slave final code finally built after three attempts in VHDL. As instructed multiple inputs of sensors were taken. First the sensor sends data to a block called “Tem_sensor_sampleblock”. This block sets the preference for each sensor i.e., those sensor which is more important will be given the top preference for setting 16 bit PWM.
Inputs from four different sensors were sent to the block where the I2C communication to the PWM  module takes place at a frequency of 100KHz that  is ideal for I2C .
 A module called “clock_divider” adjusts the frequency for the I2C communication i.e., it changes the system frequency (100 MHz) to the I2C frequency (100 KHz).
![simulation](I2C_final.png)
