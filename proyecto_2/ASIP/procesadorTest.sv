module procesadorTest();
	
	logic clk, reset;
			  
	logic [16:0] ReadData; //UNICA salida "real" del procesador
			  
	logic [16:0] PC, Result, Instr, WriteData; // Salidas que se quieren ver del datapath
	logic [3:0] ALUFlags;			  // Salidas que se quieren ver de la unidad de control
	logic PCSrc, MemtoReg, MemWrite, ALUSrc, RegWrite; //Salidas que se quieren ver de la unidad de control
	logic [1:0]  ALUControl, ImmSrc, RegSrc; //Salidas que se quieren ver de la unidad de control
	
	// instantiate device to be tested
	ASIP asip(clk, reset, Instr,
			  ReadData,
			  PC,
			  MemWrite,
			  Result,
			  WriteData);

			  
	// generate clock to sequence tests
	always begin
	clk <= 0; # 5; clk <= 1; #5;
	end
	
	
	initial begin 
		#5; reset = 1; #1; reset = 0;
		
				//RST R14, R15, R15
		Instr = 17'b00_0_01_1111_1110_1111;

		#10;	

		//MOVI R14, #0 ;Direccion de memoria
		
		
		Instr = 17'b00_1_00_1110_1110_0000;
		

		#10;			
		
		//MOVI R2, #2 
		
		Instr = 17'b00_1_00_1110_0010_0010;
		

		#10
		
		//MOVI R1, #7 ;Direccion de memoria
		
		Instr = 17'b00_1_00_1110_0001_0111;
		

		#10;
		
		
		//GEM R2, 0(R1) 
		
		Instr = 17'b01_00_0_0001_0010_0000;


		#10;
		
		//CDM R4, 0(R1)   R1 dir 7: 2
		
		Instr = 17'b01_00_1_0001_0100_0000; ReadData = 17'b00_00_0_0000_0000_0010;

		#10;
		
		//SUM R5, R4, R2
		Instr = 17'b00_0_00_0100_0101_0010;

		#10;	
		// SI _branch3
		Instr = 17'b10_0_000_00000000001;

		#10;
		
	end
			  
	
	
endmodule