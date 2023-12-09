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