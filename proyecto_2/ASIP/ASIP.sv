module ASIP(input  logic	   clk, reset,
           input  logic [16:0] Instr,
			  input  logic [16:0] ReadData,
			  output logic [16:0] PC,
           output logic        MemWrite,
           output logic [16:0] ALUResult, WriteData);

  logic [3:0] ALUFlags;
  logic       RegWrite, 
              ALUSrc, MemtoReg, PCSrc;
  logic [1:0] RegSrc, ImmSrc, ALUControl;

  controller c(clk, reset, Instr[16:11], Instr[7:4], ALUFlags, 
               RegSrc, RegWrite, ImmSrc, 
               ALUSrc, ALUControl,
               MemWrite, MemtoReg, PCSrc);
  datapath dp(clk, reset, 
              RegSrc, RegWrite, ImmSrc,
              ALUSrc, ALUControl,
              MemtoReg, PCSrc, Instr, ReadData,
              ALUFlags, PC, 
              ALUResult, WriteData);
				  
endmodule