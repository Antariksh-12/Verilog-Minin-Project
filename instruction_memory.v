module instruction_memory (
    input  [3:0] addr,
    output [7:0] instr
);
    reg [7:0] mem [0:15];
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) mem[i] = 8'h00;  // NOP
        mem[0] = 8'h15;  // LDI   5
        mem[1] = 8'h43;  // ADD   3
        mem[2] = 8'h52;  // SUB   2
        mem[3] = 8'h3A;  // STORE 10
        mem[4] = 8'hF0;  // HALT
    end
    assign instr = mem[addr];
endmodule