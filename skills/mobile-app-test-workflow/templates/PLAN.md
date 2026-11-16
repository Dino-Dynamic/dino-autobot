# <TÊN DỰ ÁN> — KẾ HOẠCH TEST THEO RỦI RO

> Căn cứ: `2-baseline.md` (khách duyệt <ngày>), gói <…>. Người dùng duyệt kế hoạch: <chưa / ngày>.

## 1. Ưu tiên chức năng

| Chức năng | Ưu tiên | Lý do (bắt buộc với P0) |
|---|---|---|
| FT-01 <Đăng nhập> | P0 | Hỏng là không dùng được app |

P0 hỏng là không go-live · P1 phụ hay dùng · P2 giao diện, câu chữ, case hiếm · P3 chỉ khi còn thời gian.

## 2. Nhóm checklist

| Nhóm | Chọn? | Lý do |
|---|---|---|
| FUNC | ✅ | |
| MOB | | |
| AIC | | |
| SEC | | <cần đồng ý trên PROD?> |
| AIF | | <app có AI?> |
| PERF | | |
| REL, STORE-IOS, STORE-AND | Bước 7 | |

## 3. Bộ smoke cố định

Chạy đầu mỗi build mới, phủ toàn bộ P0, khoảng 15–30 bước / ~30 phút.

| ID | Thao tác → kỳ vọng | Phủ | Chạy ở |
|---|---|---|---|
| SM-01 | <Mở app lần đầu → thấy màn chào trong ≤ 3 s, không crash> | PERF-04 | Sim |

## 4. Checklist round 1

Mục `CK` giữ ID ổn định qua mọi round. Kỳ vọng ghi căn cứ (`BR` / `AS` / mẫu checklist).

| ID | Nhóm | Nguồn | Thao tác → kỳ vọng | Ưu tiên | Chạy ở |
|---|---|---|---|---|---|
| CK-001 | FUNC | FUNC-01 · UF-01 | <…> | P0 | Sim |

Tổng: <n> mục (P0 <n> · P1 <n> · P2 <n> · P3 <n>) · Claude chạy được <n> · cần máy thật / proxy <n>.

## 5. Lịch

| Round | Test | Khách sửa | Ghi chú |
|---|---|---|---|
| R1 | <dd/mm–dd/mm> | <…> | |
