module partIF(input logic CLK, reset,
              input logic PCSrcD,
              input logic StallF,
              input logic [31:0] PCBranchD,
              output logic [31:0] PCPlus4F, PCF);

logic [31:0] pc;

always_ff @ (posedge CLK) begin
    if (reset) PCF <= ;
    else if (!StallF) PCF <= ;
end


always_comb begin
    PCPlus4F = ;
    
    if (PCSrcD) pc = ;
    else pc = ;

end

endmodule