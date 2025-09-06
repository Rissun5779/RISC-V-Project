/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "terasic_includes.h"

#define LED_NUM 4


void WS2812_update(){


	IOWR(WS2812_CONTROL_BASE,0x2,0x1);
	usleep(1);
	IOWR(WS2812_CONTROL_BASE,0x2,0x0);
	while(!IORD(WS2812_CONTROL_BASE,0x3));


}


void WS2812_All_off(){

	IOWR(WS2812_CONTROL_BASE,2,0x0);
	alt_u32 i;
	for(i=0;i<LED_NUM;i++){
		IOWR(WS2812_CONTROL_BASE,0,i);
		IOWR(WS2812_CONTROL_BASE,0x1,0x0);
	}
	WS2812_update();
}

void WS2812_All_on(){

	IOWR(WS2812_CONTROL_BASE,2,0x0);
	alt_u32 i;
	for(i=0;i<LED_NUM;i++){
		IOWR(WS2812_CONTROL_BASE,0,i);
		IOWR(WS2812_CONTROL_BASE,0x1,0xffffffff);
	}
	WS2812_update();

}

void WS2812_LED_SET(alt_u32 SelLED,alt_u8 R_Color, alt_u8 G_Color,  alt_u8 B_Color){

	/* R:8bit G:8bit B:8Bit*/
	alt_u32 Color;
	Color = (R_Color<<16) | (G_Color<<8) | (B_Color);
	IOWR(WS2812_CONTROL_BASE,0,SelLED);
	IOWR(WS2812_CONTROL_BASE,0x1,Color);

}

void WS2812_LED_SET_ALL(alt_u8 R_Color, alt_u8 G_Color,  alt_u8 B_Color){

	/* R:8bit G:8bit B:8Bit*/
	alt_u32 Color;
	Color = (R_Color<<16) | (G_Color<<8) | (B_Color);
	alt_u32 i;
	for(i=0;i<LED_NUM;i++){
		IOWR(WS2812_CONTROL_BASE,0,i);
		IOWR(WS2812_CONTROL_BASE,0x1,Color);
	}
	WS2812_update();
}

int main()
{

  printf("=====WS2812 LED Test=====\n");
  WS2812_All_off();
  usleep(1000000);
  while(1){
		WS2812_LED_SET(0,32,0,0);
		WS2812_LED_SET(1,31,31,0);
		WS2812_LED_SET(2,12,32,5);
		WS2812_LED_SET(3,20,4,30);
		WS2812_update();
		usleep(500000);
		WS2812_LED_SET(3,32,0,0);
		WS2812_LED_SET(2,31,31,0);
		WS2812_LED_SET(1,12,32,5);
		WS2812_LED_SET(0,20,4,30);
		WS2812_update();
		usleep(500000);
  }


  return 0;
}
