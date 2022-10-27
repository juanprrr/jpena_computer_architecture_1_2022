module conditionalLogicTest();

	logic clk, reset;
	logic [1:0] op;
	logic [2:0] Cond;	//Código que viene de la instrucción en ejecución.
	logic [3:0] ALUFlags; 	//Flags (NZCV) que vienen desde la ALU. ALUFlags[3:2]-> NZ | ALUFlags[1:0]-> CV
	logic [1:0] FlagW; 		// FlaW[0] -> Para Carry y Overflow Flags. | FlaW[1] -> Para Negative y Zero Flags.
	logic PCS, RegW, MemW, NoWrite;
					  
	logic PCSrc, RegWrite, MemWrite;
	
	ConditionalLogic condLogic(clk, reset,op, Cond, ALUFlags, FlagW, PCS, RegW, MemW, NoWrite,
										PCSrc, RegWrite, MemWrite);
	
	//Creacion de un reloj
	always begin
		clk = 0; #5; clk=~clk; #5;
	end
	
	initial begin
	reset = 1; #1; reset = 0; #4;
	//NZCV
	// CMP R1,R2 ; Donde R1>R2
	op = 2'b00; Cond = 3'b000; PCS = 0; RegW = 0; MemW = 0; FlagW = 2'b11;
	
	ALUFlags = 4'b0010; #5; //El resultado del "CMP R1,R2" genera estos nuevos valores en las flags
	
	//Branch Instruction BGT
	
	op = 2'b11; Cond = 3'b011; PCS = 1; RegW = 0; MemW = 0; FlagW = 2'b00; #5;
	
	//---------------------------------------------------------------------------------------------------
	// CMP R1,R2 ; Donde R1>R2
	op = 2'b00; Cond = 3'b000; PCS = 0; RegW = 0; MemW = 0; FlagW = 2'b11;
	
	ALUFlags = 3'b0010; #10; //El resultado del "CMP R1,R2" genera estos nuevos valores en las flags
	
	//Branch Instruction BLT
	
	op = 2'b11; Cond = 3'b101; PCS = 1; RegW = 0; MemW = 0; FlagW = 2'b00; #5;
	
	end
	
	
endmodule