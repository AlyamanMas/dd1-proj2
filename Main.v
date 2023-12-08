`timescale 1ns / 1ps

// This is the top-level module for an initial implementation of the
// project on the FPGA for testing. It uses a normal behavioral
// multiplier instead of the required sequential multiplier. It is tied
// to the constraint in `const.xdc`. It uses the FPGA's switches
// for 6-bits of numbers n1, n2, and 1-bit inputs clk, load, dir, and
// en; it also uses the LEDs for the display of the shifted_bcd,
// displaying 4 digits at a time.
module Main (
    input [5:0] n1,
    n2,
    input clk,
    load,
    dir,
    en,
    output [15:0] shifted_bcd
);
  wire [7:0] num1, num2;
  assign num1[7:6] = 2'b00;
  assign num1[5:0] = n1;
  assign num2[7:6] = 2'b00;
  assign num2[5:0] = n2;
  wire is_negative1, is_negative2;
  wire [7:0] num_positive1, num_positive2;
  wire [15:0] bin;
  wire [19:0] bcd, shifted_bcd_int;
  assign shifted_bcd = shifted_bcd_int[15:0];


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

  Multiplier #(8) mul_inst (
      .multiplier(num_positive1),
      .multiplicand(num_positive2),
      .rst(1'b0),
      .start(1'b1),
      .product(bin),
      .done()
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
      .out (shifted_bcd_int)
  );
endmodule
