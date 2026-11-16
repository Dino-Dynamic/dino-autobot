# <TÊN DỰ ÁN> — BASELINE REQUIREMENT

> Dựng lại từ hành vi app build <iOS x.y (b) · Android x.y (b)>, khám phá ngày <dd/mm/yyyy> với vai <…>.
> Đây là mốc để phân xử "bug hay tính năng". Khách duyệt: <chưa / ngày, hình thức>.

## 1. Đặc điểm app (dùng để chọn checklist ở Bước 3)

| Đặc điểm | Có? | Chi tiết |
|---|---|---|
| Đăng ký / đăng nhập (email, OTP, social) | | |
| Nhiều vai trò | | |
| Thanh toán (IAP / cổng khác) | | |
| Tính năng AI | | |
| Admin web | | |
| Push notification | | |
| Quyền hệ thống app xin (camera, vị trí, ảnh, micro, thông báo, tracking) | | |
| Deep link | | |
| Hỗ trợ iPad / tablet, xoay ngang | | |
| Đa ngôn ngữ / hiển thị tiền, ngày giờ | | |

## 2. Feature map

| Màn hình | Ảnh | Chức năng | Vai dùng được | Ghi chú |
|---|---|---|---|---|
| SC-01 <Đăng nhập> | `evidence/baseline/SC-01_dang-nhap.png` | FT-01 <Đăng nhập email> · FT-02 <Quên mật khẩu> | Mọi vai | |

Chưa khám phá được: <màn / chức năng · lý do (cần máy thật, chưa có tài khoản vai X…)>

## 3. User flow chính

| ID | Luồng | Các bước (màn đi qua) | Vai |
|---|---|---|---|
| UF-01 | <Đăng ký → xác thực → hoàn tất hồ sơ> | SC-02 → SC-03 → SC-04 | <…> |

## 4. Business rule suy ra

| ID | Rule | Suy ra từ (thao tác + kết quả thấy) | Liên quan | Khớp giả định |
|---|---|---|---|---|
| BR-01 | <Mật khẩu tối thiểu 8 ký tự> | <Nhập 7 ký tự → báo "…"> | FT-03 | AS-01 |

## 5. Giả định / câu hỏi cho khách

| ID | Giả định / câu hỏi | Vì sao hỏi | Trạng thái | Khách trả lời |
|---|---|---|---|---|
| AS-01 | <Mật khẩu tối thiểu 8 ký tự là đúng ý?> | <…> | Chưa xác nhận | |

Trạng thái: Chưa xác nhận · Đã xác nhận · Khách sửa lại (ghi hành vi đúng).

## 6. Bất thường thấy khi khám phá (chưa phải defect)

| ID | Màn / chức năng | Thấy gì | Bằng chứng | Xử lý ở Bước 3–4 |
|---|---|---|---|---|
| OB-01 | | | | Đưa vào checklist `CK-…` / hỏi `AS-…` |
