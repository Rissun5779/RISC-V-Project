// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vfpu__Syms.h"


void Vfpu___024root__trace_chg_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vfpu___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_chg_0\n"); );
    // Init
    Vfpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vfpu___024root*>(voidSelf);
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vfpu___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vfpu___024root__trace_chg_0_sub_0(Vfpu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgCData(oldp+0,(vlSelf->fpu__DOT__target_frd),5);
        bufp->chgIData(oldp+1,(vlSelf->fpu__DOT__temp_mem_addr),32);
        bufp->chgIData(oldp+2,(vlSelf->fpu__DOT__temp_mem_wdata),32);
        bufp->chgBit(oldp+3,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg));
        bufp->chgBit(oldp+4,(vlSelf->fpu__DOT__temp_freg_wb_enable));
        bufp->chgCData(oldp+5,(vlSelf->fpu__DOT__temp_freg_wb_addr),5);
        bufp->chgIData(oldp+6,(vlSelf->fpu__DOT__temp_freg_wb_data),32);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[2U])) {
        bufp->chgIData(oldp+7,((((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
                                 & (0xffU != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)))
                                 ? (0x7f800000U | (
                                                   ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                    << 0x1fU) 
                                                   | (((IData)(
                                                               (0U 
                                                                != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)) 
                                                       << 0x16U) 
                                                      | (0x3fffffU 
                                                         & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))))
                                 : (((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)) 
                                     & (0xffU != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)))
                                     ? (0x7f800000U 
                                        | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                            << 0x1fU) 
                                           | (((IData)(
                                                       (0U 
                                                        != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)) 
                                               << 0x16U) 
                                              | (0x3fffffU 
                                                 & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))))
                                     : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                         & (0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))
                                         ? (0x7fc00000U 
                                            | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                                << 0x1fU) 
                                               | (0x3fffffU 
                                                  & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)))
                                         : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                             & (0U 
                                                != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))
                                             ? (0x7fc00000U 
                                                | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                    << 0x1fU) 
                                                   | (0x3fffffU 
                                                      & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)))
                                             : (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                                 & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                    == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2)))
                                                 ? 
                                                (0x7f800000U 
                                                 | ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                    << 0x1fU))
                                                 : 
                                                ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0)
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
        bufp->chgBit(oldp+8,(((0xffU > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
                              & ((0xffU > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)) 
                                 & ((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2)) 
                                    | (0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y)))))));
        bufp->chgIData(oldp+9,(vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1),23);
        bufp->chgIData(oldp+10,(vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1),23);
        bufp->chgIData(oldp+11,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1),25);
        bufp->chgIData(oldp+12,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2),25);
        bufp->chgBit(oldp+13,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1));
        bufp->chgBit(oldp+14,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2));
        bufp->chgCData(oldp+15,(vlSelf->fpu__DOT__uut_fadd__DOT__de_st1),5);
        bufp->chgBit(oldp+16,(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1));
        bufp->chgCData(oldp+17,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st1),8);
        bufp->chgCData(oldp+18,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st1),8);
        bufp->chgCData(oldp+19,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1),8);
        bufp->chgCData(oldp+20,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2),8);
        bufp->chgBit(oldp+21,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st1));
        bufp->chgIData(oldp+22,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                  ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                                  : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1)),25);
        bufp->chgIData(oldp+23,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                  ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                                  : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2)),25);
        bufp->chgCData(oldp+24,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                  ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2)
                                  : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1))),8);
        bufp->chgBit(oldp+25,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2)
                                : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1))));
        bufp->chgBit(oldp+26,(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1)
                                : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2))));
        bufp->chgQData(oldp+27,(((QData)((IData)(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                   ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                                                   : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2))) 
                                 << 0x1fU)),56);
        bufp->chgQData(oldp+29,(((QData)((IData)(((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                   ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                                                   : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1))) 
                                 << 0x1fU)),56);
        bufp->chgQData(oldp+31,(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align),56);
        bufp->chgBit(oldp+33,((0U != (0x1fffffffU & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align)))));
        bufp->chgIData(oldp+34,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum),27);
        bufp->chgBit(oldp+35,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                     >> 0x1aU))));
        bufp->chgCData(oldp+36,((0xffU & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                            ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2)
                                            : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1)) 
                                          + (1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                                   >> 0x1aU))))),8);
        bufp->chgIData(oldp+37,(vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm),27);
        bufp->chgBit(oldp+38,((1U & ((0x4000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum)
                                      ? (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                         | (0U != (0x1fffffffU 
                                                   & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align))))
                                      : (0U != (0x1fffffffU 
                                                & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align)))))));
        bufp->chgCData(oldp+39,(vlSelf->fpu__DOT__uut_fadd__DOT__search_leading_zeros),5);
        bufp->chgBit(oldp+40,(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2));
        bufp->chgCData(oldp+41,(vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2),5);
        bufp->chgCData(oldp+42,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2),8);
        bufp->chgBit(oldp+43,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2));
        bufp->chgBit(oldp+44,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1));
        bufp->chgBit(oldp+45,(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2));
        bufp->chgIData(oldp+46,(vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2),27);
        bufp->chgCData(oldp+47,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2),8);
        bufp->chgCData(oldp+48,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2),8);
        bufp->chgIData(oldp+49,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1),23);
        bufp->chgIData(oldp+50,(vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2),23);
        bufp->chgBit(oldp+51,(vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st2));
        bufp->chgSData(oldp+52,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp),9);
        bufp->chgCData(oldp+53,(((0x100U & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp))
                                  ? 0U : (0xffU & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp)))),8);
        bufp->chgIData(oldp+54,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm),27);
        bufp->chgBit(oldp+55,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                     >> 1U))));
        bufp->chgBit(oldp+56,((1U & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                     | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm))));
        bufp->chgBit(oldp+57,((1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                     >> 2U))));
        bufp->chgBit(oldp+58,((1U & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                      >> 1U) & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                                 | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm) 
                                                | (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                                   >> 2U))))));
        bufp->chgIData(oldp+59,((0x1ffffffU & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                               >> 2U))),25);
        bufp->chgIData(oldp+60,(vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm),25);
        bufp->chgCData(oldp+61,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y),8);
        bufp->chgIData(oldp+62,((0x7fffffU & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)),23);
        bufp->chgBit(oldp+63,((((0U == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_y)) 
                                & (0U == (0x7fffffU 
                                          & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)))
                                ? ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                   & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2))
                                : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2))));
        bufp->chgBit(oldp+64,((0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)));
        bufp->chgBit(oldp+65,((0U != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)));
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[3U])) {
        bufp->chgCData(oldp+66,(vlSelf->fpu__DOT__state),4);
        bufp->chgIData(oldp+67,(vlSelf->fpu__DOT__temp_freg_rs1),32);
        bufp->chgIData(oldp+68,(vlSelf->fpu__DOT__temp_freg_rs2),32);
        bufp->chgBit(oldp+69,(vlSelf->fpu__DOT__fadd_start));
        bufp->chgBit(oldp+70,((vlSelf->fpu__DOT__temp_freg_rs1 
                               >> 0x1fU)));
        bufp->chgCData(oldp+71,((0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                                          >> 0x17U))),8);
        bufp->chgIData(oldp+72,((0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs1)),23);
        bufp->chgBit(oldp+73,((vlSelf->fpu__DOT__temp_freg_rs2 
                               >> 0x1fU)));
        bufp->chgCData(oldp+74,((0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                                          >> 0x17U))),8);
        bufp->chgIData(oldp+75,((0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs2)),23);
        bufp->chgIData(oldp+76,(vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1),25);
        bufp->chgIData(oldp+77,(vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2),25);
        bufp->chgCData(oldp+78,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1),8);
        bufp->chgCData(oldp+79,(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2),8);
        bufp->chgCData(oldp+80,(((0U == (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                                                  >> 0x17U)))
                                  ? 0xfeU : (0xffU 
                                             & (~ (vlSelf->fpu__DOT__temp_freg_rs2 
                                                   >> 0x17U))))),8);
        bufp->chgSData(oldp+81,(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff),9);
        bufp->chgBit(oldp+82,((1U & (~ ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff) 
                                        >> 8U)))));
        bufp->chgCData(oldp+83,(vlSelf->fpu__DOT__uut_fadd__DOT__tde),8);
        bufp->chgCData(oldp+84,(((0x18U <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde))
                                  ? 0x18U : (0x1fU 
                                             & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde)))),5);
        bufp->chgBit(oldp+85,((((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2) 
                                > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1)) 
                               | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1) 
                                   <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2)) 
                                  & (vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 
                                     > vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1)))));
    }
    bufp->chgBit(oldp+86,(vlSelf->clk));
    bufp->chgBit(oldp+87,(vlSelf->rst_n));
    bufp->chgBit(oldp+88,(vlSelf->enabled));
    bufp->chgBit(oldp+89,(vlSelf->instr_flw));
    bufp->chgBit(oldp+90,(vlSelf->instr_fsw));
    bufp->chgBit(oldp+91,(vlSelf->instr_fadd));
    bufp->chgBit(oldp+92,(vlSelf->instr_fmul));
    bufp->chgBit(oldp+93,(vlSelf->instr_fdiv));
    bufp->chgIData(oldp+94,(vlSelf->reg_rs1),32);
    bufp->chgIData(oldp+95,(vlSelf->reg_rs2),32);
    bufp->chgCData(oldp+96,(vlSelf->rd_addr),5);
    bufp->chgIData(oldp+97,(vlSelf->freg_rs1),32);
    bufp->chgIData(oldp+98,(vlSelf->freg_rs2),32);
    bufp->chgCData(oldp+99,(vlSelf->frd_addr),5);
    bufp->chgIData(oldp+100,(vlSelf->imm),32);
    bufp->chgIData(oldp+101,(vlSelf->mem_addr),32);
    bufp->chgIData(oldp+102,(vlSelf->mem_wdata),32);
    bufp->chgIData(oldp+103,(vlSelf->mem_rdata),32);
    bufp->chgBit(oldp+104,(vlSelf->mem_we));
    bufp->chgBit(oldp+105,(vlSelf->mem_re));
    bufp->chgBit(oldp+106,(vlSelf->mem_ready));
    bufp->chgBit(oldp+107,(vlSelf->freg_wb_enable));
    bufp->chgCData(oldp+108,(vlSelf->freg_wb_addr),5);
    bufp->chgIData(oldp+109,(vlSelf->freg_wb_data),32);
    bufp->chgBit(oldp+110,(vlSelf->reg_wb_enable));
    bufp->chgCData(oldp+111,(vlSelf->reg_wb_addr),5);
    bufp->chgIData(oldp+112,(vlSelf->reg_wb_data),32);
    bufp->chgBit(oldp+113,(vlSelf->completed));
    bufp->chgBit(oldp+114,(vlSelf->fpu_busy));
    bufp->chgCData(oldp+115,(vlSelf->fpu__DOT__next_state),4);
}

void Vfpu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root__trace_cleanup\n"); );
    // Init
    Vfpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vfpu___024root*>(voidSelf);
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
