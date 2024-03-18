module immExtendor(input [31:0] instruction,input [2:0] ImmSrc,output reg [31:0] ImmExt);

always @(*) begin
    case (ImmSrc)
        3'b000: // I-Type  (signed)
            ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        3'b001: // S-Type  (signed)
            ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        3'b010: // B-Type  (signed)
            ImmExt = {{19{instruction[31]}}, instruction[31],instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        3'b011: // U-Type 
            ImmExt = {instruction[31:12], 12'b0};
        3'b100: // J-Type  (signed)
            ImmExt = {{12{instruction[20]}}, instruction[19:12], instruction[20], instruction[30:21],1'b0};
        default:
            ImmExt = 32'bz;
    endcase
end

endmodule
