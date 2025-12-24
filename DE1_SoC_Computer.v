
//0f1571c947d9e8590cb7add6af7f6798


		module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,

	// ADC
//	ADC_CS_N,
//	ADC_DIN,
//	ADC_DOUT,
//	ADC_SCLK,

	// Audio
//	AUD_ADCDAT,
//	AUD_ADCLRCK,
//	AUD_BCLK,
//	AUD_DACDAT,
//	AUD_DACLRCK,
//	AUD_XCK,

	// SDRAM
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_LDQM,
	DRAM_RAS_N,
	DRAM_UDQM,
	DRAM_WE_N,

	// I2C Bus for Configuration of the Audio and Video-In Chips
//	FPGA_I2C_SCLK,
//	FPGA_I2C_SDAT,

	// 40-Pin Headers
	GPIO_0,
	GPIO_1,
	
	// Seven Segment Displays
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

	// IR
//	IRDA_RXD,
//	IRDA_TXD,

	// Pushbuttons
	KEY,

	// LEDs
	LEDR,

	// PS2 Ports
//	PS2_CLK,
//	PS2_DAT,
//	
//	PS2_CLK2,
//	PS2_DAT2,

	// Slider Switches
	SW,

	// Video-In
//	TD_CLK27,
//	TD_DATA,
//	TD_HS,
//	TD_RESET_N,
//	TD_VS,

	// VGA
//	VGA_B,
//	VGA_BLANK_N,
//	VGA_CLK,
//	VGA_G,
//	VGA_HS,
//	VGA_R,
//	VGA_SYNC_N,
//	VGA_VS,

	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
	
	// DDR3 SDRAM
	HPS_DDR3_ADDR,
	HPS_DDR3_BA,
	HPS_DDR3_CAS_N,
	HPS_DDR3_CKE,
	HPS_DDR3_CK_N,
	HPS_DDR3_CK_P,
	HPS_DDR3_CS_N,
	HPS_DDR3_DM,
	HPS_DDR3_DQ,
	HPS_DDR3_DQS_N,
	HPS_DDR3_DQS_P,
	HPS_DDR3_ODT,
	HPS_DDR3_RAS_N,
	HPS_DDR3_RESET_N,
	HPS_DDR3_RZQ,
	HPS_DDR3_WE_N,

	// Ethernet
	HPS_ENET_GTX_CLK,
	HPS_ENET_INT_N,
	HPS_ENET_MDC,
	HPS_ENET_MDIO,
	HPS_ENET_RX_CLK,
	HPS_ENET_RX_DATA,
	HPS_ENET_RX_DV,
	HPS_ENET_TX_DATA,
	HPS_ENET_TX_EN,

	// Flash
	HPS_FLASH_DATA,
	HPS_FLASH_DCLK,
	HPS_FLASH_NCSO,

	// Accelerometer
	HPS_GSENSOR_INT,
		
	// General Purpose I/O
	HPS_GPIO,
		
	// I2C
	HPS_I2C_CONTROL,
	HPS_I2C1_SCLK,
	HPS_I2C1_SDAT,
	HPS_I2C2_SCLK,
	HPS_I2C2_SDAT,

	// Pushbutton
	HPS_KEY,

	// LED
	HPS_LED,
		
	// SD Card
	HPS_SD_CLK,
	HPS_SD_CMD,
	HPS_SD_DATA,

	// SPI
	HPS_SPIM_CLK,
	HPS_SPIM_MISO,
	HPS_SPIM_MOSI,
	HPS_SPIM_SS,

	// UART
	HPS_UART_RX,
	HPS_UART_TX,

	// USB
	HPS_CONV_USB_N,
	HPS_USB_CLKOUT,
	HPS_USB_DATA,
	HPS_USB_DIR,
	HPS_USB_NXT,
	HPS_USB_STP
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

////////////////////////////////////
// FPGA Pins
////////////////////////////////////

// Clock pins
input						CLOCK_50;
input						CLOCK2_50;
input						CLOCK3_50;
input						CLOCK4_50;

// ADC
//inout						ADC_CS_N;
//output					ADC_DIN;
//input						ADC_DOUT;
//output					ADC_SCLK;

// Audio
//input						AUD_ADCDAT;
//inout						AUD_ADCLRCK;
//inout						AUD_BCLK;
//output					AUD_DACDAT;
//inout						AUD_DACLRCK;
//output					AUD_XCK;

// SDRAM
output 		[12: 0]	DRAM_ADDR;
output		[ 1: 0]	DRAM_BA;
output					DRAM_CAS_N;
output					DRAM_CKE;
output					DRAM_CLK;
output					DRAM_CS_N;
inout			[15: 0]	DRAM_DQ;
output					DRAM_LDQM;
output					DRAM_RAS_N;
output					DRAM_UDQM;
output					DRAM_WE_N;

// I2C Bus for Configuration of the Audio and Video-In Chips
//output					FPGA_I2C_SCLK;
//inout						FPGA_I2C_SDAT;

// 40-pin headers
inout			[35: 0]	GPIO_0;
inout			[35: 0]	GPIO_1;

// Seven Segment Displays
output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;

// IR
//input						IRDA_RXD;
//output					IRDA_TXD;

// Pushbuttons
input			[ 3: 0]	KEY;

// LEDs
output		[ 9: 0]	LEDR;

// PS2 Ports
//inout						PS2_CLK;
//inout						PS2_DAT;
//
//inout						PS2_CLK2;
//inout						PS2_DAT2;

// Slider Switches
input			[ 9: 0]	SW;

// Video-In
//input						TD_CLK27;
//input			[ 7: 0]	TD_DATA;
//input						TD_HS;
//output					TD_RESET_N;
//input						TD_VS;

// VGA
//output		[ 7: 0]	VGA_B;
//output					VGA_BLANK_N;
//output					VGA_CLK;
//output		[ 7: 0]	VGA_G;
//output					VGA_HS;
//output		[ 7: 0]	VGA_R;
//output					VGA_SYNC_N;
//output					VGA_VS;



////////////////////////////////////
// HPS Pins
////////////////////////////////////
	
// DDR3 SDRAM
output		[14: 0]	HPS_DDR3_ADDR;
output		[ 2: 0]  HPS_DDR3_BA;
output					HPS_DDR3_CAS_N;
output					HPS_DDR3_CKE;
output					HPS_DDR3_CK_N;
output					HPS_DDR3_CK_P;
output					HPS_DDR3_CS_N;
output		[ 3: 0]	HPS_DDR3_DM;
inout			[31: 0]	HPS_DDR3_DQ;
inout			[ 3: 0]	HPS_DDR3_DQS_N;
inout			[ 3: 0]	HPS_DDR3_DQS_P;
output					HPS_DDR3_ODT;
output					HPS_DDR3_RAS_N;
output					HPS_DDR3_RESET_N;
input						HPS_DDR3_RZQ;
output					HPS_DDR3_WE_N;

// Ethernet
output					HPS_ENET_GTX_CLK;
inout						HPS_ENET_INT_N;
output					HPS_ENET_MDC;
inout						HPS_ENET_MDIO;
input						HPS_ENET_RX_CLK;
input			[ 3: 0]	HPS_ENET_RX_DATA;
input						HPS_ENET_RX_DV;
output		[ 3: 0]	HPS_ENET_TX_DATA;
output					HPS_ENET_TX_EN;

// Flash
inout			[ 3: 0]	HPS_FLASH_DATA;
output					HPS_FLASH_DCLK;
output					HPS_FLASH_NCSO;

// Accelerometer
inout						HPS_GSENSOR_INT;

// General Purpose I/O
inout			[ 1: 0]	HPS_GPIO;

// I2C
inout						HPS_I2C_CONTROL;
inout						HPS_I2C1_SCLK;
inout						HPS_I2C1_SDAT;
inout						HPS_I2C2_SCLK;
inout						HPS_I2C2_SDAT;

// Pushbutton
inout						HPS_KEY;

// LED
inout						HPS_LED;

// SD Card
output					HPS_SD_CLK;
inout						HPS_SD_CMD;
inout			[ 3: 0]	HPS_SD_DATA;

// SPI
output					HPS_SPIM_CLK;
input						HPS_SPIM_MISO;
output					HPS_SPIM_MOSI;
inout						HPS_SPIM_SS;

// UART
input						HPS_UART_RX;
output					HPS_UART_TX;

// USB
inout						HPS_CONV_USB_N;
input						HPS_USB_CLKOUT;
inout			[ 7: 0]	HPS_USB_DATA;
input						HPS_USB_DIR;
input						HPS_USB_NXT;
output					HPS_USB_STP;

//localparam [127:0] KEYAES  = 128'h0f1571c947d9e8590cb7add6af7f6798;
//localparam [127:0] NONCE = 128'h00000000000000000000000000000001;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//wire			[15: 0]	hex3_hex0;
//wire			[15: 0]	hex5_hex4;

//assign HEX0 = ~hex3_hex0[ 6: 0]; // hex3_hex0[ 6: 0]; 
//assign HEX1 = ~hex3_hex0[14: 8];
//assign HEX2 = ~hex3_hex0[22:16];
//assign HEX3 = ~hex3_hex0[30:24];
//assign HEX4 = 7'b1111111;
//assign HEX5 = 7'b1111111;

//HexDigit Digit0(HEX0, hex3_hex0[3:0]);
//HexDigit Digit1(HEX1, hex3_hex0[7:4]);
//HexDigit Digit2(HEX2, hex3_hex0[11:8]);
//HexDigit Digit3(HEX3, hex3_hex0[15:12]);

//=======================================================
// HPS_to_FPGA FIFO state machine
//=======================================================
// --Check for data
//
// --Read data 
// --add one
// --write to SRAM
// --signal HPS data_ready
//=======================================================
// Controls for Qsys sram slave exported in system module
//=======================================================
wire [31:0] sram_readdata ;
reg [31:0] data_buffer, sram_writedata, data_buffer_out;
reg [7:0] sram_address; 
reg sram_write ;
wire sram_clken = 1'b1;
wire sram_chipselect = 1'b1;

(* keep_hierarchy = "yes", preserve, keep *)reg [3:0] state;

reg [2:0] state_key;

reg [127:0] input_buffer;
//reg [31:0] input_buffer [15:0];
reg [1:0] rdptr = 2'd0;
reg [1:0] wrptr = 2'd0;

//=======================================================
// Controls for HPS_to_FPGA FIFO
//=======================================================

reg [31:0] hps_to_fpga_readdata ; 
reg hps_to_fpga_read ;
// status addresses
// base => fill level
// base+1 => status bits; 
//           bit0==1 if full
//           bit1==1 if empty
wire [31:0] hps_to_fpga_out_csr_address = 0 ; // fill_level
reg	[31:0] hps_to_fpga_out_csr_readdata ;
reg [7:0] fill_level ;
reg hps_to_fpga_out_csr_read ; // status regs read cmd

reg	aes_start = 1'b0;
wire	aes_valid_out ;
reg [127:0]  aes_in, aes_data_buffer;

reg [127:0]  key_data = 32'd0;
reg [127:0] nonce_data = 32'd0;
reg key_received = 1'b0; //flag key
reg nonce_received = 1'b0; //flag nonce

wire [127:0]  aes_data_out;
reg rst_sync1, rst_sync2;
wire rst_release;
reg clk_1_clk;
wire clk_80m;         // clock đầu ra từ PLL
wire pll_locked;
reg key_ena;
wire validout_KEY;
reg key_valid =1'b0;
//always @(posedge CLOCK_50 or negedge KEY[0]) begin
//    if (!KEY[0]) begin
//        rst_sync1 <= 1'b0;
//        rst_sync2 <= 1'b0;
//    end else begin
//        rst_sync1 <= 1'b1;
//        rst_sync2 <= rst_sync1;
//    end
//end

assign rst_release = pll_locked;

//=======================================================
always @(posedge clk_80m or negedge rst_release) begin
    if (!rst_release) begin
        state <= 4'd0;
        sram_write <= 1'b0;
        wrptr <= 2'd0;
        rdptr <= 2'd0;
		  input_buffer <= 128'd0;
        hps_to_fpga_read <= 1'b0;
        hps_to_fpga_out_csr_read <= 1'b0;
		  state_key <= 3'd0;
		  aes_start <= 1'b0;
		  key_received <= 1'b0;
		  nonce_received <= 1'b0;
		  key_ena <= 1'b0;
		  key_valid <= 1'b0;
    end
    else begin
        key_ena <= 1'b0;
        sram_write <= 1'b0;
        hps_to_fpga_read <= 1'b0;
        hps_to_fpga_out_csr_read <= 1'b0;		  
		  aes_start <= 1'b0;
		  key_valid <= 1'b0;
        case (state)
            4'd0: begin
                hps_to_fpga_out_csr_read <= 1'b1;
                state <= 4'd1;
//						state <= 4'd2;
            end

            4'd1: begin
//					hps_to_fpga_out_csr_read <= 1'b0;
                state <= 4'd2;
            end

            4'd2: begin
					 hps_to_fpga_out_csr_read <= 1'b0;
                if (hps_to_fpga_out_csr_readdata > 0) begin
                    hps_to_fpga_read <= 1'b1;
                    state <= 4'd3;
//							 state <= 4'd4;
                end else begin
                    state <= 4'd0;
                end
            end

            4'd3: begin
                state <= 4'd4;
            end

            4'd4: begin
                input_buffer[127 - 32*wrptr -: 32] <= hps_to_fpga_readdata;
                hps_to_fpga_read <= 1'b0;			 
                if (wrptr == 2'd3) begin 	
						  wrptr <= 2'd0;
                    state <= 4'd5;						 
                end else begin
						  wrptr <= wrptr + 1'b1; 
                    state <= 4'd0; 			
                end
            end

            4'd5: begin 
					 if(!key_received) begin
							key_data <= input_buffer; //0f1571c947d9e8590cb7add6af7f6798'h//12345678910111213141516171819202
							key_received <= 1'b1;							
							key_ena <= 1'b1;
							if(validout_KEY)begin	
								state <= 4'd9; 
								key_valid <= 1'b1;
							end	
					 end else if(!nonce_received) begin
							nonce_data <= input_buffer; //00000000000000000000000000000001'h
							nonce_received <= 1'b1;
							state <= 4'd9; 
					 end else begin
							aes_start <= 1'b1;
							aes_in <= input_buffer;
							state <= 4'd6;
					 end
							
            end
	
				4'd6: begin 
					 aes_start <= 1'b0;
					 if(aes_valid_out) begin
						  aes_data_buffer <= aes_data_out;
						  state <= 4'd7;
					 end
					 rdptr <= 2'd0;
				end
				
            4'd7: begin
                sram_address <= 8'd1 + rdptr;
                sram_writedata <= aes_data_buffer[127 - 32*rdptr -: 32];
                sram_write <= 1'b1;
                state <= 4'd8;
            end

				4'd8: begin
					 sram_write <= 1'b0;
					 if (rdptr < 2'd3) begin
                    rdptr <= rdptr + 1'b1;		  
						  state <= 4'd7;
                end else begin
						  
                    state <= 4'd9;  
                end 
            end
				
            4'd9: begin
                sram_address <= 8'd0;
                sram_writedata <= 32'd1;
                sram_write <= 1'b1;
                state <= 4'd0;
            end

            default: begin
                state <= 4'd0;
            end
				
        endcase
    end
end

AES_CTR_pipelined aes_instance (
	 .clk(clk_80m),
    .reset(rst_release),
	 .start_key_load(key_ena),
    .enable(aes_start),
	 .key(key_data),
	 .nonce(nonce_data),
    .plaintext(aes_in),
    .ciphertext(aes_data_out),
    .valid_out(aes_valid_out),
	 .all_keys_valid(validout_KEY)
);

//=======================================================
//  Structural coding
//=======================================================
// From Qsys

Computer_System The_System (
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// 50 MHz clock bridge
	.clock_bridge_0_in_clk_clk          (clk_80m), //(CLOCK_50), 
   .clock_bridge_0_out_clk_1_clk       (clk_1_clk),
	
	.pll_0_outclk0_clk                  (clk_80m),                  //            pll_0_outclk0.clk
   .pll_0_locked_export                (pll_locked),                //             pll_0_locked.export
   .pll_0_reset_reset                  (!KEY[0]),                  //              pll_0_reset.reset
   .pll_0_refclk_clk                   (CLOCK_50) ,                  //             pll_0_refclk.clk
    
	// Global signals
	.sdram_clk_clk                      (),  
	.system_pll_ref_clk_clk					(clk_80m),
	.system_pll_ref_reset_reset			(1'b0),
		  
	// SRAM shared block with HPS
	.onchip_sram_s1_address               (sram_address),               
	.onchip_sram_s1_clken                 (sram_clken),                 
	.onchip_sram_s1_chipselect            (sram_chipselect),            
	.onchip_sram_s1_write                 (sram_write),                 
	.onchip_sram_s1_readdata              (sram_readdata),              
	.onchip_sram_s1_writedata             (sram_writedata),             
	.onchip_sram_s1_byteenable            (4'b1111), 

	.fifo_hps_to_fpga_out_readdata      (hps_to_fpga_readdata),      //  fifo_hps_to_fpga_out.readdata
	.fifo_hps_to_fpga_out_read          (hps_to_fpga_read),          //   out.read
	.fifo_hps_to_fpga_out_waitrequest   (),                            //   out.waitrequest
	.fifo_hps_to_fpga_out_csr_address   (hps_to_fpga_out_csr_address),   // fifo_hps_to_fpga_out_csr.address
	.fifo_hps_to_fpga_out_csr_read      (hps_to_fpga_out_csr_read),      //   csr.read
	.fifo_hps_to_fpga_out_csr_writedata (),                              //   csr.writedata
	.fifo_hps_to_fpga_out_csr_write     (1'b0),                           //   csr.write
	.fifo_hps_to_fpga_out_csr_readdata  (hps_to_fpga_out_csr_readdata),		//   csr.readdata
	
	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a			(HPS_DDR3_ADDR),
	.memory_mem_ba			(HPS_DDR3_BA),
	.memory_mem_ck			(HPS_DDR3_CK_P),
	.memory_mem_ck_n		(HPS_DDR3_CK_N),
	.memory_mem_cke		(HPS_DDR3_CKE),
	.memory_mem_cs_n		(HPS_DDR3_CS_N),
	.memory_mem_ras_n		(HPS_DDR3_RAS_N),
	.memory_mem_cas_n		(HPS_DDR3_CAS_N),
	.memory_mem_we_n		(HPS_DDR3_WE_N),
	.memory_mem_reset_n	(HPS_DDR3_RESET_N),
	.memory_mem_dq			(HPS_DDR3_DQ),
	.memory_mem_dqs		(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
	.memory_mem_odt		(HPS_DDR3_ODT),
	.memory_mem_dm			(HPS_DDR3_DM),
	.memory_oct_rzqin		(HPS_DDR3_RZQ),
		  
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),

	//.adc_sclk                        (ADC_SCLK),
	//.adc_cs_n                        (ADC_CS_N),
	//.adc_dout                        (ADC_DOUT),
	//.adc_din                         (ADC_DIN),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40	(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41	(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),


	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

	// LED 
	.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),
//
//	// SPI
	.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS), 


	// UART
	.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT)
);
endmodule // end top level
