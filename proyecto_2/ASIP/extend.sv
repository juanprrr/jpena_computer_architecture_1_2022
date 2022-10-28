module extend(input logic [10:0] Instr, //Se toma siempre el numero mas alto de bits en un immediato para no perder nunca informacion.
				  input logic [1:0] ImmSrc,
				  output logic [17:0] ExtImm);
	always_comb
		case(ImmSrc)
			// 4-bit unsigned immediate to data-proccesing instructions
			2'b00: ExtImm = {13'b0, Instr[3:0]}; 
			// 4-bit unsigned immediate to memory instructions
			2'b01: ExtImm = {13'b0, Instr[3:0]};
			// 11-bit two's complement shifted branch. 
			//Nuestra ASIP sería {4{Instr[10]}Instr[10:0], 2'b00
			2'b10: ExtImm = {{4{Instr[10]}}, Instr[10:0], 2'b00};
			//2'b10: ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
			
			//La extension consta de replicar el bit mas significativo del immediato 6 veces y agregar dos ceros como los LSB del numero (El shift)
			
			
			default: ExtImm = 17'bx; // undefined
		endcase
	
endmodule