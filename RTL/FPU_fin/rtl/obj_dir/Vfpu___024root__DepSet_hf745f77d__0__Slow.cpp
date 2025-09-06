// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfpu.h for the primary calling header

#include "Vfpu__pch.h"
#include "Vfpu___024root.h"

VL_ATTR_COLD void Vfpu___024root___eval_static(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vfpu___024root___eval_initial(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = vlSelf->rst_n;
}

VL_ATTR_COLD void Vfpu___024root___eval_final(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__stl(Vfpu___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vfpu___024root___eval_phase__stl(Vfpu___024root* vlSelf);

VL_ATTR_COLD void Vfpu___024root___eval_settle(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vfpu___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("fpu.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vfpu___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__stl(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

extern const VlUnpacked<CData/*3:0*/, 1024> Vfpu__ConstPool__TABLE_h5a1b682b_0;

VL_ATTR_COLD void Vfpu___024root___stl_sequent__TOP__0(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___stl_sequent__TOP__0\n"); );
    // Init
    SData/*9:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
    vlSelf->freg_wb_enable = vlSelf->fpu__DOT__temp_freg_wb_enable;
    vlSelf->freg_wb_addr = vlSelf->fpu__DOT__temp_freg_wb_addr;
    vlSelf->freg_wb_data = vlSelf->fpu__DOT__temp_freg_wb_data;
    vlSelf->fpu_busy = (0U != (IData)(vlSelf->fpu__DOT__state));
    if ((0U == (0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                         >> 0x17U)))) {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1 
            = (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs1);
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1 = 1U;
    } else {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1 
            = (0x800000U | (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs1));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                        >> 0x17U));
    }
    if ((0U == (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                         >> 0x17U)))) {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 
            = (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs2);
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2 = 1U;
    } else {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 
            = (0x800000U | (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs2));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                        >> 0x17U));
    }
    vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0 
        = ((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
           & (0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)));
    __Vtableidx1 = (((IData)(vlSelf->instr_fadd) << 9U) 
                    | (((IData)(vlSelf->instr_fsw) 
                        << 8U) | (((IData)(vlSelf->instr_flw) 
                                   << 7U) | (((IData)(vlSelf->enabled) 
                                              << 6U) 
                                             | (((IData)(vlSelf->mem_ready) 
                                                 << 5U) 
                                                | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg) 
                                                    << 4U) 
                                                   | (IData)(vlSelf->fpu__DOT__state)))))));
    vlSelf->fpu__DOT__next_state = Vfpu__ConstPool__TABLE_h5a1b682b_0
        [__Vtableidx1];
    vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align 
        = (0xffffffffffffffULL & (((QData)((IData)(
                                                   ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                     ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                                                     : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2))) 
                                   << 0x1fU) >> (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__de_st1)));
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp 
        = (0x1ffU & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2) 
                     - (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2)));
    vlSelf->fpu__DOT__uut_fadd__DOT__te_diff = (0x1ffU 
                                                & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1) 
                                                   - (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2)));
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum = (0x7ffffffU 
                                                  & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1) 
                                                      == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2))
                                                      ? 
                                                     ((((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                         ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                                                         : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1) 
                                                       << 2U) 
                                                      + (IData)(
                                                                (vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align 
                                                                 >> 0x1dU)))
                                                      : 
                                                     ((((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                         ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2
                                                         : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1) 
                                                       << 2U) 
                                                      - (IData)(
                                                                (vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align 
                                                                 >> 0x1dU)))));
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm = (0x7ffffffU 
                                                   & ((0x100U 
                                                       & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp))
                                                       ? 
                                                      VL_SHIFTL_III(27,27,8, vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2, 
                                                                    (0xffU 
                                                                     & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2) 
                                                                        - (IData)(1U))))
                                                       : 
                                                      (vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2 
                                                       << (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2))));
    vlSelf->fpu__DOT__uut_fadd__DOT__tde = (0xffU & 
                                            ((0x100U 
                                              & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff))
                                              ? ((IData)(1U) 
                                                 + 
                                                 (~ (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff)))
                                              : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff)));
    vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm = 
        (0x7ffffffU & ((0x4000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum)
                        ? VL_SHIFTR_III(27,27,32, vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum, 1U)
                        : vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum));
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm = 
        (0x1ffffffU & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                        >> 2U) + (1U & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                         >> 1U) & (
                                                   ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                                    | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm) 
                                                   | (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                                      >> 2U))))));
    vlSelf->fpu__DOT__uut_fadd__DOT__search_leading_zeros 
        = ((0x2000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
            ? 0U : ((0x1000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                     ? 1U : ((0x800000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                              ? 2U : ((0x400000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                       ? 3U : ((0x200000U 
                                                & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                ? 4U
                                                : (
                                                   (0x100000U 
                                                    & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                    ? 5U
                                                    : 
                                                   ((0x80000U 
                                                     & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                     ? 6U
                                                     : 
                                                    ((0x40000U 
                                                      & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                      ? 7U
                                                      : 
                                                     ((0x20000U 
                                                       & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                       ? 8U
                                                       : 
                                                      ((0x10000U 
                                                        & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                        ? 9U
                                                        : 
                                                       ((0x8000U 
                                                         & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                         ? 0xaU
                                                         : 
                                                        ((0x4000U 
                                                          & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                          ? 0xbU
                                                          : 
                                                         ((0x2000U 
                                                           & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                           ? 0xcU
                                                           : 
                                                          ((0x1000U 
                                                            & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                            ? 0xdU
                                                            : 
                                                           ((0x800U 
                                                             & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                             ? 0xeU
                                                             : 
                                                            ((0x400U 
                                                              & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                              ? 0xfU
                                                              : 
                                                             ((0x200U 
                                                               & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                               ? 0x10U
                                                               : 
                                                              ((0x100U 
                                                                & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                ? 0x11U
                                                                : 
                                                               ((0x80U 
                                                                 & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                 ? 0x12U
                                                                 : 
                                                                ((0x40U 
                                                                  & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                  ? 0x13U
                                                                  : 
                                                                 ((0x20U 
                                                                   & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                   ? 0x14U
                                                                   : 
                                                                  ((0x10U 
                                                                    & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                    ? 0x15U
                                                                    : 
                                                                   ((8U 
                                                                     & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                     ? 0x16U
                                                                     : 
                                                                    ((4U 
                                                                      & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                      ? 0x17U
                                                                      : 
                                                                     ((2U 
                                                                       & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                       ? 0x18U
                                                                       : 
                                                                      ((1U 
                                                                        & vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm)
                                                                        ? 0x19U
                                                                        : 0x1bU))))))))))))))))))))))))));
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_y = (0xffU 
                                              & (((0x100U 
                                                   & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp))
                                                   ? 0U
                                                   : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp)) 
                                                 + 
                                                 (1U 
                                                  & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm 
                                                     >> 0x18U))));
}

VL_ATTR_COLD void Vfpu___024root___eval_stl(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vfpu___024root___stl_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[3U] = 1U;
        vlSelf->__Vm_traceActivity[2U] = 1U;
        vlSelf->__Vm_traceActivity[1U] = 1U;
        vlSelf->__Vm_traceActivity[0U] = 1U;
    }
}

VL_ATTR_COLD void Vfpu___024root___eval_triggers__stl(Vfpu___024root* vlSelf);

VL_ATTR_COLD bool Vfpu___024root___eval_phase__stl(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vfpu___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vfpu___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__ico(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__act(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__nba(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vfpu___024root___ctor_var_reset(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->rst_n = VL_RAND_RESET_I(1);
    vlSelf->enabled = VL_RAND_RESET_I(1);
    vlSelf->instr_flw = VL_RAND_RESET_I(1);
    vlSelf->instr_fsw = VL_RAND_RESET_I(1);
    vlSelf->instr_fadd = VL_RAND_RESET_I(1);
    vlSelf->instr_fmul = VL_RAND_RESET_I(1);
    vlSelf->instr_fdiv = VL_RAND_RESET_I(1);
    vlSelf->reg_rs1 = VL_RAND_RESET_I(32);
    vlSelf->reg_rs2 = VL_RAND_RESET_I(32);
    vlSelf->rd_addr = VL_RAND_RESET_I(5);
    vlSelf->freg_rs1 = VL_RAND_RESET_I(32);
    vlSelf->freg_rs2 = VL_RAND_RESET_I(32);
    vlSelf->frd_addr = VL_RAND_RESET_I(5);
    vlSelf->imm = VL_RAND_RESET_I(32);
    vlSelf->mem_addr = VL_RAND_RESET_I(32);
    vlSelf->mem_wdata = VL_RAND_RESET_I(32);
    vlSelf->mem_rdata = VL_RAND_RESET_I(32);
    vlSelf->mem_we = VL_RAND_RESET_I(1);
    vlSelf->mem_re = VL_RAND_RESET_I(1);
    vlSelf->mem_ready = VL_RAND_RESET_I(1);
    vlSelf->freg_wb_enable = VL_RAND_RESET_I(1);
    vlSelf->freg_wb_addr = VL_RAND_RESET_I(5);
    vlSelf->freg_wb_data = VL_RAND_RESET_I(32);
    vlSelf->reg_wb_enable = VL_RAND_RESET_I(1);
    vlSelf->reg_wb_addr = VL_RAND_RESET_I(5);
    vlSelf->reg_wb_data = VL_RAND_RESET_I(32);
    vlSelf->completed = VL_RAND_RESET_I(1);
    vlSelf->fpu_busy = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__state = VL_RAND_RESET_I(4);
    vlSelf->fpu__DOT__next_state = VL_RAND_RESET_I(4);
    vlSelf->fpu__DOT__target_frd = VL_RAND_RESET_I(5);
    vlSelf->fpu__DOT__temp_mem_addr = VL_RAND_RESET_I(32);
    vlSelf->fpu__DOT__temp_mem_wdata = VL_RAND_RESET_I(32);
    vlSelf->fpu__DOT__temp_freg_rs1 = VL_RAND_RESET_I(32);
    vlSelf->fpu__DOT__temp_freg_rs2 = VL_RAND_RESET_I(32);
    vlSelf->fpu__DOT__fadd_start = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__temp_freg_wb_enable = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__temp_freg_wb_addr = VL_RAND_RESET_I(5);
    vlSelf->fpu__DOT__temp_freg_wb_data = VL_RAND_RESET_I(32);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1 = VL_RAND_RESET_I(25);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 = VL_RAND_RESET_I(25);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__te_diff = VL_RAND_RESET_I(9);
    vlSelf->fpu__DOT__uut_fadd__DOT__tde = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1 = VL_RAND_RESET_I(23);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1 = VL_RAND_RESET_I(23);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1 = VL_RAND_RESET_I(25);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2 = VL_RAND_RESET_I(25);
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__de_st1 = VL_RAND_RESET_I(5);
    vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st1 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st1 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st1 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align = VL_RAND_RESET_Q(56);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum = VL_RAND_RESET_I(27);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm = VL_RAND_RESET_I(27);
    vlSelf->fpu__DOT__uut_fadd__DOT__search_leading_zeros = VL_RAND_RESET_I(5);
    vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2 = VL_RAND_RESET_I(5);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2 = VL_RAND_RESET_I(27);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2 = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1 = VL_RAND_RESET_I(23);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2 = VL_RAND_RESET_I(23);
    vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st2 = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp = VL_RAND_RESET_I(9);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm = VL_RAND_RESET_I(27);
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm = VL_RAND_RESET_I(25);
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_y = VL_RAND_RESET_I(8);
    vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg = VL_RAND_RESET_I(1);
    vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
