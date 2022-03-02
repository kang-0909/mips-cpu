module myMem(input logic CLK, we,
               input logic [31:0] Ira, Dra,
               input logic [31:0] Dwd,
               output logic [31:0] Ird, Drd);

logic [31:0] RAM[255:0];

initial begin
    for (int i = 0; i < 256; i = i + 1) RAM[i] = 0;
    
    RAM[0] = 32'h20110001;
    RAM[1] = 32'h20100000;
    RAM[2] = 32'h20080065;
    RAM[3] = 32'h20090001;
    RAM[4] = 32'h02118020;
    RAM[5] = 32'h22310001;
    RAM[6] = 32'h0228502a;
    RAM[7] = 32'h112afffc;
    /*
	addi $s1, $0, 1
	addi $s0, $0, 0
	addi $t0, $0, 101
	addi $t1, $0, 1
for:add $s0, $s0, $s1
	addi $s1, $s1, 1
	slt $t2, $s1, $t0
	beq $t1, $t2, for
*/

end

always_ff @ (negedge CLK) begin
    if (we) RAM[Dra[31:2]] <= Dwd;
end

assign Ird = RAM[Ira[31:2]];
assign Drd = RAM[Dra[31:2]];

endmodule
