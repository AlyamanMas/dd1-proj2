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
