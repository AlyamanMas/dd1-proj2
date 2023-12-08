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
