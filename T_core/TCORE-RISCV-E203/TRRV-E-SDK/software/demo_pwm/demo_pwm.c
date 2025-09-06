#include <platform.h>
#include <stdio.h>

void pwm_gpio_init(void)
{
    /* Config PWM0 IO */
    GPIO_REG(GPIO_IOF_EN) |= IOF1_PWM0_MASK;
    GPIO_REG(GPIO_IOF_SEL) |= IOF1_PWM0_MASK;
}

void pwm_controller_init(void)
{
    // set pwm deglitch, enalways, zerocmp bits
    PWM0_REG(PWM_CFG) = (PWM_CFG_DEGLITCH | PWM_CFG_ENALWAYS | PWM_CFG_ZEROCMP);

    // pwm LBS increment at 488.3Hz about 2ms
    // set pwm_count value
    PWM0_REG(PWM_COUNT) = 0;

    // set pwm_cmp0-3 value
    PWM0_REG(PWM_CMP0) = 9;
    PWM0_REG(PWM_CMP1) = 0;
    PWM0_REG(PWM_CMP2) = 0;
    PWM0_REG(PWM_CMP3) = 0;
}

void delay(int s)
{
    volatile int i = s * 1000;
    while (i--)
    {
    };
}

void set_pwm_cmp123(int cmp)
{
    PWM0_REG(PWM_CMP1) = cmp;
    PWM0_REG(PWM_CMP2) = cmp;
    PWM0_REG(PWM_CMP3) = cmp;
}

int main(void)
{
    // init pwm gpio
    pwm_gpio_init();

    // init pwm controller
    pwm_controller_init();

    // define cmp value for breathing light
    volatile int cmp_value[21] =
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};

    int time = 500;
    while (1)
    {
        // set cmp 0-3 value
        for (int i = 0; i < 21; ++i)
        {
            set_pwm_cmp123(cmp_value[i]);
            delay(time);
        }
    }
}