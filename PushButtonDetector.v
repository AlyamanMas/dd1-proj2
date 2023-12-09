// clk must have ClockDivider with 500_000
module PushButtonDetector (
    input  a,
    clk,
    rst,
    output x
);
  wire b, c, clk_out;
  ClockDivider #(500_000) clkdiv (
      .clk(clk),
      .rst(rst),
      .clk_out(clk_out)
  );
  Debouncer debounc (
      .clk(clk_out),
      .rst(rst),
      .in (a),
      .out(b)
  );
  Synchronizer synch (
      .clk(clk_out),
      .rst(rst),
      .in (b),
      .out(c)
  );
  RisingEdge rise_edg (
      .clk(clk_out),
      .rst(rst),
      .w  (c),
      .z  (x)
  );
endmodule
