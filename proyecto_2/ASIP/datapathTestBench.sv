module datapathTestBench();
	logic clk, reset;
	
	logic RegWrite, MemWrite; //Enables
	
	logic MemtoReg, PCSrc, ALUSrc; // Selectors
	logic [1:0] RegSrc;				 // Selector
	
	logic [1:0] ImmSrc, ALUControl; //Señales de seleccion
	
	logic [3:0] ALUFlags; //out
	logic [16:0] PC, ALUResult, ReadData, writeData, Instr; //out
	
	// instantiate device to be tested
	datapath dp(clk, reset, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, 
					MemtoReg, PCSrc, Instr, ReadData,
					ALUFlags, PC, ALUResult, writeData);
//	module datapath(input  logic        clk, reset,
//                input  logic [1:0]  RegSrc,
//                input  logic        RegWrite,
//                input  logic [1:0]  ImmSrc,
//                input  logic        ALUSrc,
//                input  logic [1:0]  ALUControl,
//                input  logic        MemtoReg,
//                input  logic        PCSrc,
//					 input  logic [16:0] Instr,
//					 input  logic [16:0] ReadData,
//                output logic [3:0]  ALUFlags,
//                output logic [16:0] PC,
//                output logic [16:0] ALUResult, WriteData
//                );

	// generate clock to sequence tests
	always begin
	clk <= 0; # 5; clk <= 1; #5;
	end
	
	
	initial begin 
		#5; reset = 1; #1; reset = 0; 
		
		/*
		MOVI R14, #0 17'b00_1_00_1110_1110_0000
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		
		
		MOVI R2, #2 17'b00_1_00_1110_0010_0010
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;

		MOVI R1, #7	17'b00_1_00_1110_0001_0111
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;

		GEM R2, 0(R1) 17'b01_00_0_0001_0010_0000
		
		RegSrc = 2'b10; RegWrite = 0; ImmSrc =  2'b01; ALUSrc =  1;
		ALUControl = 00; MemWrite = 1; MemtoReg = 1'bx; PCSrc = 0;

		CDM R4, 0(R1) 17'b01_00_1_0001_0100_0000
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  2'b01; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 1'b1; PCSrc = 0;
		
		*/
		
		//RST R14, R15, R15
		Instr = 17'b00_0_01_1111_1110_1111;
		RegSrc = 2'b00; RegWrite = 1; ImmSrc =  2'bx; ALUSrc =  0;
		ALUControl = 2'b01; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		#10;	

		//MOVI R14, #0 ;Direccion de memoria
		
		
		Instr = 17'b00_1_00_1110_1110_0000;
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		#10;			
		
		//MOVI R2, #2 
		
		Instr = 17'b00_1_00_1110_0010_0010;
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		#10
		
		//MOVI R1, #7 ;Direccion de memoria
		
		Instr = 17'b00_1_00_1110_0001_0111;
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  00; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		#10;
		
		
		//GEM R2, 0(R1) 
		
		Instr = 17'b01_00_0_0001_0010_0000;
		
		RegSrc = 2'b10; RegWrite = 0; ImmSrc =  2'b01; ALUSrc =  1;
		ALUControl = 00; MemWrite = 1; MemtoReg = 1'bx; PCSrc = 0;
		#10;
		
		//CDM R4, 0(R1)
		
		Instr = 17'b01_00_1_0001_0100_0000; ReadData = 17'b00_00_0_0000_0000_0010;
		
		RegSrc = 2'bx0; RegWrite = 1; ImmSrc =  2'b01; ALUSrc =  1;
		ALUControl = 00; MemWrite = 0; MemtoReg = 1'b1; PCSrc = 0;
		#10;
		
		//SUM R5, R4, R2
		Instr = 17'b00_0_01_0100_0101_0010;
		RegSrc = 2'b00; RegWrite = 1; ImmSrc =  2'bx; ALUSrc =  0;
		ALUControl = 2'b01; MemWrite = 0; MemtoReg = 0; PCSrc = 0;
		#10;	

		
		end
endmodule