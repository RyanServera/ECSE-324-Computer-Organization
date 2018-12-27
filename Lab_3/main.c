#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"

int main(){

	// Sliders
    /*while(1){
        // read which sliders are on and then turn on the LEDs
        write_LEDs_ASM(read_slider_switches_ASM());
    }*/
	
	//Basic I/O
    // Initially flood all of the displays
	/*HEX_flood_ASM(HEX0 | HEX1 | HEX2 | HEX3| HEX4 | HEX5);

	while(1){
		write_LEDs_ASM(read_slider_switches_ASM());

        // when the button is pressed input the value of sliders is put into HEX_DISPLAY_1 and HEX_DISPLAY_5
		if(PB_data_is_pressed_ASM(PB0)){
			HEX_write_ASM(HEX1 | HEX5, read_slider_switches_ASM());
		}else {
	        // If not clear HEX_DISPLAY_1 and HEX_DISPLAY_5
			HEX_clear_ASM(HEX1 | HEX5);
		}
	}*/

	// Stopwatch
	// Initialize everything to zero
	/*int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;
	int isStarted = 0;

	 // Set the timer to 10 ms
	HPS_TIM_config_t hps_tim_0;

	hps_tim_0.tim =  TIM0;
	hps_tim_0.timeout = 10000;
	hps_tim_0.LD_en = 1;
	hps_tim_0.INT_en = 1;
	hps_tim_0.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_0);

	 // Set one to 5ms
	HPS_TIM_config_t hps_tim_1;

	hps_tim_1.tim =  TIM1;
	hps_tim_1.timeout = 5000;
	hps_tim_1.LD_en = 1;
	hps_tim_1.INT_en = 1;
	hps_tim_1.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_1);


	while(1) {

	    // read timer triggers
		if (HPS_TIM_read_INT_ASM(TIM1)){
			HPS_TIM_clear_INT_ASM(TIM1);

			// If pushbutton 0 is pressed then start the stopwatch
			if(PB_edgecap_is_pressed_ASM(PB0)){
				isStarted = 1; 
				PB_clear_edgecap_ASM(PB0);
			}

            // If pushbutton 1 is pressed then stop the stopwatch
			if(PB_edgecap_is_pressed_ASM(PB1)){
				isStarted = 0; 
				PB_clear_edgecap_ASM(PB1);
			}

			// If pushbutton 2 is pressed then reset the stopwatch
			if(PB_edgecap_is_pressed_ASM(PB2)){
				count0 = 0; 
				count1 = 0; 
				count2 = 0; 
				count3 = 0;
				count4 = 0;
				count5 = 0;
				PB_clear_edgecap_ASM(PB2);
			}
		}

	    // If the isStarted flag is 1 then start the stopwatch counter
		if(isStarted){

	        // Stopwatch counter
			if(HPS_TIM_read_INT_ASM(TIM0)){
				HPS_TIM_clear_INT_ASM(TIM0);
			
				if(++count0 == 10){
					count0 = 0;
					++count1;
				}
			
				if(count1 == 10){
					count1 = 0;
					++count2;
				}

				if(count2 == 10){
					count2 = 0;
					++count3;
				}

				if(count3 == 6){
					count3 = 0;
					++count4;
				}
	
				if(count4 == 10){
					count4 = 0;
					++count5;
				}

				if(count5 == 6){
					count5 = 0;
				}
			}
		}

        // Display the stopwatch
		HEX_write_ASM(HEX0, count0);
		HEX_write_ASM(HEX1, count1);
		HEX_write_ASM(HEX2, count2);
		HEX_write_ASM(HEX3, count3);
		HEX_write_ASM(HEX4, count4);
		HEX_write_ASM(HEX5, count5);
	} */

    // Interrupts

    // enable the pushbutton interrupt registers
	enable_PB_INT_ASM(PB0 | PB1 | PB2);

    // Initialize all of the counts and flags
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;
	int isStarted = 0;

    // Setup the interrupts
	int_setup(2, (int[]) {73, 199});

    // Configure timer to 10ms
	HPS_TIM_config_t hps_tim_0;

	hps_tim_0.tim =  TIM0;
	hps_tim_0.timeout = 10000;
	hps_tim_0.LD_en = 1;
	hps_tim_0.INT_en = 1;
	hps_tim_0.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_0);

	while(1) {

        // If Pushbutton 0 is pushed then start the stopwatch
        if (fpga_pb_keys_int_flag == 1) {
            // reset pushbutton flag
            fpga_pb_keys_int_flag = 0;
            isStarted = 1;
        }

        // If Pushbutton 1 is pushed then stop the stopwatch
        if (fpga_pb_keys_int_flag == 2) {
            // reset pushbutton flag
            fpga_pb_keys_int_flag = 0;
            isStarted = 0;
        }

        // If Pushbutton 2 is pushed then reset all of the counts
        if (fpga_pb_keys_int_flag == 4) {
            // reset pushbutton flag
            fpga_pb_keys_int_flag = 0;
            count0 = 0;
            count1 = 0;
            count2 = 0;
            count3 = 0;
            count4 = 0;
            count5 = 0;
        }

        // At every timer interrupt perform the stopwatch increment
        if (isStarted && hps_tim0_int_flag) {
            // reset timer flag
            hps_tim0_int_flag = 0;

            // Stopwatch
            if (++count0 == 10) {
                count0 = 0;
                ++count1;
            }

            if (count1 == 10) {
                count1 = 0;
                ++count2;
            }

            if (count2 == 10) {
                count2 = 0;
                ++count3;
            }

            if (count3 == 6) {
                count3 = 0;
                ++count4;
            }

            if (count4 == 10) {
                count4 = 0;
                ++count5;
            }

            if (count5 == 6) {
                count5 = 0;
            }

        }

        // Display all the stopwatch
        HEX_write_ASM(HEX0, count0);
        HEX_write_ASM(HEX1, count1);
	    HEX_write_ASM(HEX2, count2);
	    HEX_write_ASM(HEX3, count3);
	    HEX_write_ASM(HEX4, count4);
	    HEX_write_ASM(HEX5, count5);
	}

	return 0;
}
