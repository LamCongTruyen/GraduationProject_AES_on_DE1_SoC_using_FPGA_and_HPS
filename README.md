# GraduationProject_AES_Implementation_on_DE1_SoC_using_FPGA_and_HPS
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
<img width="779" height="444" alt="image" src="https://github.com/user-attachments/assets/6151ffd2-ebcb-46f2-a6d8-6de926f2fdbd" />


Cấu hình Platform Designer (trước đây là Qsys):
<img width="1916" height="1050" alt="image" src="https://github.com/user-attachments/assets/40997467-6cdd-478d-8a0d-df1efd86243d" />

Bằng việc tham khảo các Golden Hardware Reference Design trong thư mục hướng dẫn cho người mới bắt đầu của Terasic, cũng như đọc qua các báo cáo của khóa hoc ECE576 của Đại học Cornell. Từ đó học cách sử dụng cách giao tiếp giữa HPS và FGPA, mặc dù có các cách cho tốc độ cao hơn như là: DMA, dual FIFO nhưng các cách này yêu cầu độ khó cao cũng như cần hiểu biết sâu hơn. Thời gian thực hiện không còn nhiều nên tôi quyết định chọn cách đó là gửi dữ liệu từ HPS đến FPGA bằng FIFO và đọc ngược lại bằng vùng nhớ có thể nhìn chung Onchip Memory.

Luồng thiết kế khi sử dụng công cụ Platform Designer:
<img width="922" height="700" alt="image (8)" src="https://github.com/user-attachments/assets/94e58f41-e0f8-4f97-834c-ce51c34242bd" />
Lưu đồ giải thuật chương trình C thực hiện giao tiếp giữa HPS và FPGA, các ô màu xanh dương là các lệnh thực thi trên HPS còn các ô màu xanh lục là các lệnh thực thi trên FPGA:
<img width="909" height="909" alt="image (7)" src="https://github.com/user-attachments/assets/daa717a3-a311-46cc-96eb-4e9709357a34" />

Dòng SoCFPGA này cũng cho phép chạy một webserver bằng ngôn ngữ HTML nhưng vì tôi không thành thạo ngôn ngữ này nên đã chạy một server hết sức đơn giản bằng Python trên laptop Window sau đó gửi hình ảnh từ server tới HPS qua cổng Ethernet được kết nối trong mạng cục bộ. HPS nhận hình ảnh và xử lý bằng chương trình C chuyển hình ảnh thành các byte sau đó ánh xạ bộ nhớ tới các địa chỉ được khai báo ở đầu chương trình. Các địa chỉ này sinh ra trong quá trình Generate HDL trong Qsys nằm trong vùng bộ nhớ mặc định của FPGA được nhắc tới trong mục2:

https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/18.1/Computer_Systems/DE1-SoC/DE1-SoC_Computer_NiosII.pdf

Khi làm việc với dòng SoC này tôi tham khảo phần lớn tài liệu từ dự án Cornell ece5760 theo tôi tìm hiểu thì đây là một khóa đào tạo của đại học Cornell với sự hỗ trợ của Intel. Dự án hướng dẫn cho người học về lí thuyết các IP trong Qsys đi kèm chương trình mẫu, đường link dự án : 

https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/HPS_peripherials/FPGA_addr_index.html

Trang Youtube của BruceLand (một bên đồng hành cùng dự án) :

https://www.youtube.com/@ece4760

Trong phần giao tiếp HPS - FPGA mà trong đường link trên đề cập có 4 cách chính, tôi chọn cách mà tôi nghĩ là phù hợp với mình đó là "HPS to FPGA FIFO with feedback via SRAM scratchpad". Có thể hiểu là HPS giao tiếp với FPGA thông qua IP FIFO trong Qsys, FPGA làm gì đó với dữ liệu và ghi vào vùng SRAM chia sẽ chung giữa HPS và FPGA. HPS 'nhìn thấy' vùng nhớ đó là lấy dữ liệu thực hiện hoặc lưu trữ. Trước đó tôi cũng thử dùng "Full FIFO communication: HPS-to-FPGA and FPGA-to-HPS" nhưng việc bắt tay giữa các module thất bại nên tôi chọn cách mà tôi cho rằng mình nắm rõ hơn là "HPS to FPGA FIFO with feedback via SRAM scratchpad".

Tham khảo cách giao tiếp bên trong dự án tôi áp dụng vào dự án của mình như sau : trên HPS với Linux kernel 3.9 thì tôi xây dựng một chương trình C cho phép nhận ảnh từ webserver local (built đơn giản với python) sau đó chuyển hình ảnh ở dạng file nén jpg hoặc png dữ liệu byte. Ghi lần lượt dữ liệu ảnh xuống FPGA qua công cụ mmap ,FPGA nhận dữ liệu và đưa vào module AES_CTR để giải mã. Với mã hóa thì cũng thực hiện tương tự như vậy.

Kết quả chạy trên phần cứng thực tế cho tốc độ mã hóa cũng khá ấn tượng:

<img width="592" height="378" alt="image" src="https://github.com/user-attachments/assets/30dac101-77a0-4c41-9874-f4dc7bef481a" />

Video chạy thực tế trên phần cứng mà tôi đã thực hiện :

https://youtu.be/S9YSKvQt69U

À, một số ràng buộc về timing của SocFPGA vì thiếu tài liệu chính xác phải nên cài đặt như thế nào nên tôi sử dụng mặc định theo cài đặt của dự án gốc trong tutorial của Terasic.

Dự án này nối tiếp dự án UART on FPGA trước đó của tôi nên bạn sẽ thấy có 1 vài file không liên quan lắm ^^.
