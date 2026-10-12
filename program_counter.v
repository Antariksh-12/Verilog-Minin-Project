module program_counter (
    input        clk, rst, inc, load,
    input  [3:0] load_val,
    output reg [3:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst)       pc <= 4'b0;
        else if (load) pc <= load_val;   // JMP
        else if (inc)  pc <= pc + 1'b1;
    end
endmodule