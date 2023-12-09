`timescale 1ns / 1ps

module testbench;

  reg clk;
  reg [7:0] num1;
  reg [7:0] num2;
  reg start_btn;
  reg rst_btn;
  reg shift_right_btn;
  reg shift_left_btn;
  wire [6:0] segments;
  wire [3:0] anodes;
  wire done;
  wire sh_right_led;
  wire sh_left_led;
  wire rst_led;
  wire start_led;
  wire load;
  wire dir;
  wire en;

  Main main_inst (
      .num1(num1),
      .num2(num2),
      .clk(clk),
      .start_btn(start_btn),
      .rst_btn(rst_btn),
      .shift_right_btn(shift_right_btn),
      .shift_left_btn(shift_left_btn),
      .segments(segments),
      .anodes(anodes),
      .done(done),
      .sh_right_led(sh_right_led),
      .sh_left_led(sh_left_led),
      .rst_led(rst_led),
      .start_led(start_led),
      .load(load),
      .dir(dir),
      .en(en)
  );

  initial begin
    clk = 0;
    num1 = 8'b00000101;
    num2 = 8'b00001010;
    start_btn = 1'b0;
    rst_btn = 1'b0;
    shift_right_btn = 1'b0;
    shift_left_btn = 1'b0;
    
    #100 
    rst_btn = 1;
    
    #14000000
    rst_btn = 0;

    #100;
    start_btn = 1;

    #14000000;
    start_btn = 0;

    #100;
    shift_right_btn = 1;

    #14000000;
    shift_right_btn = 0;

    // Add more test cases as needed
    #100000000000000000
    $finish;
  end

  always begin
    #1 clk = ~clk;
  end
endmodule
