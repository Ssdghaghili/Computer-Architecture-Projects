`timescale 1ns/1ns
module registerFileTB();
    reg clk = 0;
    reg [4:0] A1,A2,A3;
    reg [31:0] WD3;
    reg writeEN;
    wire [31:0] RD1, RD2;
    registerFile dut (.clk(clk), .A1(A1),.A2(A2),.A3(A3),.WD3(WD3),.writeEN(writeEN),.RD1(RD1),.RD2(RD2));

    always #5 clk <= ~clk;
    initial begin
        A1 = 0;
        A2 = 1;
        A3 = 2;
        WD3 = 32'h12345678;
        writeEN = 1;

        #10 A1 = 5;
        A2 = 2;
        A3 = 10;
        WD3 = 32'h87654321;
        writeEN = 0;

        #10 A1 = 2;
        A2 = 10;
        A3 = 25;
        WD3 = 32'h81010014;
        writeEN = 1;
        #10 $stop;
    end
endmodule
