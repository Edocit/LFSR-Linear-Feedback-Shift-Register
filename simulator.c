
#include<stdio.h>
#include<unistd.h>
#include<math.h>
#include<stdlib.h>
#include <stdint.h>
#include <string.h>


#define MASK               0000000000000001    //used process data in shift_and_print() function   
#define LFSR_SIZE          16                  //register size / numer of Flip_Flop_D
#define MODELSIM_SAMPLES   65534 + 1           //the two added values are intresting for the test and are used to check the effective periodicity on polynomial maximality 
#define MODELSIM_SEED      0xACE1u             //same seed provided for the modelsim testbench simulation 


/////////////////////////////////////PROTOTYPES//////////////////////////////////////
void     setup_simulator(void);                                                    //
void     lfsr_fib(void);                                                           //
void     shift_n_print(uint16_t lfsr, unsigned period_offset);                     //
uint16_t binary_string_to_uint16(char *str);                                       //
void     compare_values(uint16_t lfsr_sw, uint16_t lfsr_hw, int count);            //
void     run_hw_sw_test(uint16_t *sw_val);                                         //
void     end_simulation(void);                                                     //
/////////////////////////////////////////////////////////////////////////////////////


int main(){

    setup_simulator();
    lfsr_fib();
    end_simulation();

    return 0;
}



void setup_simulator(){
    printf("--------------------------------------------------------\n");
    printf("--------------------------------------------------------\n");
    printf("WELCOME TO FIBONACCI LFSR SIMULATOR\n");
    printf("--------------------------------------------------------\n");
    printf("FEEDBACK POLYNOMIAL   --> x^16 + x^14 + x^13 + x^11 + 1\n");
    printf("FIBONACCI LFSR PERIOD --> %d\n", MODELSIM_SAMPLES - 1);        //we are only considering the period neglecting the first two values of the second one
    sleep(5);                                                              //just give the user time to read this little introduction 
    printf("--------------------------------------------------------\n");

}



/* Software implementation of the component modelled in VHDL             *
 * taps: 16 14 13 11; feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1 */
void lfsr_fib(){

    uint16_t start_state = MODELSIM_SEED;                                  //Must be different from 0x00
    uint16_t lfsr = start_state;                                           //first value corresponds to the seed value
    uint16_t bit;                                                          //used for the feedback
    unsigned long i = 1;                                                   //counter for cycles
    unsigned period_offset = 0;                                            //counter of the values in the period               
    uint16_t lfsr_val[MODELSIM_SAMPLES];                                   //array where sw generated outputs are saved


    lfsr_val[0] = MODELSIM_SEED;                                           //first value corresponds to the seed       

    do{  
        bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5));      // ^ --> is XOR operator and   & 1u --> is implicit (1u is unsigned 1)
        lfsr = (lfsr >> 1) | (bit << 15);                                   // feedback bit
        lfsr_val[i] = lfsr;                                                 // new value is saved in the array 

        //shift_n_print(lfsr,period_offset);                                  // print generated output with some information

        period_offset += 1;                                                
        i++;
    }while (lfsr != start_state);                                           // first value of second period is already added here and brakes the loop

    lfsr_val[i] = lfsr;                                                     //adding just another value to prove that period has begun again



    run_hw_sw_test(lfsr_val);                                               //once sw samples are ready call the core function to execute SW and VHDL output comparison

}



/* Prints the elapsed SW value both in binary and decimal form  */
void shift_n_print(uint16_t lfsr, unsigned period_offset){
    uint8_t bit;

    printf("SW generated LFSR vaue of cycle nr %d --> || ",period_offset);

    for (int i = 0; i < LFSR_SIZE; i++){
        printf("%d", (lfsr >> ((LFSR_SIZE - 1) - i)) & MASK );
    }

    printf(" || LFSR Decimal out --> %d \n", lfsr);
    
}




/* Funzione testata e corretta */
uint16_t binary_string_to_uint16(char *str){
    int i = 0;                                          //string index counter 
    uint8_t k = 0;                                      //bit pow counter (opposite to the one above)
    uint16_t total = 0;                                 //final  decimal unsigned 16 bit integer value 

    for(i = (LFSR_SIZE - 1); i >= 0; i-- ){
         if(str[i] == '1'){ total += pow(2,k); }        //value parsing and partial results accumulation
         k++;
    }

    return total;
}





void compare_values(uint16_t lfsr_sw, uint16_t lfsr_hw, int count){
    uint16_t output_string[LFSR_SIZE];

    ////////////////////////////////////////////////////////////////////////
    for (int i = 0; i < LFSR_SIZE; i++){                                  //
        output_string[i] = (lfsr_sw >> ((LFSR_SIZE - 1) - i)) & MASK;     // prints first value to compare --> SW value
        printf("%d", output_string[i]);                                   //
    }                                                                     //
    ////////////////////////////////////////////////////////////////////////
    printf(" == ");
    ////////////////////////////////////////////////////////////////////////
    for (int i = 0; i < LFSR_SIZE; i++){                                  //
        output_string[i] = (lfsr_hw >> ((LFSR_SIZE - 1) - i)) & MASK;     // prints second value to compare --> HW value
        printf("%d", output_string[i]);                                   //
    }                                                                     //
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////    
    if( lfsr_sw == lfsr_hw ){                                             // compares the two values and give the result
        printf(" -- OK -- %d%%\n", ((count*100) / MODELSIM_SAMPLES - 1));    // if OK --> continue computation
    }else{                                                                // 
        printf(" -- FAILED -->  %d  !=  %d\n", lfsr_sw, lfsr_hw);         // if sw_val != hw_val prints test failed and
        exit(-3);                                                         // exit with code -3 
    }                                                                     //
    ////////////////////////////////////////////////////////////////////////

}





void run_hw_sw_test(uint16_t *sw_val){

    FILE     *fp;
    char     line[LFSR_SIZE*100];
    uint16_t hw_val[MODELSIM_SAMPLES];
    int      i = 0;


    //////////////////////////////////////////////////////////////////////////////
    fp = fopen("MODELSIM/output_to_be_tested.txt","r");                             //
    if( fp == NULL){ perror("Error opening file output_to_be_tested.txt\n"); }  //
                                                                                //  read the testbench 
    while (!feof(fp)){                                                          //                      
            fgets(line, sizeof(line), fp);                                      //
            hw_val[i] = binary_string_to_uint16(line);                          //
            i++;                                                                //
    }                                                                           //
                                                                                //
    fclose(fp);                                                                 //
    //////////////////////////////////////////////////////////////////////////////

    for(i = 0; i < MODELSIM_SAMPLES; i++){
        compare_values(sw_val[i], hw_val[i], i );                         //  call the function to compare SW and HW (MODELSIM) values
    }

}





void end_simulation(){
    printf("-----------------------------------------------------\n");
    printf("SUCCESSFULLY RAN %d/%d\n",MODELSIM_SAMPLES,MODELSIM_SAMPLES);
    printf("-----------------------------------------------------\n");
    printf("AUTHOR  --> EDOARDO CITTADINI\n");
    printf("SUBJECT --> DIGITAL SYSTEM DESIGN\n");
    printf("PURPOSE --> SIMULATE VHDL LFSR HW IMPLEMENTATION\n");
    printf("DUT     --> FIBONACCI LINEAR FEEDBACK SHIFT REGISTER\n");
    printf("-----------------------------------------------------\n");

}


