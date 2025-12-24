module AES_pipeline_Encryption (
    input  logic        clk,
    input  logic        reset,        // reset đồng bộ toàn mạch
    input  logic [127:0] plaintext,
    input  logic [127:0] key,
	 input logic start_key_load,
    output logic [127:0] cypher,
	 output logic all_keys_valid
);

  // ==========================
  // Round keys 0..10
      logic [127:0] round_key0;
     logic [127:0] round_key1;
     logic [127:0] round_key2;
     logic [127:0] round_key3;
     logic [127:0] round_key4;
     logic [127:0] round_key5;
     logic [127:0] round_key6;
     logic [127:0] round_key7;
     logic [127:0] round_key8;
     logic [127:0] round_key9;
	  logic [127:0] round_key10;
  KeyExp_Pipelined_10rounds u_keyexp (.clk(clk),.reset(reset),.start_key_load(start_key_load),
  .key(key),.round_key0(round_key0),.round_key1(round_key1),.round_key2(round_key2),.round_key3(round_key3),.round_key4(round_key4),.round_key5(round_key5)
  ,.round_key6(round_key6),.round_key7(round_key7),.round_key8(round_key8),.round_key9(round_key9),.round_key10(round_key10),.all_keys_valid(all_keys_valid));

  logic [127:0] s0;
  AES0 r0 (.clk(clk), .reset(reset), .plaintext(plaintext), .key(round_key0), .state_out(s0));

  logic [127:0] s1, s2, s3, s4, s5, s6, s7, s8, s9;

  // AES Round pipeline

  AES1 r1 (.clk(clk), .reset(reset), .plaintext(s0),    .key(round_key1), .cypher(s1));
  AES1 r2 (.clk(clk), .reset(reset), .plaintext(s1),    .key(round_key2), .cypher(s2));
  AES1 r3 (.clk(clk), .reset(reset), .plaintext(s2),    .key(round_key3), .cypher(s3));
  AES1 r4 (.clk(clk), .reset(reset), .plaintext(s3),    .key(round_key4), .cypher(s4));
  AES1 r5 (.clk(clk), .reset(reset), .plaintext(s4),    .key(round_key5), .cypher(s5));
  AES1 r6 (.clk(clk), .reset(reset), .plaintext(s5),    .key(round_key6), .cypher(s6));
  AES1 r7 (.clk(clk), .reset(reset), .plaintext(s6),    .key(round_key7), .cypher(s7));
  AES1 r8 (.clk(clk), .reset(reset), .plaintext(s7),    .key(round_key8), .cypher(s8));
  AES1 r9 (.clk(clk), .reset(reset), .plaintext(s8),    .key(round_key9), .cypher(s9));

  AES_lastround rlast (
      .clk(clk),
      .reset(reset),
      .plaintext(s9),
      .key(round_key10),
      .cypher(cypher)
  );

endmodule
