module alu (
    input  [7:0] a, b,
    input  [2:0] op,
    output reg [7:0] result,
    output reg       carry,
    output           zero
);
    always @(*) begin
        carry  = 1'b0;
        result = 8'b0;
        case (op)
            3'b000: {carry, result} = {1'b0, a} + {1'b0, b};  // ADD
            3'b001: {carry, result} = {1'b0, a} - {1'b0, b};  // SUB (carry = borrow)
            3'b010: result = a & b;                           // AND
            3'b011: result = a | b;                           // OR
            3'b100: result = a ^ b;                           // XOR
            default: result = 8'b0;
        endcase
    end
    assign zero = (result == 8'b0);
endmodule