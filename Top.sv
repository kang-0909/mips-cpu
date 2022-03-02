module Top(input logic clk_pre, reset,
           output logic ERR1,
           output logic [10:0] disp_7seg);

integer cnt_peri = 0, cnt_disp = 0;
logic CLK = 0;

always_ff @ (posedge clk_pre) begin
   cnt_peri <= cnt_peri + 1;
   cnt_disp <= cnt_disp + 1;
   if (cnt_peri == 500000) begin // change 500000 to 1 for simulations
       cnt_peri <= 0;
       CLK <= CLK ^ 1;
	end
   if (cnt_disp == 100000) begin
		cnt_disp <= 0;
		case (disp_pos)
			0: disp_pos <= 1;
			1: disp_pos <= 2;
			2: disp_pos <= 3;
			3: disp_pos <= 0;
		endcase
	end
end


// ----------------------------- NODES ---------------------------------
logic [31:0] ansFinal;
logic PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchEQD, BranchNED, Jump;
logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE;
logic RegWriteM, MemtoRegM, MemWriteM, RegWriteW, MemtoRegW;
logic StallF, StallD, ForwardAD, ForwardBD, FlushE;
logic [1:0] ForwardAE, ForwardBE;
logic [2:0] ALUControlD, ALUControlE;

logic [31:0] InstrF, PCPlus4F, PCF, InstrD, PCPlus4D, ksjAD, ksjBD, SignImmD, PCBranchD;
logic [31:0] ksjAE, ksjBE, SignImmE, ALUOutE, WriteDataE, ALUOutM, WriteDataM, ReadDataM, ReadDataW, ALUOutW, ResultW;
logic [4:0] RsD, RtD, RdD, RsE, RtE, RdE, WriteRegE, WriteRegM, WriteRegW;
logic [27:0] PCJ;

// ---------------------------  FIVE STAGES ----------------------------
partIF partIF(CLK, reset,
              PCSrcD, Jump,
              StallF, PCBranchD, PCJ, PCPlus4F, PCF);

partID partID(CLK, RegWriteW, ForwardAD, ForwardBD, WriteRegW,
              ResultW, PCPlus4D, InstrD, ALUOutM,
              PCSrcD, RegWriteD, MemtoRegD, MemWriteD, Jump,
              ALUControlD,
              ALUSrcD, RegDstD, BranchEQD, BranchNED,
              RsD, RtD, RdD,
              SignImmD, ksjAD, ksjBD, PCBranchD,
              ansFinal, PCJ);


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
assign CLR1 = PCSrcD | Jump;
assign EN1 = ~StallD;
assign CLR2 = FlushE;

always_ff @ (posedge CLK) begin // priority: if (stall && clr) then stall
    if (CLR1 && EN1|| reset) begin
        InstrD <= 0;
        PCPlus4D <= 0;
    end
    else if (EN1) begin
        InstrD <= InstrF;
        PCPlus4D <= PCPlus4F;
    end
end

always_ff @ (posedge CLK) begin
    if (CLR2 || reset) begin
        {ksjAE, ksjBE} <= 0;
        {RsE, RtE, RdE} <= 0;
        SignImmE <= 0;
        {RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE} <= 0;
    end
    else begin
        {ksjAE, ksjBE} <= {ksjAD, ksjBD};
        {RsE, RtE, RdE} <= {RsD, RtD, RdD};
        SignImmE <= SignImmD;
        {RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE} <= {RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD};
        ALUControlE <= ALUControlD;
    end
end

always_ff @ (posedge CLK) begin 
    if (reset) begin
        ALUOutM <= 0;
        WriteDataM <= 0;
        WriteRegM <= 0;
        {RegWriteM, MemtoRegM, MemWriteM} <= 0;
    end
    else begin
        ALUOutM <= ALUOutE;
        WriteDataM <= WriteDataE;
        WriteRegM <= WriteRegE;
        {RegWriteM, MemtoRegM, MemWriteM} <= {RegWriteE, MemtoRegE, MemWriteE};
    end
end

always_ff @ (posedge CLK) begin
    if (reset) begin
        {RegWriteW, MemtoRegW} <= 0;
        ReadDataW <= 0;
        ALUOutW <= 0;
        WriteRegW <= 0;
    end
    else begin
        {RegWriteW, MemtoRegW} <= {RegWriteM, MemtoRegM};
        ReadDataW <= ReadDataM;
        ALUOutW <= ALUOutM;
        WriteRegW <= WriteRegM; 
    end
end

// ------------------------- HAZARD MODULE ---------------------------
logic lwstall, branchstall;
always_comb begin
    if ((RsE != 0) && (RsE == WriteRegM) && RegWriteM) ForwardAE = 2'b10;
    else if ((RsE != 0) && (RsE == WriteRegW) && RegWriteW) ForwardAE = 2'b01;
    else ForwardAE = 2'b00;

    if ((RtE != 0) && (RtE == WriteRegM) && RegWriteM) ForwardBE = 2'b10;
    else if ((RtE != 0) && (RtE == WriteRegW) && RegWriteW) ForwardBE = 2'b01;
    else ForwardBE = 2'b00;

    lwstall = ((RsD == RtE) || (RtD == RtE)) && MemtoRegE;

    ForwardAD = (RsD != 0) && (RsD == WriteRegM) && RegWriteM;
    ForwardBD = (RtD != 0) && (RtD == WriteRegM) && RegWriteM;

    branchstall = (BranchEQD | BranchNED) && RegWriteE && (WriteRegE == RsD || WriteRegE == RtD) || (BranchEQD | BranchNED) && MemtoRegM && (WriteRegM == RsD || WriteRegM == RtD);

    StallF = (lwstall | branchstall);
    StallD = (lwstall | branchstall);
    FlushE = (lwstall | branchstall);
end


// ----------------------- DISPLAY MODULE -----------------------------
logic [3:0] disp_number, disp_A0, disp_A1, disp_B0, disp_B1;
integer disp_pos = 0;
always_comb begin 
    disp_A1 = ansFinal / 1000;
    disp_A0 = ansFinal / 100 - disp_A1 * 10;
    disp_B1 = ansFinal / 10 - disp_A1 * 100 - disp_A0 * 10;
    disp_B0 = ansFinal - disp_A1 * 1000 - disp_A0 * 100 - disp_B1 * 10;

	case (disp_pos)
		0: begin disp_7seg[10:7] = 4'b1110; disp_number = disp_B0; end
		1: begin disp_7seg[10:7] = 4'b1101; disp_number = disp_B1; end
		2: begin disp_7seg[10:7] = 4'b1011; disp_number = disp_A0; end
		3: begin disp_7seg[10:7] = 4'b0111; disp_number = disp_A1; end
		default: begin disp_7seg[10:7] = 4'b0000; disp_number = 0; end
	endcase

    case (disp_number)
        4'd0: disp_7seg[6:0] = 7'b0000001;
        4'd1: disp_7seg[6:0] = 7'b1001111;
        4'd2: disp_7seg[6:0] = 7'b0010010;
        4'd3: disp_7seg[6:0] = 7'b0000110;
        4'd4: disp_7seg[6:0] = 7'b1001100;
        4'd5: disp_7seg[6:0] = 7'b0100100;
        4'd6: disp_7seg[6:0] = 7'b0100000;
        4'd7: disp_7seg[6:0] = 7'b0001111;
        4'd8: disp_7seg[6:0] = 7'b0000000;
        4'd9: disp_7seg[6:0] = 7'b0000100;
        default: disp_7seg[6:0] = 7'b1111111;
    endcase
end

always_comb begin
    if (ansFinal == 5050) ERR1 = 1;
    else ERR1 = 0;
end

endmodule