module  RegFile( 
clk,
inBus,
readMem,
writeMem,
addrBus, 
outBus
);
//-----------Input Ports---------------
input [2:0] addrBus;
input [15:0] inBus ;
input clk, readMem, writeMem ;
//-----------Output Ports---------------
output [15:0] outBus ;

(* ram_init_file = "RegFile.mif" *)  reg  [15:0] MemoryFile [0:7];  //For RefisterFile LE
//(* romstyle = "M9K" *)(* ram_init_file = "RegFile.mif" *)  reg  [15:0] MemoryFile [0:7]; //For RAM 
	always @ (posedge clk)
	begin
		if(writeMem == 1'b1 )begin
			MemoryFile[addrBus]<=inBus;
			
		end	 
	end 
assign outBus = readMem ? MemoryFile[addrBus]:16'bz;

endmodule 


