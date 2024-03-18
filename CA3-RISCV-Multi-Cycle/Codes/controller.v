module MultiCycleController (input clk,rst,Zero,input [31:0] instr,
    output reg AdrSrc, MemWrite, IRWrite,RegWrite, PCWrite,
    output reg [1:0]  ResultSrc, ALUSrcA, ALUSrcB,
    output reg [2:0] ALUOp, ImmSrc);

    parameter FETCH = 3'b000;
    parameter DECODE = 3'b001;
    parameter EXECUTE = 3'b010;
    parameter MEMORY = 3'b011;
    parameter WRITEBACK = 3'b100;


    parameter RTYPE = 7'b0110011;
    parameter LW =    7'b0000011;
    parameter JALR =  7'b1100111;
    parameter ITYPE = 7'b0010011;
    parameter STYPE = 7'b0100011;
    parameter JTYPE = 7'b1101111;
    parameter BTYPE = 7'b1100011;
    parameter UTYPE = 7'b0110111;

    wire [2:0] aluCtrl;
    reg [2:0] state;
    reg PCUpdate , Branch;
    AluDecoder aluDec(instr[14:12] , instr[31:25], instr[6:0] , aluCtrl);

    always@(posedge clk or posedge rst) begin
        ALUOp <= 3'b0;
        if(rst) begin
            state <= FETCH;
            AdrSrc <= 1'b0;
            MemWrite <= 1'b0;
            IRWrite <= 1'b0;
            RegWrite <= 1'b0;
            ResultSrc <= 2'b0;
            ALUSrcA <= 2'b0;
            ALUSrcB <= 2'b0;
            ImmSrc <= 3'b0;
            ALUOp <= 3'b000;
            PCUpdate <= 1'b0;
            Branch <= 1'b0;
        end
        else begin
    
            AdrSrc <= 1'b0;
            IRWrite <= 1'b0;
            ALUSrcA <= 2'b00;
            ALUSrcB <= 2'b10;
            ALUOp <= 3'b000;
            MemWrite <= 1'b0;
            RegWrite <= 1'b0;
            ResultSrc <= 2'b10;
            PCUpdate <= 1'b0;
            Branch <= 1'b0;
            case (state)
                FETCH: begin
                    AdrSrc <= 1'b0;
                    IRWrite <= 1'b1;
                    ALUSrcA <= 2'b00;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 3'b000;
                    ResultSrc <= 2'b10;
                    PCUpdate <= 1'b1;
                    Branch <= 1'b0;
                    state <= DECODE;
                end 
                DECODE: begin 
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 3'b000;
                    ImmSrc <= 3'b010;
                    state <=  EXECUTE;
                end
                EXECUTE: begin
                    state <= MEMORY;
                    case (instr[6:0])
                        RTYPE:begin
                            ALUSrcA <=2'b10;
                            ALUSrcB <= 2'b00;
                            ALUOp <= aluCtrl;
                        end
                        LW:begin
                            ImmSrc <= 3'b000;
                            ALUSrcA <= 2'b10;
                            ALUSrcB <= 2'b01;
                            ALUOp <= 3'b000;
                        end
                        ITYPE: begin
                            ImmSrc <= 3'b000;
                            ALUSrcA <= 2'b10;
                            ALUSrcB <= 2'b01;
                            ALUOp <= aluCtrl;
                        end
                        JALR: begin
                            ImmSrc <= 3'b000;
                            ALUSrcA <= 2'b10;
                            ALUSrcB <=2'b01;
                            ALUOp <= 3'b000;
                        end
                        STYPE:begin
                            ImmSrc <= 3'b001;
                            ALUSrcA <= 2'b10;
                            ALUSrcB <= 2'b01;
                            ALUOp <= 3'b000;
                        end
                        BTYPE:begin
                            ALUSrcA <= 2'b10;
                            ALUSrcB <= 2'b00;
                            ResultSrc <= 2'b00;
                            ImmSrc <= 3'b010;
                            Branch <= 1'b1;
                            state <= FETCH;
                            ALUOp <= aluCtrl;
                        end
                        UTYPE: begin
                            ImmSrc <= 3'b011;
                            ALUSrcB <= 2'b01;
                            ALUOp <= aluCtrl;
                        end
                        JTYPE: begin
                            
                            ALUSrcA <= 2'b01;
                            ALUSrcB <= 2'b10;
                            ALUOp <= 3'b000;
                            ImmSrc <= 3'b100;

                        end
                        default: 
                        state <= FETCH;
                    endcase
                end
                MEMORY: begin
                    state <= FETCH;
                    case (instr[6:0])
                        RTYPE: begin
                            ResultSrc <= 2'b00;
                            RegWrite <=1'b1; 
                        end
                        LW: begin
                            ResultSrc <= 2'b00;
                            AdrSrc <= 1'b1;
                            state <= WRITEBACK;
                        end
                        ITYPE: begin
                            ResultSrc <=2'b00;
                            RegWrite <= 1'b1;
                        end
                        JALR: begin
                            ResultSrc <= 2'b00;
                            PCUpdate <= 1'b1;
                            ALUSrcA <= 2'b01;
                            ALUSrcB <= 2'b10;
                            ALUOp <= 3'b000;
                            state <= WRITEBACK;
                        end
                        STYPE: begin
                            ResultSrc <= 2'b00;
                            AdrSrc <= 1'b1;
                            MemWrite <= 1'b1;
                            RegWrite <=1'b0;
                        end
                        UTYPE: begin
                            ResultSrc <=2'b00;
                            RegWrite <= 1'b1;

                        end
                        JTYPE: begin
                            ResultSrc <= 2'b00;
                            RegWrite <= 1'b1;
                            ALUSrcA <= 2'b01;
                            ALUSrcB <= 2'b01;
                            state <= WRITEBACK;
                        end
                        default: 
                        state <= FETCH;
                        
                    endcase
                end
                WRITEBACK: begin
                    state <= FETCH;
                    case (instr[6:0])
                        LW:begin                                    
                            ResultSrc <= 2'b01;
                            RegWrite <= 1'b1;
                        end 
                        JALR: begin
                            ResultSrc <= 2'b00;
                            RegWrite <= 1'b1;
                        end
                        JTYPE: begin
                            ResultSrc <= 2'b00;
                            PCUpdate <= 1'b1;
                            AdrSrc <= 1'b1;
                        end
                    endcase
                end
                default: 
                state <= FETCH;
            endcase
        end
    end
    assign PCWrite = ((Branch & Zero) | PCUpdate) ;
endmodule