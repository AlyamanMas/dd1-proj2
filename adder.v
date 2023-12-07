`timescale 1ns / 1ps

module MakePositive #(
    parameter width = 8
) (
    input signed [width-1:0] num,
    output is_negative,
    output [width-1:0] num_positive
);
  assign is_negative  = (num < 0);
  assign num_positive = (is_negative) ? -num : num;
endmodule

module Multiplier #(
    parameter in_width = 8  // Changed from input_width to width
) (
    input [in_width-1:0] multiplier,
    multiplicand,
    input rst,
    input start,
    output reg [2*in_width-1:0] product,  // Changed to reg and adjusted size
    output done
);
  always @(multiplier, multiplicand) begin
    product = multiplicand * multiplier;
  end
  assign done = 1;
endmodule

module DoubleDabble (
    input      [15:0] bin,  // Changed to 16-bit input
    output reg [19:0] bcd   // Changed to 20-bit output for 5 BCD digits
);
  integer i;

  always @(bin) begin
    bcd = 0;
    for (i = 0; i < 16; i = i + 1) begin  // Iterate once for each bit in the 16-bit input
      if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
      if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
      if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
      if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
      if (bcd[19:16] >= 5) bcd[19:16] = bcd[19:16] + 3;  // Added for the 5th BCD digit
      bcd = {bcd[18:0], bin[15-i]};  // Shift one bit, and shift in proper bit from input
    end
  end
endmodule

module ShiftRegisterBidirectional20 (
    input clk,
    input [19:0] num,
    input load,
    input en,
    input dir,
    output reg [19:0] out
);
  always @(posedge clk) begin
    if (load) begin
      // Load the new value into the register
      out <= num;
    end else if (en) begin
      if (dir == 1'b0) begin
        // Shift left by 4 bits with wrap-around
        out <= {out[15:0], out[19:16]};
      end else begin
        // Shift right by 4 bits with wrap-around
        out <= {out[3:0], out[19:4]};
      end
    end
  end
endmodule
