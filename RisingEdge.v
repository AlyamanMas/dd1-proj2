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