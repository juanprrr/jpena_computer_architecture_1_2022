
module controllerTest();

	logic clk,reset;
	logic [16:0] Instr;
	logic [3:0] ALUFlags; //NZCV
						
	logic [1:0] RegSrc; 
	logic RegWrite;
	logic [1:0] ImmSrc;
	logic ALUSrc;
	logic [1:0] ALUControl;
	logic MemWrite, MemtoReg;
	logic PCSrc;
	
	controller ctllr(clk, reset, Instr[16:11], ALUFlags, 
						  RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc);


	
	//Creacion de un reloj
	always begin
		clk = 0; #5; clk=~clk; #5;
	end
		
	
	initial begin
	
		reset = 1; #1; reset = 0; #4; //Se resetea los registros que permiten o no la actualizacion de los flags.
		
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 1 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		
		ALUFlags = 0000; //Se dejarán las Flags en 0 pues se probará el CMP
				
		Instr = 17'b00_0_00_0010_0001_0011; #10; // SUM R1,R2,R3
		Instr = 17'b00_0_00_1110_0101_1001; #10; // MOV R7,R9 ; se usa Rn = 14 que vale 0 por defecto
		Instr = 17'b00_0_10_xxxx_0001_0101; #10; // COM R1,R7
		Instr = 17'b00_0_01_1100_1010_0010; #10; // RST R10,R12,#2
		
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		//												Instrucciones de memoria
		
		ALUFlags = 0000; //Se dejarán las Flags en 0 
				
		Instr = 17'b01_00_0_0010_0001_0000; #10; // GEM R1,0(R2)
		Instr = 17'b01_00_1_0111_1001_0100; #10; // CDM R7,4(R9)

		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 3 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		//												Instrucciones de control
		// flags N y V son las de interés, seteadas en 0, 
		// así la condición SMAI se cumple y CondEx = 1, SMEI no se cumple entonces CondEx = 0

		ALUFlags = 0000; 
		Instr = 17'b10_1_101_01000010000; #10; // SMAI LABEL
		Instr = 17'b10_1_100_01000010000; #10; // SMEI LABEL 
		
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		//----------------------------------------- CASO 1-----------------------------------------
		//Supongamos que se hace un SUBS R5 R1,R2 (El cual setea los flags y es como el CMP R1,R2). 
		//Si R1 = 5 y R2 = 2 entonces el resultado de los flags es 0010. 
		/*
		Instr = 20'hE0515; #5;
		ALUFlags = 4'b0010; #5; // NZCV 
		*/
		
		//Posterior a esto se hace un BGT el cual si deberia de permitirse 
		/*
		Instr = 20'hCA000; #10;
		*/
		
		//------------------------------------------ CASO 2 ----------------------------------------
		//Supongamos que se hace un CMP R1,R2 (El cual setea los flags). 
		//Si R1 = 5 y R2 = 2 entonces el resultado de los flags es 0010. 
		/*
		Instr = 20'hE0515; #5;
		ALUFlags = 4'b0010; #5; // NZCV 
		*/
		
		//Posterior a esto se hace un BLT el cual no deberia de permitirse
		/*
		Instr = 20'hBA000; #10;
		*/
		
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 3 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		/*
				SUB R0, R15, R15  ;E04F000F
				ADD R1, R0, #5    ;E2801005
				ADD R2, R0, #2    ;E2802002
				ADD R4, R0, #0x00 ;E2804000
				
				SUBS R9, R1,R2	   ;E0519002
				BLE R2ESMAYOR     ;DA000001
				SUB R3,R1, R2     ;E0413002
				B FIN		    		;EA000000
			R2ESMAYOR:
				ADD R3, R1, R2    ;E0813002
			FIN:
				STR R3, [R4]      ;E5843000
		*/
		
		/*
		Instr = 20'hE04F0; #10; // SUB R0, R15, R15 ; R0 = 0
		
		Instr = 20'hE2801; #10; // ADD R1, R0, #5 ; R1 = 5
		
		Instr = 20'hE2802; #10; // ADD R2, R0, #2 ; R2 = 2
		
		Instr = 20'hE2804; #10; // ADD R4, R0, #0x00
		
		Instr = 20'hE0519; #5;  // SUBS R9, R1,R2
		ALUFlags = 4'b0010; #5; // NZCV 
		
		Instr = 20'hDA000; #10;  // BLE R2ESMAYOR 
		
		Instr = 20'hE0413; #10;  // SUB R3,R1, R2   		
		Instr = 20'hEA000; #10;  // B FIN		   
		Instr = 20'hE0813; #10;  // ADD R3, R1, R2  
		Instr = 20'hE5843; #10;  // STR R3, [R4]   
		*/
		
		// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EJEMPLO 4 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		/*
				SUB R0, R15, R15  ;E04F000F
				ADD R1, R0, #2    ;E2801002
				ADD R2, R0, #5    ;E2802005
				ADD R4, R0, #0x00 ;E2804000
				
				SUBS R9, R1,R2	   ;E0519002
				BLE R2ESMAYOR     ;DA000001
				SUB R3,R1, R2     ;E0413002
				B FIN		    		;EA000000
			R2ESMAYOR:
				ADD R3, R1, R2    ;E0813002
			FIN:
				STR R3, [R4]      ;E5843000
		*/
			
		
		
	end
	
						  
endmodule