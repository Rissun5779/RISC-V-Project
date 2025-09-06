TARGET = FreeRTOS_10.3.1
CFLAGS += -Os

BSP_BASE = ../../bsp

C_SRCS += Source/list.c
C_SRCS += Source/queue.c
C_SRCS += Source/tasks.c
C_SRCS += Source/timers.c
C_SRCS += Source/portable/MemMang/heap_4.c
C_SRCS += Source/portable/GCC/T-Core/port.c

C_SRCS += Demo/RISCV_TCORE_GCC/main.c
C_SRCS += $(BSP_BASE)/$(BOARD)/drivers/plic/plic_driver.c

INCLUDES += -ISource/include
INCLUDES += -IDemo/RISCV_TCORE_GCC
INCLUDES += -ISource/portable/GCC/T-Core
INCLUDES += -I/home/rissun57/Desktop/T_core/TCORE-RISCV-E203/TRRV-E-SDK/bsp/tcore-e203/drivers/plic


ASM_SRCS += Source/portable/GCC/T-Core/portasm.S

include $(BSP_BASE)/$(BOARD)/env/common.mk