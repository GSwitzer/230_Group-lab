----------------------------------------------------------------------------------
-- Name:	Prof Jeff Falkinburg
-- Date:	Fall 2020
-- Course:	CSCE 230
-- File:	MemoryIOInterface.vhd
-- HW:		Group Project
-- Purp:	Implements a Memory I/O Interface for our processor 
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

entity MemoryIOInterface is
	port(
		clock 		: in std_logic;
		reset			: in std_logic;
		MEM_read		: in std_logic;
		MEM_write 	: in std_logic;
		MFC			: out std_logic;
		Address 		: in std_logic_vector(15 downto 0);
		Data_in 		: in std_logic_vector(15 downto 0);
		Data_out		: out std_logic_vector(15 downto 0);
		LEDR 			: out std_logic_vector(9 downto 0);
		HEX_DP 			: out std_logic_vector(7 downto 0);
		SW 			: in std_logic_vector(9 downto 0);
		KEY 			: in std_logic
	);
end MemoryIOInterface;

architecture implementation of MemoryIOInterface is
	component MainMemory is
		port(
				clock			: in std_logic;
				MEM_read		: in std_logic;
				MEM_write	: in std_logic;
				MFC			: out std_logic;
				Address		: in std_logic_vector(15 downto 0);
				Data_in		: in std_logic_vector(15 downto 0);
				Data_out 	: out std_logic_vector(15 downto 0)
		);
	end component;
	component Reg16Bit is
		port(
			clock   : in std_logic;
			reset   : in std_logic;
			enable  : in std_logic;
			D		  : in std_logic_vector(15 downto 0);
			Q		  : out std_logic_vector(15 downto 0)
		);
	end component;

	signal IS_MEM, IS_SW, IS_KEY, IS_HEX_DP, IS_LEDR: std_logic;
	signal MFC_MEM : std_logic;
	signal Data_out_MEM: std_logic_vector(15 downto 0);
	signal Data_out_SW : std_logic_vector(15 downto 0);
	signal Data_out_KEY: std_logic_vector(15 downto 0);
	signal DE10_LEDR: std_logic_vector(15 downto 0);
	signal DE10_HEX_DP: std_logic_vector(15 downto 0);
	signal DE10_SW : std_logic_vector(15 downto 0);
	signal DE10_KEY: std_logic_vector(15 downto 0);
begin

	IS_MEM  <= '1' when Address(15 downto 12)="0000" else 
				  '0';
	IS_LEDR <= '1' when Address=x"1000" else
				  '0';
	IS_HEX_DP <= '1' when Address=x"1010" else
				  '0';
	IS_SW   <= '1' when Address=x"1040" else
				  '0';
	IS_KEY  <= '1' when Address=x"1050" else
				  '0';

	-- Memory
	Memory: MainMemory port map (clock=>clock, MEM_read=>IS_MEM and MEM_read, MEM_write=>IS_MEM and MEM_write,
			MFC=>MFC_MEM, Address=>Address, Data_in=>Data_in, Data_out=>Data_out_MEM);
	
	-- write only
	LEDRed: Reg16Bit port map(clock=>clock, reset=>reset, enable=>IS_LEDR and MEM_write,
				D=>Data_in, Q=>DE10_LEDR);
	LEDR <= DE10_LEDR(9 downto 0);
	
	-- write only
	HEX_Display: Reg16Bit port map(clock=>clock, reset=>reset, enable=>IS_HEX_DP and MEM_write,
				D=>Data_in, Q=>DE10_HEX_DP);
	HEX_DP <= not (DE10_HEX_DP(7 downto 0));  -- invert Hex digits
	
	-- read only
	SliderSwitch: Reg16Bit port map(clock=>clock, reset=>'0', enable=>'1',
				D=>DE10_SW, Q=>Data_out_SW);
	DE10_SW(9 downto 0) <= SW;
	DE10_SW(15 downto 10) <= (others => '0'); -- all other bits are 0
	
	-- read only
	PushButton: Reg16Bit port map(clock=>clock, reset=>'0', enable=>'1',
				D=>DE10_KEY, Q=>Data_out_KEY);
	DE10_KEY(1) <= KEY;
	DE10_KEY(0) <= '0';
	DE10_KEY(15 downto 2) <= (others => '0');	-- all other bits are 0

	-- MFC to processor
	MFC <= MFC_MEM when IS_MEM='1' else
			 '1';
	
	-- Data to Processor
	Data_out <= Data_out_MEM when IS_MEM='1' and MEM_read='1' else
				   Data_out_SW  when IS_SW='1'  and MEM_read='1' else
					Data_out_KEY when IS_KEY='1' and MEM_read='1' else
					x"0000";
	
end implementation;