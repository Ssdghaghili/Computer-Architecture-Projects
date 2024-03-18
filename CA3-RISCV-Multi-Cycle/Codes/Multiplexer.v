`timescale 1ns/1ns
module mux4to1 (input [31:0] data1 , data2 , data3 , data4,input [1:0] sel,output reg [31:0] out);
always @(*) begin
  case (sel)
    2'b00: out <= data1;
    2'b01: out <= data2;
    2'b10: out <= data3;
    2'b11: out <= data4;
  endcase
end
endmodule

module mux2to1 (input [31:0] data1 , data2 , input sel,output reg [31:0] out);

always @(*) begin
    if (sel == 1'b0)  out <= data1;
    else
    out <= data2;
end
endmodule
