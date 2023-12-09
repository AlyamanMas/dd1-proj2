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
