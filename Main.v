`timescale 1ns / 1ps

module Main (
    input [7:0] num1,
    num2,
    input clk,
    start_btn,
    rst_btn,
    shift_right_btn,
    shift_left_btn,
    output [6:0] segments,
    output [3:0] anodes,
    output done,
    sh_right_led,
    sh_left_led,
    rst_led,
    start_led,
    load,
    dir,
    en
);
  wire is_negative1, is_negative2;
  wire [7:0] num_positive1, num_positive2;
  wire [15:0] bin;
  wire [19:0] bcd, shifted_bcd_int;

  wire sh_right_posedge, sh_left_posedge, rst_posedge, start_posedge;
  wire pb_clk;
  reg  start;

  //wire load, dir, en;

  assign sh_right_led = sh_right_posedge;
  assign sh_left_led = sh_left_posedge;
  assign rst_led = rst_posedge;
  assign start_led = start;

  ClockDivider #(500_000) pb_clockdiv (
      .clk(clk),
      .rst(rst_btn),
      .clk_out(pb_clk)
  );

  PushButtonDetector rst_detector (
      .clk(pb_clk),
      .rst(rst_btn),
      .a  (rst_btn),
      .x  (rst_posedge)
  );
  PushButtonDetector start_detector (
      .clk(pb_clk),
      .rst(rst_posedge),
      .a  (start_btn),
      .x  (start_posedge)
  );

  PushButtonDetector sh_right_detector (
      .clk(pb_clk),
      .rst(rst_posedge),
      .a  (shift_right_btn),
      .x  (sh_right_posedge)
  );
  PushButtonDetector sh_left_detector (
      .clk(pb_clk),
      .rst(rst_posedge),
      .a  (shift_left_btn),
      .x  (sh_left_posedge)
  );

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

  SeqMult seq_mult (
      .rst(rst_posedge),
      .clk(clk),
      .start(start),
      .multiplier(num_positive1),
      .multiplicand(num_positive2),
      .product(bin),
      .done(done)
  );

  // We need to load the contents of `bin` into the shift regiser module instance
  // when we finish the multiplication, then turn the `load` input of the 
  // shift register off to allow for shifting.
  // In order to achieve this, a PushButtonDetector is used to detect the 
  // positive edge of the `done` signal from the SeqMult and output it 
  // to `load`.
  PushButtonDetector load_driver (
      .clk(clk),
      .rst(rst_posedge),
      .a  (done),
      .x  (load)
  );

  DoubleDabble dd_inst (
      .bin(bin),
      .bcd(bcd)
  );

  assign en  = sh_left_posedge || sh_right_posedge;
  assign dir = sh_right_posedge ? 1 : 0;
  ShiftRegisterBidirectional shift_reg20 (
      .clk (clk),
      .num (bcd),
      .load(load),
      .en  (en),
      .dir (dir),
      .out (shifted_bcd_int)
  );

  Display3DigitsSign display_unit (
      .clk(clk),
      .rst(rst_posedge),
      .negative_sign(is_negative1 ^ is_negative2),
      .dig0(shifted_bcd_int[3:0]),
      .dig1(shifted_bcd_int[7:4]),
      .dig2(shifted_bcd_int[11:8]),
      .en(1'b1),
      .segments(segments),
      .anodes(anodes)
  );

  always @(posedge clk or posedge rst_posedge) begin
    if (start_posedge) start <= 1;
    else if (rst_posedge) start <= 0;
  end
endmodule
