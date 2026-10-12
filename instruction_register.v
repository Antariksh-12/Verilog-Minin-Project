module instruction_register (
    input        clk, rst, ir_load,
    input  [7:0] instr_in,
    output [3:0] opcode,
    output [3:0] operand
);
    reg [7:0] ir;
    always @(posedge clk or posedge rst) begin
        if (rst)          ir <= 8'b0;
        else if (ir_load) ir <= instr_in;
    end
    assign opcode  = ir[7:4];
    assign operand = ir[3:0];
endmodule