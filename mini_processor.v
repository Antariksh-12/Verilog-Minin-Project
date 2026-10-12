module mini_processor (
    input  clk, rst,
    output halted,
    output [7:0] acc_out
);
    wire [3:0] pc, opcode, operand;
    wire [7:0] instr, acc, alu_result, mem_dout, acc_din;
    wire       ir_load, pc_inc, pc_load, acc_load, mem_we, carry, zero;
    wire [2:0] alu_op;
    wire [1:0] acc_src;

    program_counter u_pc (.clk(clk), .rst(rst), .inc(pc_inc), .load(pc_load),
                          .load_val(operand), .pc(pc));

    instruction_memory u_imem (.addr(pc), .instr(instr));

    instruction_register u_ir (.clk(clk), .rst(rst), .ir_load(ir_load),
                               .instr_in(instr), .opcode(opcode), .operand(operand));

    control_unit u_cu (.clk(clk), .rst(rst), .opcode(opcode),
                       .ir_load(ir_load), .pc_inc(pc_inc), .pc_load(pc_load),
                       .acc_load(acc_load), .mem_we(mem_we), .halted(halted),
                       .alu_op(alu_op), .acc_src(acc_src));

    alu u_alu (.a(acc), .b({4'b0000, operand}), .op(alu_op),
               .result(alu_result), .carry(carry), .zero(zero));

    data_memory u_dmem (.clk(clk), .we(mem_we), .addr(operand),
                        .din(acc), .dout(mem_dout));

    // Accumulator input mux
    assign acc_din = (acc_src == 2'd1) ? {4'b0000, operand} :
                     (acc_src == 2'd2) ? mem_dout :
                                         alu_result;

    register_unit u_acc (.clk(clk), .rst(rst), .load(acc_load),
                         .din(acc_din), .acc(acc));

    assign acc_out = acc;
endmodule