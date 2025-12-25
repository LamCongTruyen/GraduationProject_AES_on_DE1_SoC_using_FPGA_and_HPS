# GraduationProject_AES_CTR128bit_Implementation_on_DE1_SoC_using_FPGA_and_HPS
Trong dự án này nhóm hai thành viên chúng tôi sử dụng bo mạch phát triển DE1-SoC, đầu tiên tôi muốn nói sơ qua quá trình từ lúc bắt đầu cho đến khi đạt được kết quả cuối cùng:
- Đầu tiên, tôi đưa ra lựa chọn là dùng UART làm giao thức truyền nhận dữ liệu cho module AES, vì khi mới bắt đầu dự án chúng tôi không có quá nhiều kinh phí đầu tư cho phần cứng nên chúng tôi dự định toàn bộ hệ thống sẽ được thiết kế trên FPGA.
- Sau khi hoàn tất đăng ký đề tài thì nhóm mới có cơ hội được tiếp cận với DE1-SoC một bo mạch phát triển được Terasic thiết kế cho chương trình dạy học. Tuy nhiên vì đã đăng ký và không thay đổi tên đề tài được nên hệ thống dùng UART chúng tôi vẫn phải hoàn thành, sau khi viết module giao thức UART và thực hiện truyền nhận dữ liệu thực tế trên kit thành công thì tôi cũng có tham khảo thêm ý kiến của thầy hướng dẫn và tôi quyết định phát triển dự án này cả trong lúc đang thực hiện. Lúc này thời gian chỉ còn khoảng 1 tháng rưỡi trước ngày bảo vệ, tôi quyết định chuyển sang sử dụng Ethernet (socket TCP/IP) chạy trên HPS để truyền nhận dữ liệu. Qúa trình thiết kế và kết quả được trình bày như các phần bên dưới.

Bộ công cụ phát triển DE1-SoC là một nền tảng thiết kế phần cứng mạnh mẽ được xây dựng xung quanh FPGA-SoC của Altera, kết hợp lõi nhúng Cortex-A9 mới nhất với logic lập trình hàng đầu trong ngành, mang lại sự linh hoạt tối ưu trong thiết kế
<img width="460" height="570" alt="image" src="https://github.com/user-attachments/assets/27e5fe10-03a7-43ab-8488-2f09d7d235db" />

<img width="570" height="461" alt="image" src="https://github.com/user-attachments/assets/7599be84-4121-4fbb-a817-3a9fda7aadc3" />

Hệ thống cơ bản bao gồm một giao diện thao tác trên máy tính được xây dựng dựa trên thư viện QtPy5, giao tiếp với DE1-SoC thông qua Ethernet bằng socket TCP/IP cho phép truyền nhận dữ liệu tốc độ cao. Người dùng trực tiếp thao tác trên giao diện này, chọn tải hình ảnh cần mã hóa/giải mã lên từ thư mục của máy tính hoặc chụp ảnh từ Camera.
<img width="1379" height="372" alt="image (6)" src="https://github.com/user-attachments/assets/422417f6-75c4-4bcc-8124-d370013d7cb8" />
Sơ đồ khối hệ thống gồm: 
- Hard Processor System (HPS): Dual-core ARM Cortex-A9 MPCore có tốc độ lên đến ~800MHz chạy hệ điều hành Linux được boot từ thẻ SD. Kết nối với các ngoại vi như Gigabit Ethernet, USB to UART.
- FPGA: gồm 2 IP chính được hỗ trợ bởi công cụ Platform Designer: On-chip Memory, FIFO Avalon Memory Mapped và module AES được chúng tôi thiết kế.
- Cầu giao tiếp AXI: được Platform Designer sinh ra tự động hỗ trợ tạo kết nối giữa phần HPS và FPGA.
<img width="700" height="444" alt="image" src="https://github.com/user-attachments/assets/6151ffd2-ebcb-46f2-a6d8-6de926f2fdbd" />


# Cấu hình Platform Designer (trước đây là Qsys):
<img width="1916" height="1050" alt="image" src="https://github.com/user-attachments/assets/40997467-6cdd-478d-8a0d-df1efd86243d" />

Bằng việc tham khảo các Golden Hardware Reference Design trong thư mục hướng dẫn cho người mới bắt đầu của Terasic, cũng như đọc qua các báo cáo của dự án ECE5760 của Đại học Cornell. Từ đó học cách sử dụng cách giao tiếp giữa HPS và FGPA, mặc dù có các cách cho tốc độ cao hơn như là: DMA, dual FIFO nhưng các cách này yêu cầu độ khó cao cũng như cần hiểu biết sâu hơn. Thời gian thực hiện không còn nhiều nên tôi quyết định chọn cách đó là gửi dữ liệu từ HPS đến FPGA bằng FIFO và đọc ngược lại bằng vùng nhớ có thể nhìn chung Onchip Memory.

Luồng thiết kế khi sử dụng công cụ Platform Designer:
<img width="700" height="500" alt="image (8)" src="https://github.com/user-attachments/assets/94e58f41-e0f8-4f97-834c-ce51c34242bd" />

Lưu đồ giải thuật chương trình C thực hiện giao tiếp giữa HPS và FPGA, các ô màu xanh dương là các lệnh thực thi trên HPS còn các ô màu xanh lục là các lệnh thực thi trên FPGA:
<img width="909" height="909" alt="image (7)" src="https://github.com/user-attachments/assets/fbceba74-1045-4a61-a28f-94f07499bc4a" />

Dạng sóng testbench topmodule thiết kế sử dụng UART truyền nhận dữ liệu cho module AES:
<img width="1846" height="584" alt="image (5)" src="https://github.com/user-attachments/assets/1601bd26-1e68-43aa-aa4b-b27f8f1f2b79" />

Phóng to dạng sóng thời điểm AES xử lý:
<img width="1101" height="501" alt="image (4)" src="https://github.com/user-attachments/assets/b5833411-420a-4290-8e6e-b51ec2a3bb2a" />

#Signal Tap Logic Analysis
Để tăng cường độ tin cậy của dự án thì ngoài testbench nhóm có sử dụng thêm công cụ SignalTap gỡ lỗi với tín hiệu thực tế khi chạy trên CHIP 
Dữ liệu sẽ được lưu vào RAM, luồng thiết kế trong dự án này được thực hiện như sau:
<img width="690" height="814" alt="image" src="https://github.com/user-attachments/assets/cc062eda-6ac3-490b-b0b7-35831b6fb00e" />

Trong dự án này nhóm thực hiện các điều kiện gỡ lỗi cơ bản, theo kiến thức và kinh nghiệm của người trực tiếp thực hiện là bản thân tôi:
- kiểm tra độ trễ thực tế module AES có đảm bảo theo tính toán là 11clk?
- kiểm tra tín hiệu aes_start có được kích hoạt? có tồn tại các trạng thái không xác định như X,Z?
- kiểm tra xem máy trạng thái có hoạt động đúng theo thiết kế hay có các trạng thái nào khác không?
- dữ liệu được máy trạng thái ghi lại trước mã hóa và sau khi được giải mã có chĩnh xác hay không?
- dữ liệu được ghi vào vùng nhớ On-chip Memory có chính xác hay không?

Tín hiệu độ trễ module AES quan sát được qua Signaltap:
<img width="945" height="210" alt="image" src="https://github.com/user-attachments/assets/23030f29-91d7-4ef4-a23c-8aafda9f4cb3" />

Dạng sóng ghi lại toàn bộ quá trình xử lý mã hóa một gói tin 128bit:
<img width="945" height="172" alt="image" src="https://github.com/user-attachments/assets/55c7b76f-0519-47ec-93bd-b0958394391f" />

Dạng sóng ghi lại quá trình mã hóa và ghi dữ liệu vào On-chip Memory:
<img width="944" height="157" alt="image" src="https://github.com/user-attachments/assets/75cedc29-0cab-48f0-9e64-d8b35264f604" />

Dạng sóng ghi lại quá trình giải mã ngược và ghi dữ liệu vào On-chip Memory:
<img width="945" height="172" alt="image" src="https://github.com/user-attachments/assets/392e7e44-e0af-4aa7-b793-7b9b20f107d7" />

# Triển khai trên FPGA
Kết quả tổng hợp hệ thống HPS-FPGA trên Cyclone V 5CSEMAF31C6

<img width="598" height="342" alt="image" src="https://github.com/user-attachments/assets/6cd99c77-236c-46a5-93a3-85d4d5492998" />

Kết quả tổng hợp khi sử dụng giao thức UART:

<img width="491" height="352" alt="image" src="https://github.com/user-attachments/assets/9b95d5fb-5b5e-4c97-b983-e2955912c41a" />

So sánh hai kết quả, có thể thấy được tốc độ toàn bộ hệ thống khi sử dụng thêm HPS giao tiếp ngoại vi nhanh hơn khi sử dụng mỗi UART với cấu hình 8N1 (8bit data, no parity, 1 stopbit) ở tốc độ Baud 115200 (khoảng 0.011MB/s) như trước đó nhóm thực hiện khoảng 400 lần. Mức sử dụng các khối logic cũng giảm từ 22000 xuống chỉ còn gần 8000.

# Trạng thái và kết quả xử lý được hiển thị trên Terminal trong quá trình chương trình hoạt động:

<img width="752" height="884" alt="image" src="https://github.com/user-attachments/assets/2c0ce9ae-7f26-4c85-88db-6fb5301be965" />

Tốc độ toàn bộ quá trình mã hóa cũng như giải mã dao động vào khoảng 4.5 đến 4.7MB/s (hình 4.23), tốc độ này hoàn toàn vẫn có thể tối ưu hơn chứ chưa phải là giới hạn. Dữ liệu (dữ liệu ở đây là hình ảnh) nhận từ client sau khi mã hóa/giải mã thì kích thước không hề thay đổi, dữ liệu với kích thước được toàn vẹn sau toàn bộ quy trình của cả hệ thống. Tốc độ ở khâu mã hóa có chút khác biệt với giải mã tại vì trong dự án này nhóm chọn phương thức nhận dữ liệu và phản hồi lại cho HPS là hai phương thức khác nhau. Điều này thì không gây ảnh hưởng gì đến độ chính xác cũng như là vi phạm bất cứ yêu cầu an toàn nào của hệ thống.

# Giao diện thao tác PyQt5
Giao diện PyQt5 thực hiện quy trình với dữ liệu được tải lên từ máy tính
<img width="828" height="424" alt="image" src="https://github.com/user-attachments/assets/9c264fc9-ba53-40dc-aa5f-9f3832bb5417" />

Giao diện PyQt5 thực hiện quy trình với dữ liệu từ ESPCam
<img width="839" height="429" alt="image" src="https://github.com/user-attachments/assets/8c709cce-8f3c-45cb-b946-ec4d0532c150" />

# Giao diện winform giao tiếp UART với module AES
<img width="935" height="525" alt="image" src="https://github.com/user-attachments/assets/c1e14dde-6c6c-4caf-9183-56d2b03dff9e" />

# Triển khai thực tế trên DE1-SoC
<img width="926" height="521" alt="image" src="https://github.com/user-attachments/assets/644e4eea-b73a-408d-b05f-684466566c9e" />

# Bản Final báo cáo Tốt nghiệp Đại học: 
https://docs.google.com/document/d/1xVUMK3fAIc5wAczC5PWcu856gjt7scLw/edit?usp=sharing&ouid=109821258768301239272&rtpof=true&sd=true
# Slide thuyết trình:
https://drive.google.com/file/d/1ngxJcHEp_deetAN-4ZRwzoEtzyoNM3FQ/view?usp=sharing
