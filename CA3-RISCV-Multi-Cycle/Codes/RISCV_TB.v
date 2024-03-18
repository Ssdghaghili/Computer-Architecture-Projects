`timescale 1ns/1ns

module RISCV_TB();

    reg clk = 0;
    reg rst = 0;
    wire [31:0] controllerSignal;

    RISCV dut(.clk(clk), .rst(rst), .currentInstruction(controllerSignal));

    always #5 clk = ~clk;
    initial begin
        clk = 1;
        rst = 1;
        #5 rst = 0;
        #3200 $stop;
    end
endmodule
