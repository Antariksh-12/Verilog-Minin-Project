module data_memory (
    input        clk, we,
    input  [3:0] addr,
    input  [7:0] din,
    output [7:0] dout
);
    reg [7:0] mem [0:15];
    integer i;
    initial for (i = 0; i < 16; i = i + 1) mem[i] = 8'h00;

    always @(posedge clk)
        if (we) mem[addr] <= din;

    assign dout = mem[addr];
endmodule