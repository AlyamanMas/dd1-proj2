`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 09:36:41 PM
// Design Name: 
// Module Name: MakePositive
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

module MakePositive #(
    parameter width = 8
) (
    input signed [width-1:0] num,
    output is_negative,
    output [width-1:0] num_positive
);
  assign is_negative  = (num < 0);
  assign num_positive = (is_negative) ? -num : num;
endmodule  // end MakePositive