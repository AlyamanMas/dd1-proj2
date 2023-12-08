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
endmodule  // end MakePositive


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


module SeqMult #(
    parameter in_width = 8
) (
    input rst,
    clk,
    start,
    input [in_width-1:0] multiplier,
    multiplicand,
    output reg [2*in_width-1:0] product,
    output done
);
  wire load_prod, sel_prod;
  wire [2*in_width-1:0] in_prod;
  reg  [2*in_width-1:0] multiplicand_reg;  // This is A in Logisim
  wire en_a, load_a;
  reg [in_width-1:0] multiplier_reg;  // This is B in Logisim
  wire en_b, load_b;
  wire zflag, b0;

  assign in_prod = sel_prod ? 0 : product + multiplicand_reg;
  assign zflag = multiplier_reg == 0;
  assign b0 = multiplier_reg[0];

  MultControlUnit cu (
      .clk(clk),
      .rst(rst),
      .b0(b0),
      .zflag(zflag),
      .start(start),
      .sel_prod(sel_prod),
      .load_a(load_a),
      .load_b(load_b),
      .load_prod(load_prod),
      .en_a(en_a),
      .en_b(en_b),
      .done(done)
  );

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      multiplicand_reg <= 0;
      multiplier_reg <= 0;
      product <= 0;
    end else begin
      if (load_a) begin
        // assign each part separately to avoid verilator
        // warnings and potential undefined/unpredictable behavior
        multiplicand_reg[2*in_width-1:in_width] <= 0;
        multiplicand_reg[in_width-1:0] <= multiplicand;
      end else if (en_a) multiplicand_reg <= multiplicand_reg << 1;

      if (load_b) multiplier_reg <= multiplier;
      else if (en_b) multiplier_reg <= multiplier_reg >> 1;

      if (load_prod) product <= in_prod;
    end  // end else (not rst)
  end  // end always clk
endmodule  // end SeqMult


module MultControlUnit (
    input  clk,
    rst,
    b0,
    zflag,
    start,
    output sel_prod,
    load_a,
    load_b,
    load_prod,
    en_a,
    en_b,
    done
);
  reg [1:0] state = 1, next_state;
  localparam [1:0] S1 = 1, S2 = 2, S3 = 3;

  // state change based on previous states and input
  always @(zflag or start or state) begin
    case (state)
      S1: begin
        if (start) next_state = S2;
        else next_state = S1;
      end
      S2: begin
        if (zflag) next_state = S3;
        else next_state = S2;
      end
      S3: begin
        if (start) next_state = S3;
        else next_state = S1;
      end
      default: begin
        next_state = S1;
        // strings are concatednated to allow the string to be split
        // over multiple lines for readability
        $display({"WARNING: Reached default state in CU.", "This is not supposed to happen.",
                  "State: %d. Next State: %d."}, state, next_state);  // for debugging
      end
    endcase
  end

  // state switching mechanism
  always @(posedge clk or posedge rst) begin
    if (rst) state <= S1;
    else state <= next_state;
  end

  // signals in S1
  assign sel_prod = state == S1;
  assign load_a = (state == S1) && start;
  assign load_b = (state == S1) && start;

  // signals in S2
  assign en_a = state == S2;
  assign en_b = state == S2;
  assign load_prod = (state == S2) && !zflag && b0;

  // signals in S3
  assign done = state == S3;
endmodule  // end MultControlUnit


module DoubleDabble (
    input      [15:0] bin,
    output reg [19:0] bcd
);
  integer i;

  always @(bin) begin
    bcd = 0;
    for (i = 0; i < 16; i = i + 1) begin
      if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
      if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
      if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
      if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
      if (bcd[19:16] >= 5) bcd[19:16] = bcd[19:16] + 3;
      bcd = {bcd[18:0], bin[15-i]};
    end
  end
endmodule  // end DoubleDabble


module ShiftRegisterBidirectional #(
    parameter width = 20,
    shbits = 4
) (
    input clk,
    input [width-1:0] num,
    input load,
    input en,
    input dir,
    output reg [width-1:0] out
);
  always @(posedge clk) begin
    if (load) begin
      // Load the new value into the register
      out <= num;
    end else if (en) begin
      if (dir == 1'b0) begin
        // Shift left by 4 bits with wrap-around
        out <= {out[width-shbits-1:0], out[width-1:width-shbits]};
      end else begin
        // Shift right by 4 bits with wrap-around
        out <= {out[shbits-1:0], out[width-1:shbits]};
      end
    end
  end
endmodule  // end ShiftRegisterBidirectional


module RisingEdge (
    input  clk,
    rst,
    w,
    output z
);
  reg [1:0] state, nextState;
  parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10;  // States Encoding
  // Next state generation (combinational logic)
  always @(w or state)
    case (state)
      A:
      if (w == 0) nextState = A;
      else nextState = B;
      B:
      if (w == 0) nextState = A;
      else nextState = C;
      C:
      if (w == 0) nextState = A;
      else nextState = C;
      default: nextState = A;
    endcase
  // State register
  // Update state FF's with the triggering edge of the clock
  always @(posedge clk or posedge rst) begin
    if (rst) state <= A;
    else state <= nextState;
  end
  // output generation (combinational logic)
  assign z = (state == B && rst == 0);
endmodule  // end RisingEdge


module Debouncer (
    input  clk,
    rst,
    in,
    output out
);
  reg q1, q2, q3;
  always @(posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      q1 <= 0;
      q2 <= 0;
      q3 <= 0;
    end else begin
      q1 <= in;
      q2 <= q1;
      q3 <= q2;
    end
  end
  assign out = (rst) ? 0 : q1 & q2 & q3;
endmodule  // end Debouncer


module Synchronizer (
    input  clk,
    rst,
    in,
    output out
);
  reg q1, q2;
  always @(posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      q1 <= 0;
      q2 <= 0;
    end else begin
      q1 <= in;
      q2 <= q1;
    end
  end
  assign out = q2;
endmodule  // end Synchronizer


module Counter #(
    parameter width = 4,
    max_number = 6
) (
    input clk,
    reset,
    en,
    output reg [width-1:0] count
);

  always @(posedge clk, posedge reset) begin
    if (reset == 1) count <= 0;
    else if (en == 1) begin
      if (count == max_number - 1) count <= 0;
      else count <= count + 1;
    end
  end
endmodule  // end Counter


module ClockDivider #(
    parameter n = 50_000_000
) (
    input clk,
    rst,
    output reg clk_out
);
  wire [31:0] count;
  // Big enough to hold the maximum possible value
  // Increment count
  Counter #(32, n) counterMod (
      .clk(clk),
      .en(1'b1),
      .reset(rst),
      .count(count)
  );
  // Handle the output clock
  always @(posedge clk, posedge rst) begin
    if (rst)  // Asynchronous Reset
      clk_out <= 0;
    else if (count == n - 1) clk_out <= ~clk_out;
  end
endmodule  // end ClockDivider


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
  always @(sel) begin
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
      .en(1'b0),
      .count(selector)
  );

  // TODO: maybe change this to clk and see if anything changes
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


// clk must have ClockDivider with 500_000
module PushButtonDetector (
    input  a,
    clk,
    rst,
    output x
);
  wire b, c;
  //ClockDivider #(500_000) clkdiv (
  //    .clk(clk),
  //    .rst(rst),
  //    .clk_out(clk_out)
  //);
  Debouncer debounc (
      .clk(clk),
      .rst(rst),
      .in (a),
      .out(b)
  );
  Synchronizer synch (
      .clk(clk),
      .rst(rst),
      .in (b),
      .out(c)
  );
  RisingEdge rise_edg (
      .clk(clk),
      .rst(rst),
      .w  (c),
      .z  (x)
  );
endmodule

// Note to self:
// rst can be rising edge button since I believe it only needs
// one iteration to run
// start can also be rising edge where we actually use a start
// regsiter that becomes = 1 when the start button is pressed
// and it is equal to 0 when the rst button is pressed
