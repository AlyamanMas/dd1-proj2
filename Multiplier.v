`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 09:57:25 PM
// Design Name: 
// Module Name: Multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplier #(
    parameter in_width = 8
) (
    input [in_width-1:0] multiplier,
    multiplicand,
    input rst,
    input start,
    output reg [2*in_width-1:0] product,
    output done
);
  always @(multiplier, multiplicand) begin
    product = multiplicand * multiplier;
  end
  assign done = 1;
endmodule  // end Multiplier