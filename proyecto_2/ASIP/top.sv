module top(input  logic        clk, reset, 
           output logic [16:0] WriteData, DataAdr, 
           output logic        MemWrite);

  logic [16:0] PC, Instr, ReadData;
  
  // instantiate processor and memories
  ASIP asip(clk, reset, PC, Instr, MemWrite, DataAdr, 
          WriteData, ReadData);
			 
  instructionMemory imem(PC, Instr);
  dataMemory dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
  
endmodule