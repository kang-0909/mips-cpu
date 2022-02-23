module partIF(input logic CLK, reset,
              input logic PCSrcD, Jump,
              input logic StallF,
              input logic [31:0] PCBranchD,
              input logic [27:0] PCJ,
              output logic [31:0] PCPlus4F, PCF);

logic [31:0] pcc, pc;

always_ff @ (posedge CLK) begin
    if (reset) PCF <= 0;
    else if (!StallF) PCF <= pc;
end


assign pcc = PCSrcD ? PCBranchD : PCPlus4F;
assign pc = Jump ? {PCPlus4F[31:28], PCJ} : pcc;
assign PCPlus4F = PCF + 4;


endmodule