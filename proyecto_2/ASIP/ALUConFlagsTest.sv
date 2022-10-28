module ALUConFlagsTest();

	logic [16:0] A, B;
	logic [1:0] ALUControl;
	
	logic [16:0] out;	
	logic [3:0] ALUFlags; //NZCV
	
	ALUConFlags #(17) aluConFlags(A,B,ALUControl, out, ALUFlags);
	
		
			
	initial begin
	
	/* ------------------------- Datos de 4 bits -------------------------------
		//Suma
		A = 4'd3; B = 4'1d14; ALUControl = 00; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 00; #5;
		A = 4'd7; B = 4'd4;  ALUControl = 00; #5;
		
		//Resta
		A = 4'd3; B = 4'd14; ALUControl = 01; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 01; #5;
		A = 4'd7; B = 4'd4;  ALUControl = 01; #5;	
						//XOR
		A = 4'b0011; B = 4'b1110; ALUControl = 10; #5;	
		A = 4'b0010; B = 4'b0110;  ALUControl = 10; #5;
		A = 4'b0111; B = 4'b0100;  ALUControl = 10; #5;		

		
		
		//NOT de A
		A = 4'd3; ALUControl = 11; #5;	
		A = 4'd2; ALUControl = 11; #5;	
		A = 4'd7; ALUControl = 11; #5;
	*/
		
		// ------------------------- Datos de 32 bits -------------------------------
		//Suma entre direccion de un PC+8(A) y el resultado que sale del modulo del inmediato(B).
		//A = 32'h00000038; B = 32'h00000040;  ALUControl = 00; #5;
		//A = 32'h00000058; B = 32'hffffffE4;  ALUControl = 00; #5;
		//A = 32'h00000040; B = 32'hfffffffC;  ALUControl = 00; #5;
		
		//Resta
		A = 17'b00000_00000_00001_01; B = 17'b00000_00000_00000_10; ALUControl = 01; #5;	
		A = 17'b00000_00000_00000_10; B = 17'b00000_00000_00001_01; ALUControl = 01; #5;
		A = 17'b00000_00000_00000_10; B = 17'b00000_00000_00000_10; ALUControl = 01; #5;
				//XOR
		A = 17'b00000_00000_00001_01; B = 17'b00000_00000_00000_10; ALUControl = 10; #5;	
		A = 17'b00000_00000_00000_10; B = 17'b00000_00000_00001_01; ALUControl = 10; #5;
		A = 17'b00000_00000_00000_10; B = 17'b00000_00000_00000_10; ALUControl = 10; #5;
		
	end
	
	

endmodule