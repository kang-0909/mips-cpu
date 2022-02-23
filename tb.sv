module tb;

logic CLK = 0, reset = 0;
Top dut(CLK, reset);

initial begin
    reset = 1;
    #10;
    reset = 0;
    #10;
end

always begin
    CLK = 1; #5;
    CLK = 0; #5;
end

endmodule