module pipelineTestBench();
//			input  logic        clk, reset,
//			output logic		  MemWrite,
//         output logic [31:0] ResultW, WriteData,
//         output logic [31:0] ReadData 
//	

	logic clk, reset, MemWrite;
	logic [31:0] ResultW, WriteData, ReadData;
	
	pipelinedProcessor dut(clk, reset, MemWrite, ResultW, WriteData, ReadData);
	
	  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end


endmodule