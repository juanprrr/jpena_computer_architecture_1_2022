module ffdatamem #(parameter WIDTH = 32) (
			input logic clk, reset,
			input logic 				PCSrcU,
			input logic 				RegWriteU,
			input logic 		 		MemtoRegU,
			input logic 				MemWriteU,
			input logic [WIDTH-1:0] ALUResultE,
			input logic [WIDTH-1:0]	WriteDataE,
			input logic [3:0]		 	WA3E,
			
			output logic 				PCSrcM,
			output logic 				RegWriteM,
			output logic 		 		MemtoRegM,
			output logic 				MemWriteM,
			output logic [WIDTH-1:0] ALUOutM,
			output logic [WIDTH-1:0] WriteDataM,
			output logic [3:0]		 	WA3M);

	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			PCSrcM 		<= 0;
			RegWriteM 	<= 0;
			MemtoRegM	<= 0;
			MemWriteM	<= 0;
			ALUOutM		<= 0;
			WriteDataM	<= 0;
			WA3M			<= 0;
			
		end
		else begin
			PCSrcM 		<= PCSrcU;
			RegWriteM 	<= RegWriteU;
			MemtoRegM	<= MemtoRegU;
			MemWriteM	<= MemWriteU;
			ALUOutM		<= ALUResultE;
			WriteDataM	<= WriteDataE;
			WA3M			<= WA3E;
		end
			
endmodule