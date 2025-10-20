/**
 * =====================================================================================
 *
 * Filename:  my_fft_project_advanced.c
 *
 * Description:  Advanced Bare-Metal RISC-V FFT Test.
 * This version generates a complex signal (Sine + Sinc + Noise) to serve as a
 * benchmark for future hardware FPU acceleration.
 * NOTE: This code is computationally intensive and is expected to perform poorly
 * or potentially crash on a soft-float implementation.
 *
 * =====================================================================================
 */

#include <stdint.h>
#include <math.h>
#include <stdlib.h> // 為了使用 rand()
#include <encoding.h>
#include "platform.h"

// 引用 Andes DSP 函式庫的標頭檔
#include "riscv_dsp_transform_math.h"
#include "riscv_dsp_complex_math.h"

// --- 專案設定 ---
#define FFT_SIZE         256
#define FFT_LOGN         8
#define SAMPLING_RATE    1000
#define NOISE_LEVEL      0.2f // 雜訊強度

#ifndef PI
#define PI 3.1415926535f
#endif

// --- 全域變數 ---
// 使用 static 將大型陣列放置在靜態儲存區，避免堆疊溢位
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
// 新增的訊號產生輔助函式
// =================================================================
/**
 * @brief Custom single-precision sinc function. sinc(x) = sin(PI*x) / (PI*x).
 */
float32_t sincf(float32_t x) {
    if (x == 0.0f) {
        return 1.0f;
    }
    float32_t pix = PI * x;
    return sinf(pix) / pix;
}

/**
 * @brief Generates a random float between -1.0 and 1.0 using stdlib rand().
 */
float32_t rand_float() {
    return ((float32_t)rand() / (RAND_MAX / 2.0f)) - 1.0f;
}


// =================================================================
// 主程式 Main Function
// =================================================================
int main(void)
{
    // 1. 初始化
    demo_uart_init();
    // 使用 srand(0) 來確保每次執行產生的隨機雜訊都一樣，方便對比
    srand(0); 
    uart_print("\n\r--- RISC-V DSP FFT Advanced Test ---\n\r");

    // 2. 產生更複雜的測試訊號
    uart_print("1. Generating complex signal (Sine + Sinc + Noise)...\n\r");

    for (int i = 0; i < FFT_SIZE; i++) {
        float32_t time_sec = (float32_t)i / SAMPLING_RATE;
        
        float32_t component_sine = 1.0f * sinf(2.0f * PI * 50.0f * time_sec);
        float32_t sinc_time = (float32_t)i - (FFT_SIZE / 2.0f);
        float32_t component_sinc = 2.0f * sincf(sinc_time / 10.0f);
        float32_t component_noise = NOISE_LEVEL * rand_float();
        
        signal_buffer[i] = component_sine + component_sinc + component_noise;
    }
    
    // 3. 準備效能計數器
    uint64_t cycle_start, cycle_end, instret_start, instret_end;
    uint64_t cycle_cost, instret_cost;

    // 4. 執行 FFT 並測量效能
    uart_print("2. Running RFFT Calculation...\n\r");
    
    cycle_start = get_cycle_value();
    instret_start = get_instret_value();

    riscv_dsp_rfft_f32(signal_buffer, FFT_LOGN);

    cycle_end = get_cycle_value();
    instret_end = get_instret_value();

    cycle_cost = cycle_end - cycle_start;
    instret_cost = instret_end - instret_start;
    
    // 5. 計算頻譜幅度
    uart_print("3. Calculating magnitude...\n\r");
    riscv_dsp_cmag_f32(signal_buffer, magnitude, FFT_SIZE / 2);

    // 6. 找出峰值
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
    
    // 7. 輸出所有結果
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

    // 程式結束，進入無窮迴圈
    while(1);

    return 0;
}