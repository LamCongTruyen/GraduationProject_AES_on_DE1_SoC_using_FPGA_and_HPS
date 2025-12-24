module AES_lastround (
    input  logic        clk,
	 input  logic        reset,
    input  logic [127:0] plaintext,   // đầu vào round 9
    input  logic [127:0] key,   // round key 10
    output logic [127:0] cypher       // đầu ra cuối cùng
);
  logic [127:0] sbox_out;
  logic [127:0] shift_out;
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

  // --- AddRoundKey ---
  assign round_out = shift_out ^ key;

  // --- Output Register ---
  always_ff @(posedge clk) begin
      if (reset)
          cypher <= 128'h0;   // reset output về 0
      else
          cypher <= round_out;
  end
endmodule
