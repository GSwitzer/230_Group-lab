----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	Decoder3Bit.vhd
-- HW:		Group Project
-- Purp:	Implements a 3-Bit One-Hot Decoder 
--
-- Doc:		Lecture Notes
-- 	
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Decoder3Bit is
	port(
		x : in  std_logic_vector(2 downto 0);
		y : out std_logic_vector(7 downto 0));
end Decoder3Bit;

architecture implementation of Decoder3Bit is
begin
	y(0) <= not x(2) and not x(1) and not x(0);
	y(1) <= not x(2) and not x(1) and x(0);
	y(2) <= not x(2) and x(1) and not x(0);
	y(3) <= not x(2) and x(1) and x(0);
	y(4) <= x(2) and not x(1) and not x(0);
	y(5) <= x(2) and not x(1) and x(0);
	y(6) <= x(2) and x(1) and not x(0);
	y(7) <= x(2) and x(1) and x(0);
end implementation;

