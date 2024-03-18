`timescale 1ns/1ns
module registerFile (input clk,input [4:0] A1,A2,A3,input [31:0] WD3,input reg writeEN,output reg [31:0] RD1, RD2);
    reg [31:0] registers [31:0];
    genvar  i;
    generate
            for (i = 0; i<32 ; i=i+1) begin:setZero
            assign registers[i] = 32'b0;
        end
    endgenerate

    always @(posedge clk) begin
        if (writeEN)
            registers[A3] <= WD3;
    end

    assign RD1 = registers[A1];
    assign RD2 = registers[A2];

endmodule
