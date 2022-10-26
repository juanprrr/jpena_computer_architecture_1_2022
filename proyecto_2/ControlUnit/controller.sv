/*
	Instr[31:28] -> Condition (Cond)
	Instr[27:26] -> Operation Code (Op)
	Instr[25:20] -> Function (Funct)
	Instr[15:12] -> Rd
*/

module controller(input 	logic 			clk, reset,
						input 	logic [16:11] 	Instr,
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
	decoder dec(Instr[16:15], Instr[14:12],
					FlagW, PCS, RegW, MemW,
					MemtoReg, ALUSrc,NoWrite, ImmSrc, RegSrc, ALUControl);
	
	ConditionalLogic cl(clk, reset, Instr[13:11], ALUFlags,
							  FlagW, PCS, RegW, MemW, NoWrite,
							  PCSrc, RegWrite, MemWrite);
	
endmodule