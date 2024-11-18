----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	Reg16Bit.vhd
-- HW:		Group Project
-- Purp:	Implements a 16-Bit Register for our project 
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

entity Reg16Bit is
	port(
		clock   : in std_logic;
		reset   : in std_logic;
		enable  : in std_logic;
		D		  : in std_logic_vector(15 downto 0);
		Q		  : out std_logic_vector(15 downto 0)
	);
end Reg16Bit;

architecture implementation of Reg16Bit is
	component Reg1Bit is
	port(
		clock   : in std_logic;
		reset   : in std_logic;
		enable  : in std_logic;
		D		  : in std_logic;
		Q		  : out std_logic
	);
	end component;
begin
	bit0: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(0), Q=>Q(0));
	bit1: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(1), Q=>Q(1));
	bit2: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(2), Q=>Q(2));
	bit3: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(3), Q=>Q(3));
	bit4: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(4), Q=>Q(4));
	bit5: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(5), Q=>Q(5));
	bit6: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(6), Q=>Q(6));
	bit7: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(7), Q=>Q(7));
	bit8: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(8), Q=>Q(8));
	bit9: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(9), Q=>Q(9));
	bit10: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(10), Q=>Q(10));
	bit11: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(11), Q=>Q(11));
	bit12: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(12), Q=>Q(12));
	bit13: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(13), Q=>Q(13));
	bit14: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(14), Q=>Q(14));
	bit15: Reg1Bit port map (clock=>clock, reset=>reset, enable=>enable, D=>D(15), Q=>Q(15));
end implementation;