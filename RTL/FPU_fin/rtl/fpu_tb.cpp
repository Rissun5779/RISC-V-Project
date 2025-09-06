#include <iostream>
#include <iomanip>
#include <string>
#include <cstring>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vfpu.h"  // 根據您的模組名稱調整

using namespace std;

class FpuTestbench {
private:
    Vfpu* dut;
    VerilatedVcdC* tfp;
    uint64_t sim_time;
    
    // 記憶體模擬
    uint32_t memory[4096];
    
    // 統計變數
    int pass_count;
    int fail_count;
    
public:
    FpuTestbench() {
        dut = new Vfpu;
        tfp = new VerilatedVcdC;
        sim_time = 0;
        pass_count = 0;
        fail_count = 0;
        
        // 初始化 VCD 追蹤
        Verilated::traceEverOn(true);
        dut->trace(tfp, 99);
        tfp->open("build/fpu_comprehensive_tb.vcd");
        
        // 初始化記憶體
        memset(memory, 0, sizeof(memory));
    }
    
    ~FpuTestbench() {
        tfp->close();
        delete dut;
        delete tfp;
    }
    
    void tick() {
        // 模擬記憶體邏輯
        memory_model();
        
        // 時脈週期的前半部分
        dut->clk = 0;
        dut->eval();
        tfp->dump(sim_time);
        sim_time++;
        
        // 時脈週期的後半部分
        dut->clk = 1;
        dut->eval();
        tfp->dump(sim_time);
        sim_time++;
        
        // 狀態監控
        monitor_signals();
    }
    
    void memory_model() {
        static bool prev_rst_n = false;
        
        if (!dut->rst_n) {
            dut->mem_ready = 0;
            dut->mem_rdata = 0;
        } else {
            if (dut->mem_re) {
                uint32_t addr_index = (dut->mem_addr >> 2) & 0xFFF;
                dut->mem_rdata = memory[addr_index];
                dut->mem_ready = 1;
            } else if (dut->mem_we) {
                uint32_t addr_index = (dut->mem_addr >> 2) & 0xFFF;
                memory[addr_index] = dut->mem_wdata;
                dut->mem_ready = 1;
            } else {
                dut->mem_ready = 0;
            }
        }
        prev_rst_n = dut->rst_n;
    }
    
    void monitor_signals() {
        // 在這裡添加信號監控邏輯
        if (dut->completed) {
            cout << "Time: " << sim_time << " | ✓ Operation completed" << endl;
        }
        
        if (dut->freg_wb_enable) {
            cout << "Time: " << sim_time << " | Write-back: freg[" << (int)dut->freg_wb_addr 
                 << "] = 0x" << hex << dut->freg_wb_data << dec << endl;
        }
        
        if (dut->mem_re && dut->mem_ready) {
            cout << "Time: " << sim_time << " | Memory Read: addr=0x" << hex << dut->mem_addr 
                 << ", data=0x" << dut->mem_rdata << dec << endl;
        }
        
        if (dut->mem_we && dut->mem_ready) {
            cout << "Time: " << sim_time << " | Memory Write: addr=0x" << hex << dut->mem_addr 
                 << ", data=0x" << dut->mem_wdata << dec << endl;
        }
    }
    
    void reset_system() {
        cout << "Resetting system..." << endl;
        dut->rst_n = 0;
        dut->enabled = 0;
        clear_instructions();
        
        for (int i = 0; i < 4; i++) tick();
        
        dut->rst_n = 1;
        for (int i = 0; i < 2; i++) tick();
    }
    
    void clear_instructions() {
        dut->instr_flw = 0;
        dut->instr_fsw = 0;
        dut->instr_fadd = 0;
        dut->instr_fdiv = 0;
        dut->instr_fmul = 0;
    }
    
    void wait_cycles(int cycles) {
        for (int i = 0; i < cycles; i++) {
            tick();
        }
    }
    
    void test_flw(uint32_t base_addr, uint32_t offset, uint32_t expected_data, 
                  uint8_t target_reg, const string& test_name) {
        cout << "\n=== Testing FLW: " << test_name << " ===" << endl;
        
        dut->reg_rs1 = base_addr;
        dut->imm = offset;
        dut->frd_addr = target_reg;
        dut->enabled = 1;
        dut->instr_flw = 1;
        
        tick();
        
        clear_instructions();
        dut->enabled = 0;
        
        // 等待完成
        int timeout = 1000;
        while (!dut->completed && timeout > 0) {
            tick();
            timeout--;
        }
        
        if (timeout == 0) {
            cout << "✗ TIMEOUT: FLW operation did not complete" << endl;
            fail_count++;
            return;
        }
        
        if (dut->freg_wb_enable && dut->freg_wb_addr == target_reg && 
            dut->freg_wb_data == expected_data) {
            cout << "✓ PASS: freg[" << (int)dut->freg_wb_addr << "] = 0x" 
                 << hex << dut->freg_wb_data << dec << endl;
            pass_count++;
        } else {
            cout << "✗ FAIL: Expected freg[" << (int)target_reg << "] = 0x" 
                 << hex << expected_data << ", Got freg[" << (int)dut->freg_wb_addr 
                 << "] = 0x" << dut->freg_wb_data << dec << endl;
            fail_count++;
        }
        
        tick();
    }
    
    void test_fsw(uint32_t base_addr, uint32_t offset, uint32_t store_data, 
                  const string& test_name) {
        cout << "\n=== Testing FSW: " << test_name << " ===" << endl;
        
        dut->reg_rs1 = base_addr;
        dut->freg_rs2 = store_data;
        dut->imm = offset;
        dut->enabled = 1;
        dut->instr_fsw = 1;
        
        tick();
        
        clear_instructions();
        dut->enabled = 0;
        
        // 等待完成
        int timeout = 1000;
        while (!dut->completed && timeout > 0) {
            tick();
            timeout--;
        }
        
        if (timeout == 0) {
            cout << "✗ TIMEOUT: FSW operation did not complete" << endl;
            fail_count++;
            return;
        }
        
        // 額外等待幾個週期確保記憶體寫入
        for (int i = 0; i < 2; i++) tick();
        
        uint32_t check_addr = base_addr + offset;
        uint32_t addr_index = (check_addr >> 2) & 0xFFF;
        
        if (memory[addr_index] == store_data) {
            cout << "✓ PASS: Memory[0x" << hex << check_addr << "] = 0x" 
                 << memory[addr_index] << dec << endl;
            pass_count++;
        } else {
            cout << "✗ FAIL: Expected Memory[0x" << hex << check_addr << "] = 0x" 
                 << store_data << ", Got 0x" << memory[addr_index] << dec << endl;
            fail_count++;
        }
    }
    
    void test_fadd(uint32_t op1, uint32_t op2, uint32_t expected_result, 
                   uint8_t target_reg, const string& test_name) {
        cout << "\n=== Testing FADD: " << test_name << " ===" << endl;
        cout << "FADD: 0x" << hex << op1 << " + 0x" << op2 << " -> freg[" 
             << dec << (int)target_reg << "]" << endl;
        
        dut->freg_rs1 = op1;
        dut->freg_rs2 = op2;
        dut->frd_addr = target_reg;
        dut->enabled = 1;
        dut->instr_fadd = 1;
        
        tick();
        
        clear_instructions();
        dut->enabled = 0;
        
        // 等待完成
        int timeout = 1000;
        while (!dut->completed && timeout > 0) {
            tick();
            timeout--;
        }
        
        if (timeout == 0) {
            cout << "✗ TIMEOUT: FADD operation did not complete" << endl;
            fail_count++;
            return;
        }
        
        if (dut->freg_wb_enable && dut->freg_wb_addr == target_reg && 
            dut->freg_wb_data == expected_result) {
            cout << "✓ PASS: freg[" << (int)dut->freg_wb_addr << "] = 0x" 
                 << hex << dut->freg_wb_data << dec << endl;
            pass_count++;
        } else {
            cout << "✗ FAIL: Expected freg[" << (int)target_reg << "] = 0x" 
                 << hex << expected_result << ", Got freg[" << (int)dut->freg_wb_addr 
                 << "] = 0x" << dut->freg_wb_data << dec << endl;
            fail_count++;
        }
        
        tick();
    }
    
    void initialize_memory() {
        // 初始化測試數據到記憶體
        // 基本浮點數
        memory[0x1000 >> 2] = 0x3F800000;  // 1.0
        memory[0x1004 >> 2] = 0x40000000;  // 2.0
        memory[0x1008 >> 2] = 0x40400000;  // 3.0
        memory[0x100C >> 2] = 0x40800000;  // 4.0
        memory[0x1010 >> 2] = 0x40A00000;  // 5.0
        
        // 小數
        memory[0x1014 >> 2] = 0x3F000000;  // 0.5
        memory[0x1018 >> 2] = 0x3E800000;  // 0.25
        memory[0x101C >> 2] = 0x3F400000;  // 0.75
        
        // 負數
        memory[0x1020 >> 2] = 0xBF800000;  // -1.0
        memory[0x1024 >> 2] = 0xC0000000;  // -2.0
        memory[0x1028 >> 2] = 0xC0400000;  // -3.0
        
        // 特殊值
        memory[0x1030 >> 2] = 0x00000000;  // +0.0
        memory[0x1034 >> 2] = 0x80000000;  // -0.0
        memory[0x1038 >> 2] = 0x7F800000;  // +Infinity
        memory[0x103C >> 2] = 0xFF800000;  // -Infinity
        memory[0x1040 >> 2] = 0x7FC00000;  // NaN
        
        // 非常小的數 (denormalized)
        memory[0x1044 >> 2] = 0x00000001;  // 最小正非規格化數
        memory[0x1048 >> 2] = 0x007FFFFF;  // 最大非規格化數
        
        // 非常大的數
        memory[0x104C >> 2] = 0x7F7FFFFF;  // 最大正規格化數
        memory[0x1050 >> 2] = 0xFF7FFFFF;  // 最小負規格化數
        
        // 測試用的大數
        memory[4095] = 0x42C80000;  // 100.0
    }
    
    void run_tests() {
        cout << "=== FPU Comprehensive Testbench Started ===" << endl;
        
        // 初始化
        dut->mem_rdata = 0;
        
        reset_system();
        initialize_memory();
        
        cout << "\n========== FLW INSTRUCTION TESTS ==========" << endl;
        
        // 基本 FLW 測試
        test_flw(0x1000, 0x0, 0x3F800000, 1, "Load 1.0");
        wait_cycles(5);
        test_flw(0x1000, 0x4, 0x40000000, 2, "Load 2.0");
        wait_cycles(5);
        test_flw(0x1000, 0x8, 0x40400000, 3, "Load 3.0");
        wait_cycles(5);
        
        // 小數測試
        test_flw(0x1014, 0x0, 0x3F000000, 4, "Load 0.5");
        wait_cycles(5);
        test_flw(0x1018, 0x0, 0x3E800000, 5, "Load 0.25");
        wait_cycles(5);
        
        // 負數測試
        test_flw(0x1020, 0x0, 0xBF800000, 6, "Load -1.0");
        wait_cycles(5);
        test_flw(0x1024, 0x0, 0xC0000000, 7, "Load -2.0");
        wait_cycles(5);
        
        // 特殊值測試
        test_flw(0x1030, 0x0, 0x00000000, 8, "Load +0.0");
        wait_cycles(5);
        test_flw(0x1034, 0x0, 0x80000000, 9, "Load -0.0");
        wait_cycles(5);
        test_flw(0x1038, 0x0, 0x7F800000, 10, "Load +Infinity");
        wait_cycles(5);
        test_flw(0x103C, 0x0, 0xFF800000, 11, "Load -Infinity");
        wait_cycles(5);
        test_flw(0x1040, 0x0, 0x7FC00000, 12, "Load NaN");
        wait_cycles(5);
        
        // 邊界值測試
        test_flw(0x1044, 0x0, 0x00000001, 13, "Load Min Denormalized");
        wait_cycles(5);
        test_flw(0x1048, 0x0, 0x007FFFFF, 14, "Load Max Denormalized");
        wait_cycles(5);
        test_flw(0x104C, 0x0, 0x7F7FFFFF, 15, "Load Max Normalized");
        wait_cycles(5);
        
        cout << "\n========== FSW INSTRUCTION TESTS ==========" << endl;
        
        // 基本 FSW 測試
        test_fsw(0x2000, 0x0, 0x3F800000, "Store 1.0");
        wait_cycles(5);
        test_fsw(0x2000, 0x4, 0x40000000, "Store 2.0");
        wait_cycles(5);
        test_fsw(0x2000, 0x8, 0xBF800000, "Store -1.0");
        wait_cycles(5);
        
        // 特殊值儲存
        test_fsw(0x2010, 0x0, 0x00000000, "Store +0.0");
        wait_cycles(5);
        test_fsw(0x2010, 0x4, 0x80000000, "Store -0.0");
        wait_cycles(5);
        test_fsw(0x2010, 0x8, 0x7F800000, "Store +Infinity");
        wait_cycles(5);
        test_fsw(0x2010, 0xC, 0xFF800000, "Store -Infinity");
        wait_cycles(5);
        test_fsw(0x2010, 0x10, 0x7FC00000, "Store NaN");
        wait_cycles(5);
        
        // 邊界值儲存
        test_fsw(0x2020, 0x0, 0x7F7FFFFF, "Store Max Float");
        wait_cycles(5);
        test_fsw(0x2020, 0x4, 0x00000001, "Store Min Denorm");
        wait_cycles(5);
        
        cout << "\n========== FADD INSTRUCTION TESTS ==========" << endl;
        
        // 基本加法測試
        test_fadd(0x3F800000, 0x40000000, 0x40400000, 16, "1.0 + 2.0 = 3.0");
        wait_cycles(5);
        test_fadd(0x40000000, 0x40400000, 0x40A00000, 17, "2.0 + 3.0 = 5.0");
        wait_cycles(5);
        test_fadd(0x3F000000, 0x3F000000, 0x3F800000, 18, "0.5 + 0.5 = 1.0");
        wait_cycles(5);
        
        // 減法測試 (負數加法)
        test_fadd(0x40400000, 0xBF800000, 0x40000000, 19, "3.0 + (-1.0) = 2.0");
        wait_cycles(5);
        test_fadd(0x3F800000, 0xBF800000, 0x00000000, 20, "1.0 + (-1.0) = 0.0");
        wait_cycles(5);
        
        // 零值測試
        test_fadd(0x3F800000, 0x00000000, 0x3F800000, 21, "1.0 + 0.0 = 1.0");
        wait_cycles(5);
        test_fadd(0x00000000, 0x00000000, 0x00000000, 22, "0.0 + 0.0 = 0.0");
        wait_cycles(5);
        test_fadd(0x00000000, 0x80000000, 0x00000000, 23, "+0.0 + (-0.0) = +0.0");
        wait_cycles(5);
        
        // 無窮大測試
        test_fadd(0x7F800000, 0x3F800000, 0x7F800000, 24, "+Inf + 1.0 = +Inf");
        wait_cycles(5);
        test_fadd(0xFF800000, 0x3F800000, 0xFF800000, 25, "-Inf + 1.0 = -Inf");
        wait_cycles(5);
        test_fadd(0x7F800000, 0x7F800000, 0x7F800000, 26, "+Inf + +Inf = +Inf");
        wait_cycles(5);
        test_fadd(0x7F800000, 0xFF800000, 0x7FC00000, 27, "+Inf + (-Inf) = NaN");
        wait_cycles(5);
        
        // NaN 測試
        test_fadd(0x7FC00000, 0x3F800000, 0x7FC00000, 28, "NaN + 1.0 = NaN");
        wait_cycles(5);
        test_fadd(0x3F800000, 0x7FC00000, 0x7FC00000, 29, "1.0 + NaN = NaN");
        wait_cycles(5);
        
        // 非規格化數測試
        test_fadd(0x00000001, 0x00000001, 0x00000002, 30, "Min_Denorm + Min_Denorm");
        wait_cycles(5);
        
        // 大數加法測試
        test_fadd(0x7F000000, 0x7F000000, 0x7F800000, 31, "Large + Large = Overflow to Inf");
        wait_cycles(5);
        
        cout << "\n========== 混合操作測試 ==========" << endl;
        
        // 複雜的載入-計算-儲存序列
        cout << "\n--- 序列 1: 載入兩個數，相加，儲存結果 ---" << endl;
        test_flw(0x1000, 0x0, 0x3F800000, 1, "Load 1.0 to f1");
        wait_cycles(3);
        test_flw(0x1000, 0x4, 0x40000000, 2, "Load 2.0 to f2");
        wait_cycles(3);
        test_fadd(0x3F800000, 0x40000000, 0x40400000, 3, "f1 + f2 = 3.0");
        wait_cycles(3);
        test_fsw(0x3000, 0x0, 0x40400000, "Store result 3.0");
        wait_cycles(5);
        
        cout << "\n--- 序列 2: 連續加法 ---" << endl;
        test_fadd(0x3F800000, 0x3F800000, 0x40000000, 4, "1.0 + 1.0 = 2.0");
        wait_cycles(3);
        test_fadd(0x40000000, 0x3F800000, 0x40400000, 5, "2.0 + 1.0 = 3.0");
        wait_cycles(3);
        test_fadd(0x40400000, 0x3F800000, 0x40800000, 6, "3.0 + 1.0 = 4.0");
        wait_cycles(5);
        
        cout << "\n========== 邊界和錯誤情況測試 ==========" << endl;
        
        // 測試不同的暫存器編號
        test_flw(0x1000, 0x0, 0x3F800000, 0, "Load to f0");
        wait_cycles(3);
        test_flw(0x1000, 0x4, 0x40000000, 31, "Load to f31");
        wait_cycles(3);
        
        // 測試最大記憶體地址
        test_flw(0x3FFC, 0x0, 0x42C80000, 7, "Load from max address");
        wait_cycles(3);
        test_fsw(0x3FF8, 0x0, 0x42C80000, "Store to near max address");
        wait_cycles(5);
        
        // 精度測試
        test_fadd(0x3F800000, 0x33800000, 0x3F800000, 8, "1.0 + very_small (precision test)");
        wait_cycles(5);
        
        cout << "\n========== 壓力測試 ==========" << endl;
        
        // 快速連續操作
        cout << "\n--- 快速連續 FLW 操作 ---" << endl;
        test_flw(0x1000, 0x0, 0x3F800000, 10, "Fast FLW 1");
        test_flw(0x1000, 0x4, 0x40000000, 11, "Fast FLW 2");
        test_flw(0x1000, 0x8, 0x40400000, 12, "Fast FLW 3");
        wait_cycles(5);
        
        cout << "\n--- 快速連續 FADD 操作 ---" << endl;
        test_fadd(0x3F800000, 0x3F800000, 0x40000000, 13, "Fast FADD 1");
        test_fadd(0x40000000, 0x3F800000, 0x40400000, 14, "Fast FADD 2");
        test_fadd(0x40400000, 0x3F800000, 0x40800000, 15, "Fast FADD 3");
        wait_cycles(10);
        
        // 顯示結果
        print_results();
    }
    
    void print_results() {
        cout << "\n========== 測試結果統計 ==========" << endl;
        cout << "總測試數: " << (pass_count + fail_count) << endl;
        cout << "通過: " << pass_count << endl;
        cout << "失敗: " << fail_count << endl;
        
        if (fail_count == 0) {
            cout << "🎉 所有測試都通過了！" << endl;
        } else {
            cout << "⚠️  有 " << fail_count << " 個測試失敗" << endl;
        }
        
        cout << "\n=== 測試完成 ===" << endl;
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    FpuTestbench tb;
    tb.run_tests();
    
    return 0;
}