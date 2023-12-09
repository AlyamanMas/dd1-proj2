module Counter #(
    parameter width = 3,
    max_number = 6
) (
    input clk,
    reset,
    en,
    output [width-1:0] count
);
  reg [width-1:0] count_reg = 0;
  assign count = count_reg;
  always @(posedge clk, posedge reset) begin
    if (reset == 1) count_reg <= 0;
    else if (en == 1) begin
      if (count_reg == max_number - 1) count_reg <= 0;
      else count_reg <= count_reg + 1;
    end
  end
endmodule  // end Counter