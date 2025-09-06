#define configRTC_CLOCK_HZ 32768
#define configCPU_CLOCK_HZ 50000000UL

#define INCLUDE_uxTaskPriorityGet 1
#define INCLUDE_vTaskDelay 1

#define configUSE_16_BIT_TICKS 0
#define configUSE_PREEMPTION 1

#define configMAX_PRIORITIES 3
#define configTICK_RATE_HZ 80
#define configMINIMAL_STACK_SIZE 450

/* Memory allocation related definitions. */
#define configSUPPORT_DYNAMIC_ALLOCATION 1
#define configTOTAL_HEAP_SIZE 11 * 1024

/* Hook function related definitions. */
#define configUSE_IDLE_HOOK 1
#define configUSE_TICK_HOOK 1
#define configUSE_MALLOC_FAILED_HOOK 1

#define configUSE_TIMERS 1
#define configTIMER_TASK_PRIORITY 3
#define configTIMER_QUEUE_LENGTH 5
#define configTIMER_TASK_STACK_DEPTH configMINIMAL_STACK_SIZE

#define INCLUDE_vTaskPrioritySet 1
#define INCLUDE_uxTaskPriorityGet 1
#define INCLUDE_vTaskDelete 1
#define INCLUDE_vTaskSuspend 1
#define INCLUDE_xResumeFromISR 1
#define INCLUDE_vTaskDelayUntil 1
#define INCLUDE_vTaskDelay 1

#define configMTIME_BASE_ADDRESS (0x0200BFF8UL)
#define configMTIMECMP_BASE_ADDRESS (0x02004000UL)
#define configCLINT_BASE_ADDRESS 0x02000000UL
