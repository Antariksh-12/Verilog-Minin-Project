module control_unit (
    input        clk, rst,
    input  [3:0] opcode,
    output reg   ir_load, pc_inc, pc_load,
    output reg   acc_load, mem_we, halted,
    output reg [2:0] alu_op,
    output reg [1:0] acc_src      // 0 = ALU, 1 = immediate, 2 = data memory
);
    localparam FETCH = 2'd0, DECODE = 2'd1, EXECUTE = 2'd2, HALT_S = 2'd3;

    localparam NOP = 4'h0, LDI = 4'h1, LOAD = 4'h2, STORE = 4'h3,
               ADD = 4'h4, SUB = 4'h5, AND_ = 4'h6, OR_  = 4'h7,
               XOR_ = 4'h8, JMP = 4'h9, HALT = 4'hF;

    reg [1:0] state, next_state;

    // 1) State register
    always @(posedge clk or posedge rst) begin
        if (rst) state <= FETCH;
        else     state <= next_state;
    end

    // 2) Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            FETCH:   next_state = DECODE;
            DECODE:  next_state = (opcode == HALT) ? HALT_S : EXECUTE;
            EXECUTE: next_state = FETCH;
            HALT_S:  next_state = HALT_S;
        endcase
    end

    // 3) Output logic (defaults first, then override)
    always @(*) begin
        ir_load = 0; pc_inc = 0; pc_load = 0;
        acc_load = 0; mem_we = 0; halted = 0;
        alu_op = 3'b000; acc_src = 2'd0;

        case (state)
            FETCH:  ir_load = 1;
            DECODE: pc_inc  = 1;
            EXECUTE: begin
                case (opcode)
                    LDI:   begin acc_load = 1; acc_src = 2'd1; end
                    LOAD:  begin acc_load = 1; acc_src = 2'd2; end
                    STORE: mem_we = 1;
                    ADD:   begin acc_load = 1; alu_op = 3'b000; end
                    SUB:   begin acc_load = 1; alu_op = 3'b001; end
                    AND_:  begin acc_load = 1; alu_op = 3'b010; end
                    OR_:   begin acc_load = 1; alu_op = 3'b011; end
                    XOR_:  begin acc_load = 1; alu_op = 3'b100; end
                    JMP:   pc_load = 1;
                    default: ; // NOP
                endcase
            end
            HALT_S: halted = 1;
        endcase
    end
endmodule