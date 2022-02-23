module Regfile(input logic CLK, we3,
               input logic [4:0] ra1, ra2, wa3,
               input logic [31:0] wd3,
               output logic [31:0] rd1, rd2,
               output logic [31:0] s0);

logic [31:0] rf[31:0];
integer i = 0;
initial begin
    for (i=0; i < 32; i = i + 1) begin
        rf[i] = 0;
    end
end
always_ff @ (negedge CLK) begin
    if (we3) rf[wa3] <= wd3;
end

assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
assign s0 = rf[16];

endmodule