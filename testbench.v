`timescale 1ns / 1ps

module testbench;
  reg [7:0] num1, num2;
  reg clk, load, dir, en, rst, start;
  wire is_negative1, is_negative2, done;
  wire [7:0] num_positive1, num_positive2;
  wire [15:0] bin;
  wire [19:0] bcd, shifted_bcd;

  MakePositive #(8) mp_inst1 (
      .num(num1),
      .is_negative(is_negative1),
      .num_positive(num_positive1)
  );

  MakePositive #(8) mp_inst2 (
      .num(num2),
      .is_negative(is_negative2),
      .num_positive(num_positive2)
  );

  //Multiplier #(8) mul_inst (
  //    .multiplier(num_positive1),
  //    .multiplicand(num_positive2),
  //    .rst(1'b0),
  //    .start(1'b1),
  //    .product(bin),
  //    .done()
  //);

  SeqMult seq_mult (
      .rst(rst),
      .clk(clk),
      .start(start),
      .multiplier(num_positive1),
      .multiplicand(num_positive2),
      .product(bin),
      .done(done)
  );

  DoubleDabble dd_inst (
      .bin(bin),
      .bcd(bcd)
  );

  ShiftRegisterBidirectional shift_reg20 (
      .clk (clk),
      .num (bcd),
      .load(load),
      .en  (en),
      .dir (dir),
      .out (shifted_bcd)
  );

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    start = 0;
    en = 0;
    load = 0;
    dir = 0;
    num1 = -5;
    num2 = 10;
    #10;
    rst   = 0;
    start = 1;
    $display("is_negative1: %b, num_positive1: %d", is_negative1, num_positive1);
    $display("is_negative2: %b, num_positive2: %d", is_negative2, num_positive2);

    #100;
    $display("Binary product: %b", bin);
    $display("Binary product: %d", bin);

    #30;
    $display("BCD output: %b", bcd);
    $display("BCD output: %h", bcd);
    load = 1;

    #30;
    $display("BCD Shifted: %h", shifted_bcd);
    load = 0;
    en   = 1;

    #40;
    $display("BCD Shifted: %h", shifted_bcd);
    en = 0;
    $finish;
  end
endmodule
