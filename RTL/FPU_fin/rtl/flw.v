//====================
// State Encoding
//====================
typedef enum logic [3:0] {
    NONE            = 4'd0,

    // FLW states
    FLW_MEM_ACCESS  = 4'd1,
    FLW_WAIT_READY  = 4'd2,
    FLW_WAIT_DATA   = 4'd3,
    FLW_STABILIZE   = 4'd4,
    FLW_SAMPLE      = 4'd5,
    FLW_COMPLETE    = 4'd6,

    // FSW states
    FSW_MEM_ACCESS  = 4'd7,
    FSW_WAIT_READY  = 4'd8,
    FSW_COMPLETE    = 4'd9

} fsm_state_t;

//====================
// State Registers
//====================
fsm_state_t state, next_state;

//====================
// State Transition (Combinational)
//====================
always_comb begin
    next_state = state;

    case (state)
        // FLW flow
        FLW_MEM_ACCESS:  next_state = FLW_WAIT_READY;

        FLW_WAIT_READY: begin
            if (mem_ready)
                next_state = FLW_WAIT_DATA;
        end

        FLW_WAIT_DATA:   next_state = FLW_STABILIZE;

        FLW_STABILIZE:   next_state = FLW_SAMPLE;

        FLW_SAMPLE:      next_state = FLW_COMPLETE;

        FLW_COMPLETE:    next_state = NONE;

        // FSW flow
        FSW_MEM_ACCESS:  next_state = FSW_WAIT_READY;

        FSW_WAIT_READY: begin
            if (mem_ready)
                next_state = FSW_COMPLETE;
        end

        FSW_COMPLETE:    next_state = NONE;

        default:         next_state = NONE;
    endcase
end

//====================
// State Update (Sequential)
//====================
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= NONE;
    else
        state <= next_state;
end

//====================
// State Behavior (Combinational or Sequential)
//====================
always_comb begin
    // Default signal assignments
    mem_re               = 1'b0;
    mem_we               = 1'b0;
    mem_addr             = 32'd0;
    mem_wdata            = 32'd0;
    temp_mem_addr        = 32'd0;
    temp_mem_wdata       = 32'd0;
    temp_freg_wb_data    = 32'd0;
    temp_freg_wb_enable  = 1'b0;
    temp_freg_wb_addr    = 5'd0;
    completed            = 1'b0;

    case (state)
        // FLW 行為
        FLW_MEM_ACCESS: begin
            temp_mem_addr <= reg_rs1 + imm;
            target_frd    <= frd_addr;
        end

        FLW_WAIT_READY: begin
            mem_re   = 1'b1;
            mem_addr = temp_mem_addr;
        end

        FLW_SAMPLE: begin
            temp_freg_wb_addr <= target_frd;
            temp_freg_wb_data <= mem_rdata;
        end

        FLW_COMPLETE: begin
            temp_freg_wb_enable <= 1'b1;
            completed           <= 1'b1;
        end

        // FSW 行為
        FSW_MEM_ACCESS: begin
            temp_mem_addr  <= reg_rs1 + imm;
            temp_mem_wdata <= freg_rs2;
        end

        FSW_WAIT_READY: begin
            mem_we    = 1'b1;
            mem_addr  = temp_mem_addr;
            mem_wdata = temp_mem_wdata;
        end

        FSW_COMPLETE: begin
            completed = 1'b1;
        end

        default: begin
            // 保持預設狀態
        end
    endcase
end
