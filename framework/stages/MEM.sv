module partMEM(input logic CLK,
               input logic RegWriteM, MemtoRegM, MemWriteM,
               input logic [31:0] ALUOutM, WriteDataM, PCF,
               input logic [4:0] WriteRegM,
               output logic [31:0] ReadDataM, InstrF);

initial begin
    InstrF = 0;
end

myMem myMem(.CLK(CLK), .we(MemWriteM), .Dra(ALUOutM), .Drd(ReadDataM), .Dwd(WriteDataM), .Ira(PCF), .Ird(InstrF));

endmodule