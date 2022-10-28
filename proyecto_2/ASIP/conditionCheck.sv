module conditionCheck(input logic [1:0] op,
							 input logic [2:0] Cond, 
							 input logic [3:0] Flags,
							 output logic CondEx);
					  
	logic neg, zero, carryF, overflow, ge;
	logic [2:0] condAux;
	
	assign {neg, zero, carryF, overflow} = Flags;
	assign ge = (neg ^ overflow);
	
	always_comb
		casex(op)
		
			2'b00: condAux = 3'b000;
			2'b01: condAux = 3'b000;
			2'b10: condAux = Cond;
			default: condAux = 3'bx;
		endcase
		
		
	always_comb
		case(condAux)
			3'b001: CondEx = zero; 				// EQ
//			3'b001: CondEx = ~zero;				// NE
//			4'b0010: CondEx = carryF;				// CS
//			4'b0011: CondEx = ~carryF; 			// CC
//			4'b0100: CondEx = neg; 					// MI
//			4'b0101: CondEx = ~neg; 				// PL
//			4'b0110: CondEx = overflow;			// VS
//			4'b0111: CondEx = ~overflow;  		// VC
//			4'b1000: CondEx = ~zero & carryF; 	// HI
//			4'b1001: CondEx = zero | ~carryF; 	// LS
			3'b101: CondEx = ~ge; 					// GE
			3'b010: CondEx = ge; 					// LT
			3'b011: CondEx = ~zero & ~ge; 		// GT
			3'b100: CondEx = zero | ge;		 	// LE
			3'b000: CondEx = 1'b1; 				// Always-B
			default: CondEx = 1'bx; 				// undefined
		endcase
	
endmodule