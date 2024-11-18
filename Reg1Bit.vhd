----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	Reg1Bit.vhd
-- HW:		Group Project
-- Purp:	Implements a 1-Bit Register for our project 
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

entity Reg1Bit is
	port(
		clock   : in std_logic;
		reset   : in std_logic;
		enable  : in std_logic;
		D		  : in std_logic;
		Q		  : out std_logic
	);
end Reg1Bit;

architecture implementation of Reg1Bit is
begin
	process(clock, reset)
	begin
		if (reset='1') then
			Q <= '0';
		elsif (rising_edge(clock)) then
			if (enable = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end implementation;