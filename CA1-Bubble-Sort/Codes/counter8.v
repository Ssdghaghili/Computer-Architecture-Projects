`timescale 1ns/1ns
module counter5bit_1 (
  input wire EN,
  input wire CLK,
  input wire RST,
  input wire LOAD,
  input wire [4:0] P_IN,
  output wire [4:0] P_OUT,
  output wire C_OUT
);
  reg [4:0] counter;

  always @(posedge CLK or posedge RST) begin
    if (RST)
      counter <= 5'b0;
    else if (EN)
      counter <= 1 + counter;
    else if (LOAD)
      counter <= P_IN;
  end

  assign P_OUT = counter;
  assign C_OUT = counter[4];
endmodule