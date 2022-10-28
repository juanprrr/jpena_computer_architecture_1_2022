/*
	Total inputs: currentInstr[16:11]
	
	Tipo = currentInstr[16:15]
	
	If Tipo == 00 // Data instructions
		I      = currentInstr[14]
		Instr  = currentInstr[13:12]
		unused = currentInstr[11]
			
	If Tipo == 01 // Memory instructions
		unused = currentInstr[14:13]
		Instr  = currentInstr[12]
		unused = currentInstr[11]
	
	If Tipo == 10 // Branch instructions
		B      = currentInstr[14]
		Instr  = currentInstr[13:11]
*/

module controller(input 	logic 			clk, reset,
						input 	logic [16:11] 	currentInstr,
						input 	logic [3:0] 	ALUFlags, //NZCV
						output 	logic [1:0] 	RegSrc, // RegSrc[1]->  Selector del MUX de RA2| RegSrc[0]-> Selector del MUX de RA1
						output 	logic 			RegWrite,
						output 	logic [1:0] 	ImmSrc,
						output 	logic 			ALUSrc,
						output 	logic [1:0] 	ALUControl,
						output 	logic 			MemWrite, MemtoReg,
						output 	logic 			PCSrc);
						
	logic [1:0] FlagW; //FlaW[0]-> Para C y V.|FlaW[1]-> Para N y Z.
	logic PCS,RegW, MemW, NoWrite;

							//op		funct			
	decoder dec(currentInstr[16:15], currentInstr[14:12],
					FlagW, 
					PCS, 
					RegW, MemW, MemtoReg, ALUSrc,NoWrite, ImmSrc, RegSrc, ALUControl);
	
	ConditionalLogic cl(clk, reset,currentInstr[16:15], currentInstr[13:11], ALUFlags,
							  FlagW, PCS, RegW, MemW, NoWrite,
							  PCSrc, RegWrite, MemWrite);
	
endmodule