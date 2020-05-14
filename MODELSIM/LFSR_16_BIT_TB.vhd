


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTio.ALL;
use ieee.STD_LOGIC_TEXTio.ALL;


entity LFSR_16_BIT_TB IS   -- TESTBENCH IS AN EMPTY ENTITY 

end LFSR_16_BIT_TB;





ARCHITECTURE BHV OF LFSR_16_BIT_TB IS 
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Testbench CONSTANTS                                                                                                                								           --
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CONSTANT T_CLK   : TIME := 10 ns;                                             -- CLOCK PERIOD                                                       						           --
	CONSTANT T_RESET : TIME := 25 ns;                                             -- PERIOD BEFORE THE RESET DEASSERTION                                                                                       --
	CONSTANT N_TB	 : NATURAL := 3;	                                      -- GENERIC CONSTANT DEFINITION                                                                                               --
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Testbench SIGNALS																							   --    
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SIGNAL clock_tb        : STD_LOGIC := '0';                                    -- CLOCK SIGNAL, INTIALIZED TO '0'                                             						   --
	SIGNAL reset_tb        : STD_LOGIC := '1';                                    -- RESET SIGNAL ACTIVE HIGH												   --
	SIGNAL input_value_tb  : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1010110011100001"; -- INPUT_VALUE  OF LFSR  													   --
        SIGNAL output_value_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);                       -- OUTPUT_VALUE OF LFSR													   --
	SIGNAL en_tb           : STD_LOGIC := '1';                                    -- ENABLE SIGNAL TO CONNECT TO THE EN INPUT PORT                                                                             --
	SIGNAL end_sim         : STD_LOGIC := '1';                                    -- SIGNAL TO USE TO STOP THE SIMULATION WHEN THERE IS NOTHING ELSE TO TEST                                                   --
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- COMPONENT TO TEST (DUT) DECLARATION (DUT = DESIGN UNDER TEST)                                                                                          							   --
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        COMPONENT LFSR_16_BIT IS                                 																		   --
              PORT(                          																					   --
                    clock        : IN  STD_LOGIC;																				   --
                    reset        : IN  STD_LOGIC;																				   --
                    input_value  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);            																   --
                    output_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)     																	   -- 	
                  );																							           --
        END COMPONENT;            																						   --
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																										   --
	BEGIN																									   --
																										   --
	  clock_tb <= (NOT(clock_tb) AND end_sim) AFTER T_CLK / 2;     -- THE CLOCK TOGGLES AFTER T_CLK / 2 WHEN END_SIM IS HIGH. WHEN END_SIM IS FORCED LOW, THE CLOCK STOPS TOGGLING AND THE SIMULATION ENDS     --
	  reset_tb <= '0' AFTER T_RESET;                               -- DEASSERTING THE RESET AFTER T_RESET NANOSECODS                                                                                           --
 																										   --
																										   --
	                     																							   --
	  LFSR : LFSR_16_BIT            																					   --
	             PORT MAP(																							   --
                               clock        => clock_tb,                  																	   --
                               reset        => reset_tb,                                                                                                                                                           --
                               input_value  => input_value_tb,																			   --
                               output_value => output_value_tb																			   --
                       );																							   --
	   																									   --
	  d_PROCESS: PROCESS(clock_tb, reset_tb)                                           -- PROCESS USED TO MAKE THE TESTBENCH SIGNALS CHANGE SYNCHRONOUSLY WITH THE RISING EDGE OF THE CLOCK                    --
		VARIABLE t            : INTEGER := 0;                                      -- VARIABLE USED TO COUNT THE CLOCK CYCLE AFTER THE RESET 								   --
	        FILE     file_handler : TEXT OPEN write_mode IS "output_to_be_tested.txt"; -- CREATE THE FILE WHERE TB SIMULATION OUTPUT WILL BE TESTED                                                            --
	        VARIABLE row          : line;						   -- VARIABLE TO HANDLE FILE ROW											   --
	        VARIABLE data_write   : STD_LOGIC_vector(15 DOWNTO 0);                     -- FILE WRITER     													   --
	  BEGIN																									   --
	    if(reset_tb = '1') then																						   --
		  t := 0;   																							   --
		ELSIF(rising_edge(clock_tb)) THEN                                                                                                                                                                  --
		  CASE(t) IS                                                               -- SPECIFYING THE INPUT D_TB AND END_SIM DEPENDING ON THE VALUE OF T ( AND SO ON THE NUMBER OF THE PASSED CLOCK CYCLES) --
                     WHEN 65535 => end_sim <= '0';	                                   -- END SIMULATION 													   --
                     WHEN OTHERS => data_write := output_value_tb; write(row, data_write); writeline(file_handler ,row); -- FILE IS UPDATED WITH CURRENT OUTPUT                                                    --
		  END CASE;                    																					   --
		  t := t + 1;                                                                                            -- VARIABLE IS UPDATED EXACTLY HERE                                                       --
		END IF;																								   --
	  END PROCESS;                                                                                                                                                                                             --
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------																										   --
END BHV;																									   
