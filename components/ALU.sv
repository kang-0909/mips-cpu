module ALU(input logic [2:0] Control,
           input logic [31:0] A, B,
           output logic [31:0] ALUOut);
always_comb begin
	case (Control)
			3'b000: ALUOut = A & B;
			3'b001: ALUOut = A | B;
			3'b010: ALUOut = A + B;
			3'b100: ALUOut = A & ~B;
			3'b101: ALUOut = A | ~B;
			3'b110: ALUOut = A - B;
			3'b111: ALUOut = {31'b0, A < B};
	endcase
end

endmodule