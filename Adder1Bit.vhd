----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	Adder1Bit.vhd
-- HW:		Group Project
-- Purp:	Implements a 1-Bit Adder 
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

entity Adder1Bit is
	port(
		X, Y, C_in : in std_logic;
		S, C_out : out std_logic
	);
end Adder1Bit;

architecture implementation of Adder1Bit is
begin
	S <= X xor Y xor C_in;
	C_out <=(X and Y) or (X and C_in) or (Y and C_in);
end implementation;