module partID(input logic CLK, RegWriteW, 
              input logic ForwardAD, ForwardBD,
              input logic [4:0] WriteRegW,
              input logic [31:0] ResultW, PCPlus4D, InstrD, ALUOutM,
              output logic PCSrcD, RegWriteD, MemtoRegD, MemWriteD,
              output logic [2:0] ALUControlD,
              output logic ALUSrcD, RegDstD, BranchD,
              output logic [4:0] RsD, RtD, RdD,
              output logic [31:0] SignImmD, ksjAD, ksjBD, PCBranchD);

logic [1:0] ALUOp;
always_comb begin
    case(InstrD[31:26])
        6'b000000: {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, ALUOp} = ;
        6'b100011: {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, ALUOp} = ;
        6'b101011: {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, ALUOp} = ;
        6'b000100: {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, ALUOp} = ;
        6'b001000: {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, ALUOp} = ;
    endcase
    
    case(ALUOp)
        2'b00: ALUControlD = ;
        2'b10:  case(InstrD[5:0])
                    6'b100000: ALUControlD = ;
                    6'b100010: ALUControlD = ;
                    6'b100100: ALUControlD = ;
                    6'b100101: ALUControlD = ;
                    6'b101010: ALUControlD = ;
                    default: ALUControlD = ;
                endcase
        2'b01: ALUControlD = ;
    endcase
end

Regfile RF(.CLK(CLK), .we3(RegWriteW), .ra1(InstrD[25:21]), .ra2(InstrD[20:16]), .rd1(ksjAD), .rd2(ksjBD), .wa3(WriteRegW), .wd3(ResultW));
logic [31:0] tmp1, tmp2;
logic EqualD;
always_comb begin
    if (ForwardAD) tmp1 = ;
    else tmp1 = ;
    if (ForwardBD) tmp2 = ;
    else tmp2 = ;
    EqualD = ;
    PCSrcD = ;
end


always_comb begin
    RsD = ;
    RtD = ;
    RdD = ;
    SignImmD = ;
    PCBranchD = ;
end

endmodule