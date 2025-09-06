// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary model header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef VERILATED_VFPU_H_
#define VERILATED_VFPU_H_  // guard

#include "verilated.h"

class Vfpu__Syms;
class Vfpu___024root;
class VerilatedVcdC;

// This class is the main interface to the Verilated model
class alignas(VL_CACHE_LINE_BYTES) Vfpu VL_NOT_FINAL : public VerilatedModel {
  private:
    // Symbol table holding complete model state (owned by this class)
    Vfpu__Syms* const vlSymsp;

  public:

    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(&clk,0,0);
    VL_IN8(&rst_n,0,0);
    VL_IN8(&enabled,0,0);
    VL_IN8(&instr_flw,0,0);
    VL_IN8(&instr_fsw,0,0);
    VL_IN8(&instr_fadd,0,0);
    VL_IN8(&instr_fmul,0,0);
    VL_IN8(&instr_fdiv,0,0);
    VL_IN8(&rd_addr,4,0);
    VL_IN8(&frd_addr,4,0);
    VL_OUT8(&mem_we,0,0);
    VL_OUT8(&mem_re,0,0);
    VL_IN8(&mem_ready,0,0);
    VL_OUT8(&freg_wb_enable,0,0);
    VL_OUT8(&freg_wb_addr,4,0);
    VL_OUT8(&reg_wb_enable,0,0);
    VL_OUT8(&reg_wb_addr,4,0);
    VL_OUT8(&completed,0,0);
    VL_OUT8(&fpu_busy,0,0);
    VL_IN(&reg_rs1,31,0);
    VL_IN(&reg_rs2,31,0);
    VL_IN(&freg_rs1,31,0);
    VL_IN(&freg_rs2,31,0);
    VL_IN(&imm,31,0);
    VL_OUT(&mem_addr,31,0);
    VL_OUT(&mem_wdata,31,0);
    VL_IN(&mem_rdata,31,0);
    VL_OUT(&freg_wb_data,31,0);
    VL_OUT(&reg_wb_data,31,0);

    // CELLS
    // Public to allow access to /* verilator public */ items.
    // Otherwise the application code can consider these internals.

    // Root instance pointer to allow access to model internals,
    // including inlined /* verilator public_flat_* */ items.
    Vfpu___024root* const rootp;

    // CONSTRUCTORS
    /// Construct the model; called by application code
    /// If contextp is null, then the model will use the default global context
    /// If name is "", then makes a wrapper with a
    /// single model invisible with respect to DPI scope names.
    explicit Vfpu(VerilatedContext* contextp, const char* name = "TOP");
    explicit Vfpu(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    virtual ~Vfpu();
  private:
    VL_UNCOPYABLE(Vfpu);  ///< Copying not allowed

  public:
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    /// Are there scheduled events to handle?
    bool eventsPending();
    /// Returns time at next time slot. Aborts if !eventsPending()
    uint64_t nextTimeSlot();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    /// Retrieve name of this model instance (as passed to constructor).
    const char* name() const;

    // Abstract methods from VerilatedModel
    const char* hierName() const override final;
    const char* modelName() const override final;
    unsigned threads() const override final;
    /// Prepare for cloning the model at the process level (e.g. fork in Linux)
    /// Release necessary resources. Called before cloning.
    void prepareClone() const;
    /// Re-init after cloning the model at the process level (e.g. fork in Linux)
    /// Re-allocate necessary resources. Called after cloning.
    void atClone() const;
    std::unique_ptr<VerilatedTraceConfig> traceConfig() const override final;
};

#endif  // guard
