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


module datapath(input logic clk, reset,
					 input logic [1:0] RegSrc,
					 input logic RegWrite, MemWrite,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [1:0] ALUControl,
					 input logic MemtoReg,
					 input logic PCSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] ReadOutData,
					 output logic [31:0] PC, Result, InstrD); //Salidas que solo se quieren observar.
					 
	//logic [31:0] PC, PCNext, PCPlus4, PCPlus8, Instr, ReadData, WriteData;
	//logic [31:0] PCPlus4, PCPlus8, ReadData, WriteData;
	logic [31:0] PCNext, PCPlus4, PCPlus4F, PCPlus8, ReadData, WriteData, ALUResult, InstrF;
	
	logic [31:0] ExtImm, SrcA, SrcB;
	//logic [31:0] ExtImm, SrcA, SrcB, Result;
	logic [3:0] RA1, RA2;
	
	// Next PC logic
	mux2 #(32) pcmux(PCPlus4, ALUResult, PCSrc, PCNext);	
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	
	instructionMemory instMem(PC, InstrF);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	//First stage for pipeline
	ffrinstruct #(32) pipeline_instreg(clk, reset, InstrF, PCPlus4, InstrD, PCPlus4F);
	adder #(32) pcadd2(PCPlus4F, 32'b100, PCPlus8);
	
	// Register file logic
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
	
	regfile rf(clk, RegWrite, RA1, RA2,
					InstrD[15:12], Result, PCPlus8,
					SrcA, WriteData);		
	extend ext(InstrD[23:0], ImmSrc, ExtImm);
	
	// ALU logic
	mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
	ALUConFlags alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
	
	dataMemory outDataMemory(clk, MemWrite, ALUResult[7:0], WriteData, ReadOutData);
	ROM32 romInputData(ALUResult[10:0], ReadData);
	
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
	
endmodule