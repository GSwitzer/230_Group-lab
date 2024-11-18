----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	Mux4Input3Bit.vhd
-- HW:		Group Project
-- Purp:	Implements a 4 Input by 3-Bit Multiplexer for our project 
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

entity Mux4Input3Bit is
	port(
		s : in  std_logic_vector(1 downto 0);
		input0, input1, input2, input3 : in  std_logic_vector(2 downto 0);
		result : out std_logic_vector(2 downto 0));
end Mux4Input3Bit;

architecture implementation of mux4Input3Bit is
begin
	with s select
		result <=   input0 when "00",
						input1 when "01",
						input2 when "10",
						input3 when others;
end implementation;
