#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"

void test_char() {
	int x, y;
	char c = 0;
	
	for(y = 0; y <= 59; y++){
		for(x = 0; x < 79; x++){
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte(){
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++){
		for(x = 0; x <= 79; x+= 3){
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel(){
	int x, y;
	unsigned short colour = 0;

	for(y = 0; y <= 239; y++){
		for(x = 0; x <= 319; x++){
			VGA_draw_point_ASM(x, y, colour++);
		}
	}
}


int main(){
// Part 1	
/*
	while(1){
		if(PB_data_is_pressed_ASM(PB0)){
			if(read_slider_switches_ASM()){
				test_byte();
			}else{
				test_char();
			}
		}

		if (PB_data_is_pressed_ASM(PB1)){
			test_pixel();
		}

		if (PB_data_is_pressed_ASM(PB2)){
			VGA_clear_charbuff_ASM();
		}

		if (PB_data_is_pressed_ASM(PB3)){
			VGA_clear_pixelbuff_ASM();
		}
	}
*/	

// Part 2
/*
	int x = 0, y = 0;
	char *data;
	VGA_clear_charbuff_ASM();
	while(1){
		if(read_PS2_data_ASM(data)){
			VGA_write_byte_ASM(x, y, *data);
			x +=3;
		}
		if(x >= 79){
			x = 0;
			y++;
		}
		if(y >= 59){
			y = 0;
		}
	}
*/

// Part 3

	int high = 0x00FFFFFF;
	int low = 0x00000000;
	int i;
	int signal = high;
	while(1){
		for(i = 0; i < 240; i++){ // 240 sample/ half-cycle equals 100hz
			audio_write_ASM(signal);
		}
		if(signal == high){
			signal = low;
		}else{
			signal = high;
		}
	}
	
	return 0;
}
