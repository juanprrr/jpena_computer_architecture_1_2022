module decoder(input logic [1:0] Op,
					input logic [2:0] Funct,
					input logic [3:0] Rd,
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW,
					output logic MemtoReg, ALUSrc, NoWrite,
					output logic [1:0] ImmSrc, RegSrc, ALUControl); // RegSrc[1]->  Selector del MUX de RA2| RegSrc[0]-> Selector del MUX de RA1
					
	logic [9:0] controls;
	logic Branch, ALUOp;
	
	// Main Decoder
	always_comb
		casex(Op)
						// Data-processing immediate
			2'b00: if (Funct[2]) controls = 10'b00_00_1_0_1_0_0_1; //If statement: verify if a second source operand(Src2) is an immmediate
						// Data-processing register
					else controls = 10'b00_00_0_0_1_0_0_1;
						// LDR con segundo operando (que representa un offset) SOLO como un inmediato
			2'b01: if (Funct[2]) controls = 10'b00_01_1_1_1_0_0_0; 
						// STR con segundo operando (que representa un offset) SOLO como un inmediato
					else controls = 10'b10_01_1_1_0_1_0_0;
						// B
			2'b10: controls = 10'b01_10_1_0_0_0_1_0;
						// Unimplemented
			default: controls = 10'bx;
		endcase
	
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	
	// ALU Decoder
	always_comb
		if (ALUOp) // Si el ALUOp es 1, esto implica que la intrucción en ejecución es de tipo Data Processing Instruction. (DP-Inst)
			begin 	//Command
				case(Funct[1:0]) //En las DP-Inst se puede decidir la operación que la ALU realizará. Esto, segun los codigos de Command
					2'b00: ALUControl = 2'b00; // SUM-MOV
					2'b01: ALUControl = 2'b01; // RST
					2'b10: ALUControl = 2'b01; // COM
					
					default: ALUControl = 2'bx; // unimplemented
				endcase
				
				// Update flags if funct is COM
				FlagW = {Funct[1], Funct[1]}; // 
				//FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01); //(Actualiza C & V si S = 1 y la operación es arith).
			end 
		else 
			begin
				// Siempre se realiza un ADD para non-DP instructions. En otras palabras, todos las operaciones que involucren
				// direcciones de memoria como sus operandos, solo pueden hacer offset positivos.
				ALUControl = 2'b00;
				// Para no-DP Instructions(Memory Inst y Branch Inst) las flags no tienen ningun sentido. Por tanto, no es necesario actualizarlas.
				FlagW = 2'b00; 
			end
	
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule 