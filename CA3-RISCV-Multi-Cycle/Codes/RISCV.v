`timescale 1ns/1ns
module RISCV(input clk , rst , output reg [31:0] currentInstruction);

wire RegWrite,MemWrite,AdrSrc,Zero,IRWrite ,PCWrite;
wire [1:0] ResaultSrc , ALUSrcA , ALUSrcB;
wire [2:0] ImmSrc ,ALUControl;
wire [31:0] instruction;

DataPath DP(clk , rst , PCWrite , AdrSrc , MemWrite , IRWrite , RegWrite 
    , ResaultSrc  ,ALUSrcA , ALUSrcB, ImmSrc ,ALUControl ,Zero , instruction);

MultiCycleController MC(clk,rst,Zero,instruction,
    AdrSrc, MemWrite, IRWrite,RegWrite, PCWrite,
   ResaultSrc, ALUSrcA, ALUSrcB, ALUControl, ImmSrc);
   assign currentInstruction = instruction;


endmodule