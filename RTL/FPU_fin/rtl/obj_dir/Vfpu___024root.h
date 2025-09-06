// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vfpu.h for the primary calling header

#ifndef VERILATED_VFPU___024ROOT_H_
#define VERILATED_VFPU___024ROOT_H_  // guard

#include "verilated.h"


class Vfpu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vfpu___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(rst_n,0,0);
        VL_IN8(enabled,0,0);
        VL_IN8(instr_flw,0,0);
        VL_IN8(instr_fsw,0,0);
        VL_IN8(instr_fadd,0,0);
        VL_IN8(instr_fmul,0,0);
        VL_IN8(instr_fdiv,0,0);
        VL_IN8(rd_addr,4,0);
        VL_IN8(frd_addr,4,0);
        VL_OUT8(mem_we,0,0);
        VL_OUT8(mem_re,0,0);
        VL_IN8(mem_ready,0,0);
        VL_OUT8(freg_wb_enable,0,0);
        VL_OUT8(freg_wb_addr,4,0);
        VL_OUT8(reg_wb_enable,0,0);
        VL_OUT8(reg_wb_addr,4,0);
        VL_OUT8(completed,0,0);
        VL_OUT8(fpu_busy,0,0);
        CData/*3:0*/ fpu__DOT__state;
        CData/*3:0*/ fpu__DOT__next_state;
        CData/*4:0*/ fpu__DOT__target_frd;
        CData/*0:0*/ fpu__DOT__fadd_start;
        CData/*0:0*/ fpu__DOT__temp_freg_wb_enable;
        CData/*4:0*/ fpu__DOT__temp_freg_wb_addr;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_norm_x1;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_norm_x2;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__tde;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__symbol_st1_x1;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__symbol_st1_x2;
        CData/*4:0*/ fpu__DOT__uut_fadd__DOT__de_st1;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__sel_st1;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_init_x1_st1;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_init_x2_st1;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_st1_x1;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_st1_x2;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__enable_in_st1;
        CData/*4:0*/ fpu__DOT__uut_fadd__DOT__search_leading_zeros;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__stck_st2;
        CData/*4:0*/ fpu__DOT__uut_fadd__DOT__slz_st2;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_pre_norm_st2;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__symbol_signi_st2;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__symbol_st2_x1;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__symbol_st2_x2;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_init_x1_st2;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_init_x2_st2;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__enable_in_st2;
        CData/*7:0*/ fpu__DOT__uut_fadd__DOT__exp_y;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT__enable_out_reg;
        CData/*0:0*/ fpu__DOT__uut_fadd__DOT____VdfgTmp_h6f4398df__0;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VicoFirstIteration;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
        CData/*0:0*/ __VactContinue;
        SData/*8:0*/ fpu__DOT__uut_fadd__DOT__te_diff;
        SData/*8:0*/ fpu__DOT__uut_fadd__DOT__exp_norm_temp;
        VL_IN(reg_rs1,31,0);
        VL_IN(reg_rs2,31,0);
        VL_IN(freg_rs1,31,0);
        VL_IN(freg_rs2,31,0);
        VL_IN(imm,31,0);
        VL_OUT(mem_addr,31,0);
        VL_OUT(mem_wdata,31,0);
    };
    struct {
        VL_IN(mem_rdata,31,0);
        VL_OUT(freg_wb_data,31,0);
        VL_OUT(reg_wb_data,31,0);
        IData/*31:0*/ fpu__DOT__temp_mem_addr;
        IData/*31:0*/ fpu__DOT__temp_mem_wdata;
        IData/*31:0*/ fpu__DOT__temp_freg_rs1;
        IData/*31:0*/ fpu__DOT__temp_freg_rs2;
        IData/*31:0*/ fpu__DOT__temp_freg_wb_data;
        IData/*24:0*/ fpu__DOT__uut_fadd__DOT__man_ext_x1;
        IData/*24:0*/ fpu__DOT__uut_fadd__DOT__man_ext_x2;
        IData/*22:0*/ fpu__DOT__uut_fadd__DOT__man_init_x1_st1;
        IData/*22:0*/ fpu__DOT__uut_fadd__DOT__man_init_x2_st1;
        IData/*24:0*/ fpu__DOT__uut_fadd__DOT__man_st1_x1;
        IData/*24:0*/ fpu__DOT__uut_fadd__DOT__man_st1_x2;
        IData/*26:0*/ fpu__DOT__uut_fadd__DOT__man_y_sum;
        IData/*26:0*/ fpu__DOT__uut_fadd__DOT__man_pre_norm;
        IData/*26:0*/ fpu__DOT__uut_fadd__DOT__man_pre_norm_st2;
        IData/*22:0*/ fpu__DOT__uut_fadd__DOT__man_st2_x1;
        IData/*22:0*/ fpu__DOT__uut_fadd__DOT__man_st2_x2;
        IData/*26:0*/ fpu__DOT__uut_fadd__DOT__man_y_norm;
        IData/*24:0*/ fpu__DOT__uut_fadd__DOT__man_y_finorm;
        IData/*31:0*/ __VactIterCount;
        QData/*55:0*/ fpu__DOT__uut_fadd__DOT__man_insigni_align;
        VlUnpacked<CData/*0:0*/, 4> __Vm_traceActivity;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vfpu__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vfpu___024root(Vfpu__Syms* symsp, const char* v__name);
    ~Vfpu___024root();
    VL_UNCOPYABLE(Vfpu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
