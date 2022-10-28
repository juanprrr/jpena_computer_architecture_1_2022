module toptestbench();

  logic        clk;
  logic        reset;

  logic [16:0] WriteData, DataAdr;
  logic        MemWrite;

  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite);
  
  // initialize test
	always 
	begin
	clk <= 0; # 5; clk <= 1; #5;
	end
	
	
	initial 
	begin 
		#5; reset = 1; #1; reset = 0;
	end
		
endmodule