

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



ENTITY LFSR_16_BIT IS
              PORT(
                    clock        : IN  STD_LOGIC;
                    reset        : IN  STD_LOGIC;
                    input_value  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
                    output_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
                  );
END LFSR_16_BIT;


ARCHITECTURE BHV OF LFSR_16_BIT IS 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    SIGNAL      feedback : STD_LOGIC;                        -- INTERNAL SIGNAL FOR THE FEEDBACK BIT                                                                                                  --
    SIGNAL  actual_value : STD_LOGIC_VECTOR(15 DOWNTO 0);    -- CONTAINS THE ACTUAL VALUE OF THE LFSR                                                                                                 --
    SIGNAL    next_value : STD_LOGIC_VECTOR(15 DOWNTO 0);    -- VALUE FOR LFSR STATE UPDATE                                                                                                           --
                                                                                                                                                                                                      --
BEGIN                                                                                                                                                                                                 --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                        WITHIN THE PROCESS STATEMENTS ARE SEQUENTIALLY EXECUTED - OUTSIDE EVERYTHING IS PARALLEL... PROCESS ITSELF IT'S EXECUTED IN PARALLEL WITH ALL THE REST                      --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   ragister_state : PROCESS(clock, reset)                                                              -- STATE CHANGES ONLY IN THE VARIATION OF ONE OF THE PARAMETERS IN THE SENSITIVITY LIST
     BEGIN 
            IF(reset = '1') THEN 								       -- RESET IS HIGH-ACTIVE
                actual_value <= input_value;                                                           -- AT RESET REGISTER RETURNS TO THE VALUE OF THE SEED
            ELSIF(rising_edge(clock)) THEN 							       -- AT RISING_EDGE THE STATE OF THE REGISTER IS UPDATED 
                actual_value <= next_value; 							       -- NEW VALUE IS ASSIGNED TO ACTUAL VALUE
            END IF;
     END PROCESS;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   feedback     <= actual_value(0) XOR actual_value(2) XOR actual_value(3) XOR actual_value(5);        -- VALUE OBTAINED FROM THE FEEDBACK FUNCTION DETAILED BY CHARACTERISTIC POLYNOMYAL             -- 
   next_value   <= feedback & actual_value(15 DOWNTO 1);                                               -- IN VHDL & OPERATOR IS CONCATENATION THAT IN THIS CASE IS VERY USEFUL                        --
                                                                                                                                                                                                      --
   output_value <= actual_value;								       -- ACTUAL VALUE IS ASSIGNED AS LFSR OUTPUT                                                     --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
END BHV;
