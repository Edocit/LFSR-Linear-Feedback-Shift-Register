

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



ENTITY LFSR_16_BIT IS
              PORT(
                    clock_btn        : IN  STD_LOGIC;
                    reset            : IN  STD_LOGIC;
                    output_value     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
                  );
END LFSR_16_BIT;


ARCHITECTURE BHV OF LFSR_16_BIT IS 
    CONSTANT seed : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1010110011100001";
    SIGNAL      feedback : STD_LOGIC;
    SIGNAL  actual_value : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL    next_value : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--             ALL' INTERNO DEL PROCESSO GLI STATEMENTS VENGONO ESEGUITI IN MANIERA SEQUENZIALE FUORI � TUTTO PARALLELO... IL PROCESSO STESSO � ESEGUITO CONCORRENTEMENTE AL RESTO                    --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   ragister_state : PROCESS(clock_btn, reset)                                                              -- LO STATO CAMBIA SOLO AL VARIARE DI UNO DEI PARAMETRI NELLA SENSITIVITY LIST 
     BEGIN 
            IF(reset = '0') THEN   			--QUA STA A ZERO PERCHÈ IL BOTTONE ON BOARD VALE GND SE PREMUTO 
                actual_value <= seed;
            ELSIF(rising_edge(clock_btn)) THEN 
                actual_value <= next_value; 
            END IF;
     END PROCESS;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   feedback     <= actual_value(0) XOR actual_value(2) XOR actual_value(3) XOR actual_value(5);        -- VALORE OTTENUTO DALLA FUNZIONE DI RETROAZIONE DETTATA DAL POLINOMIO CARATTERISTICO 
   next_value   <= feedback & actual_value(15 DOWNTO 1);                                               -- IN VHDL L' OPERATORE & � LA CONCATENAZIONE CHE NEL NOSTRO CONTESTO DI RETROAZIONE � UTILISSIMO

   output_value <= actual_value;								       -- ASSEGNO AL SEGNALE DI OUTPUT IL 

END BHV;
