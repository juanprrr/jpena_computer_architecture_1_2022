/*
	A nivel de simulación del datapath, se quisieron ver varias señales de salida de las que están
	a lo interno del procesador. Entre estas señales se encuentran:
	-> output logic [31:0] PC, ALUResult, PCNext, Instr, Result, SrcA, SrcB.
	-> output logic [3:0] RA1, RA2.
	
	A nivel de su funcionamiento real, las unicas salidas que este modulo debe de tener son:
	->  output logic [3:0] ALUFlags.
	->  output logic [31:0] ReadOutData.

	En caso de que se quiera simular y ver todas estas distintas señales, se deben de incluir las mismas
	en la interfaz del modulo.
	
*/


module datapath(input 	logic 			clk, reset,
					 input 	logic [1:0] 	RegSrc,
					 input 	logic 			RegWrite,
					 input 	logic [1:0] 	ImmSrc,
					 input 	logic 			ALUSrc,
					 input 	logic [1:0] 	ALUControl,
					 input 	logic 			MemtoReg,
					 input 	logic 			PCSrc,
					 output 	logic [3:0] 	ALUFlags,
					 output 	logic [31:0]	PC,
					 input 	logic [31:0] 	Instr,
					 output 	logic [31:0] 	ALUResult, WriteData,
					 input 	logic [31:0] 	ReadData); //Salidas que solo se quieren observar.
					 
	//logic [31:0] PC, PCNext, PCPlus4, PCPlus8, Instr, ReadData, WriteData;
	//logic [31:0] PCPlus4, PCPlus8, ReadData, WriteData;
	
	// Instruction Fetch pipeline segment
  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2;
  
  

  // next PC logic
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b100, PCPlus4);
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

  // register file logic
  mux2 #(4)   ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  regfile     rf(clk, RegWrite, RA1, RA2,
                 Instr[15:12], Result, PCPlus8, 
                 SrcA, WriteData); 
  mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[23:0], ImmSrc, ExtImm);

  // ALU logic
  mux2 #(32)  srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
  ALUConFlags alu(SrcA, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
	
	
endmodule