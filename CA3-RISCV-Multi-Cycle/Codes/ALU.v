`timescale 1ns/1ns

module ALU (input signed [31:0] A, B,input [2:0] ALU_control,output reg [31:0] resault,output reg zero);

always @(*) begin

   zero <= 1'b0;
  case (ALU_control)
    3'b000: resault <= A + B; // add
    3'b001: resault <= A - B; // sub
    3'b010: resault <= A & B; // and
    3'b011: resault <= A | B; //or
    3'b100: begin //xor and beq
      resault <= A ^ B;
      if(A == B)
        zero <= 1'b1;
    end

    3'b101: begin //bne , lui
      resault <= B;
      if(A != B)
        zero <= 1'b1;
      end

    3'b110: begin //blt , slt , slti
    
      if(A < B)begin
        zero <= 1'b1;
        resault <=32'd1;
      end
      else
        resault = 32'b0;
      end

    3'b111: begin //bge

      if(A >= B)
        zero <= 1'b1;
      end

    default: resault <= B; // INVALID OPERATION
  endcase

end
endmodule
