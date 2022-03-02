module Top(input logic CLK, reset);


// ----------------------------- NODES ---------------------------------
logic PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD;
logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE;
logic RegWriteM, MemtoRegM, MemWriteM, RegWriteW, MemtoRegW;
logic StallF, StallD, ForwardAD, ForwardBD, FlushE;
logic [1:0] ForwardAE, ForwardBE;
logic [2:0] ALUControlD, ALUControlE;

logic [31:0] InstrF, PCPlus4F, PCF, InstrD, PCPlus4D, ksjAD, ksjBD, SignImmD, PCBranchD;
logic [31:0] ksjAE, ksjBE, SignImmE, ALUOutE, WriteDataE, ALUOutM, WriteDataM, ReadDataM, ReadDataW, ALUOutW, ResultW;
logic [4:0] RsD, RtD, RdD, RsE, RtE, RdE, WriteRegE, WriteRegM, WriteRegW;

// ---------------------------  FIVE STAGES ----------------------------
partIF partIF(CLK, reset, PCSrcD, StallF, PCBranchD, PCPlus4F, PCF);
partID partID(CLK, RegWriteW, ForwardAD, ForwardBD, WriteRegW,
              ResultW, PCPlus4D, InstrD, ALUOutM,
              PCSrcD, RegWriteD, MemtoRegD, MemWriteD,
              ALUControlD,
              ALUSrcD, RegDstD, BranchD,
              RsD, RtD, RdD,
              SignImmD, ksjAD, ksjBD, PCBranchD);


partEX partEX(RegDstE, ALUSrcE,
              ALUControlE,
              ForwardAE, ForwardBE,
              ksjAE, ksjBE, SignImmE,
              RsE, RtE, RdE, 
              ALUOutM, ResultW,
              ALUOutE, WriteDataE,
              WriteRegE);

partMEM partMEM(CLK,
               RegWriteM, MemtoRegM, MemWriteM,
               ALUOutM, WriteDataM, PCF,
               WriteRegM,
               ReadDataM, InstrF);

partWB partWB(RegWriteW, MemtoRegW,
              ReadDataW, ALUOutW,
              ResultW);


// ------------------------- FOUR REGISTERS ----------------------------

logic CLR1, EN1, CLR2;
assign CLR1 = PCSrcD;
assign EN1 = ~StallD;
assign CLR2 = FlushE;

always_ff @ (posedge CLK) begin // priority: first stall then clear
                                // how to clear?
    if (CLR1 && EN1|| reset) begin
       
    end
    else if (EN1) begin
        
    end
end

always_ff @ (posedge CLK) begin
    if (CLR2 || reset) begin
        
    end
    else begin
       
    end
end

always_ff @ (posedge CLK) begin
    if (reset) begin
      
    end
    else begin
       
    end
end

always_ff @ (posedge CLK) begin
    if (reset) begin
       
    end
    else begin
       
    end
end

// ------------------------- HAZARD MODULE ---------------------------
logic lwstall, branchstall;
always_comb begin

    // caculate ForwardAE 
    // caculate ForwardBE


    lwstall = ;

    ForwardAD = ;
    ForwardBD = ;

    branchstall = ;

    StallF = ;
    StallD = ;
    FlushE = ;
end

endmodule