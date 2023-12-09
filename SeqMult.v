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