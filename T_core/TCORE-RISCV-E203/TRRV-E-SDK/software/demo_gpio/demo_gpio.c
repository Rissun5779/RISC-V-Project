// See LICENSE for license details.

#include <stdint.h>
#include <stdbool.h>
#include <stdatomic.h>
#include "encoding.h"
#include <platform.h>


// LED0-3: bit 0-3
// SW0-3:  bit 4-7
// KEY0-1: bit 8-9
// ...
#define TERASIC_LED_MASK  0x0000000F
#define TERASIC_SW_MASK   0x000000F0
#define TERASIC_KEY_MASK  0x00000300


uint32_t gpio_value = 0;

void set_LED(uint8_t value){
    gpio_value &= ~TERASIC_LED_MASK;
    gpio_value |= (uint32_t)(value << 0) & TERASIC_LED_MASK;
}

void update_GPIO_Output(void){
    GPIO_REG(GPIO_OUTPUT_VAL) = (GPIO_REG(GPIO_OUTPUT_VAL)&(~TERASIC_LED_MASK))|gpio_value;
}



int main (void){
    // Wait a bit because we were changing the GPIOs
    volatile int i=0;
    while(i < 10000){i++;}

    // Set LED0-3 output
    GPIO_REG(GPIO_OUTPUT_EN) |= TERASIC_LED_MASK;

    uint8_t led_value=0x01;

    while(1){
        volatile uint64_t *  now = (volatile uint64_t*)(CLINT_CTRL_ADDR + CLINT_MTIME);
        volatile uint64_t then = *now + 4000;

        while (*now < then) { }

        if(led_value >= 0x08) 
            led_value = 0x01;
        else
            led_value = led_value << 1;

        set_LED(led_value);
        update_GPIO_Output();
    }    //end of while


}
  

