TARGET = fifo
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-

CFLAGS = -g -Wall -D$(ALT_DEVICE_FAMILY) \
	-I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY) \
	-I$(HWLIBS_ROOT)/include/
LDFLAGS = -g -Wall

CC = $(CROSS_COMPILE)gcc
ARCH = arm

build: $(TARGET)

	
$(TARGET): fifo.o
	$(CC) $(LDFLAGS) $^ -o $@
	scp fifo root@192.168.1.2:/home/root
	scp root@192.168.1.2:/home/root/Picture_decrypted.jpg \
		 root@192.168.1.2:/home/root/Picture_encrypted.jpg \
		 /cygdrive/c/intelFPGA_lite/24.1/embedded/fifo_hps_fpga

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

	
.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~