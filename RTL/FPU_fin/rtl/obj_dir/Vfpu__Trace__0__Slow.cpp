// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vfpu__Syms.h"


VL_ATTR_COLD void Vfpu___024root__trace_init_sub__TOP__0(Vfpu___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+87,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"enabled",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"instr_flw",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"instr_fsw",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"instr_fadd",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+93,0,"instr_fmul",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+94,0,"instr_fdiv",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+95,0,"reg_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+96,0,"reg_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+97,0,"rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+98,0,"freg_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+99,0,"freg_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+100,0,"frd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+101,0,"imm",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+102,0,"mem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+103,0,"mem_wdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+104,0,"mem_rdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+105,0,"mem_we",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"mem_re",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"mem_ready",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"freg_wb_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+109,0,"freg_wb_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+110,0,"freg_wb_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+111,0,"reg_wb_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+112,0,"reg_wb_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+113,0,"reg_wb_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+114,0,"completed",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"fpu_busy",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("fpu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+117,0,"NONE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+118,0,"FLW_MEM_ACCESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+119,0,"FLW_WAIT_READY",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+120,0,"FLW_WAIT_DATA",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+121,0,"FLW_STABILIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+122,0,"FLW_SAMPLE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+123,0,"FLW_COMPLETE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+124,0,"FSW_MEM_ACCESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+125,0,"FSW_WAIT_READY",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+126,0,"FSW_COMPLETE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+127,0,"FADD_START",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+128,0,"FADD_WAIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+129,0,"FADD_COMPLETE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBit(c+87,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"enabled",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"instr_flw",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"instr_fsw",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"instr_fadd",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+93,0,"instr_fmul",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+94,0,"instr_fdiv",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+95,0,"reg_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+96,0,"reg_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+97,0,"rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+98,0,"freg_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+99,0,"freg_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+100,0,"frd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+101,0,"imm",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+102,0,"mem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+103,0,"mem_wdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+104,0,"mem_rdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+105,0,"mem_we",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"mem_re",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"mem_ready",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"freg_wb_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+109,0,"freg_wb_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+110,0,"freg_wb_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+111,0,"reg_wb_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+112,0,"reg_wb_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+113,0,"reg_wb_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+114,0,"completed",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"fpu_busy",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+67,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+116,0,"next_state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+1,0,"target_frd",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+2,0,"temp_mem_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+3,0,"temp_mem_wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+68,0,"temp_freg_rs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+69,0,"temp_freg_rs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+70,0,"fadd_start",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"fadd_enable_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+8,0,"fadd_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+9,0,"fadd_ovf",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"temp_freg_wb_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"temp_freg_wb_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+7,0,"temp_freg_wb_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("uut_fadd", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+68,0,"x1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+69,0,"x2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+87,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+70,0,"enable_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"enable_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+8,0,"y",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+9,0,"ovf",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+71,0,"symbol_init_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+72,0,"exp_init_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+73,0,"man_init_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBit(c+74,0,"symbol_init_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+75,0,"exp_init_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+76,0,"man_init_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+77,0,"man_ext_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+78,0,"man_ext_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+79,0,"exp_norm_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+80,0,"exp_norm_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+81,0,"exp_norm_x2_i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+82,0,"te_diff",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+83,0,"ce",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+84,0,"tde",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+85,0,"de",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+86,0,"sel",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+10,0,"man_init_x1_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+11,0,"man_init_x2_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+12,0,"man_st1_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+13,0,"man_st1_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBit(c+14,0,"symbol_st1_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+15,0,"symbol_st1_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+16,0,"de_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+17,0,"sel_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+18,0,"exp_init_x1_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+19,0,"exp_init_x2_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+20,0,"exp_st1_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+21,0,"exp_st1_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBit(c+22,0,"enable_in_st1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+23,0,"man_signi",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+24,0,"man_insigni",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+25,0,"exp_signi",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBit(c+26,0,"symbol_signi",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+27,0,"symbol_insigni",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+28,0,"man_insigni_ext",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 55,0);
    tracep->declQuad(c+30,0,"man_signi_ext",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 55,0);
    tracep->declQuad(c+32,0,"man_insigni_align",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 55,0);
    tracep->declBit(c+34,0,"tstck",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+35,0,"man_y_sum",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 26,0);
    tracep->declBit(c+36,0,"man_overflow",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+37,0,"exp_pre_norm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+38,0,"man_pre_norm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 26,0);
    tracep->declBit(c+39,0,"stck",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+40,0,"search_leading_zeros",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+41,0,"stck_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+42,0,"slz_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+43,0,"exp_pre_norm_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBit(c+44,0,"symbol_signi_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+45,0,"symbol_st2_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+46,0,"symbol_st2_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+47,0,"man_pre_norm_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 26,0);
    tracep->declBus(c+48,0,"exp_init_x1_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+49,0,"exp_init_x2_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+50,0,"man_st2_x1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+51,0,"man_st2_x2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBit(c+52,0,"enable_in_st2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+53,0,"exp_norm_temp",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+54,0,"exp_norm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+55,0,"man_y_norm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 26,0);
    tracep->declBit(c+56,0,"round_bit",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+57,0,"sticky_bit_final",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+58,0,"tie_even",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+59,0,"round_up",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+60,0,"man_y_finorm_unrounded",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+61,0,"man_y_finorm",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 24,0);
    tracep->declBus(c+62,0,"exp_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+63,0,"man_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBit(c+64,0,"symbol_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"nzm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+66,0,"nzm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"enable_out_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vfpu___024root__trace_init_top(Vfpu___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_init_top\n"); );
    // Body
    Vfpu___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vfpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vfpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vfpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vfpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vfpu___024root__trace_register(Vfpu___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vfpu___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vfpu___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vfpu___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vfpu___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vfpu___024root__trace_const_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vfpu___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_const_0\n"); );
    // Init
    Vfpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vfpu___024root*>(voidSelf);
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vfpu___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vfpu___024root__trace_const_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_const_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+117,(0U),4);
    bufp->fullCData(oldp+118,(1U),4);
    bufp->fullCData(oldp+119,(2U),4);
    bufp->fullCData(oldp+120,(3U),4);
    bufp->fullCData(oldp+121,(4U),4);
    bufp->fullCData(oldp+122,(5U),4);
    bufp->fullCData(oldp+123,(6U),4);
    bufp->fullCData(oldp+124,(7U),4);
    bufp->fullCData(oldp+125,(8U),4);
    bufp->fullCData(oldp+126,(9U),4);
    bufp->fullCData(oldp+127,(0xaU),4);
    bufp->fullCData(oldp+128,(0xbU),4);
    bufp->fullCData(oldp+129,(0xcU),4);
}

VL_ATTR_COLD void Vfpu___024root__trace_full_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vfpu___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_full_0\n"); );
    // Init
    Vfpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vfpu___024root*>(voidSelf);
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vfpu___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vfpu___024root__trace_full_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+1,(vlSelf->fpu__DOT__target_frd),5);
    bufp->fullIData(oldp+2,(vlSelf->fpu__DOT__temp_mem_addr),32);
    bufp->fullIData(oldp+3,(vlSelf->fpu__DOT__temp_mem_wdata),32);
    bufp->fullBit(oldp+4,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg));
    bufp->fullBit(oldp+5,(vlSelf->fpu__DOT__temp_freg_wb_enable));
    bufp->fullCData(oldp+6,(vlSelf->fpu__DOT__temp_freg_wb_addr),5);
    bufp->fullIData(oldp+7,(vlSelf->fpu__DOT__temp_freg_wb_data),32);
    bufp->fullIData(oldp+8,((((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
                              & (0xffU != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)))
                              ? (0x7f800000U | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                 << 0x1fU) 
                                                | (((IData)(
                                                            (0U 
                                                             != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)) 
                                                    << 0x16U) 
                                                   | (0x3fffffU 
                                                      & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))))
                              : (((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)) 
                                  & (0xffU != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)))
                                  ? (0x7f800000U | 
                                     (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                       << 0x1fU) | 
                                      (((IData)((0U 
                                                 != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)) 
                                        << 0x16U) | 
                                       (0x3fffffU & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))))
                                  : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                      & (0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))
                                      ? (0x7fc00000U 
                                         | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                             << 0x1fU) 
                                            | (0x3fffffU 
                                               & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)))
                                      : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                          & (0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))
                                          ? (0x7fc00000U 
                                             | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                 << 0x1fU) 
                                                | (0x3fffffU 
                                                   & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)))
                                          : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                              & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                 == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2)))
                                              ? (0x7f800000U 
                                                 | ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                    << 0x1fU))
                                              : ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0)
                                                  ? 0xffc00000U
                                                  : 
                                                 (((((0U 
                                                      == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y)) 
                                                     & (0U 
                                                        == 
                                                        (0x7fffffU 
                                                         & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)))
                                                     ? 
                                                    ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                     & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2))
                                                     : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2)) 
                                                   << 0x1fU) 
                                                  | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y) 
                                                      << 0x17U) 
                                                     | (0x7fffffU 
                                                        & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)))))))))),32);
    bufp->fullBit(oldp+9,(((0xffU > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
                           & ((0xffU > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)) 
                              & ((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2)) 
                                 | (0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y)))))));
    bufp->fullIData(oldp+10,(vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1),23);
    bufp->fullIData(oldp+11,(vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1),23);
    bufp->fullIData(oldp+12,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1),25);
    bufp->fullIData(oldp+13,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2),25);
    bufp->fullBit(oldp+14,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1));
    bufp->fullBit(oldp+15,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2));
    bufp->fullCData(oldp+16,(vlSelf->fpu__DOT__uut_fadd__DOT__de_st1),5);
    bufp->fullBit(oldp+17,(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1));
    bufp->fullCData(oldp+18,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st1),8);
    bufp->fullCData(oldp+19,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st1),8);
    bufp->fullCData(oldp+20,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1),8);
    bufp->fullCData(oldp+21,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2),8);
    bufp->fullBit(oldp+22,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st1));
    bufp->fullIData(oldp+23,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                               ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                               : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1)),25);
    bufp->fullIData(oldp+24,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                               ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                               : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2)),25);
    bufp->fullCData(oldp+25,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                               ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2)
                               : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1))),8);
    bufp->fullBit(oldp+26,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                             ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2)
                             : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1))));
    bufp->fullBit(oldp+27,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                             ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1)
                             : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2))));
    bufp->fullQData(oldp+28,(((QData)((IData)(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                                                : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2))) 
                              << 0x1fU)),56);
    bufp->fullQData(oldp+30,(((QData)((IData)(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                                                : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1))) 
                              << 0x1fU)),56);
    bufp->fullQData(oldp+32,(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align),56);
    bufp->fullBit(oldp+34,((0U != (0x1fffffffU & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align)))));
    bufp->fullIData(oldp+35,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum),27);
    bufp->fullBit(oldp+36,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                  >> 0x1aU))));
    bufp->fullCData(oldp+37,((0xffU & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                         ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2)
                                         : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1)) 
                                       + (1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                                >> 0x1aU))))),8);
    bufp->fullIData(oldp+38,(vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm),27);
    bufp->fullBit(oldp+39,((1U & ((0x4000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum)
                                   ? (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                      | (0U != (0x1fffffffU 
                                                & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align))))
                                   : (0U != (0x1fffffffU 
                                             & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align)))))));
    bufp->fullCData(oldp+40,(vlSelf->fpu__DOT__uut_fadd__DOT__search_leading_zeros),5);
    bufp->fullBit(oldp+41,(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2));
    bufp->fullCData(oldp+42,(vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2),5);
    bufp->fullCData(oldp+43,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2),8);
    bufp->fullBit(oldp+44,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2));
    bufp->fullBit(oldp+45,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1));
    bufp->fullBit(oldp+46,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2));
    bufp->fullIData(oldp+47,(vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2),27);
    bufp->fullCData(oldp+48,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2),8);
    bufp->fullCData(oldp+49,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2),8);
    bufp->fullIData(oldp+50,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1),23);
    bufp->fullIData(oldp+51,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2),23);
    bufp->fullBit(oldp+52,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st2));
    bufp->fullSData(oldp+53,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp),9);
    bufp->fullCData(oldp+54,(((0x100U & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp))
                               ? 0U : (0xffU & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp)))),8);
    bufp->fullIData(oldp+55,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm),27);
    bufp->fullBit(oldp+56,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                  >> 1U))));
    bufp->fullBit(oldp+57,((1U & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                  | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm))));
    bufp->fullBit(oldp+58,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                  >> 2U))));
    bufp->fullBit(oldp+59,((1U & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                   >> 1U) & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                              | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm) 
                                             | (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                                >> 2U))))));
    bufp->fullIData(oldp+60,((0x1ffffffU & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                            >> 2U))),25);
    bufp->fullIData(oldp+61,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm),25);
    bufp->fullCData(oldp+62,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y),8);
    bufp->fullIData(oldp+63,((0x7fffffU & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)),23);
    bufp->fullBit(oldp+64,((((0U == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y)) 
                             & (0U == (0x7fffffU & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)))
                             ? ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2))
                             : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2))));
    bufp->fullBit(oldp+65,((0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)));
    bufp->fullBit(oldp+66,((0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)));
    bufp->fullCData(oldp+67,(vlSelf->fpu__DOT__state),4);
    bufp->fullIData(oldp+68,(vlSelf->fpu__DOT__temp_freg_rs1),32);
    bufp->fullIData(oldp+69,(vlSelf->fpu__DOT__temp_freg_rs2),32);
    bufp->fullBit(oldp+70,(vlSelf->fpu__DOT__fadd_start));
    bufp->fullBit(oldp+71,((vlSelf->fpu__DOT__temp_freg_rs1 
                            >> 0x1fU)));
    bufp->fullCData(oldp+72,((0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                                       >> 0x17U))),8);
    bufp->fullIData(oldp+73,((0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs1)),23);
    bufp->fullBit(oldp+74,((vlSelf->fpu__DOT__temp_freg_rs2 
                            >> 0x1fU)));
    bufp->fullCData(oldp+75,((0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                                       >> 0x17U))),8);
    bufp->fullIData(oldp+76,((0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs2)),23);
    bufp->fullIData(oldp+77,(vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1),25);
    bufp->fullIData(oldp+78,(vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2),25);
    bufp->fullCData(oldp+79,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1),8);
    bufp->fullCData(oldp+80,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2),8);
    bufp->fullCData(oldp+81,(((0U == (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                                               >> 0x17U)))
                               ? 0xfeU : (0xffU & (~ 
                                                   (vlSelf->fpu__DOT__temp_freg_rs2 
                                                    >> 0x17U))))),8);
    bufp->fullSData(oldp+82,(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff),9);
    bufp->fullBit(oldp+83,((1U & (~ ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff) 
                                     >> 8U)))));
    bufp->fullCData(oldp+84,(vlSelf->fpu__DOT__uut_fadd__DOT__tde),8);
    bufp->fullCData(oldp+85,(((0x18U <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde))
                               ? 0x18U : (0x1fU & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde)))),5);
    bufp->fullBit(oldp+86,((((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2) 
                             > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1)) 
                            | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1) 
                                <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2)) 
                               & (vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 
                                  > vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1)))));
    bufp->fullBit(oldp+87,(vlSelf->clk));
    bufp->fullBit(oldp+88,(vlSelf->rst_n));
    bufp->fullBit(oldp+89,(vlSelf->enabled));
    bufp->fullBit(oldp+90,(vlSelf->instr_flw));
    bufp->fullBit(oldp+91,(vlSelf->instr_fsw));
    bufp->fullBit(oldp+92,(vlSelf->instr_fadd));
    bufp->fullBit(oldp+93,(vlSelf->instr_fmul));
    bufp->fullBit(oldp+94,(vlSelf->instr_fdiv));
    bufp->fullIData(oldp+95,(vlSelf->reg_rs1),32);
    bufp->fullIData(oldp+96,(vlSelf->reg_rs2),32);
    bufp->fullCData(oldp+97,(vlSelf->rd_addr),5);
    bufp->fullIData(oldp+98,(vlSelf->freg_rs1),32);
    bufp->fullIData(oldp+99,(vlSelf->freg_rs2),32);
    bufp->fullCData(oldp+100,(vlSelf->frd_addr),5);
    bufp->fullIData(oldp+101,(vlSelf->imm),32);
    bufp->fullIData(oldp+102,(vlSelf->mem_addr),32);
    bufp->fullIData(oldp+103,(vlSelf->mem_wdata),32);
    bufp->fullIData(oldp+104,(vlSelf->mem_rdata),32);
    bufp->fullBit(oldp+105,(vlSelf->mem_we));
    bufp->fullBit(oldp+106,(vlSelf->mem_re));
    bufp->fullBit(oldp+107,(vlSelf->mem_ready));
    bufp->fullBit(oldp+108,(vlSelf->freg_wb_enable));
    bufp->fullCData(oldp+109,(vlSelf->freg_wb_addr),5);
    bufp->fullIData(oldp+110,(vlSelf->freg_wb_data),32);
    bufp->fullBit(oldp+111,(vlSelf->reg_wb_enable));
    bufp->fullCData(oldp+112,(vlSelf->reg_wb_addr),5);
    bufp->fullIData(oldp+113,(vlSelf->reg_wb_data),32);
    bufp->fullBit(oldp+114,(vlSelf->completed));
    bufp->fullBit(oldp+115,(vlSelf->fpu_busy));
    bufp->fullCData(oldp+116,(vlSelf->fpu__DOT__next_state),4);
}
