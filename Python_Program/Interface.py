import sys
import socket
import cv2
import base64
import numpy as np
from PyQt5.QtWidgets import (
    QApplication, QWidget, QPushButton, QLabel, QVBoxLayout,
    QHBoxLayout, QFileDialog
)
from PyQt5.QtGui import QPixmap, QImage
from PyQt5.QtCore import Qt, QTimer, QThread

SERVER_IP = "192.168.1.2"
PORT = 9999
PORT_RECV = 8386
BUFFER_SIZE = 65536
# CAM_URL = "http://192.168.1.135:81/stream"
CAM_URL = "http://192.168.59.19:81/stream"
# http://192.168.59.19
THRESH_VALUE = 128

SAVE_ORIGINAL = "received_image.jpg"
SAVE_THRESH   = "threshold_image.jpg"

class App(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("AES Encrypt/Decrypt Image - DE1-SOC")
        self.setGeometry(100, 100, 1200, 600)

        self.image_bytes = None
        self.image_path = None
        self.cap = None

        self.original_label = QLabel("Ảnh gốc")
        self.original_label.setAlignment(Qt.AlignCenter)
        self.original_label.setMinimumSize(400, 400)
        self.original_label.setStyleSheet("border: 1px solid gray; background: #f0f0f0")

        self.result_label = QLabel("Ảnh sau giải mã")
        self.result_label.setAlignment(Qt.AlignCenter)
        self.result_label.setMinimumSize(400, 400)
        self.result_label.setStyleSheet("border: 1px solid gray; background: #f0f0f0")

        self.cam_label = QLabel("Camera Stream")
        self.cam_label.setAlignment(Qt.AlignCenter)
        self.cam_label.setMinimumSize(400, 400)
        self.cam_label.setStyleSheet("border: 1px solid gray; background: #000")

        self.status_label = QLabel("Status: Đang khởi động camera...")
        # self.status_label.setAlignment(Qt.AlignCenter)

        self.btn_load = QPushButton("Tải hình ảnh")
        self.btn_send = QPushButton("Gửi đến DE1-SOC")
        self.btn_capture = QPushButton("Chụp từ Camera")

        self.btn_load.clicked.connect(self.load_image)
        self.btn_send.clicked.connect(self.send_image)
        self.btn_capture.clicked.connect(self.capture_from_stream)
    
        self.setup_ui()
        
        self.start_camera_stream()

    def setup_ui(self):
  
        img_row = QHBoxLayout()
        img_row.addWidget(self.original_label)
        img_row.addWidget(self.result_label)
        img_row.addWidget(self.cam_label)

        btn_row = QHBoxLayout()
        btn_row.addWidget(self.btn_load)
        btn_row.addWidget(self.btn_send)
        btn_row.addWidget(self.btn_capture)

        main_layout = QVBoxLayout()
        main_layout.addLayout(img_row)
        main_layout.addLayout(btn_row)
        main_layout.addWidget(self.status_label)
        self.setLayout(main_layout)

    def start_camera_stream(self):
        """Khởi động stream camera và timer"""
        self.cap = cv2.VideoCapture(CAM_URL)
        if not self.cap.isOpened():
            self.status_label.setText("Lỗi: Không kết nối được ESP32-CAM!")
            return

        self.timer = QTimer()
        self.timer.timeout.connect(self.update_stream)
        self.timer.start() 
        # self.status_label.setText("Camera đang stream...")

    def update_stream(self):
        """Cập nhật frame từ camera"""
        if not self.cap or not self.cap.isOpened():
            return

        ret, frame = self.cap.read()
        if not ret:
            self.cam_label.setText("Mất kết nối camera!")
            return
       
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        h, w, ch = rgb.shape
        bytes_per_line = ch * w
        qimg = QImage(rgb.data, w, h, bytes_per_line, QImage.Format_RGB888)
        pixmap = QPixmap.fromImage(qimg).scaled(400, 300, Qt.KeepAspectRatio)
        self.cam_label.setPixmap(pixmap)

    def capture_from_stream(self):
        """Chụp 1 frame từ camera làm ảnh gốc"""
        if not self.cap or not self.cap.isOpened():
            self.status_label.setText("Camera chưa sẵn sàng!")
            return
        self.timer.stop()
        ret, frame = self.cap.read()
        self.timer.start()
        if not ret:
            self.status_label.setText("Không chụp được ảnh!")
            return

        _, buf = cv2.imencode(".jpg", frame)
        self.image_bytes = bytes(buf)
        self.image_path = None

        self.show_image(self.original_label, frame)
        self.status_label.setText("Đã chụp!")

    def load_image(self):
        """Load ảnh từ file"""
        path, _ = QFileDialog.getOpenFileName(self, "Chọn ảnh", "", "Images (*.png *.jpg *.bmp)")
        if not path:
            return

        img = cv2.imread(path) #rawbyte h*w*ch
        if img is None:
            self.status_label.setText("Lỗi đọc ảnh!")
            return

        _, buf = cv2.imencode(".jpg", img) 
        self.image_bytes = buf
        self.image_path = path
        self.show_image(self.original_label, img)
        self.status_label.setText("Ảnh đã tải lên từ folder.")

# self.image_bytes = base64.b64encode(buf).decode()
# with open(path, "rb") as f: ##byte theo file
# raw = f.read()

    # def load_image(self):
        # """Load ảnh từ file"""
        # path, _ = QFileDialog.getOpenFileName(self, "Chọn ảnh", "", "Images (*.png *.jpg *.bmp)")
        # if not path:
            # return

        # img = cv2.imread(path)
        # if img is None:
            # self.status_label.setText("Lỗi đọc ảnh!")
            # return

        # with open(path, "rb") as f:
            # raw = f.read()
        # self.image_bytes = img
        # self.image_path = None
        # self.show_image(self.original_label, img)
        # self.status_label.setText("Ảnh đã tải lên từ folder.")
        
    def send_image(self):
        """Gửi ảnh đến DE1-SOC và nhận kết quả"""
        if self.image_bytes is None:
            self.status_label.setText("Chưa có ảnh để gửi!")
            return

        self.status_label.setText("Đang gửi ảnh...")
        self.timer.stop() # tạm dừng stream camera

        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                
                s.connect((SERVER_IP, PORT))
                    
                if self.image_path is not None: 
                    with open(self.image_path, "rb") as f:
                        data = f.read()
                else:                     
                    data = self.image_bytes    
                s.sendall(data)
                
            self.status_label.setText("Đã gửi, đang chờ phản hồi...")
        except Exception as e:
            self.status_label.setText(f"Lỗi gửi: {e}")
            return
        
        self.status_label.setText("📥 Chờ phản hồi...")
     # //0f1571c947d9e8590cb7add6af7f6798 
     
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:               
                s.bind(("0.0.0.0", PORT_RECV )) #gắn IP và port cho socket
                s.settimeout(60) 
                s.listen(1)           
                conn, addr = s.accept()
                data = b""
                while True:           
                        chunk = conn.recv(BUFFER_SIZE)
                        if not chunk:
                            
                            break
                        data += chunk                                 
                       
            img = cv2.imdecode(np.frombuffer(data, np.uint8), cv2.IMREAD_COLOR) #hoặc cv2.IMREAD_COLOR - IMREAD_UNCHANGED 
            # filename = "C:/Pythonprj/Anh_sau_giai_ma/savedImage.jpg"
            # cv2.imwrite(filename, img,[cv2.IMWRITE_JPEG_QUALITY, 89]) #lưu hình ảnh dùng để so sánh tiện hơn dùng command SCP
            if img is not None:
                self.show_image(self.result_label, img)
                self.status_label.setText("Giải mã thành công!")
            else:
                self.status_label.setText("Lỗi giải mã ảnh!")
              
            self.start_camera_stream() #tái khởi tạo camera nếu hình ảnh lớn quá gây timeout
            
        except Exception as e:
            self.status_label.setText(f"Lỗi nhận: {e}")
            self.start_camera_stream()
            return


    def show_image(self, label, img):
        """Hiển thị ảnh OpenCV lên QLabel"""
        h, w, ch = img.shape
        bytes_per_line = ch * w #tính số byte trong 1 hàng
        qimg = QImage(img.data, w, h, bytes_per_line, QImage.Format_BGR888)
        pixmap = QPixmap.fromImage(qimg).scaled(400, 400, Qt.KeepAspectRatio)
        label.setPixmap(pixmap)

    def closeEvent(self, event):
        """Dọn dẹp khi đóng"""
        if self.cap:
            self.cap.release()
        cv2.destroyAllWindows()
        super().closeEvent(event)

if __name__ == "__main__":
    
    app = QApplication(sys.argv)
    window = App()
    window.show()
    sys.exit(app.exec_())