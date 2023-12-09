module Display3DigitsSign (
    input clk,
    rst,
    en,
    input negative_sign,
    input [3:0] dig2,
    dig1,
    dig0,
    output [6:0] segments,
    output [3:0] anodes
);
  wire clk_out;
  wire [1:0] selector;
  reg [3:0] current_digit;

  ClockDivider #(250_000) clk_div (
      .clk(clk),
      .rst(1'b0),
      .clk_out(clk_out)
  );

  Counter #(2, 4) sel (
      .clk(clk_out),
      .reset(rst),
      .en(1'b1),
      .count(selector)
  );

  always @(*) begin
    case (selector)
      2'b00: current_digit <= dig0;
      2'b01: current_digit <= dig1;
      2'b10: current_digit <= dig2;
      2'b11: current_digit <= negative_sign ? 10 : 11;
    endcase
  end

  SevenSegDecWithEn display (
      .en(en),
      .sel(selector),
      .x(current_digit),
      .segments(segments),
      .anode_active(anodes)
  );
endmodule  // end Display3DigitsSign