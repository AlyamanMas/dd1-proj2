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
  initial clk_out = 0;
endmodule  // end ClockDivider