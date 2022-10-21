module ffwriteback#(parameter WIDTH = 32) (
			input logic clk, reset,
			input logic 				PCSrcM,
			input logic 				RegWriteM,
			input logic 		 		MemtoRegM,
			input logic [WIDTH-1:0]	ReadDataM,
			input logic [WIDTH-1:0] ALUOutM,
			input logic [3:0]			WA3M,
			output logic 				PCSrcW,
			output logic 				RegWriteW,
			output logic 		 		MemtoRegW,
			output logic [WIDTH-1:0] ReadDataW,
			output logic [WIDTH-1:0] ALUOutW,
			output logic [3:0]		 WA3W		
			);
			
	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			PCSrcW 		<= 0;
			RegWriteW	<= 0;
			MemtoRegW	<= 0;
			ReadDataW	<= 0;
			ALUOutW		<= 0;
			WA3W			<= 0;
			
		end
		else begin
			PCSrcW 		<= PCSrcM;
			RegWriteW	<= RegWriteM;
			MemtoRegW	<= MemtoRegM;
			ReadDataW	<= ReadDataM;
			ALUOutW		<= ALUOutM;
			WA3W			<= WA3M;
		end	
			
endmodule