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
/*
		WS2812_LED_SET(0,32,0,0);
		WS2812_LED_SET(1,31,31,0);
		WS2812_LED_SET(2,12,32,5);
		WS2812_LED_SET(3,20,4,30);
*/

#include <stdio.h>
#include "terasic_includes.h"

#define LED_NUM 143
#define DEMO_Red 64,0,0
#define DEMO_YELLOW 62,62,0
#define DEMO_GREEN 24,64,10
#define DEMO_PURPLE 40,8,60


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
  int i=0,j=0;
  printf("=====WS2812 EXT LED Test=====\n");
  WS2812_All_off();
  usleep(1000000);
  while(1){

	  printf("Red color\n");
	  WS2812_All_off();
	  for(i=0;i<LED_NUM-7;i+=7){
		  WS2812_LED_SET(i,30,0,0);
		  WS2812_LED_SET(i+1,60,0,0);
		  WS2812_LED_SET(i+2,90,0,0);
		  WS2812_LED_SET(i+3,120,0,0);
		  WS2812_LED_SET(i+4,150,0,0);
		  WS2812_LED_SET(i+5,180,0,0);
		  WS2812_LED_SET(i+6,210,0,0);
		  WS2812_LED_SET(i+7,240,0,0);
		  WS2812_update();
		  usleep(10000);

	  }
	  for(i=0;i<15;i++){
		  WS2812_LED_SET_ALL(i*10,0,0);
		  usleep(100000);
	  }
	  printf("Green color\n");
	  WS2812_All_off();
	  for(i=0;i<LED_NUM-7;i+=7){
		  WS2812_LED_SET(i,0,30,0);
		  WS2812_LED_SET(i+1,0,60,0);
		  WS2812_LED_SET(i+2,0,90,0);
		  WS2812_LED_SET(i+3,0,120,0);
		  WS2812_LED_SET(i+4,0,150,0);
		  WS2812_LED_SET(i+5,0,180,0);
		  WS2812_LED_SET(i+6,0,210,0);
		  WS2812_LED_SET(i+7,0,240,0);
		  WS2812_update();
		  usleep(10000);
	  }

	  WS2812_All_off();
	  for(i=0;i<15;i++){
		  WS2812_LED_SET_ALL(0,i*10,0);
		  usleep(100000);
	  }

	  printf("Blue color\n");
	  WS2812_All_off();
	  for(i=0;i<LED_NUM-7;i+=7){
		  WS2812_LED_SET(i,0,0,30);
		  WS2812_LED_SET(i+1,0,0,60);
		  WS2812_LED_SET(i+2,0,0,90);
		  WS2812_LED_SET(i+3,0,0,120);
		  WS2812_LED_SET(i+4,0,0,150);
		  WS2812_LED_SET(i+5,0,0,180);
		  WS2812_LED_SET(i+6,0,0,210);
		  WS2812_LED_SET(i+7,0,0,240);
		  WS2812_update();
		  usleep(10000);
	  }


	  WS2812_All_off();
	  for(i=0;i<15;i++){
		  WS2812_LED_SET_ALL(0,0,i*10);
		  usleep(100000);
	  }
	  printf("Demo color\n");
	  WS2812_All_off();
	  for(j=0;j<3;j++){
		  for(i=0;i<LED_NUM-7;i+=7){
			  WS2812_LED_SET(i,DEMO_Red);
			  WS2812_LED_SET(i+1,DEMO_YELLOW);
			  WS2812_LED_SET(i+2,DEMO_GREEN);
			  WS2812_LED_SET(i+3,DEMO_PURPLE);
			  WS2812_LED_SET(i+4,DEMO_Red);
			  WS2812_LED_SET(i+5,DEMO_YELLOW);
			  WS2812_LED_SET(i+6,DEMO_GREEN);
			  WS2812_LED_SET(i+7,DEMO_PURPLE);
			  WS2812_update();
			  usleep(10000);
		  }
		  usleep(1000000);
		  WS2812_All_off();
	  }


  }


  return 0;
}
