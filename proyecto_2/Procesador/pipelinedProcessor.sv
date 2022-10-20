module pipelinedProcessor(
			input  logic        clk, reset, 
         output logic [31:0] WriteData, DataAdr, 
         output logic        MemWrite);
			
	
	// PC logic and instruction fetch vars
	logic [31:0] 		InstrF, InstrD;
	logic [31:0] 		PCNext,PCF, PCPlus4F, PCPlus8D;
	logic 				PCSrcW, ResultW;
	instructionMemory instMem(PCF, InstrF);
	
	mux2 	#(32)  	pcmux(PCPlus4F, ResultW, PCSrcW, PCNext);
	flopr #(32) 	pcreg(clk, reset, PCNext, PCF);
	adder #(32) 	pcadd1(PCF, 32'b100, PCPlus4F);
	assign 			PCPlus8D = PCPlus4F;
	
	ffinstruct if_id_segment(clk, reset, InstrF, InstrD);
	
	 //Control Unit Data Output
	logic 		PCSrcD, RegWriteD, MemtoRegD, MemWriteD;
	logic [1:0] ALUControlD;
	logic 		BranchD;
	logic 		ALUSrcD;
	logic [1:0] FlagWriteD;
	logic [1:0] ImmSrcD;
	logic [1:0] RegSrcD; // RegSrc[1]->  Selector del MUX de RA2| RegSrc[0]-> Selector del MUX de RA1
		
	decoder dec(InstrD[27:26], InstrD[25:20], InstrD[15:12],
					FlagWriteD, PCSrcD, RegWriteD, MemWriteD,
					MemtoRegD, ALUSrcD, BranchD, ImmSrcD, RegSrcD, ALUControlD);
  
	//Register file memory
	logic [31:0] ExtImm, SrcA, SrcB, Result, WriteDataD;
	logic [3:0]  RA1, RA2;
	
	mux2 #(4)   ra1mux(InstrD[19:16], 4'b1111, RegSrcD[0], RA1);
	mux2 #(4)   ra2mux(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2);
	regfile     rf(clk, RegWriteW, RA1, RA2,
					  InstrD[15:12], ResultW, PCPlus8D, 
					  SrcA, WriteDataD); 
	extend      ext(InstrD[23:0], ImmSrcD, ExtImm);	
	

	//mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
	
  
  //Register Memory segment
  	logic 		PCSrcE, RegWriteE, MemtoRegE, MemWriteE;
	logic [1:0] ALUControlE;
	logic 		BranchE;
	logic 		ALUSrcE, PCSrcU, RegWriteU, MemWriteU;
	logic [1:0] FlagWriteE;
	logic [3:0] FlagsNext;
	logic [3:0] FlagsE, CondE, WA3E, ALUFlagsE;
	logic [31:0] ExtImmE, SrcAE, SrcBE, WriteDataE, ALUResultE;
	
	ffregfile id_rm_segment(PCSrcD, RegWriteD, MemtoRegD,MemWriteD, ALUControlD,
									BranchD, ALUSrcD, FlagWriteD, InstrD[31:28],
									WriteDataD, InstrD[15:12], ExtImm, 						
									PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE,
									BranchE, ALUSrcE, FlagWriteE, CondE, SrcAE, WriteDataE, WA3E, ExtImmE);
	
	
	//ALU logic
	
	mux2 #(32)  srcbmux(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
	ALUConFlags alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);	
	
	//Conditional Unit logic
	
	conditionalLogic cl(clk, reset, CondE, ALUFlagsE,
						  FlagWriteE, PCSrcE, RegWriteE, MemWriteE, BranchE,
						  PCSrcU, RegWriteU, MemWriteU, FlagsNext);

	//Data memory segment
	logic	PCSrcM, RegWriteM,MemtoRegM, MemWriteM;
	logic [3:0] WA3M;
	logic [31:0] ALUOutM, WriteDataM;
	
	ffdatamem dmem_segment(clk, reset, PCSrcU, RegWriteU,MemtoRegE, MemWriteU,
									ALUResultE, WriteDataE, WA3E, 
									PCSrcM, RegWriteM,MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WA3M);
	
	
endmodule