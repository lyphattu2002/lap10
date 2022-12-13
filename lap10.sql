tạo  cơ sở dữ liệu QLSV
sử dụng QLSV
tạo  bảng Lop(
MaLop char ( 5 ) không phải là  khóa chính null  , 
TenLop nvarchar ( 20 ),
SiSo int )
tạo  bảng Sinhvien(
MaSV char ( 5 ) không phải là  khóa chính null  , 
Hoten nvarchar ( 20 ),
Ngày sinh ngay ,
MaLop char ( 5 ) ràng buộc tham chiếu fk_malop lop(malop))
tạo  bảng MonHoc(
MaMH char ( 5 ) không phải là  khóa chính null  , 
TenMH nvarchar ( 20 ))
tạo  bảng KetQua(
MaSV char ( 5 ) không  null ,
MaMH char ( 5 ) không  null ,
phao thi diem ,
ràng buộc fk_Masv khóa ngoại (MaSV) tham chiếu sinhvien(MaSV),
ràng buộc fk_Mamh tham chiếu khóa ngoại (MaMH) Monhoc(MaMH),
ràng buộc khóa chính  pk_Masv_Mamh (Masv, mamh))
chèn giá trị lop
( ' a' , ' lop a' , 0 ),
( ' b' , ' lop b' , 0 ),
( ' c' , ' lop c' , 0 )
chèn giá trị sinhvien
( ' 01' , ' Lê Minh' , ' 1999-1-1' , ' a' ),
( ' 02' , ' Le Hung' , ' 1999-11-1 ' , ' a' ),
( ' 03' , ' Lê Trí' , ' 12-12-1999 ' , ' a' )
chèn giá trị đơn sắc
( ' PPLT' , ' Phuong phap LT' ),
( ' CSDL' , ' Co so du lieu' ),
( ' SQL' , ' Hệ thống quản trị CSDL' ),
( ' PTW' , ' Web phát triển' )
chèn giá trị KetQua
( ' 01' , ' PPLT' , 8 ),
( ' 01' , ' SQL' , 7 ),
( ' 02' , ' PPLT' , 8 ),
( ' 01' , ' CSDL' , 5 ),
( ' 02' , ' PTW' , 5 )
-- 1.Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
đi
tạo  hàm diemtb (@msv char ( 5 ))
trả về  float
như
bắt đầu
 khai báo @tb float
 set @tb = ( select  avg (Diemthi)
 từ KetQua
trong đó MaSV = @msv)
 trả lại @tb
chấm dứt
đi
chọn  dbo . diemtb ( ' 01 ' )
-- 2.Viết hàm bằng 2 cách (table – value fuction and multistatement value function) tính điểm trung bình của
cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1
đi
-- cách 1
tạo  hàm trbinhlop(@malop char ( 5 ))
 bảng trả về
như
trở về
 chọn  s . masv , Hoten , trungbinh = dbo . diemtb ( s . maSV )
 from Sinhvien s tham gia KetQua k on  s . MaSV = k . MaSV
 nơi MaLop = @malop
C:\ data \HSGD_HKI_2018\HeQTCSDL\ Dapan_OntapSQL . sql  2
 nhóm theo  s . masv , Hoten
-- cách 2
đi
tạo  hàm trbinhlop1(@malop char ( 5 ))
trả về bảng @dsdiemtb (masv char ( 5 ), tensv nvarchar ( 20 ), dtb float )
như
bắt đầu
 chèn @dsdiemtb
 chọn  s . masv , Hoten , trungbinh = dbo . diemtb ( s . maSV )
 from Sinhvien s tham gia KetQua k on  s . MaSV = k . MaSV
 nơi MaLop = @malop
 nhóm theo  s . masv , Hoten
 trở về
chấm dứt
đi
select * from trbinhlop1( ' a' )
-- 3.Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên có MaSV=01
thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi
nào”
đi
tạo proc ktra @msv char ( 5 )
như
bắt đầu 
 khai báo @n int
 đặt @n = ( chọn  số lượng ( * ) từ ketqua trong đó Masv = @msv)
 nếu @n = 0 
 print  ' sinh vien ' + @msv +  ' khong thi mon nao'
 khác
 print  ' sinh vien ' + @msv +  ' thi ' + cast (@n as  char ( 2 )) +  ' mon'
chấm dứt 
đi
exec ktra ' 01'
-- 4.Viết một trình kích hoạt kiểm tra sỉ số lớp khi thêm sinh viên mới vào danh sách sinh viên thì hệ thống cập nhật
cập nhật lại siso của lớp, tối đa mỗi lớp là 10SV, nếu thêm vào > 10 thì thông báo lớp đầy đủ và hủy giao dịch
đi
tạo kích hoạt cập nhậtslop
trên sinhvien
để  chèn
như
bắt đầu
 khai báo @ss int
 set @ss = ( select  count ( * ) từ sinhvien s
 nơi malop vào ( chọn malop từ đã chèn))
 nếu @ss > 10
 bắt đầu
 in  ' Lop day'
 đảo  chiều
 chấm dứt
 khác
 bắt đầu
 cập nhật lop
 đặt SiSo = @ss
 nơi malop vào ( chọn malop từ đã chèn)
 chấm dứt
-- 5.Tạo 2 tên đăng nhập user1 và user2 đăng nhập vào sql, tạo 2 tên user tên user1 và user2
-- trên cơ sở dữ liệu Quản lý sinh viên tương ứng với 2 đăng nhập vừa tạo.
-- tao đăng nhập
tạo  đăng nhập user1 với  mật khẩu  =  ' 123'
tạo  đăng nhập user2 với  mật khẩu  =  ' 456'
-- hoac
sp_addlogin ' user1' , ' 123'
-- người dùng tao
tạo người dùng user1 để  đăng nhập user1
tạo người dùng user2 để  đăng nhập user2
C:\ data \HSGD_HKI_2018\HeQTCSDL\ Dapan_OntapSQL . sql  3
-- hoac
sp_adduser ' user1' , ' user1'
đi
-- 6.Gán quyền cho người dùng 1 quyền Insert, Update, trên bảng sinhvien,
-- gán quyền select cho user2 trên bảng sinhvien
cấp  Insert , Update  trên sinhvien cho user1
cấp  quyền chọn  trên sinhvien cho user2