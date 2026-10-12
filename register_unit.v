module register_unit (
    input        clk, rst, load,
    input  [7:0] din,
    output reg [7:0] acc
);
    always @(posedge clk or posedge rst) begin
        if (rst)       acc <= 8'b0;
        else if (load) acc <= din;
    end
endmodule