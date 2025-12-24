module custom_trigger_statecheck(
    input        acq_clk,
    input        reset,
    input [3:0]  data_in,    
    output    trigger_out
);

reg [3:0] prev_state, counter;
reg trigger_out_1, trigger_out_2, trigger_out_3;

	always @(posedge acq_clk or posedge reset) begin
		 if (reset) begin
			  prev_state <= 4'd0;
			  trigger_out_1 <= 1'b0;
			  trigger_out_2 <= 1'b0;
			  trigger_out_3 <= 1'b0;
			  counter <= 4'd0;
			  
		 end else begin
			  trigger_out_1 <= 1'b0;
			  trigger_out_2 <= 1'b0;		 
			  
	//=========================	 
	
			  if (data_in[3:0] > 4'd9) begin //state có trường hợp ngoài các điều kiện case
					trigger_out_1 <= 1'b1;
			  end  
			  if (data_in[3:0] === 4'bxxxx || data_in[3:0] === 4'bzzzz) begin 
					trigger_out_2 <= 1'b1;
			  end
			  
	//=========================
	
			  if(data_in[3:0] == 4'd6) begin //trong state 6 nếu AES latch quá 11clk thì báo trigger
					counter <= counter + 1'd1;
					if(counter > 4'd12) begin
						trigger_out_3 <= 1'b1;
					end else begin
						trigger_out_3 <= 1'b0;
					end
			  end else begin
					counter <= 4'd0;
			  end
			  
	//=========================
			  prev_state <= data_in[3:0];
		 end
	end
	
	assign trigger_out = (trigger_out_1 || trigger_out_2 || trigger_out_3);

endmodule
