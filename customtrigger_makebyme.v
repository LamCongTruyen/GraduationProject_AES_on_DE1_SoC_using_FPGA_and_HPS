module customtrigger_makebyme ( //check signal aes_start
    input  wire        acq_clk,
    input  wire        reset,
    input  wire   	data_in,
    output         trigger_out
);
	 reg trigger_out_1, trigger_out_2;
    reg prev_start;
	 
    always @(posedge acq_clk or posedge reset) begin
        if (reset) begin
            prev_start  <= 1'b0;
//				trigger_out <= 1'b0;

				trigger_out_1 <= 1'b0;
				trigger_out_2 <= 1'b0;
        end else begin
//				trigger_out <= 1'b0;
            trigger_out_1 <= 1'b0;
				trigger_out_2 <= 1'b0;  			
			
				if(data_in === 1'bx || data_in === 1'bz) begin
					trigger_out_2 <= 1'b1; 
				end
				
				if (data_in == 1'b1 && prev_start == 1'b1) begin
					trigger_out_1 <= 1'b1;
				end
				
            prev_start <= data_in; 
        end
    end
	 
	 assign trigger_out = (trigger_out_1 || trigger_out_2);

endmodule
