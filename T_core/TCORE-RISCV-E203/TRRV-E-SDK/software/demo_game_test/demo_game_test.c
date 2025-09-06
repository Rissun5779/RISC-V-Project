#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <plic/plic_driver.h>
#include <platform.h>
#include <encoding.h>

static const char game_start[] =
    "\n\r"
    " ░██████                                                      \n\r"
    " ░██   ░██                                                    \n\r"
    "░██        ░██    ░██  ░███████   ░███████   ░███████         \n\r"
    "░██  █████ ░██    ░██ ░██    ░██ ░██        ░██               \n\r"
    "░██     ██ ░██    ░██ ░█████████  ░███████   ░███████         \n\r"
    " ░██  ░███ ░██   ░███ ░██               ░██        ░██        \n\r"
    "  ░█████░█  ░█████░██  ░███████   ░███████   ░███████  ░██    \n\r"
    "                                                        ░█    \n\r"
    "                                                       ░█     \n\r"
    "                                                              \n\r";

static const char game_over[] =
    "\n\r"
    "            ▗▄▖ ▗▖  ▗▖▗▄▄▄▖▗▄▄▖                                \n\r"
    "           ▐▌ ▐▌▐▌  ▐▌▐▌   ▐▌ ▐▌                                \n\r"
    "           ▐▌ ▐▌▐▌  ▐▌▐▛▀▀▘▐▛▀▚▖                                \n\r"
    "           ▝▚▄▞▘ ▝▚▞▘ ▐▙▄▄▖▐▌ ▐▌                                \n\r";

void uart_init()
{
    // Config UART to print
    GPIO_REG(GPIO_IOF_EN) |= IOF0_UART0_MASK;
    GPIO_REG(GPIO_IOF_SEL) &= IOF0_UART0_MASK;

    // 115200 Baud Rate
    UART0_REG(UART_REG_DIV) = 138;
    UART0_REG(UART_REG_TXCTRL) |= UART_TXEN;
    UART0_REG(UART_REG_RXCTRL) |= UART_RXEN;
}

static void uart_tx(char c)
{
    while (((UART0_REG(UART_REG_TXFIFO) >> 31) & 1) == 1)
    {
    };

    UART0_REG(UART_REG_TXFIFO) = c;
}

static void uart_print(const char *s)
{
    int i = 0;

    while (*s != '\0')
    {
        uart_tx(*s++);
    }
}

int uart_rx(char *c)
{
    uint32_t val = UART0_REG(UART_REG_RXFIFO);

    if ((val >> 31) == 0)
    {
        *c = val & 0xFF;
        return 1;
    }

    return 0;
}

int uart_scan(char *buf)
{
    char c = 0;
    int exit = 0;
    int len = 0;

    while (exit != 1)
    {
        if (uart_rx(&c) == 1)
        {
            if (c == '\r')
            {
                exit = 1;
            }
            else
            {
                buf[len] = c;
                len++;
                uart_tx(c);
            }
        }
    }

    buf[len] = '\0';
    return len;
}

int buf2int(char *buf)
{
    int result = 0;

    while (*buf != '\0')
    {
        if (*buf >= '0' && *buf <= '9')
        {
            result *= 10;
            result += (*buf - '0');
        }
        else
        {
            uart_print("\n\ryour input is error!!");
            return -1;
        }
        buf++;
    }
    return result;
}

/*void handle_m_time_interrupt()
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

    set_csr(mie, MIE_MTIE);
}*/

void timer_init(void)
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
}

int get_random(void)
{
    volatile uint64_t *mtime = (uint64_t *)(CLINT_CTRL_ADDR + CLINT_MTIME);
    uint64_t now = *mtime;
    return (int)(now % 100); // 0~99
}

int main(void)
{
    // Init UART, Timer
    uart_init();
    timer_init();

    while (1)
    {
        // Flush any leftover UART input
        char dummy = {0};
        while (uart_rx(&dummy))
            ;
        uart_print(game_start);

        int input = 222;
        int answer = get_random();
        char buf[20] = {0};

        while (input != answer)
        {
            printf("\n\rEnter your answer is(0-99):\n\r");
            uart_scan(buf);
            uart_print("\n\rYour Input:\n\r");
            uart_print(buf);

            input = buf2int(buf);

            if (input == -1)
            {
                // 已在 buf2int 印錯誤訊息，這裡可以直接 continue
                continue;
            }
            else if (input != answer)
            {
                uart_print("\n\rYour answer is error!!\n\r");
                if (abs(input - answer) < 10)
                {
                    uart_print("Your answer is very closely!!\n\r");
                    if (input > answer)
                    {
                        uart_print("too high!!\n\r");
                    }
                    else
                    {
                        uart_print("too low!\n\r");
                    }
                }
                else if (abs(input - answer) < 30)
                {
                    uart_print("Your answer have some distance.\n\r");
                }
            }
            else
            {
                break; // 答對，跳出迴圈
            }
        }

        uart_print("\n\rYour answer is correct!!");
        uart_print("Thank your participate.\n\r");

        uart_print("\n\r Do you want to play again??(Y/N)");
        uart_scan(buf);

        if (buf[0] != 'Y' && buf[0] != 'y')
        {
            uart_print("\n\rGame over. See you next time!\n\r");
            break;
        }
    }
    uart_print(game_over);
    return 0;
}