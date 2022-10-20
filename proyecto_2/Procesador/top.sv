module top(input  logic        clk, reset, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite);

	logic [31:0] PC, Instr, ReadData;
  
  // instantiate processor and memories
	arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, 
          WriteData, ReadData);

	instructionMemory instMem(PC, Instr);
	dataMemory outDataMemory(clk, MemWrite, DataAdr[7:0], WriteData, ReadData);
	
endmodule