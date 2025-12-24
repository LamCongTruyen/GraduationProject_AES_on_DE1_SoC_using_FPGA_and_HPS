module AES1 (
    input  logic        clk,
    input  logic        reset,        // thêm reset
    input  logic [127:0] plaintext,   // đầu vào round
    input  logic [127:0] key,         // khóa round i
    output logic [127:0] cypher       // đầu ra round
);
  // Intermediate signals
  logic [127:0] sbox_out;
  logic [127:0] shift_out;
  logic [127:0] mix_out;
  logic [127:0] round_out;

  // --- SubBytes ---
  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : sbox_loop
      sbox u_sbox (
          .a(plaintext[127 - 8*i -: 8]),
          .c(sbox_out[127 - 8*i -: 8])
      );
    end
  endgenerate

  // --- ShiftRows ---
  shiftrow u_shift (
      .in(sbox_out),
      .out(shift_out)
  );

  // --- MixColumns ---
  MixColumns_function u_mix (
      .in(shift_out),
      .dataout(mix_out)
  );

  // --- AddRoundKey ---
  assign round_out = mix_out ^ key;

  // --- Pipeline Register (1 stage delay) ---
  always_ff @(posedge clk) begin
      if (reset)
          cypher <= 128'h0;   // reset output về 0
      else
          cypher <= round_out;
  end

endmodule
