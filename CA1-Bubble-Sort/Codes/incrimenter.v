`timescale 1ns/1ns
module Incrementer(input clk, rst, incrementer_en, input [7:0] data_in,output reg [7:0] data_out);
  
    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 4'b0000; // Reset to 0
        else if (incrementer_en)
            data_out <= data_out + 1; // Increment by 1
    end

 endmodule