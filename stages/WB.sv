module partWB(input logic RegWriteW, MemtoRegW,
              input logic [31:0] ReadDataW, ALUOutW,
              output logic [31:0] ResultW);

always_comb begin
    if (MemtoRegW) ResultW = ReadDataW;
    else ResultW = ALUOutW;
end

endmodule