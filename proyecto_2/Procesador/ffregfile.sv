module ffregfile #(parameter WIDTH = 32)
					(input logic clk, reset,
					input logic 				PCSrcD,
					input logic 				RegWriteD,
					input logic 		 		MemtoRegD,
					input logic 				MemWriteD,
					input logic [1:0] 		ALUControlD,
					input logic 				BranchD,
					input logic 		 		ALUSrcD,
					input logic [1:0] 		FlagWriteD,
					input logic [3:0] 		CondD,
					input logic [WIDTH-1:0] SrcA,
					input logic [WIDTH-1:0] WriteDataD,
					input logic [3:0]			WA3D,
					input logic [WIDTH-1:0] ExtImmD,

					output logic 				PCSrcE,
					output logic 				RegWriteE,
					output logic 		 		MemtoRegE,
					output logic 				MemWriteE,
					output logic [1:0] 		ALUControlE,
					output logic 				BranchE,
					output logic 		 		ALUSrcE,
					output logic [1:0] 		FlagWriteE,
					output logic [3:0] 		CondE,
					output logic [WIDTH-1:0] SrcAE,
					output logic [WIDTH-1:0] WriteDataE,
					output logic [3:0]			WA3E,
					output logic [WIDTH-1:0] ExtImmE					
					);
					
	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			PCSrcE 		<= 0;
			RegWriteE 	<= 0;
			MemtoRegE	<= 0;
			MemWriteE	<= 0;
			ALUControlE	<= 0;
			BranchE		<= 0;
			ALUSrcE		<= 0;
			FlagWriteE	<= 0;
			CondE			<= 0;
			SrcAE			<= 0;
			WriteDataE	<= 0;
			WA3E			<= 0;
			ExtImmE		<= 0;
			
		end
		else begin
			PCSrcE 		<= PCSrcD;
			RegWriteE 	<= RegWriteD;
			MemtoRegE	<= MemtoRegD;
			MemWriteE	<= MemWriteD;
			ALUControlE	<= ALUControlD;
			BranchE		<= BranchD;
			ALUSrcE		<= ALUSrcD;
			FlagWriteE	<= FlagWriteD;
			CondE			<= CondD;
			SrcAE			<= SrcA;
			WriteDataE	<= WriteDataD;
			WA3E			<= WA3D;
			ExtImmE		<= ExtImmD;
		end
endmodule