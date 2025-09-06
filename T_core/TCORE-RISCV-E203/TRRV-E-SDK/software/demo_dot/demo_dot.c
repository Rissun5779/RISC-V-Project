#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdatomic.h>
#include <encoding.h>
#include <platform.h>

#define CONST_I 32
#define CONST_J 32
#define CONST_K 64

#define A_ROW CONST_I
#define A_COL CONST_K

#define B_ROW CONST_K
#define B_COL CONST_J

#define RES_ROW CONST_I
#define RES_COL CONST_J

void uart_init()
{
    GPIO_REG(GPIO_IOF_EN) |= IOF0_UART0_MASK;
    GPIO_REG(GPIO_IOF_SEL) &= ~IOF0_UART0_MASK;

    UART0_REG(UART_REG_DIV) = 138;
    UART0_REG(UART_REG_TXCTRL) |= UART_TXEN;
    UART0_REG(UART_REG_RXCTRL) |= UART_RXEN;
}

int main(int argc, char *argv[])
{
    uart_init();

    int i = 0;
    int j = 0;
    int k = 0;
    int reg = 0;
    int incr = 4;

    // malloc and init matrixs
    printf("Malloc and initial Matrixs!!\n\n");

    // matrix stored as an array of size row*column
    int *a = NULL;
    int *b = NULL;
    int *no_dot_res = NULL;
    int *dot_res = NULL;

    a = (int *)malloc(A_ROW * A_COL * sizeof(int));
    b = (int *)malloc(B_ROW * B_COL * sizeof(int));
    no_dot_res = (int *)malloc(RES_ROW * RES_COL * sizeof(int));
    dot_res = (int *)malloc(RES_ROW * RES_COL * sizeof(int));

    // init matrix A
    for (i = 0; i < A_ROW; ++i)
    {
        for (j = 0; j < A_COL; ++j)
        {
            a[i * A_COL + j] = i * A_COL + j;
        }
    }

    // init matrix B
    for (i = 0; i < B_ROW; ++i)
    {
        for (j = 0; j < B_COL; ++j)
        {
            b[i * B_COL + j] = i * B_COL + j;
        }
    }

    // init matrix dot_res, no_dot_res
    for (i = 0; i < RES_ROW; ++i)
    {
        for (j = 0; j < RES_COL; ++j)
        {
            no_dot_res[i * RES_COL + j] = 0;
            dot_res[i * RES_COL + j] = 0;
        }
    }

    // no dot inst tile matrix multipication
    printf("Matrix multiplication without using custom DOT inst:\n");

    unsigned int no_dot_instret_start = get_instret_value();
    unsigned int no_dot_cycle_start = get_cycle_value();
    unsigned int no_dot_timer_start = get_timer_value();

    for (i = 0; i < RES_ROW; ++i)
    {
        for (j = 0; j < RES_COL; ++j)
        {
            for (k = 0; k < CONST_K; ++k)
            {
                no_dot_res[i * RES_COL + j] += a[i * A_COL + k] * b[k * B_COL + j];
            }
        }
    }

    unsigned int no_dot_timer_cost = get_timer_value() - no_dot_timer_start;
    unsigned int no_dot_cycle_cost = get_cycle_value() - no_dot_cycle_start;
    unsigned int no_dot_instret_cost = get_instret_value() - no_dot_instret_start;

    printf("not_dot time cost: %0.2fms\n", (float)no_dot_timer_cost / RTC_FREQ * 1000);
    printf("not_dot_cycle: %u\n", no_dot_cycle_cost);
    printf("not_dot_instret: %u\n", no_dot_instret_cost);
    printf("not_dot CPI: %.2f\n", (float)no_dot_cycle_cost / no_dot_instret_cost);

    // dot inst
    printf("Matrix MUL with custom DOT inst: \n");

    unsigned int dot_instret_start = get_instret_value();
    unsigned int dot_cycle_start = get_cycle_value();
    unsigned int dot_timer_start = get_timer_value();

    for (i = 0; i < RES_ROW; ++i)
    {
        for (j = 0; j < RES_ROW; ++j)
        {
            for (k = 0; k < CONST_K; k += incr)
            {
                /* our inline asm first load value to the register x10~x17,
                   [x10 x11 x12 x13]*[x14 x15 x16 x17]=x10*x14+x11*x15+x12*x16+x13*x17;
                */

                asm volatile(
                    "lw x10, %[a0]\t\n"
                    "lw x11, %[a1]\t\n"
                    "lw x12, %[a2]\t\n"
                    "lw x13, %[a3]\t\n"
                    "lw x14, %[a4]\t\n"
                    "lw x15, %[a5]\t\n"
                    "lw x16, %[a6]\t\n"
                    "lw x17, %[a7]\t\n"
                    "dot %[output], x12, x13\t\n"
                    : [output] "=r"(reg)
                    : [a0] "m"(a[i * A_COL + (k + 0)]), [a1] "m"(a[i * A_COL + (k + 1)]), [a2] "m"(a[i * A_COL + (k + 2)]), [a3] "m"(a[i * A_COL + (k + 3)]), [a4] "m"(b[(k + 0) * B_COL + j]), [a5] "m"(b[(k + 1) * B_COL + j]), [a6] "m"(b[(k + 2) * B_COL + j]), [a7] "m"(b[(k + 3) * B_COL + j])
                    : "x10", "x11", "x12", "x13",
                      "x14", "x15", "x16", "x17");

                dot_res[i * RES_COL + j] += reg;
            }
        }
    }

    unsigned int dot_timer_cost = get_timer_value() - dot_timer_start;
    unsigned int dot_cycle_cost = get_cycle_value() - dot_cycle_start;
    unsigned int dot_instret_cost = get_instret_value() - dot_instret_start;

    printf("not_dot time cost: %0.2fms\n", (float)dot_timer_cost / RTC_FREQ * 1000);
    printf("not_dot_cycle: %u\n", dot_cycle_cost);
    printf("not_dot_instret: %u\n", dot_instret_cost);
    printf("not_dot CPI: %.2f\n", (float)dot_cycle_cost / no_dot_instret_cost);

    // verify the no_dot_res and dot_res array are equal
    printf("Matrix MUL result verification: \n");
    int verifyRes = 1;

    for (i = 0; i < RES_ROW * RES_COL; ++i)
    {
        if (dot_res[i] != no_dot_res[i])
        {
            verifyRes = 0;
            break;
        }
    }

    if (verifyRes)
        printf("Pass!\n\n");
    else
        printf("Fail!\n\n");

    printf("Ratio of timer: %.2f\n", (float)no_dot_timer_cost / dot_timer_cost);
    printf("Ratio of cycle: %.2f\n", (float)no_dot_cycle_cost / dot_cycle_cost);
    printf("Ratio of instret(retired instruction): %.2f\n", (float)no_dot_instret_cost / dot_instret_cost);

    // free matrix
    free(a);
    free(b);
    free(no_dot_res);
    free(dot_res);
    return 0;
}