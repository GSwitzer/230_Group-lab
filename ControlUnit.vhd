----------------------------------------------------------------------------------
-- Name: Prof Jeff Falkinburg
-- Date: Fall 2020
-- Course: CSCE 230
-- File: ControlUnit.vhd
-- HW: Group Project
-- Purp: Implements a 16-Bit Control Unit for our processor
--
-- Doc: Lecture Notes
-- 
-- Academic Integrity Statement: I certify that, while others may have
-- assisted me in brain storming, debugging and validating this program,
-- the program itself is my own work. I understand that submitting code
-- which is the work of other individuals is a violation of the honor 
-- code. I also understand that if I knowingly give my original work to
-- another individual is also a violation of the honor code.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ControlUnit IS
	PORT (
		clock : IN std_logic;
		reset : IN std_logic;
		status : IN std_logic_vector(15 DOWNTO 0);
		MFC : IN std_logic;
		IR : IN std_logic_vector(15 DOWNTO 0);
 
		RF_write : OUT std_logic;
		C_select : OUT std_logic_vector(1 DOWNTO 0);
		B_select : OUT std_logic;
		Y_select : OUT std_logic_vector(1 DOWNTO 0);
		ALU_op : OUT std_logic_vector(1 DOWNTO 0);
		A_inv : OUT std_logic;
		B_inv : OUT std_logic;
		C_in : OUT std_logic;
		MEM_read : OUT std_logic;
		MEM_write : OUT std_logic;
		MA_select : OUT std_logic;
		IR_enable : OUT std_logic;
		PC_select : OUT std_logic_vector(1 DOWNTO 0);
		PC_enable : OUT std_logic;
		INC_select : OUT std_logic;
		extend : OUT std_logic_vector(2 DOWNTO 0);
		Status_enable : OUT std_logic;
		-- for ModelSim debugging only
		debug_state : OUT std_logic_vector(2 DOWNTO 0)
	);
END ControlUnit;

ARCHITECTURE implementation OF ControlUnit IS
	SIGNAL current_state : std_logic_vector(2 DOWNTO 0);
	SIGNAL next_state : std_logic_vector(2 DOWNTO 0);
	SIGNAL WMFC : std_logic;
	SIGNAL OP_code : std_logic_vector(2 DOWNTO 0);
	SIGNAL OPX : std_logic_vector(3 DOWNTO 0);
	SIGNAL N, C, V, Z : std_logic;
BEGIN
	OP_code <= IR(2 DOWNTO 0);
	OPX <= IR(6 DOWNTO 3);
	N <= status(3);
	C <= status(2);
	V <= status(1);
	Z <= status(0);

	-- for debugging only
	debug_state <= current_state;

	-- current state logic
	PROCESS (clock, reset)
	BEGIN
		IF (reset = '1') THEN
			current_state <= "000";
		ELSIF rising_edge(clock) THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	-- next state logic
	PROCESS (current_state, WMFC, MFC)
		BEGIN
			CASE current_state IS
				WHEN "000" => 
					next_state <= "001"; -- start with stage 1
				WHEN "001" => 
					IF (WMFC = '0') THEN
						next_state <= "010"; -- not wait for mem (for clarity, not necessary)
					ELSIF (MFC = '1') THEN
						next_state <= "010"; -- mem ready
					ELSE 
						next_state <= "001"; -- mem not ready
					END IF;
				WHEN "010" => 
					next_state <= "011";
				WHEN "011" => 
					next_state <= "100";
				WHEN "100" => 
					IF (WMFC = '0') THEN
						next_state <= "101"; -- not wait for mem
					ELSIF (MFC = '1') THEN
						next_state <= "101"; -- mem ready
					ELSE 
						next_state <= "100"; -- mem not ready
					END IF; 
				WHEN "101" => 
					next_state <= "001";
				WHEN OTHERS => 
					next_state <= "000"; -- something wrong, reset
			END CASE;
		END PROCESS;

 
		-- Mealy output logic
		PROCESS (current_state, MFC, OP_code, OPX, N, C, V, Z)
			BEGIN
				-- set all output signals to the default 0
				RF_write <= '0';
				C_select <= "00";
				B_select <= '0';
				Y_select <= "00";
				ALU_op <= "00";
				A_inv <= '0';
				B_inv <= '0';
				C_in <= '0';
				MEM_read <= '0';
				MEM_write <= '0';
				MA_select <= '0';
				IR_enable <= '0';
				PC_select <= "00";
				PC_enable <= '0';
				INC_select <= '0';
				extend <= "000";
				Status_enable <= '0';
				-- set internal WMFC signal to the default 0
				WMFC <= '0';

				-- Student Code: set output signals and WMFC for each instruction and each stage
				IF (current_state = "001") THEN
					MA_select <= '1';
					MEM_read <= '1';
					MEM_write <= '0';
					WMFC <= '1';
 
					IF (MFC = '1') THEN
						IR_enable <= '1';
					ELSE
						IR_enable <= '0'; --for clarity
					END IF;
 
					INC_select <= '0'; -- for clarity
					PC_select <= "01";
					IF (MFC = '1') THEN
						PC_enable <= '1';
					ELSE
						PC_enable <= '0'; --for clarity
					END IF;
				END IF;
				
				--ADD INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0000")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "11";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--ADDi INSTRUCTION
				IF ((OP_code = "011") ) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						extend <= "000";
						B_select <= '1';
						ALU_op <= "11";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "00";
					END IF;
				END IF;
				
				--SUB INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0001")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "11";
						A_inv <= '0';
						B_inv <= '1';
						C_in <= '1';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--AND INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0010")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "00";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--OR INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0011")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "01";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--ORI INSTRUCTION
				IF ((OP_code = "100")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
					   extend <= "001";
						B_select <= '1';
						ALU_op <= "01";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "00";
					END IF;
				END IF;
				
				--ORHI INSTRUCTION
				IF ((OP_code = "101")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
					   extend <= "010";
						B_select <= '1';
						ALU_op <= "01";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "00";
					END IF;
				END IF;
				
				--XOR INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0100")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "10";
						A_inv <= '0';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--NAND INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0101")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "01";
						A_inv <= '1';
						B_inv <= '1';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--NOR INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0110")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "00";
						A_inv <= '1';
						B_inv <= '1';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
				
				--XNOR INSTRUCTION
				IF ((OP_code = "000") AND (OPX = "0111")) THEN
					IF (current_state = "010") THEN
					ELSIF (current_state = "011") THEN
						B_select <= '0';
						ALU_op <= "10";
						A_inv <= '1';
						B_inv <= '0';
						C_in <= '0';
					ELSIF (current_state = "100") THEN
						Y_select <= "00";
					ELSIF (current_state = "101") THEN
						RF_write <= '1';
						C_select <= "01";
					END IF;
				END IF;
 
				END PROCESS;
 
END implementation;