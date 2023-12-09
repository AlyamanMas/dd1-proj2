`timescale 1ns / 1ps

module shiftreg_test;

reg clk, en, dir, load;
reg [19:0] num;
wire [19:0] out;

ShiftRegisterBidirectional shift_reg20bit (
    .clk(clk),
    .en(en),
    .dir(dir),
    .load(load),
    .num(num),
    .out(out)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    en = 0;
    dir = 0;
    load = 0;
    num = 20'h12345;
    
    #20
    load = 1;
    
    #20
    load = 0;
    en = 1;
    
    #10 
    en = 0;
end
endmodule
