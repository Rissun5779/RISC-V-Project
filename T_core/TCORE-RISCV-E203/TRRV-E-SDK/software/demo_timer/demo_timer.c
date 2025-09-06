#include <platform.h>
#include <plic/plic_driver.h>
#include <encoding.h>

#define TERASIC_LED_MASK 0x0000000F

void gpio_init()
{
    // set LED0-3 output
    GPIO_REG(GPIO_OUTPUT_EN) |= TERASIC_LED_MASK;

    // set led default value 0
    GPIO_REG(GPIO_OUTPUT_VAL) &= ~TERASIC_LED_MASK;
}

void handle_m_time_interrupt()
{
    // disable timer interrupt
    clear_csr(mie, MIE_MTIE);

    // Reset the timer for 1s int the future
    // This also clears the existing timer interrupt
    volatile uint64_t *mtime = (uint64_t *)(CLINT_CTRL_ADDR + CLINT_MTIME);
    volatile uint64_t *mtimecmp = (uint64_t *)(CLINT_CTRL_ADDR + CLINT_MTIMECMP);

    uint64_t now = *mtime;
    uint64_t then = now + 1 * RTC_FREQ;
    *mtimecmp = then;

    GPIO_REG(GPIO_OUTPUT_VAL) ^= (TERASIC_LED_MASK);
    set_csr(mie, MIE_MTIE);
}

void timer_init()
{
    // disable timer intterupt
    clear_csr(mie, MIE_MTIE);

    // set up timer
    // set up machine timer to go off in 1 sec
    volatile uint64_t *mtime = (uint64_t *)(CLINT_CTRL_ADDR + CLINT_MTIME);
    volatile uint64_t *mtimecmp = (uint64_t *)(CLINT_CTRL_ADDR + CLINT_MTIMECMP);

    uint64_t now = *mtime;
    uint64_t then = now + 1 * RTC_FREQ;
    *mtimecmp = then;

    // enable timer interrupt
    set_csr(mie, MIE_MTIE);

    // enable global interrupt
    set_csr(mstatus, MSTATUS_MIE);
}

int main(int argc, char **argv)
{
    // init led
    gpio_init();

    // init timer
    timer_init();

    while (1)
        ;
    return 0;
}