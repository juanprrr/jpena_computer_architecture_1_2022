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
					 output logic [31:0] PCF, Result, InstrD); //Salidas que solo se quieren observar.
					 
	//logic [31:0] PC, PCNext, PCPlus4, PCPlus8, Instr, ReadData, WriteData;
	//logic [31:0] PCPlus4, PCPlus8, ReadData, WriteData;
	logic [31:0] PCNext, PCPlus4, ReadData, WriteData, ALUResult;
	
	logic [31:0] ExtImm, SrcA, SrcB;
	//logic [31:0] ExtImm, SrcA, SrcB, Result;
	logic [3:0] RA1, RA2;
	
	//Pipeline values
	logic [31:0] PCPlus4F,PCPlus4FP, InstrF;
	logic [31:0] SrcAE, WriteDataE, SrcBE, ExtImmE;
	logic [31:0] ALUResultE, WD, ALUOutM, ALUOutW, ReadDataW
	
	logic [3:0] WA3D, WA3E, WA3M, WA3W;
	
	// Next PC logic
	mux2 #(32) pcmux(PCPlus4F, Result, PCSrc, PCNext);	
	flopr #(32) pcreg(clk, reset, PCNext, PCF);
	instructionMemory instMem(PCF, InstrF);
	adder #(32) pcadd1(PCF, 32'b100, PCPlus4F);
	//First stage for pipeline
	ffinstruct #(32) pipeline_instreg(clk, reset, InstrF, InstrD);
	// Register file logic
	
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
	
	regfile rf(clk, RegWrite, RA1, RA2,
					WA3W, Result, PCPlus4F,
					SrcA, WriteData);		
					
	extend ext(InstrD[23:0], ImmSrc, ExtImm);
	//Second stage for pipeline
	ffregfile #(32) pipeline_regfile(clk, reset, SrcA, 
							WriteData, InstrD[15:12], ExtImm, 
							SrcAE, WriteDataE, WA3E, ExtImmE);
	
	// ALU logic
	mux2 #(32) srcbmux(WriteDataE, ExtImmE, ALUSrc, SrcBE);
	ALUConFlags alu(SrcAE, SrcBE, ALUControl, ALUResultE, ALUFlags);
	// Third Stage for pipeline
	
	ffalures#(32) pipeline_alu(clk, reset, ALUResultE, WriteDataE, WA3E,ALUOutM, WD, WA3M);
	
	dataMemory outDataMemory(clk, MemWrite, ALUOutM[7:0], WD, ReadOutData);
	// Fourth stage for pipeline
	ROM32 romInputData(ALUOutM[10:0], ReadData);
	
	ffalures#(32) pipeline_dataMem(clk, reset, ALUOutM, ReadData, WA3M, ALUOutW, ReadDataW, WA3W);
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoReg, Result);
	
	
	
	
endmodule