/**
 * =====================================================================================
 *
 * Filename:  my_fft_project.c
 *
 * Description:  DEBUGGING VERSION.
 * This version replaces the complex sine wave generation with a simple
 * impulse signal to test if the rest of the system (FFT, memory, printing)
 * works correctly, bypassing the heavy soft-float `sinf()` function.
 *
 * =====================================================================================
 */

#include <stdint.h>
#include <math.h>
#include <encoding.h>
#include "platform.h"

#include "riscv_dsp_transform_math.h"
#include "riscv_dsp_complex_math.h"

// --- 專案設定 ---
#define FFT_SIZE         256
#define FFT_LOGN         8
#define SAMPLING_RATE    1000

#ifndef PI
#define PI 3.1415926535f
#endif

// --- 全域變數 ---
static float32_t signal_buffer[FFT_SIZE];
static float32_t magnitude[FFT_SIZE / 2];

// =================================================================
// UART 相關的輔助函式
// =================================================================
static void uart_tx(char c) {
    while (((UART0_REG(UART_REG_TXFIFO) >> 31) & 1) == 1);
    UART0_REG(UART_REG_TXFIFO) = c;
}

static void uart_print(const char *s) {
    while (*s != '\0') {
        uart_tx(*s++);
    }
}

void demo_uart_init() {
    GPIO_REG(GPIO_IOF_EN) |= IOF0_UART0_MASK;
    GPIO_REG(GPIO_IOF_SEL) &= ~IOF0_UART0_MASK;
    UART0_REG(UART_REG_DIV) = 138;
    UART0_REG(UART_REG_TXCTRL) |= UART_TXEN;
    UART0_REG(UART_REG_RXCTRL) |= UART_RXEN;
}

void uart_print_int(long long n) {
    if (n < 0) {
        uart_tx('-');
        n = -n;
    }
    if (n == 0) {
        uart_tx('0');
        return;
    }
    char buf[20];
    int i = 0;
    while (n > 0) {
        buf[i++] = (n % 10) + '0';
        n /= 10;
    }
    while (i > 0) {
        uart_tx(buf[--i]);
    }
}

// =================================================================
// 主程式 Main Function
// =================================================================
int main(void)
{
    demo_uart_init();
    uart_print("\n\r--- RISC-V DSP FFT Debug Test (Impulse Input) ---\n\r");

    // --- 產生測試訊號 (⭐️ 關鍵修改處 ⭐️) ---
    uart_print("1. Generating test signal (IMPULSE)...\n\r");

    // 步驟 A: 先將所有訊號清零
    for (int i = 0; i < FFT_SIZE; i++) {
        signal_buffer[i] = 0.0f;
    }
    
    // 步驟 B: 只在某個點上給一個非零值，形成一個脈衝
    signal_buffer[5] = 100.0f; 

    /*
    // 將原本的正弦波產生迴圈完整註解掉
    for (int i = 0; i < FFT_SIZE; i++) {
        float32_t time_sec = (float32_t)i / SAMPLING_RATE;
        signal_buffer[i] = 1.0f * sinf(2.0f * PI * 60.0f * time_sec) + 
                           0.5f * sinf(2.0f * PI * 150.0f * time_sec);
    }
    */
    
    // --- 後續的程式碼完全保持不變 ---
    
    uint64_t cycle_start, cycle_end, instret_start, instret_end;
    uint64_t cycle_cost, instret_cost;

    uart_print("2. Running RFFT Calculation...\n\r");
    
    cycle_start = get_cycle_value();
    instret_start = get_instret_value();

    riscv_dsp_rfft_f32(signal_buffer, FFT_LOGN);

    cycle_end = get_cycle_value();
    instret_end = get_instret_value();

    cycle_cost = cycle_end - cycle_start;
    instret_cost = instret_end - instret_start;
    
    uart_print("3. Calculating magnitude...\n\r");
    riscv_dsp_cmag_f32(signal_buffer, magnitude, FFT_SIZE / 2);

    uart_print("4. Finding peak frequency...\n\r");
    float32_t max_magnitude = 0.0f;
    uint32_t max_magnitude_index = 0;
    for (uint32_t i = 1; i < FFT_SIZE / 2; i++) {
        if (magnitude[i] > max_magnitude) {
            max_magnitude = magnitude[i];
            max_magnitude_index = i;
        }
    }
    float32_t dominant_frequency = (float32_t)max_magnitude_index * SAMPLING_RATE / FFT_SIZE;
    
    uart_print("\n\r--- PERFORMANCE ---\n\r");
    uart_print("Total Cycles: ");
    uart_print_int(cycle_cost);
    uart_print("\n\r");
    
    uart_print("Total Instructions: ");
    uart_print_int(instret_cost);
    uart_print("\n\r");
    
    if (instret_cost > 0) {
        uint32_t cpi_times_100 = (uint32_t)(cycle_cost * 100 / instret_cost);
        uart_print("CPI (*100): ");
        uart_print_int(cpi_times_100);
        uart_print("\n\r");
    }
    uart_print("-------------------\n\r");

    uart_print("\n\r--- FUNCTIONALITY ---\n\r");
    uart_print("Peak found at index: ");
    uart_print_int(max_magnitude_index);
    uart_print("\n\r");
    uart_print("Dominant Frequency is approx: ");
    uart_print_int((int)dominant_frequency);
    uart_print(" Hz\n\r");
    uart_print("---------------------\n\r");

    while(1);

    return 0;
}