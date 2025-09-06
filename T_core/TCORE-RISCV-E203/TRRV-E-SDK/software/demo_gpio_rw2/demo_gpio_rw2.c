#include "platform.h"

// LED0~3: bit 0-3
// SW0~3 : bit 4-7
#define TERASIC_LED_MASK    0x0000000F  // led mask
#define TERASIC_SW_MASK     0x000000F0  // sw  mask

int main(void){
    // Set LED0~3 output
    GPIO_REG(GPIO_OUTPUT_EN) |= TERASIC_LED_MASK;

    // Set SW0~3 input 
    GPIO_REG(GPIO_INPUT_EN)  |= TERASIC_SW_MASK;

    uint32_t sw_value = 0;
    uint32_t gpio_output_value = 0;
    uint32_t gpio_input_value = 0;
    
    while (1){
        // Get SW0-3 Value
        gpio_input_value  = GPIO_REG(GPIO_INPUT_VAL);
        sw_value          = (gpio_input_value & TERASIC_SW_MASK)>>4;

        // Set LED0-3 Value
        gpio_output_value = GPIO_REG(GPIO_OUTPUT_VAL);
        gpio_output_value = gpio_output_value & (~TERASIC_LED_MASK) | (sw_value<<0);
        GPIO_REG(GPIO_OUTPUT_VAL)=gpio_output_value;
    }    
}