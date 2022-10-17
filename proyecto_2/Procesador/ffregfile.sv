module ffregfile #(parameter WIDTH = 8)
					(input logic clk, reset,
					input logic [WIDTH-1:0] d,
					input logic [WIDTH-1:0] d1,
					input logic [3:0] d2,
					input logic [WIDTH-1:0] d3,
					output logic [WIDTH-1:0] q,
					output logic [WIDTH-1:0] q1,
					output logic [3:0] q2,
					output logic [WIDTH-1:0] q3);
					
	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			q <= 0;
			q1<= 0;
			q2<= 0;
			q3<= 0;
		end
		else begin
			q <= d;
			q1 <= d1;
			q2 <= d2;
			q3 <= d3;
		end
endmodule