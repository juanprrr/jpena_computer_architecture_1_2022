module ffalures #(parameter WIDTH = 8)
					(input logic clk, reset,
					input logic [WIDTH-1:0] d,
					input logic [WIDTH-1:0] d1,
					input logic [3:0] d2,
					output logic [WIDTH-1:0] q,
					output logic [WIDTH-1:0] q1,
					output logic [3:0] q2);
					
	always_ff @(posedge clk, posedge reset)
		if (reset) begin
			q <= 0;
			q1<= 0;
			q2<= 0;
		end
		else begin
			q <= d;
			q1 <= d1;
			q2 <= d2;
		end
endmodule