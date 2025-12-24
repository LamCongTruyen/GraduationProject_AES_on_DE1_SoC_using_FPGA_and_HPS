module AES_CTR_pipelined (
    input  logic         clk,
    input  logic         reset,
	 input logic start_key_load,
    input  logic         enable,        // cho phép xử lý dòng plaintext
    input  logic [127:0] key,
    input  logic [127:0] nonce,
    input  logic [127:0] plaintext,
    output logic [127:0] ciphertext,
    output logic         valid_out,
	 output logic         all_keys_valid
   // output logic [127:0] counter_debug
);

    // --------------------------------
    // Tham số
    // --------------------------------
    localparam int LATENCY = 11;
	 //logic [127:0] key = 128'h0f1571c947d9e8590cb7add6af7f6798;
    //logic [127:0] nonce = 128'h00000000000000000000000000000001;
    //logic [127:0] plaintext = 128'h22222222222222222222222222222222;
//ocalparam [127:0] PLAINTEXT = 128'h22222222222222222222222222222222; 
//	 localparam [127:0] KEY= 128'h0f1571c947d9e8590cb7add6af7f6798;
	// localparam [127:0] NONCE = 128'h00000000000000000000000000000001;
	 
    // --------------------------------
    // Tín hiệu nội bộ
    // --------------------------------
    logic [127:0] counter;      // counter gửi vào AES
    logic [127:0] keystream;    // đầu ra AES (sau pipeline)
    logic [LATENCY:0] valid_pipe;
    logic [127:0] plaintext_delay [0:LATENCY];

    assign counter_debug = counter;

    // --------------------------------
    // AES pipeline
    // --------------------------------
    // --------------------------------
    // Register hóa key và nonce để cải thiện timing
    // --------------------------------
    logic [127:0] key_reg;
    logic [127:0] nonce_reg;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            key_reg   <= 128'b0;
            nonce_reg <= 128'b0;
        end else begin
            key_reg   <= key;     // chốt key từ demux
            nonce_reg <= nonce;   // chốt nonce từ demux
        end
    end

    // --------------------------------
    // AES pipeline
    // --------------------------------
    AES_pipeline_Encryption u_aes (
        .clk(clk),
        .reset(~reset),
        .plaintext(counter),
        .key(key_reg),        // dùng key_reg thay vì key trực tiếp
		  .start_key_load(start_key_load),
        .cypher(keystream),
		  .all_keys_valid(all_keys_valid)
		  
    );

    // --------------------------------
    // Counter logic
    // --------------------------------
    always_ff @(posedge clk or negedge reset) begin
        if (!reset)
            counter <= 128'h0;
        else if (enable)
            counter <= (counter == 128'h0) ? nonce_reg : (counter + 1);
    end


    // --------------------------------
    // Dịch valid qua pipeline
    // --------------------------------
    always_ff @(posedge clk or negedge reset) begin
        if (!reset)
            valid_pipe <= '0;
        else begin
            valid_pipe[0] <= enable;
            for (int i = 1; i <= LATENCY; i++)
                valid_pipe[i] <= valid_pipe[i-1];
        end
    end

    assign valid_out = valid_pipe[LATENCY];

    // --------------------------------
    // Delay plaintext qua pipeline
    // --------------------------------
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (int i = 0; i <= LATENCY; i++)
                plaintext_delay[i] <= '0;
        end else begin
            plaintext_delay[0] <= plaintext;
            for (int i = 1; i <= LATENCY; i++)
                plaintext_delay[i] <= plaintext_delay[i-1];
        end
    end

    // XOR plaintext và keystream
    // --------------------------------
    assign ciphertext = valid_out ? (plaintext_delay[LATENCY] ^ keystream) : 128'h0;

endmodule
