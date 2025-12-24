
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <math.h> 
#include <stdint.h>
#include <arpa/inet.h>

// main bus; scratch RAM
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_ONCHIP_SPAN      0x000003ff //0x00001000

// main bus; FIFO write address
#define FIFO_BASE            0xC0000000
#define FIFO_SPAN            0x00000003 //0x00001000

/// lw_bus; FIFO status address
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x0000001f //0x00005000

#define PORT 9999
#define PORTSEND 8386
#define BUFFER_SIZE 65536

#define WAIT {}
#define FIFO_WRITE		     (*(FIFO_write_ptr))

#define WRITE_FIFO_FILL_LEVEL (*FIFO_status_ptr)
#define WRITE_FIFO_FULL		  ((*(FIFO_status_ptr+1))& 1 ) 

#define FIFO_WRITE_BLOCK(a)	  {while (WRITE_FIFO_FULL){WAIT};FIFO_WRITE=a;}

volatile unsigned int * FIFO_write_status_ptr = NULL ;

// the light weight buss base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
volatile unsigned int * FIFO_status_ptr = NULL ;

// RAM FPGA command buffer
// main bus addess 0x0800_0000
volatile unsigned int * sram_ptr = NULL ;
void *sram_virtual_base;

// HPS_to_FPGA FIFO write address
// main bus addess 0x0000_0000
void *h2p_virtual_base;
volatile unsigned int * FIFO_write_ptr = NULL ;

// /dev/mem file id
int fd;	
int N;
long total_bytes = 0;
struct timeval t1, t2;
double elapsedTime;
long total_bytes2 = 0;
long bytes_received;

//============================================

void recovered_image(const char* filename_read, const char* filename_write){
	printf("\nConvert file %s to %s\n",filename_read,filename_write);
	FILE *fbin = fopen(filename_read, "rb");
	if (!fbin) {
		perror("Cannot open file");
		return;
	}
	fseek(fbin, 0, SEEK_END);
	long total_bytes = ftell(fbin);
	fseek(fbin, 0, SEEK_SET);
	while(total_bytes % 16 != 0) total_bytes++;

	unsigned char *data = malloc(total_bytes);
	if (!data) {
		perror("Memory allocation failed");
		fclose(fbin);
		return;
	}
	fread(data, 1, total_bytes, fbin);
	fclose(fbin);

	FILE *fout = fopen(filename_write, "wb");
	if (!fout) {
		perror("\nCannot open output image file\n");
		free(data);
		return;
	}
	fwrite(data, 1, total_bytes, fout);
	fclose(fout);
	free(data);
	printf("Saved success: %s\n", filename_write);	
}
//0f1571c947d9e8590cb7add6af7f6798
//============================================
//0f1571c947d9e8590cb7add6af7f6798
void decrypt_from_bin(const char* filename_read){
	FILE *fbin = fopen(filename_read, "rb");
	if (!fbin) {
		perror("\nCannot open file in funtion decrypt_from_bin \n");
		return;
	}
	fseek(fbin, 0, SEEK_END);
	long total_bytes_long = ftell(fbin);
	fseek(fbin, 0, SEEK_SET);
	size_t total_bytes = (size_t) total_bytes_long;
	if (total_bytes_long <= 0) {
        perror("\nCannot open image file in funtion decrypt_from_bin\n");
        fclose(fbin);
        return;
    }
	
	unsigned char *buffer_data_bin = malloc(total_bytes);
	size_t read_bytes = fread(buffer_data_bin, 1, total_bytes, fbin);
	printf("\nRead %zu bytes from file %s\n", read_bytes,filename_read);
	fclose(fbin);
	long total_blocks = total_bytes / 16;//chia tổng byte ra thành các block 128bit-16byte
	uint8_t *plaintext_back = malloc(total_bytes); //calloc(1, total_bytes); //malloc(total_bytes); 
	uint32_t* data_from_bin = malloc(4 * sizeof(uint32_t));
	int count = 0;
	printf("\nSend Ciphertext data to FPGA...\n");
	gettimeofday(&t1, NULL);
	
	for (int block = 0; block < total_blocks; block++) { 
		for (int i = 0; i <4; i++) {
			int idx = block * 16 + i * 4;
			data_from_bin[i] =  (buffer_data_bin[idx] << 24)   |
								(buffer_data_bin[idx+1] << 16) |
								(buffer_data_bin[idx+2] << 8)  |
								buffer_data_bin[idx+3];
			// *(FIFO_write_ptr) = data_from_bin[i];
			FIFO_WRITE_BLOCK( data_from_bin[i] );
		}
		count += 16;
		while (*(sram_ptr) == 0);
		*(sram_ptr) = 0;

		for (int i = 0; i < 4; i++) {
			uint32_t word_data_bytes2 = *(sram_ptr + i + 1);
			int idx = block * 16 + i * 4;
			plaintext_back[idx + 0] = (word_data_bytes2>> 24)  & 0xFF; 
			plaintext_back[idx + 1] = (word_data_bytes2 >> 16) & 0xFF;
			plaintext_back[idx + 2] = (word_data_bytes2 >> 8)  & 0xFF;
			plaintext_back[idx + 3] =  word_data_bytes2 & 0xFF;        
		}
	}	
	//============================================
	gettimeofday(&t2, NULL);
	elapsedTime = (t2.tv_sec - t1.tv_sec)  * 1000000.0;  
	elapsedTime += (t2.tv_usec - t1.tv_usec) ;  
	double time_sec = elapsedTime / 1e6;
	double total_MB = count / (1024.0 * 1024.0);
	double MBps = total_MB / time_sec;
	printf("DECRYPT ciphertext time = %.2f us for %d BYTE\n", elapsedTime, count);
	printf("DECRYPT ciphertext speed = %.2f MB/s\n", MBps);
	//============================================
	FILE *fout = fopen("Plaintext_after_Decrypt.bin", "wb");
	if (fout) {
		fwrite(plaintext_back, 1, total_bytes, fout);
		fclose(fout);
		printf("Saved data after DECRYPT to file Plaintext_after_Decrypt.bin\n");
	}
	
	free(plaintext_back);
	free(data_from_bin);
	free(buffer_data_bin);
	recovered_image("Plaintext_after_Decrypt.bin", "Picture_decrypted.jpg");
	//Đọc lại byte của file hình ảnh sau giải mã 
	FILE *f_readagain = fopen("Picture_decrypted.jpg", "rb");
	if (!f_readagain) {
		perror("\nCannot open file Picture_decrypted.jpg \n");
		return;
	}
	fseek(f_readagain, 0, SEEK_END);
	long total_bytes_read_again = ftell(f_readagain);
	fseek(f_readagain, 0, SEEK_SET);
	printf("\nAfter DECRYPT, read %lu bytes from file Picture_decrypted.jpg\n", total_bytes_read_again);
}

//============================================

void encrypt_from_bytepicture(const char* filename_read){
	FILE *img = fopen(filename_read, "rb");
	if (!img) {
		perror("\nCannot open file in funtion decrypt_from_bin \n");
		return ;
	}

	fseek(img, 0, SEEK_END);
	long total_bytes = ftell(img);
	fseek(img, 0, SEEK_SET);	
	while(total_bytes%16 != 0) total_bytes++;
	printf("\nRead %lu bytes from file %s\n", total_bytes, filename_read);
	uint8_t *data_byte = malloc(total_bytes);
	fread(data_byte, 1, total_bytes, img);
	long total_blocks = total_bytes / 16;
	fclose(img);
	uint8_t *cipher_back = malloc(total_bytes);
	uint32_t *words_send = malloc(4 * sizeof(uint32_t));
	printf("\nSend Plaintext data to FPGA...\n");
	//============================================
	int count = 0;
	gettimeofday(&t1, NULL);
	//============================================
	for (int block = 0; block < total_blocks; block++) { 
		for (int i = 0; i <4; i++) {
			int idx = block * 16 + i * 4;
			words_send[i] =  (data_byte[idx] << 24) 	 |
								(data_byte[idx+1] << 16) |
								(data_byte[idx+2] << 8)  |
								data_byte[idx+3];
			// *(FIFO_write_ptr) = words_send[i];
			FIFO_WRITE_BLOCK( words_send[i] );	
		}
		count += 16;
		while (*(sram_ptr) == 0);
		*(sram_ptr) = 0;  
			
		for (int i = 0; i <4; i++) {
			uint32_t word_data_bytes2 = *(sram_ptr + i + 1);
			int idx = block * 16 + i * 4;
			cipher_back[idx + 0] = (word_data_bytes2>> 24) & 0xFF; 
			cipher_back[idx + 1] = (word_data_bytes2 >> 16) & 0xFF;
			cipher_back[idx + 2] = (word_data_bytes2 >> 8)  & 0xFF;
			cipher_back[idx + 3] = word_data_bytes2 & 0xFF;       
		}
	}
	gettimeofday(&t2, NULL);
	elapsedTime = (t2.tv_sec - t1.tv_sec)  * 1000000.0;     
	elapsedTime += (t2.tv_usec - t1.tv_usec) ;  
	double time_sec = elapsedTime / 1e6;
	double total_MB = count / (1024.0 * 1024.0);
	double MBps = total_MB / time_sec;
	printf("ENCRYPT plaintext time = %.2f us for %d BYTE\n", elapsedTime, count);
	printf("ENCRYPT plaintext speed = %.2f MB/s\n", MBps);
	
	FILE *fout = fopen("Ciphertext_after_Encypt.bin", "wb");
	if (!fout) {
		perror("Cannot open Ciphertext_after_Encypt.bin");
		return ;
	}
	fwrite(cipher_back, 1, total_bytes, fout);
	fclose(fout);
	printf("After ENCRYPT, saved %lu bytes to file name Ciphertext_after_Encypt.bin!\n", total_bytes);
	free(data_byte);
	free(words_send);
	free(cipher_back);
	recovered_image("Ciphertext_after_Encypt.bin", "Picture_encrypted.jpg");//chuyển bản mã thành file hình ảnh >>không mở được
//============================================
}
//============================================
void send_key_and_encrypt_image(const char *hexstring) {
	uint8_t key_bytes[16];
	uint32_t words_send_key[4];
	char hex_input[64];
	do {
		printf("\nType %s 128-bit (32hex characters, no space): ", hexstring);
		fflush(stdout);
		scanf("%32s", hex_input);
	} while(strlen(hex_input) != 32);

	for(int i = 0; i < 16; i++) {
		sscanf(hex_input + 2*i, "%2hhx", &key_bytes[i]);
	}

	printf("%s input: ", hexstring);
	for(int i=0; i<16; i++) printf("%02X ", key_bytes[i]);
	printf("\n");

	for(int i = 0; i < 4; i++) {
	words_send_key[i] = (key_bytes[4*i] << 24) |
					(key_bytes[4*i+1] << 16) |
					(key_bytes[4*i+2] << 8) |
					key_bytes[4*i+3];
	}

	for (int i = 0; i < 4; i++) {
		FIFO_WRITE_BLOCK(words_send_key[i]);
	}

	printf("Send %s to FPGA...\n", hexstring);
	while (*(sram_ptr) == 0);    
	*(sram_ptr) = 0;          
	printf("FPGA received %s !\n", hexstring);
}
//============================================
int main(void)
{
	int server_fd, new_socket;
	struct sockaddr_in address;
    socklen_t addrlen = sizeof(address);
    char buffer[BUFFER_SIZE];
	int sock;
    struct sockaddr_in server;  
    size_t bytes_read;

	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 
  	
	// === need to mmap: =======================
 
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
	//============================================
    // get virtual addr that maps to physical
	// for light weight bus
	// FIFO status registers
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
	//32bit FIFO status pointer
	FIFO_status_ptr = (unsigned int *)(h2p_lw_virtual_base);// ===========================================// ===========================================
	
	//============================================
	
	// scratch RAM FPGA parameter addr 
	sram_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE); 	
	
	if( sram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffer
	sram_ptr =(unsigned int *)(sram_virtual_base);// ===========================================// ===========================================
	
	// ===========================================

	// FIFO write addr 
	h2p_virtual_base = mmap( NULL, FIFO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FIFO_BASE); 	
	
	if( h2p_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}

	FIFO_write_ptr =(unsigned int *)(h2p_virtual_base);// ===========================================// ===========================================
	
	// ===========================================

	server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket failed");
        return -1;
    }
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        return -1;
    }
    listen(server_fd, 3);
    printf("✅ Server is running on Port %d...\n", PORT);

	while(1) 
	{
		new_socket = accept(server_fd, (struct sockaddr *)&address, &addrlen);
        if (new_socket < 0) {
            perror("Accept failed");
			close(new_socket);
            continue;
        }

        FILE *f = fopen("received_image.jpg", "wb");
        if (!f) {
            perror("File open failed");
            close(new_socket);
            continue;
        }
		
        while ((bytes_received = recv(new_socket, buffer, BUFFER_SIZE, 0)) > 0){
            fwrite(buffer, 1, bytes_received, f);
            total_bytes2 += bytes_received;
        }
		fclose(f);
		printf("      		DE1-SoC\n");
        printf("📸Received %ld BYTE from Client. Saved: received_image.jpg\n", total_bytes2);
		close(new_socket);
		total_bytes2=0;
//============================================
		send_key_and_encrypt_image("KEY");
		send_key_and_encrypt_image("NONCE");
		encrypt_from_bytepicture("received_image.jpg"); //hàm thực thi quy trình mã hóa
//============================================	
		printf("\nType '1' to DECRYPT the image and another number to exit: ");
		scanf("%d", &N);
		if( N != 1 ) {
			return 1;
		} else if( N == 1 ) {
			send_key_and_encrypt_image("KEY");
			send_key_and_encrypt_image("NONCE");
			decrypt_from_bin("Ciphertext_after_Encypt.bin"); //hàm thực thi quy trình giải mã
		} 		
//============================================	
		printf("Send feedback file to Client");
		sock = socket(AF_INET, SOCK_STREAM, 0);
		if(sock < 0) {
			perror("Socket creation failed");
			return 1;
		}
		server.sin_family = AF_INET;
		server.sin_port = htons(8386);
		server.sin_addr.s_addr = inet_addr("192.168.1.1"); 
		if(connect(sock, (struct sockaddr*)&server, sizeof(server)) < 0) {
			perror("Connect failed");
			close(sock);
			return 1;
		}
		FILE *foutcipher = fopen("Picture_decrypted.jpg", "rb");
		if(!foutcipher) {
			perror("File open failed");
			close(sock);
			return 1;
		}
		while((bytes_read = fread(buffer, 1, BUFFER_SIZE, f)) > 0) {
			if(send(sock, buffer, bytes_read, 0) < 0) {
				perror("Send feedback file to Client failed");
				fclose(foutcipher);
				close(sock);
				return 1;
			}
		}	
		fclose(foutcipher);
		close(sock);
	}
	close(server_fd);
	munmap(h2p_lw_virtual_base, HW_REGS_SPAN);
	munmap(sram_virtual_base, FPGA_ONCHIP_BASE);
	munmap(h2p_virtual_base, FIFO_BASE);
	close(fd);
	return 0;
}
