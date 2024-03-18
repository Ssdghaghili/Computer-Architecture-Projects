module Memory(clk, rst, readMem, writeMem, addrBus, inBus, rdyMem, outBus);
  //inputs
  input clk, rst, readMem, writeMem;
  input [15:0] inBus; 
  input [7:0]addrBus;
  //outputs
  output reg rdyMem;    
  output [15:0] outBus;
  //memory declarations
  reg [15:0] memData[0:256];
  reg [15:0] outReg;

  integer i;

  initial begin
    for(i = 0; i < 256; i = i+1)
      memData[i] = 16'b0; 
      $readmemb( "mem_data.txt" ,memData,0 ,255 );   
      rdyMem <= 1'b0;
  end

  always @(posedge clk, posedge rst)
    begin
      if(rst == 1'b1)
        begin
          for(i = 0; i < 256; i = i+1)
            memData[i] = 16'b0; // initialize to zero
            $readmemb( "mem_data.txt" ,memData,0 ,255 );//initialize memory
            rdyMem <= 1'b0;
        end
      else if(clk == 1'b1)
        begin
          if(writeMem == 1'b1)
            begin
              rdyMem = 1'b0;
              memData[addrBus] = inBus;
              $writememb("mem_data.txt",memData,0 ,255);
              rdyMem = 1'b1;
            end
      
        end
      
    end

  always @(posedge readMem, addrBus) // Async read
  begin
    if(readMem == 1'b1) 
      begin
        rdyMem = 1'b0;
        outReg = memData[addrBus];
        rdyMem = 1'b1;
      end
  end
  
  assign outBus = (rdyMem == 1'b1 && writeMem == 1'b0) ? outReg :16'bz;

endmodule


