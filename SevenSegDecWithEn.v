// NOTE: this is taken from a lab report submission for lab 5.
// It has been modified to replace hexadecimal entries with
// a positive or negative sign.
module SevenSegDecWithEn (
    input en,
    input [1:0] sel,
    input [3:0] x,
    output reg [6:0] segments,
    output reg [3:0] anode_active
);
  always @(en) begin
    if (en)
      case (sel)
        0: anode_active = 4'b1110;
        1: anode_active = 4'b1101;
        2: anode_active = 4'b1011;
        3: anode_active = 4'b0111;
      endcase
    else anode_active = 4'b1111;  // if !en, disable all digits
  end

  always @(x) begin
    case (x)
      0: segments = 7'b0000001;
      1: segments = 7'b1001111;
      2: segments = 7'b0010010;
      3: segments = 7'b0000110;
      4: segments = 7'b1001100;
      5: segments = 7'b0100100;
      6: segments = 7'b0100000;
      7: segments = 7'b0001111;
      8: segments = 7'b0000000;
      9: segments = 7'b0000100;
      // this is reserved for a negative sign
      10: segments = 7'b1111110;
      // this is reserved for a positive sign
      11: segments = 7'b1111111;
      default: segments = 7'b1111111;
    endcase
  end
endmodule  // end SevenSegDecWithEn