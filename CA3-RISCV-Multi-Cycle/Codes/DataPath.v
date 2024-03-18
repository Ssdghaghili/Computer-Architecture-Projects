`timescale 1ns/1ns 
module DataPath(input clk , rst , PCWrite , AdrSrc , MemWrite , IRWrite , RegWrite 
    , input[1:0] ResaultSrc  ,ALUSrcA,ALUSrcB, input [2:0] ImmSrc ,ALUControl ,
    output reg Zero , output reg [31:0] controllerSignal);
    
    wire tempZero;
    wire [31:0]  PCout , Adr , ReadData , Instr , 
    OldPC , Data , ImmExt , A ,WriteData , SrcA , SrcB , ALUResault , ALUOut , Resault  , RD1 , RD2;

    register32bit pc(clk,rst, PCWrite , Resault ,PCout);
    mux2to1  selectAdr (PCout , Resault , AdrSrc, Adr);
    InstDataMemory IDM(clk,rst,Adr,WriteData,MemWrite,ReadData);
    register32bit oldpc(clk , rst, IRWrite , PCout ,OldPC);
    register32bit readedinstruction(clk , rst, IRWrite , ReadData ,Instr);
    register32bit dataInMemory(clk , rst, 1'b1 , ReadData ,Data);
    registerFile RF(clk,Instr[19:15],Instr[24:20],Instr[11:7],Resault,RegWrite,RD1, RD2);
    immExtendor immEx(Instr,ImmSrc,ImmExt);
    register32bit RD1Register(clk , rst, 1'b1 , RD1 , A);
    register32bit RD2Register(clk , rst, 1'b1 , RD2 , WriteData);
    mux4to1 SourceASel(PCout , OldPC , A , 32'b0,ALUSrcA,SrcA);
    mux4to1 SourceBSel(WriteData , ImmExt , 32'd4 , 32'b0, ALUSrcB,SrcB);
    ALU alu( SrcA, SrcB, ALUControl, ALUResault,tempZero);
    register32bit resaultRegister(clk , rst, 1'b1 , ALUResault , ALUOut);
    mux4to1 resaultSel(ALUOut , Data , ALUResault , 32'b0, ResaultSrc,Resault);
    assign controllerSignal = Instr;
    assign Zero = tempZero;
 
endmodule