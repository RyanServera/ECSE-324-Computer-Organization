// Useful imports
#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"


int makeNote (int time, float frequency);
void getNote(int data, float frequencies[9]);

// Map for the keys that are pressed down
int keyMap[8] = {0, 0, 0, 0, 0, 0, 0, 0};

// Initial amplitude and volume level
float  amplitude = 1.0;
int volumeLevel = 7;

int main() {

    // Look up table for all the signals
	float frequencies[9] = {130.813, 146.832, 164.832,
			 174.614, 195.998, 220.000, 246.942, 261.626, 0.0};

    // Setting the timer for the interrupt (set to 20 microseconds)
	int_setup(1, (int[]) {199});

	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 20;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

    // Initialized variables for making signals
	int i;
	int signal = 0;
	float frequency = 0;
	int time = 0;

    // Initialized variables for keyboard presses
	char keyPressed;
	int numberOfKeysPressed = 0;

    // Mapping for display messages
	char displayGroup[8] = {'G','r','o','u','p',':','6','0'};
	char displayVolumeLevel[8] = {'V','o','l','u','m','e',':'};

    // Initialized variables for displaying waves
	int rowColumnPosition[320]; 
	int vgaOutCounter = 0; 
	int x = 0; 
	int y = 0; 

    // Clears the messages on the screen
	VGA_clear_charbuff_ASM();

    // Display the messages
	for(i = 0; i < 8; i++){
		VGA_write_char_ASM(x, 0, displayGroup[i]);
		VGA_write_char_ASM(x, 1, displayVolumeLevel[i]);
		x += 1;
	}

	while(1) {	

        // Display the current volume level
		VGA_write_char_ASM(8, 1, (char)volumeLevel+48);	

        // Map the note in the keyMap array when a key is pressed
		if(read_ps2_data_ASM(&keyPressed))
			getNote(keyPressed, frequencies);

        // When the interrupt is hit, load the signal to the audio port
		if(hps_tim0_int_flag){
			hps_tim0_int_flag = 0;
			time = (time + 1) % 48000;

            // Make the overall signal from the keyMap array
			numberOfKeysPressed = 0;
			signal = 0;
			for (i = 0; i < 8; i++){
				if(keyMap[i] == 1){
					numberOfKeysPressed++;
					signal = signal + makeNote (time, frequencies[i]);
				}
			}

            // Normalize and scaled the signal based on the volume
			signal = signal * amplitude / numberOfKeysPressed;

            // Load write audio only when the queues are not full
            while(!audio_write_data_ASM(signal, signal));

            // Display the wave on the screen
			vgaOutCounter++;
			if(vgaOutCounter > 10) {
				vgaOutCounter = 0;
				x = (x + 1) % 320;
				y = (int)((float) signal / 240000);
				VGA_draw_point_ASM(x, rowColumnPosition[x], 0);
				VGA_draw_point_ASM(x, 120 + y, 16000);
				rowColumnPosition[x] = 120 + y;
			}
		}
	}
	return 0;
}

// Makes the note given the time and the frequency
int makeNote (int time, float frequency){

    // Separate the ft
	float ft = (frequency * time);
	int ftFloor = (int) ft;
	float ftRemainder = ft - ftFloor;

    // Get the indexes
	int index1 = ftFloor % 48000;
	int index2 = index1 + 1;

    // Perform linear interpolation
	int signal = (int) ((1.0-ftRemainder)*(float)sine[index1] + ftRemainder*(float)sine[index2]);

	return signal;
}

// Map the button pressed in the keyMap array
void getNote(int data, float frequencies[9]){

	static int isBreakCodeTriggered;
	switch(data){
        // Set the end key flag
		case 0xF0:
			isBreakCodeTriggered = 1;
		break;

        // For any other key map when the flag is not set and don't map when the end key flag is set
		case 0x1C:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[0] = 0;
			}
			else {
				keyMap[0] = 1;
			}
		break;

		case 0x1B:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[1] = 0;
			}
			else {
				keyMap[1] = 1;
			}
		break;

		case 0x23:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[2] = 0;
			}
			else {
				keyMap[2] = 1;
			}
		break;

		case 0x2B:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[3] = 0;
			}
			else {
				keyMap[3] = 1;
			}
		break;

		case 0x3B:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[4] = 0;
			}
			else {
				keyMap[4] = 1;
			}
		break;

		case 0x42:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[5] = 0;
			}
			else {
				keyMap[5] = 1;
			}
		break;

		case 0x4B:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[6] = 0;
			}
			else {
				keyMap[6] = 1;
			}
		break;

		case 0x4C:
			if(isBreakCodeTriggered){
				isBreakCodeTriggered = 0;
				keyMap[7] = 0;
			}
			else {
				keyMap[7] = 1;
			}
		break;

        // Increase the volume
		case 0x75:
			if(isBreakCodeTriggered) {
				if(volumeLevel < 9){
					amplitude = amplitude * 1.75;
					volumeLevel += 1;
				}
				isBreakCodeTriggered = 0;
			}
		break;

        // Lower the volume
		case 0x72:
			if(isBreakCodeTriggered) {
				if(volumeLevel > 0){
               		amplitude = amplitude / 1.75;
					volumeLevel -= 1;
				}
                isBreakCodeTriggered = 0;
            }
		break;
        
		default: 
			break;
	}
}
