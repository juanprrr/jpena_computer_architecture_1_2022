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


module ConditionalLogic(input logic clk, reset, 
					  input logic [16:15] op,
					  input logic [13:11] Cond,		//Código que viene de bits 13-11 desde Inst en instrucciones de control
					  input logic [3:0] ALUFlags, //Flags (NZCV) que vienen desde la ALU. ALUFlags[3:2]-> NZ | ALUFlags[1:0]-> CV
					  input logic [1:0] FlagW, // FlaW[0] -> Para Carry y Overflow Flags. | FlaW[1] -> Para Negative y Zero Flags.
					  input logic PCS, RegW, MemW, NoWrite,
					  output logic PCSrc, RegWrite, MemWrite);
//	ConditionalLogic cl(clk, reset, Instr[13:11], ALUFlags,
//							  FlagW, PCS, RegW, MemW, NoWrite,
//							  PCSrc, RegWrite, MemWrite, FlagsNext);
	//Salida del AND para definir si se tienen o no que actualizar los Flags. FlaWrite[0]-> Para C y V.|FlaWrite[1]-> Para N y Z.
	logic [1:0] FlagWrite;
	//Salida de los registros para que los Flags (NZCV) sean habilitados. Flags[3:2]-> NZ | Flags[1:0]-> CV
	logic [3:0] Flags;
	
	logic CondEx;
	
	flopenr #(2) flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]); // NZ
	flopenr #(2) flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]); // CV
	
	// Write controls are conditional
	conditionCheck condCheck(op, Cond, Flags, CondEx);
	
	assign FlagWrite = FlagW & {2{CondEx}};
	assign RegWrite = RegW & CondEx & ~NoWrite;
	assign MemWrite = MemW & CondEx;
	assign PCSrc = PCS & CondEx;
	
endmodule