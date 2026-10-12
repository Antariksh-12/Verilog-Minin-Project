`timescale 1ns/1ps
module mini_processor_tb;
    reg clk = 0, rst = 1;
    wire halted;
    wire [7:0] acc_out;

    mini_processor dut (.clk(clk), .rst(rst), .halted(halted), .acc_out(acc_out));

    always #5 clk = ~clk;                 // 10 ns clock

    initial begin
        $dumpfile("wave.vcd");
       $dumpvars(0, mini_processor_tb);
        #12 rst = 0;                      // release reset between clock edges
        wait (halted);
        #10;
        $display("ACC = %0d, MEM[10] = %0d", acc_out, dut.u_dmem.mem[10]);
        if (dut.u_dmem.mem[10] == 8'd6) $display("PASS");
        else                            $display("FAIL");
        $finish;
    end

    initial begin #2000 $display("TIMEOUT"); $finish; end   // safety net
endmodule