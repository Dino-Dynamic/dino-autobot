# <TÊN DỰ ÁN> — BÁO CÁO KIỂM THỬ & KHUYẾN NGHỊ GO-LIVE

| Mục | Thông tin |
|---|---|
| Ngày | <dd/mm/yyyy> |
| Build đã test | iOS <…> · Android <…> · Release build: <…> |
| Số round | <N> (<dd/mm> – <dd/mm>) |
| Thiết bị | <danh sách> |
| **Khuyến nghị** | **Go / Go có điều kiện / No-go** |

> Phạm vi cam kết: đã test phạm vi dưới đây trên các thiết bị trên qua <N> round. Báo cáo không khẳng định
> ứng dụng không còn lỗi; rủi ro còn lại liệt kê ở mục 5.

## 1. Phạm vi

| Đã test | Chưa test (lý do) |
|---|---|
| <chức năng / nhóm checklist> | <ngoài gói / cần máy thật / chưa được phép trên PROD / không có bản proxy> |

## 2. Defect

| Severity | Tổng | Open | Reopen | Fixed (chờ retest) | Closed | Won't fix |
|---|---|---|---|---|---|---|
| Critical | | | | | | |
| Major | | | | | | |
| Minor | | | | | | |
| Low | | | | | | |
| **Tổng** | | | | | | |

Defect còn mở: <ID · tiêu đề · severity · nền tảng>
Defect regression qua các round: <n>

## 3. Kết quả theo chức năng

| Ưu tiên | Chức năng | iOS | Android | Ghi chú |
|---|---|---|---|---|
| P0 | <FT-01 Đăng nhập> | Pass | Pass | |

## 4. Giả định chưa được khách xác nhận

| ID | Giả định | Đã test theo giả định này ở | Ảnh hưởng nếu sai |
|---|---|---|---|
| AS-xx | | | |

## 5. Rủi ro còn lại

- Phần chưa test: <…>
- Defect còn mở (Minor / Low): <…> — khách chấp nhận bằng văn bản: <có / chưa>
- Giới hạn môi trường: <không soi được API, chỉ test trên simulator / emulator cho phần …, chỉ có PROD…>

## 6. Tiêu chí go-live

| Tiêu chí | Đạt? | Chi tiết |
|---|---|---|
| 100% P0 Pass trên mọi nền tảng | | |
| Không còn Critical / Major đang mở | | |
| Smoke pass trên release build, không crash | | |
| Store không còn mục chặn | | |
| Minor / Low còn mở được khách chấp nhận | | |

## 7. Khuyến nghị

**<Go / Go có điều kiện / No-go>**

- Điều kiện (nếu Go có điều kiện): <điều kiện · ai làm · hạn>
- Lý do (nếu No-go): <mục P0 / defect / mục store>

## 8. Sau go-live (nếu có trong gói)

| Ngày | Tỉ lệ crash | Crash mới | Review store | Smoke bản tải từ store |
|---|---|---|---|---|
| | | | | |
