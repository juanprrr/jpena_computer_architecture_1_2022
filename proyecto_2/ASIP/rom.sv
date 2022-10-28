module rom(output logic [15:0] ex1_mem);

	logic [15:0] ex1_memory [0:3];

	//$readmemh("ex1.mem", ex1_memory);
	
	assign ex1_mem = ex1_memory[0];
	
endmodule