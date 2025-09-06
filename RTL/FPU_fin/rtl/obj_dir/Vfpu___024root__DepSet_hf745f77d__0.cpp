// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfpu.h for the primary calling header

#include "Vfpu__pch.h"
#include "Vfpu___024root.h"

extern const VlUnpacked<CData/*3:0*/, 1024> Vfpu__ConstPool__TABLE_h5a1b682b_0;

VL_INLINE_OPT void Vfpu___024root___ico_sequent__TOP__0(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___ico_sequent__TOP__0\n"); );
    // Init
    SData/*9:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
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
}

void Vfpu___024root___eval_ico(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vfpu___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vfpu___024root___eval_triggers__ico(Vfpu___024root* vlSelf);

bool Vfpu___024root___eval_phase__ico(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vfpu___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vfpu___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vfpu___024root___eval_act(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vfpu___024root___nba_sequent__TOP__0(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->reg_wb_enable = 0U;
    if ((1U & (~ (IData)(vlSelf->rst_n)))) {
        vlSelf->reg_wb_data = 0U;
        vlSelf->reg_wb_addr = 0U;
    }
    if (vlSelf->rst_n) {
        vlSelf->mem_re = 0U;
        vlSelf->completed = 0U;
        vlSelf->mem_we = 0U;
        vlSelf->fpu__DOT__temp_freg_wb_enable = 0U;
        if (((((((((1U == (IData)(vlSelf->fpu__DOT__state)) 
                   | (5U == (IData)(vlSelf->fpu__DOT__state))) 
                  | (6U == (IData)(vlSelf->fpu__DOT__state))) 
                 | (7U == (IData)(vlSelf->fpu__DOT__state))) 
                | (9U == (IData)(vlSelf->fpu__DOT__state))) 
               | (0xaU == (IData)(vlSelf->fpu__DOT__state))) 
              | (0xbU == (IData)(vlSelf->fpu__DOT__state))) 
             | (0xcU == (IData)(vlSelf->fpu__DOT__state)))) {
            if ((1U == (IData)(vlSelf->fpu__DOT__state))) {
                vlSelf->mem_re = 1U;
                vlSelf->mem_addr = vlSelf->fpu__DOT__temp_mem_addr;
            } else if ((5U != (IData)(vlSelf->fpu__DOT__state))) {
                if ((6U != (IData)(vlSelf->fpu__DOT__state))) {
                    if ((7U == (IData)(vlSelf->fpu__DOT__state))) {
                        vlSelf->mem_addr = vlSelf->fpu__DOT__temp_mem_addr;
                    }
                }
            }
            if ((1U != (IData)(vlSelf->fpu__DOT__state))) {
                if ((5U != (IData)(vlSelf->fpu__DOT__state))) {
                    if ((6U == (IData)(vlSelf->fpu__DOT__state))) {
                        vlSelf->completed = 1U;
                        vlSelf->fpu__DOT__temp_freg_wb_enable = 1U;
                    } else if ((7U != (IData)(vlSelf->fpu__DOT__state))) {
                        if ((9U == (IData)(vlSelf->fpu__DOT__state))) {
                            vlSelf->completed = 1U;
                        } else if ((0xaU != (IData)(vlSelf->fpu__DOT__state))) {
                            if ((0xbU != (IData)(vlSelf->fpu__DOT__state))) {
                                vlSelf->completed = 1U;
                            }
                        }
                        if ((9U != (IData)(vlSelf->fpu__DOT__state))) {
                            if ((0xaU != (IData)(vlSelf->fpu__DOT__state))) {
                                if ((0xbU != (IData)(vlSelf->fpu__DOT__state))) {
                                    vlSelf->fpu__DOT__temp_freg_wb_enable = 1U;
                                }
                            }
                        }
                    }
                    if ((6U != (IData)(vlSelf->fpu__DOT__state))) {
                        if ((7U == (IData)(vlSelf->fpu__DOT__state))) {
                            vlSelf->mem_we = 1U;
                            vlSelf->mem_wdata = vlSelf->fpu__DOT__temp_mem_wdata;
                        }
                    }
                }
                if ((5U == (IData)(vlSelf->fpu__DOT__state))) {
                    vlSelf->fpu__DOT__temp_freg_wb_addr 
                        = vlSelf->fpu__DOT__target_frd;
                    vlSelf->fpu__DOT__temp_freg_wb_data 
                        = vlSelf->mem_rdata;
                } else if ((6U != (IData)(vlSelf->fpu__DOT__state))) {
                    if ((7U != (IData)(vlSelf->fpu__DOT__state))) {
                        if ((9U != (IData)(vlSelf->fpu__DOT__state))) {
                            if ((0xaU != (IData)(vlSelf->fpu__DOT__state))) {
                                if ((0xbU == (IData)(vlSelf->fpu__DOT__state))) {
                                    if (vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg) {
                                        vlSelf->fpu__DOT__temp_freg_wb_addr 
                                            = vlSelf->fpu__DOT__target_frd;
                                        vlSelf->fpu__DOT__temp_freg_wb_data 
                                            = (((0xffU 
                                                 == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
                                                & (0xffU 
                                                   != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)))
                                                ? (0x7f800000U 
                                                   | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                       << 0x1fU) 
                                                      | (((IData)(
                                                                  (0U 
                                                                   != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)) 
                                                          << 0x16U) 
                                                         | (0x3fffffU 
                                                            & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))))
                                                : (
                                                   ((0xffU 
                                                     == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)) 
                                                    & (0xffU 
                                                       != (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)))
                                                    ? 
                                                   (0x7f800000U 
                                                    | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                                        << 0x1fU) 
                                                       | (((IData)(
                                                                   (0U 
                                                                    != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)) 
                                                           << 0x16U) 
                                                          | (0x3fffffU 
                                                             & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))))
                                                    : 
                                                   (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                                     & (0U 
                                                        != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2))
                                                     ? 
                                                    (0x7fc00000U 
                                                     | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2) 
                                                         << 0x1fU) 
                                                        | (0x3fffffU 
                                                           & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2)))
                                                     : 
                                                    (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
                                                      & (0U 
                                                         != vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1))
                                                      ? 
                                                     (0x7fc00000U 
                                                      | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1) 
                                                          << 0x1fU) 
                                                         | (0x3fffffU 
                                                            & vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1)))
                                                      : 
                                                     (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0) 
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
                                                              & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm)))))))));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if ((1U == (IData)(vlSelf->fpu__DOT__next_state))) {
            vlSelf->fpu__DOT__temp_mem_addr = (vlSelf->reg_rs1 
                                               + vlSelf->imm);
            vlSelf->fpu__DOT__target_frd = vlSelf->frd_addr;
        } else {
            if ((7U == (IData)(vlSelf->fpu__DOT__next_state))) {
                vlSelf->fpu__DOT__temp_mem_addr = (vlSelf->reg_rs1 
                                                   + vlSelf->imm);
            }
            if ((7U != (IData)(vlSelf->fpu__DOT__next_state))) {
                if ((0xaU == (IData)(vlSelf->fpu__DOT__next_state))) {
                    vlSelf->fpu__DOT__target_frd = vlSelf->frd_addr;
                }
            }
        }
        if ((1U != (IData)(vlSelf->fpu__DOT__next_state))) {
            if ((7U == (IData)(vlSelf->fpu__DOT__next_state))) {
                vlSelf->fpu__DOT__temp_mem_wdata = vlSelf->freg_rs2;
            }
        }
        vlSelf->freg_wb_enable = vlSelf->fpu__DOT__temp_freg_wb_enable;
        vlSelf->freg_wb_addr = vlSelf->fpu__DOT__temp_freg_wb_addr;
        vlSelf->freg_wb_data = vlSelf->fpu__DOT__temp_freg_wb_data;
        vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg 
            = vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st2;
    } else {
        vlSelf->mem_re = 0U;
        vlSelf->completed = 0U;
        vlSelf->mem_we = 0U;
        vlSelf->fpu__DOT__temp_freg_wb_enable = 0U;
        vlSelf->mem_addr = 0U;
        vlSelf->mem_wdata = 0U;
        vlSelf->fpu__DOT__temp_freg_wb_addr = 0U;
        vlSelf->fpu__DOT__temp_freg_wb_data = 0U;
        vlSelf->fpu__DOT__temp_mem_addr = 0U;
        vlSelf->fpu__DOT__temp_mem_wdata = 0U;
        vlSelf->fpu__DOT__target_frd = 0U;
        vlSelf->freg_wb_enable = vlSelf->fpu__DOT__temp_freg_wb_enable;
        vlSelf->freg_wb_addr = vlSelf->fpu__DOT__temp_freg_wb_addr;
        vlSelf->freg_wb_data = vlSelf->fpu__DOT__temp_freg_wb_data;
        vlSelf->fpu__DOT__uut_fadd__DOT__enable_out_reg = 0U;
    }
}

VL_INLINE_OPT void Vfpu___024root___nba_sequent__TOP__1(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___nba_sequent__TOP__1\n"); );
    // Body
    if (vlSelf->rst_n) {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2 
            = vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm;
        vlSelf->fpu__DOT__uut_fadd__DOT__de_st1 = (
                                                   (0x18U 
                                                    <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde))
                                                    ? 0x18U
                                                    : 
                                                   (0x1fU 
                                                    & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__tde)));
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1 
            = vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2 
            = vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2;
        vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2 = vlSelf->fpu__DOT__uut_fadd__DOT__search_leading_zeros;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st1 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                        >> 0x17U));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st1 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                        >> 0x17U));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2 
            = (0xffU & (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                          ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2)
                          : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1)) 
                        + (1U & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                 >> 0x1aU))));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs1 
                        >> 0x17U));
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2 
            = (0xffU & (vlSelf->fpu__DOT__temp_freg_rs2 
                        >> 0x17U));
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1 
            = vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2 
            = vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2 
            = vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1 
            = vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1 
            = (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs1);
        vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1 
            = (0x7fffffU & vlSelf->fpu__DOT__temp_freg_rs2);
    } else {
        vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm_st2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__de_st1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_st2_x2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x2 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__exp_st1_x1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x1_st1 = 0U;
        vlSelf->fpu__DOT__uut_fadd__DOT__man_init_x2_st1 = 0U;
    }
    vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2 = ((IData)(vlSelf->rst_n) 
                                                 && (1U 
                                                     & ((0x4000000U 
                                                         & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum)
                                                         ? 
                                                        (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum 
                                                         | (0U 
                                                            != 
                                                            (0x1fffffffU 
                                                             & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align))))
                                                         : 
                                                        (0U 
                                                         != 
                                                         (0x1fffffffU 
                                                          & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align))))));
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x1 
        = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1));
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st2_x2 
        = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2));
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_signi_st2 
        = ((IData)(vlSelf->rst_n) && ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                       ? (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2)
                                       : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1)));
    vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st2 
        = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st1));
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp 
        = (0x1ffU & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2) 
                     - (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__slz_st2)));
    vlSelf->fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0 
        = ((0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x1_st2)) 
           & (0xffU == (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_init_x2_st2)));
    vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1 = ((IData)(vlSelf->rst_n) 
                                                && (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2) 
                                                     > (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1)) 
                                                    | (((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1) 
                                                        <= (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2)) 
                                                       & (vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x2 
                                                          > vlSelf->fpu__DOT__uut_fadd__DOT__man_ext_x1))));
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x1 
        = ((IData)(vlSelf->rst_n) && (vlSelf->fpu__DOT__temp_freg_rs1 
                                      >> 0x1fU));
    vlSelf->fpu__DOT__uut_fadd__DOT__symbol_st1_x2 
        = ((IData)(vlSelf->rst_n) && (vlSelf->fpu__DOT__temp_freg_rs2 
                                      >> 0x1fU));
    vlSelf->fpu__DOT__uut_fadd__DOT__enable_in_st1 
        = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->fpu__DOT__fadd_start));
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
    vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm = 
        (0x1ffffffU & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                        >> 2U) + (1U & ((vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                         >> 1U) & (
                                                   ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__stck_st2) 
                                                    | vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm) 
                                                   | (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_norm 
                                                      >> 2U))))));
    vlSelf->fpu__DOT__uut_fadd__DOT__man_insigni_align 
        = (0xffffffffffffffULL & (((QData)((IData)(
                                                   ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__sel_st1)
                                                     ? vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x1
                                                     : vlSelf->fpu__DOT__uut_fadd__DOT__man_st1_x2))) 
                                   << 0x1fU) >> (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__de_st1)));
    vlSelf->fpu__DOT__uut_fadd__DOT__exp_y = (0xffU 
                                              & (((0x100U 
                                                   & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp))
                                                   ? 0U
                                                   : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_temp)) 
                                                 + 
                                                 (1U 
                                                  & (vlSelf->fpu__DOT__uut_fadd__DOT__man_y_finorm 
                                                     >> 0x18U))));
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
    vlSelf->fpu__DOT__uut_fadd__DOT__man_pre_norm = 
        (0x7ffffffU & ((0x4000000U & vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum)
                        ? VL_SHIFTR_III(27,27,32, vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum, 1U)
                        : vlSelf->fpu__DOT__uut_fadd__DOT__man_y_sum));
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
}

VL_INLINE_OPT void Vfpu___024root___nba_sequent__TOP__2(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___nba_sequent__TOP__2\n"); );
    // Init
    SData/*9:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
    if (vlSelf->rst_n) {
        if ((1U != (IData)(vlSelf->fpu__DOT__next_state))) {
            if ((7U != (IData)(vlSelf->fpu__DOT__next_state))) {
                if ((0xaU == (IData)(vlSelf->fpu__DOT__next_state))) {
                    vlSelf->fpu__DOT__temp_freg_rs1 
                        = vlSelf->freg_rs1;
                    vlSelf->fpu__DOT__temp_freg_rs2 
                        = vlSelf->freg_rs2;
                }
            }
        }
        vlSelf->fpu__DOT__fadd_start = 0U;
        if (((((((((1U == (IData)(vlSelf->fpu__DOT__state)) 
                   | (5U == (IData)(vlSelf->fpu__DOT__state))) 
                  | (6U == (IData)(vlSelf->fpu__DOT__state))) 
                 | (7U == (IData)(vlSelf->fpu__DOT__state))) 
                | (9U == (IData)(vlSelf->fpu__DOT__state))) 
               | (0xaU == (IData)(vlSelf->fpu__DOT__state))) 
              | (0xbU == (IData)(vlSelf->fpu__DOT__state))) 
             | (0xcU == (IData)(vlSelf->fpu__DOT__state)))) {
            if ((1U != (IData)(vlSelf->fpu__DOT__state))) {
                if ((5U != (IData)(vlSelf->fpu__DOT__state))) {
                    if ((6U != (IData)(vlSelf->fpu__DOT__state))) {
                        if ((7U != (IData)(vlSelf->fpu__DOT__state))) {
                            if ((9U != (IData)(vlSelf->fpu__DOT__state))) {
                                if ((0xaU == (IData)(vlSelf->fpu__DOT__state))) {
                                    vlSelf->fpu__DOT__fadd_start = 1U;
                                }
                            }
                        }
                    }
                }
            }
        }
        vlSelf->fpu__DOT__state = vlSelf->fpu__DOT__next_state;
    } else {
        vlSelf->fpu__DOT__temp_freg_rs1 = 0U;
        vlSelf->fpu__DOT__temp_freg_rs2 = 0U;
        vlSelf->fpu__DOT__fadd_start = 0U;
        vlSelf->fpu__DOT__state = 0U;
    }
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
    vlSelf->fpu__DOT__uut_fadd__DOT__te_diff = (0x1ffU 
                                                & ((IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x1) 
                                                   - (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__exp_norm_x2)));
    vlSelf->fpu__DOT__uut_fadd__DOT__tde = (0xffU & 
                                            ((0x100U 
                                              & (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff))
                                              ? ((IData)(1U) 
                                                 + 
                                                 (~ (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff)))
                                              : (IData)(vlSelf->fpu__DOT__uut_fadd__DOT__te_diff)));
    vlSelf->fpu_busy = (0U != (IData)(vlSelf->fpu__DOT__state));
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
}

void Vfpu___024root___eval_nba(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vfpu___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vfpu___024root___nba_sequent__TOP__1(vlSelf);
        vlSelf->__Vm_traceActivity[2U] = 1U;
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vfpu___024root___nba_sequent__TOP__2(vlSelf);
        vlSelf->__Vm_traceActivity[3U] = 1U;
    }
}

void Vfpu___024root___eval_triggers__act(Vfpu___024root* vlSelf);

bool Vfpu___024root___eval_phase__act(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vfpu___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vfpu___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vfpu___024root___eval_phase__nba(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vfpu___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__ico(Vfpu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__nba(Vfpu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfpu___024root___dump_triggers__act(Vfpu___024root* vlSelf);
#endif  // VL_DEBUG

void Vfpu___024root___eval(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelf->__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vfpu___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("fpu.v", 3, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vfpu___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vfpu___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("fpu.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vfpu___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("fpu.v", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vfpu___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vfpu___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vfpu___024root___eval_debug_assertions(Vfpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfpu___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
    if (VL_UNLIKELY((vlSelf->enabled & 0xfeU))) {
        Verilated::overWidthError("enabled");}
    if (VL_UNLIKELY((vlSelf->instr_flw & 0xfeU))) {
        Verilated::overWidthError("instr_flw");}
    if (VL_UNLIKELY((vlSelf->instr_fsw & 0xfeU))) {
        Verilated::overWidthError("instr_fsw");}
    if (VL_UNLIKELY((vlSelf->instr_fadd & 0xfeU))) {
        Verilated::overWidthError("instr_fadd");}
    if (VL_UNLIKELY((vlSelf->instr_fmul & 0xfeU))) {
        Verilated::overWidthError("instr_fmul");}
    if (VL_UNLIKELY((vlSelf->instr_fdiv & 0xfeU))) {
        Verilated::overWidthError("instr_fdiv");}
    if (VL_UNLIKELY((vlSelf->rd_addr & 0xe0U))) {
        Verilated::overWidthError("rd_addr");}
    if (VL_UNLIKELY((vlSelf->frd_addr & 0xe0U))) {
        Verilated::overWidthError("frd_addr");}
    if (VL_UNLIKELY((vlSelf->mem_ready & 0xfeU))) {
        Verilated::overWidthError("mem_ready");}
}
#endif  // VL_DEBUG
