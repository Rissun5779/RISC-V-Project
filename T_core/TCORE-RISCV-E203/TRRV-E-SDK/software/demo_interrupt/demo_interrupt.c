#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include <string.h>
#include "plic/plic_driver.h"
#include "encoding.h"
#include <unistd.h>
#include "stdatomic.h"

// LED0-3: bit 0-3
// SW0-3 : bit 4-7
// KEY0-1: bit 8-9
#define TERASIC_LED_MASK 0x0000000F  // led mask
#define TERASIC_SW01_MASK 0x00000030 // SW  mask
#define TERASIC_KEY_MASK 0x00000300  // Key mask, key0 use for reset

#define PLIC_INI_DEVICE_KEY_1 (PLIC_INI_GPIO_BASE + KEY_1_GPIO_OFFSET)

// PLIC (Platform Level Interrupt Controller)
// It used to Interrupt sources priority level arbitration, and generator a interrupt signal
// for RISC-V core.
// In theory, PLIC can be support 1024 external interrupt sources, but specifically not msut.
// In T core riscv core, it support :
// 0                    no interrupt
// 1                    wdogcmp(Watchdog Compare Register) 防止系統「當機不動」。
//                      它會在指定時間內要求程式「重設它」（kick/feed the dog），否則就會觸發 系統重啟 或 中斷
// 2                    rtccmp( Real-Time Clock Compare Register)
//                      當 RTC 計時器值（mtime） 遞增到與 rtccmp 設定值相等時，產生 軟體中斷（timer interrupt）
// 3,4                  uart0, 1   UART 接收資料 → 觸發 RX 中斷 → CPU 中斷服務函數(ISR)被呼叫 → 從 UART 緩衝區讀取資料 → 處理資料
// 5-7                  qspi0-qspi2 QSPI 控制器通常會有中斷來通知, 傳輸完成, 錯誤發生, 緩衝區狀態改變
// 8-39                 gpio0-gpio37
// 40-43                pwm0cmp0-pwm0cmp3
// 44-47                pwm1cpm0-pwm1cmp3
// 48-51                pwm2cmp0-pwm2cmp3
// 52                   i2c     常見的 兩線式串列通訊協定，設計用來讓多個 IC（晶片）彼此通信

// PLIC Register
// PLIC Register it is used to store Register mapping module
// addr                 name                         default Reset value
// 0x0C00_0004          Source 1 priority            0x0
// 0x0C00_0008          Source 2 priority            0x0
// .............
// 0x0C00_0FFC          Source 1023 ''               0x0
// .............
// 0x0C00_1000          Start of pending array       0x0
// .............
// 0x0C00_107C          End   of pending array       0x0
// .............
// 0x0C00_2000          Target 0 enables             0x0
// .............
// 0x0C20_0000          Target 0 priority thereshold 0x0
// 0x0C20_0004          Target 0 claim/complete      0x0

// interrupt register
// mtvec
// if MODE=0, => BASE , PC
// if MODE=1, => BASE+4*CAUSE.PC
// mcause
//
// mepc
// can R/W, if interrupt => interrupt return address mepc = next inst
//          if abnormal  => mepc = (abnomal) inst
// mstatus
// The status register in machine mode, including many different functions areas
// MIE area = global interrupt enable
//      if (MIE=1) => All interrupt global on
//      else       => ''                   off
// 進入中斷時，MIE 會自動清除，處理完要用 mret 回復
// mie
//

// Structures for registering different interrupt handlers
// for different parts of the application
typedef void (*function_ptr_t)(void);
function_ptr_t g_ext_interrupt_handlers[PLIC_NUM_INTERRUPTS];

// do nothing interrupt handler
void no_interrupt_handler(void) {};

// Instance data for the PLIC
plic_instance_t g_plic;

/*typedef struct __plic_instance_t
{
    uintptr_t base_addr;
    uint32_t  num_sources;
    uint32_t  num_priorities;
}plic_instance_t;*/

// blinking led direction flag
volatile int led_mode = 0;
volatile uint8_t led_value = 0x1;
volatile uint32_t gpio_value = 0;

void handle_m_ext_interrupt()
{
    // get interrupt number
    plic_source int_num = PLIC_claim_interrupt(&g_plic);

    if ((int_num >= 1) && (int_num <= PLIC_NUM_INTERRUPTS))
    {
        g_ext_interrupt_handlers[int_num](); // run interrupt service
    }
    else
    {
        exit(1 + (uintptr_t)int_num);
    }

    // interrupt complete
    PLIC_complete_interrupt(&g_plic, int_num);
}

void key1_irq_handler(void)
{
    // Read SW[1:0] value to set led show mode
    led_mode = (GPIO_REG(GPIO_INPUT_VAL) & TERASIC_SW01_MASK) >> 4;

    // set default value
    led_value = 0x1;

    // Clear the GPIO Pending interrupt by writting 1.
    GPIO_REG(GPIO_RISE_IP) |= (0x1 << KEY_1_GPIO_OFFSET);
}

#define PLIC_INT_DEVICE_KEY_1 (PLIC_INT_GPIO_BASE + KEY_1_GPIO_OFFSET)

void register_plic_irqs()
{
    // init plic
    PLIC_init(&g_plic, PLIC_CTRL_ADDR, PLIC_NUM_INTERRUPTS, PLIC_NUM_PRIORITIES);

    // init interrupt handlers as null
    for (int i = 0; i < PLIC_NUM_INTERRUPTS; ++i)
    {
        g_ext_interrupt_handlers[i] = no_interrupt_handler;
    }

    // to enable KEY1. must enable WDOGCMP first
    PLIC_enable_interrupt(&g_plic, PLIC_INT_WDOGCMP);
    PLIC_set_priority(&g_plic, PLIC_INT_WDOGCMP, 1);

    g_ext_interrupt_handlers[PLIC_INT_DEVICE_KEY_1] = key1_irq_handler;

    // Have to enable the interrupt both at the GPIO level and PLIC level.
    PLIC_enable_interrupt(&g_plic, PLIC_INT_DEVICE_KEY_1);

    // Priority must to be set >0
    PLIC_set_priority(&g_plic, PLIC_INT_DEVICE_KEY_1, 1);
}

void gpio_init()
{
    // Set LED0-3 Output
    GPIO_REG(GPIO_OUTPUT_EN) |= TERASIC_LED_MASK;

    // Set KEY0-1 input
    GPIO_REG(GPIO_INPUT_EN) |= TERASIC_KEY_MASK;

    // Set SW0-1 input
    GPIO_REG(GPIO_INPUT_EN) |= TERASIC_SW01_MASK;
}

void interrupt_init()
{
    // Enable KEY1 Interrupt
    GPIO_REG(GPIO_RISE_IE) |= (0x1 << KEY_1_GPIO_OFFSET);

    // clear external interrupt
    clear_csr(mie, MIE_MEIE);

    // init external interrupt
    register_plic_irqs();

    // Enable external interrupt and global interrupt
    set_csr(mie, MIE_MEIE);
    set_csr(mstatus, MSTATUS_MIE);
}

void delay(int s)
{
    volatile int i = s * 1000;
    while (i--)
        ;
}

void led_show_mode0()
{
    // 0001->0010->0100->1000, left loop
    if (led_value != 0x08)
    {
        led_value = led_value << 1;
    }
    else
    {
        led_value = 0x01;
    }
}

void led_show_mode1()
{
    // led 1000->0100->0010->0001, right loop
    if (led_value != 0x01)
    {
        led_value = led_value >> 1;
    }
    else
    {
        led_value = 0x08;
    }
}

void led_show_mode2()
{
    // led 0001->0011->0111->1111->1110->1100->1000->0000->0001, left
    if ((led_value & 0x1) && (led_value != 0xf))
    {
        led_value = ((led_value << 1) + 1) & 0xf;
    }
    else if (led_value & 0x8)
    {
        led_value = (led_value << 1) & 0xf;
    }
    else
    {
        led_value = 0x1;
    }
}

void led_show_mode3()
{
    // led 1000->1100->1110->1111->0111->0011->0001->0000->1000, right
    if ((led_value & 0x8) && (led_value != 0xf))
    {
        led_value = ((led_value >> 1) + 0x8) & 0xf;
    }
    else if (led_value & 0x1)
    {
        led_value = (led_value >> 1) & 0xf;
    }
    else
    {
        led_value = 0x8;
    }
}

void update_led_value()
{
    // update gpio_value
    gpio_value |= (uint32_t)(led_value << 0) & TERASIC_LED_MASK;

    // set gpio reg
    GPIO_REG(GPIO_OUTPUT_VAL) = (GPIO_REG(GPIO_OUTPUT_VAL) & (~TERASIC_LED_MASK)) | gpio_value;

    // clear gpio_value after setting gpio reg
    gpio_value = 0;
}

int main(int argc, char **argv)
{
    // configure gpio
    gpio_init();

    // initialize interrupt
    interrupt_init();

    // start blinking led
    led_mode = (GPIO_REG(GPIO_INPUT_VAL) & TERASIC_SW01_MASK) >> 4; // init mode
    led_value = 0x1;

    while (1)
    {
        switch (led_mode)
        {
        case 0:
            led_show_mode0();
            break;
        case 1:
            led_show_mode1();
            break;
        case 2:
            led_show_mode2();
            break;
        case 3:
            led_show_mode3();
        default:
            break;
        }

        // update led's value
        update_led_value();

        // delay
        delay(1000);
    }
    return 0;
}