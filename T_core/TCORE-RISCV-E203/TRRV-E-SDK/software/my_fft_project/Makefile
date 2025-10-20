# =================================================================
# === Final Makefile for my_fft_project ===
# =================================================================

# 1. 定義目標執行檔的名稱
TARGET = my_fft_project

# 2. 設定編譯旗標 (Compiler Flags)
#    -O1: 優化等級
#    -DPURE_C: 告訴 libdsp 編譯純 C 版本
#    -I...: 指定標頭檔 (.h) 的搜尋路徑
CFLAGS += -O1 -DPURE_C -I../libraries/libdsp/include -I../libraries/libdsp/internal

# 3. 設定連結時需要額外加入的函式庫 (Libraries)
#    -lm: 連結標準數學函式庫 (libm.a)，提供 sinf, sqrtf 等
LDFLAGS += -lm

# 4. 指定 BSP (硬體設定檔) 的基礎路徑
BSP_BASE = ../../bsp

# 5. 定義所有需要編譯的 C 原始碼檔案 (.c)
C_SRCS += my_fft_project.c \
  ../libraries/libdsp/transform/riscv_dsp_rfft_f32.c \
  ../libraries/libdsp/transform/riscv_dsp_cfft_f32.c \
  ../libraries/libdsp/complex/riscv_dsp_cmag_f32.c \
  ../libraries/libdsp/utils/riscv_dsp_cos_f32.c \
  ../libraries/libdsp/utils/riscv_dsp_sin_f32.c \
  ../libraries/libdsp/utils/riscv_dsp_sqrt_f32.c \
  ../libraries/libdsp/transform/riscv_dsp_cfft_rd2_f32.c \
  ../libraries/libdsp/transform/riscv_dsp_cfft_rd4_f32.c \
  ../libraries/libdsp/utils/table/riscv_dsp_cos_table_f32_1024.c

# 6. 載入 SDK 提供的主要編譯規則 (魔法所在，務必保留)
include $(BSP_BASE)/tcore-e203/env/common.mk
