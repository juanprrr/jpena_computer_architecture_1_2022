module arm(input logic clk, reset,
			  
			  output logic [31:0] ReadOutData, //UNICA salida "real" del procesador
			  
			  output logic [31:0] PC, Result, Instr, // Salidas que se quieren ver del datapath
			  output logic [3:0] ALUFlags,			  // Salidas que se quieren ver de la unidad de control
			  output logic PCSrc, MemtoReg, MemWrite, ALUSrc, RegWrite, //Salidas que se quieren ver de la unidad de control
			  output logic [1:0]  ALUControl, ImmSrc, RegSrc 				//Salidas que se quieren ver de la unidad de control
			  );
			  
	//logic [3:0] ALUFlags;	
	//logic 		PCSrc, MemtoReg, MemWrite, ALUSrc, RegWrite;
	//logic [1:0] ALUControl, ImmSrc, RegSrc;
	
	
	controller c(clk, reset, Instr[31:12], ALUFlags,
					 RegSrc, RegWrite, ImmSrc,
					 ALUSrc, ALUControl,
					 MemWrite, MemtoReg, PCSrc);
	
	datapath dp(clk, reset,
					RegSrc, 
					RegWrite, MemWrite, 
					ImmSrc,
					ALUSrc, 
					ALUControl,
					MemtoReg, 
					PCSrc,					
					ALUFlags, 
					ReadOutData, 
					PC, Result, Instr); // Salidas que solo se quieren ver del datapath
	
endmodule