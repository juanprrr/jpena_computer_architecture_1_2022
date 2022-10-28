module ALUSinFlagsTest();
	
	logic [3:0] A, B, out;
	logic [1:0] ALUControl;
	logic cout;
	
	ALUSinFlags #(4) aluSinFlags(A,B, ALUControl, out, cout);
	
	
			
	initial begin
		//Suma
		A = 4'd3; B = 4'd14; ALUControl = 00; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 00; #5;	
		A = 4'd7; B = 4'd4;  ALUControl = 00; #5; 
		
		//Resta
		A = 4'd3; B = 4'd14; ALUControl = 01; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 01; #5;	
		A = 4'd7; B = 4'd4;  ALUControl = 01; #5;		
				
		//XOR
		A = 4'd3; B = 4'd14; ALUControl = 10; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 10; #5;	
		A = 4'd7; B = 4'd4;  ALUControl = 10; #5;		
		
		
		//NOT de A
		A = 4'd3; B = 4'd14; ALUControl = 11; #5;	
		A = 4'd2; B = 4'd6;  ALUControl = 11; #5;	
		A = 4'd7; B = 4'd4;  ALUControl = 11; #5;
	

	
	end
	
	
	

endmodule