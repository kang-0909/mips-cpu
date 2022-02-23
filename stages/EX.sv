module partEX(input logic RegDstE, ALUSrcE,
              input logic [2:0] ALUControlE,
              input logic [1:0] ForwardAE, ForwardBE,
              input logic [31:0] ksjAE, ksjBE, SignImmE,
              input logic [4:0] RsE, RtE, RdE,
              input logic [31:0] ALUOutM, ResultW,
              output logic [31:0] ALUOutE, WriteDataE,
              output logic [4:0] WriteRegE);

logic [31:0] SrcAE, SrcBE;
always_comb begin
    WriteRegE = RegDstE ? RdE : RtE;
    case (ForwardAE)
        2'b00: SrcAE = ksjAE;
        2'b01: SrcAE = ResultW;
        2'b10: SrcAE = ALUOutM;
    endcase
    case(ForwardBE) 
        2'b00: WriteDataE = ksjBE;
        2'b01: WriteDataE = ResultW;
        2'b10: WriteDataE = ALUOutM;
    endcase
    SrcBE = ALUSrcE ? SignImmE : WriteDataE;
end

ALU myALU(.A(SrcAE), .B(SrcBE), .Control(ALUControlE), .ALUOut(ALUOutE));


endmodule