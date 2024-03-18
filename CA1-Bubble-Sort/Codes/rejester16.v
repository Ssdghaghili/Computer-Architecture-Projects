module register16bit(input[15:0] parallel_in, input clk, rst, register16bit_enable,reg16bit_load, output reg [15:0] parallel_out);
always @(posedge clk or posedge rst) begin
        if (rst)
            parallel_out <= 16'b0000000000000000; // Reset to 0
        else if (register16bit_enable) begin
            if (reg16bit_load)
                parallel_out <= parallel_in; // Load data_in
        end
    end
endmodule