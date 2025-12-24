module AES0 (
    input  logic        clk,
    input  logic        reset,         // reset đồng bộ
    input  logic [127:0] plaintext,    // đầu vào ban đầu
    input  logic [127:0] key,          // round key[0]
    output logic [127:0] state_out     // đầu ra sau AddRoundKey
);

  logic [127:0] addkey_result;

  // --- AddRoundKey combinational ---
  assign addkey_result = plaintext ^ key;

  // --- Pipeline register ---
  always_ff @(posedge clk) begin
    if (reset)
      state_out <= 128'h0;     // reset output về 0
    else
      state_out <= addkey_result; // lưu kết quả AddRoundKey
  end

endmodule
