module register8bit(input[7:0] parallel_in, input clk, rst, register8bit_enable,reg8bit_load, output reg [7:0] parallel_out);
always @(posedge clk or posedge rst) begin
        if (rst)
            parallel_out <= 8'b00000000; // Reset to 0
        else if (register8bit_enable) begin
            if (reg8bit_load)
                parallel_out <= parallel_in; // Load data_in
        end
    end
endmodule