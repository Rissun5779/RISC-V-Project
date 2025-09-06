// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vfpu__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vfpu::Vfpu(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vfpu__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , enabled{vlSymsp->TOP.enabled}
    , instr_flw{vlSymsp->TOP.instr_flw}
    , instr_fsw{vlSymsp->TOP.instr_fsw}
    , instr_fadd{vlSymsp->TOP.instr_fadd}
    , instr_fmul{vlSymsp->TOP.instr_fmul}
    , instr_fdiv{vlSymsp->TOP.instr_fdiv}
    , rd_addr{vlSymsp->TOP.rd_addr}
    , frd_addr{vlSymsp->TOP.frd_addr}
    , mem_we{vlSymsp->TOP.mem_we}
    , mem_re{vlSymsp->TOP.mem_re}
    , mem_ready{vlSymsp->TOP.mem_ready}
    , freg_wb_enable{vlSymsp->TOP.freg_wb_enable}
    , freg_wb_addr{vlSymsp->TOP.freg_wb_addr}
    , reg_wb_enable{vlSymsp->TOP.reg_wb_enable}
    , reg_wb_addr{vlSymsp->TOP.reg_wb_addr}
    , completed{vlSymsp->TOP.completed}
    , fpu_busy{vlSymsp->TOP.fpu_busy}
    , reg_rs1{vlSymsp->TOP.reg_rs1}
    , reg_rs2{vlSymsp->TOP.reg_rs2}
    , freg_rs1{vlSymsp->TOP.freg_rs1}
    , freg_rs2{vlSymsp->TOP.freg_rs2}
    , imm{vlSymsp->TOP.imm}
    , mem_addr{vlSymsp->TOP.mem_addr}
    , mem_wdata{vlSymsp->TOP.mem_wdata}
    , mem_rdata{vlSymsp->TOP.mem_rdata}
    , freg_wb_data{vlSymsp->TOP.freg_wb_data}
    , reg_wb_data{vlSymsp->TOP.reg_wb_data}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vfpu::Vfpu(const char* _vcname__)
    : Vfpu(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vfpu::~Vfpu() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vfpu___024root___eval_debug_assertions(Vfpu___024root* vlSelf);
#endif  // VL_DEBUG
void Vfpu___024root___eval_static(Vfpu___024root* vlSelf);
void Vfpu___024root___eval_initial(Vfpu___024root* vlSelf);
void Vfpu___024root___eval_settle(Vfpu___024root* vlSelf);
void Vfpu___024root___eval(Vfpu___024root* vlSelf);

void Vfpu::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vfpu::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vfpu___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vfpu___024root___eval_static(&(vlSymsp->TOP));
        Vfpu___024root___eval_initial(&(vlSymsp->TOP));
        Vfpu___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vfpu___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vfpu::eventsPending() { return false; }

uint64_t Vfpu::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vfpu::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vfpu___024root___eval_final(Vfpu___024root* vlSelf);

VL_ATTR_COLD void Vfpu::final() {
    Vfpu___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vfpu::hierName() const { return vlSymsp->name(); }
const char* Vfpu::modelName() const { return "Vfpu"; }
unsigned Vfpu::threads() const { return 1; }
void Vfpu::prepareClone() const { contextp()->prepareClone(); }
void Vfpu::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vfpu::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vfpu___024root__trace_decl_types(VerilatedVcd* tracep);

void Vfpu___024root__trace_init_top(Vfpu___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vfpu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vfpu___024root*>(voidSelf);
    Vfpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vfpu___024root__trace_decl_types(tracep);
    Vfpu___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vfpu___024root__trace_register(Vfpu___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vfpu::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vfpu::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vfpu___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
