// LED0-3: bit 0-3
// SW0-3 : bit 4-7

#define TERASIC_LED_MASK     0x0000000F         // led mask
#define TERASIC_SW_MASK      0x000000F0         // sw mask

#define GPIO_BASE_ADDR       (0x10012000)
#define GPIO_INPUT_VAL_ADDR  (GPIO_BASE_ADDR+0x00) // gpio base addr 
#define GPIO_INPUT_EN_ADDR   (GPIO_BASE_ADDR+0x04) // gpio input_value register addr 
#define GPIO_OUTPUT_EN_ADDR  (GPIO_BASE_ADDR+0x08) // gpio input enable register addr
#define GPIO_OUTPUT_VAL_ADDR (GPIO_BASE_ADDR+0x0c) // gpio output_value register addr

int main(void){
    // set led0-3 output
    *(volatile unsigned int *)(GPIO_OUTPUT_EN_ADDR) |= TERASIC_LED_MASK;

    // set se0-3 output
    *(volatile unsigned int *)(GPIO_INPUT_EN_ADDR) |= TERASIC_SW_MASK;

    unsigned int sw_value=0;
    unsigned int gpio_output_value=0;
    unsigned int gpio_input_value=0;

    while(1){
        // Get SW0-3 value
        gpio_input_value = *(volatile unsigned int *)(GPIO_INPUT_VAL_ADDR);
        sw_value = (gpio_input_value&TERASIC_SW_MASK)>>4;

        // Set LED0-3 value
        gpio_output_value = *(volatile unsigned int *)(GPIO_OUTPUT_VAL_ADDR);
        gpio_output_value = gpio_output_value & (~TERASIC_LED_MASK) | (sw_value<<0);
        *(volatile unsigned  int *)(GPIO_OUTPUT_VAL_ADDR) = gpio_output_value;
    }
}