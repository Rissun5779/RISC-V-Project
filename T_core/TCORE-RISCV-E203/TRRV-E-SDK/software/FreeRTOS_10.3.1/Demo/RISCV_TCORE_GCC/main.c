/* kernel include */
#include "FreeRTOS.h"
#include "FreeRTOSConfig.h"
#include "task.h"
#include "timers.h"
#include "semphr.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "platform.h"
#include "encoding.h"
#include "plic_driver.h"

#define TERASIC_LED_MASK 0x0000000F
#define LED0_GPIO_OFFSET 0
#define LED1_GPIO_OFFSET 1
#define LED2_GPIO_OFFSET 2
#define LED3_GPIO_OFFSET 3

TaskHandle_t Task1_Handler;
TaskHandle_t Task2_Handler;

void delay(int s)
{
    volatile int time = s * 1000;
    while (time--)
        ;
}

static void prvTask1(void *pvParameters)
{
    for (;;)
    {
        printf("do Task1: priority is %d\n", uxTaskPriorityGet(Task1_Handler));
        GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << LED0_GPIO_OFFSET);
        delay(500);
        GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << LED0_GPIO_OFFSET);
        delay(500);
    }
}

static void prvTask2(void *pvParameters)
{
    int task2_count = 0;
    for (;;)
    {
        task2_count++;
        printf("do Task2: priority is %d\n", uxTaskPriorityGet(Task2_Handler));
        GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << LED1_GPIO_OFFSET);
        delay(500);
        GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << LED1_GPIO_OFFSET);
        delay(500);
        printf("Task2 count:%d\n", task2_count);

        if (task2_count == 5)
        {
            vTaskDelay(3000 / portTICK_PERIOD_MS);
            task2_count = 0;
        }
    }
}

void led_init()
{
    GPIO_REG(GPIO_OUTPUT_EN) |= TERASIC_LED_MASK;
    GPIO_REG(GPIO_OUTPUT_VAL) &= ~TERASIC_LED_MASK;
}

static void prvSetupHardware(void)
{
    led_init();
}

void vApplicationTickHook(void)
{
    BaseType_t xHigherpriorityTaskWoken = pdFAIL;
    static uint32_t ulcount = 0;

    ulcount++;
    if (ulcount >= 500UL)
    {
        ulcount = 0UL;
        GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << LED2_GPIO_OFFSET);
    }
}

void vApplicationMallocFailedHook(void)
{
    write(1, "malloc failed\n", 14);
    for (;;)
        ;
}

extern UBaseType_t uxCriticalNesting;
void vApplicationIdleHook(void)
{
    volatile size_t xFreeStackSpace;

    xFreeStackSpace = xPortGetFreeHeapSize();
    if (xFreeStackSpace > 100)
    {
    }
}

int main(void)
{
    prvSetupHardware();
    xTaskCreate(
        prvTask1,
        (const char *)"Task1",
        configMINIMAL_STACK_SIZE,
        NULL,
        tskIDLE_PRIORITY + 1,
        &Task1_Handler);
    xTaskCreate(
        prvTask2,
        (const char *)"Task2",
        configMINIMAL_STACK_SIZE,
        NULL,
        tskIDLE_PRIORITY + 2,
        &Task2_Handler);

    vTaskStartScheduler();
}
