module datapath(input  logic        clk, reset,
                input  logic [1:0]  RegSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic        ALUSrc,
                input  logic [1:0]  ALUControl,
                input  logic        MemtoReg,
                input  logic        PCSrc,
					 input  logic [16:0] Instr,
					 input  logic [16:0] ReadData,
                output logic [3:0]  ALUFlags,
                output logic [16:0] PC,
                output logic [16:0] ALUResult, WriteData
                );

  logic [16:0] PCNext, PCPlus4, PCPlus8;
  logic [16:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2;

  // next PC logic
  mux2 #(17)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(17) pcreg(clk, reset, PCNext, PC);
  adder #(17) pcadd1(PC, 17'b100, PCPlus4);
  adder #(17) pcadd2(PCPlus4, 17'b100, PCPlus8);

  // register file logic
  mux2 #(4)   ra1mux(Instr[11:8], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[3:0], Instr[7:4], RegSrc[1], RA2);
  regfile     rf(clk, RegWrite, RA1, RA2,
                 Instr[7:4], Result, PCPlus8, 
                 SrcA, WriteData); 
  mux2 #(17)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[10:0], ImmSrc, ExtImm);

  // ALU logic
  mux2 #(17)  srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
  ALUConFlags #(17) alu(SrcA, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
endmodule
