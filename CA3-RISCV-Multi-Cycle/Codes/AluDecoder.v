`timescale 1ns/1ps

module AluDecoder (input  [2:0] func3 , input [6:0] func7, OP ,output reg [2:0] ALUcontrol);

    always@(OP,func3,func7) begin
        case (OP)
            7'b0000011: ALUcontrol <= 3'b000; //+ lw
            
            7'b0110111: ALUcontrol <=3'b101; //lui

            7'b0100011: ALUcontrol <= 3'b000; // +, sw

            7'b1100111: ALUcontrol <= 3'b000; //jalr

            7'b0110011: begin // R type
                case (func3)
                    3'b000: begin
                        case (func7)
                            7'b0000000: ALUcontrol <= 3'b000; // +, add

                            7'b0100000: ALUcontrol <= 3'b001; // -, sub

                            default: ALUcontrol <= 3'b000;
                        endcase
                    end
                    3'b111: ALUcontrol <= 3'b010 ;// &, and

                    3'b110: ALUcontrol <= 3'b011 ;// |, or

                    3'b010: ALUcontrol <= 3'b110; //slt 

                    default: ALUcontrol <= 3'b000;
                endcase
            end

            7'b0010011: begin // I type
                case (func3)
                    3'b000: ALUcontrol <= 3'b000; //+ , addi

                    3'b100: ALUcontrol <= 3'b100; // ^ , xori

                    3'b110: ALUcontrol <= 3'b011; //|, ori

                    3'b010: ALUcontrol <= 3'b110; //slti

                    default: ALUcontrol <= 3'b000;
                endcase
            end

            7'b1100011:begin   //B-type
                 case (func3)
                    3'b000: ALUcontrol <= 3'b100; // beq

                    3'b001: ALUcontrol <= 3'b101; // bne

                    3'b100: ALUcontrol <= 3'b110; // blt

                    3'b101: ALUcontrol <= 3'b111; // bge

                    default: ALUcontrol <= 3'b000;
                endcase
            end 

            default: ALUcontrol <= 3'b000;
        endcase
    end
    
endmodule