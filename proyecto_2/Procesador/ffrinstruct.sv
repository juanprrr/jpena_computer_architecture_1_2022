module ffrinstruct #(parameter WIDTH = 8)
					(input logic clk, reset,
					input logic [WIDTH-1:0] d,
					input logic [WIDTH-1:0] d1,
					output logic [WIDTH-1:0] q,
					output logic [WIDTH-1:0] q1);
					
	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			q <= 0;
			q1<= 0;
		end
		else begin
			q <= d;
			q1 <= d1;
		end
endmodule