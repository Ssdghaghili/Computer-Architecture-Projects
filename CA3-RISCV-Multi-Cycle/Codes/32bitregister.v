`timescale 1ns/1ns
module register32bit (input clk,reset, writeEn ,input [31:0] data_in,output reg [31:0] data_out);
reg [31:0] data;
assign data_out = data;
always @(posedge clk) begin
    if (reset == 1'b1)
        data <= 32'b0;
    else if (writeEn)
        data <= data_in;
end
endmodule
