# <TÊN DỰ ÁN> — ROUND <N>

| Mục | Thông tin |
|---|---|
| Loại round | Round 1 · Retest + regression |
| Build | iOS <x.y (b)> · Android <x.y (b)> |
| Thiết bị | <iPhone 17 Pro sim iOS 26.5 · Pixel 8 emulator Android 15 · …> |
| Thời gian | <dd/mm–dd/mm> |
| Defect khách báo đã sửa (round sau) | <ID…> |

Kết quả: `Pass` · `Fail` (Defect ID) · `Blocked` (lý do) · `N/A` (lý do) · `Not run` (lý do + ai chạy).
Mục P0 `Pass` và `Fail` Critical / Major do Claude chạy → `… - Need verify`; tester xác minh rồi đổi thành
`… - Verified by <tên>`. Ghi chú có `AI` khi Claude chạy.

## 1. Smoke

| ID | iOS | Android | Ghi chú |
|---|---|---|---|
| SM-01 | | | |

## 2. Retest (round 2…N)

| Defect | Severity | Build sửa | iOS | Android | Kết quả (Closed / Reopen) | Bằng chứng / lý do |
|---|---|---|---|---|---|---|
| | | | | | | |

## 3. Regression (round 2…N)

Lý do chọn: <mục cùng màn / cùng dữ liệu / cùng API với defect đã sửa · mọi luồng P0 (code AI)>.

## 4. Checklist

| ID | Nhóm | Thao tác → kỳ vọng | Ưu tiên | iOS | Android | Ghi chú |
|---|---|---|---|---|---|---|
| CK-001 | FUNC | | P0 | | | |

## 5. Khám phá ngoài checklist

| ID | Từ mục | Dấu hiệu | Đã thử | Thấy gì | Kết luận (Defect / OB chưa đủ bằng chứng / AS mới / mục CK đề xuất / không có gì) |
|---|---|---|---|---|---|
| OB-xx | | | | | |

## 6. Cần người chạy

| ID | Lý do (máy thật / proxy / thanh toán / chưa được phép trên PROD) | Ai chạy | Kết quả |
|---|---|---|---|
| | | | |

## 7. Tổng kết round

- Smoke: <Pass / Fail — chặn round?>
- Checklist: <x>/<y> · Pass <a> · Fail <b> · Blocked <c> · N/A <d> · Not run <e>
- Defect mới: <ID…> (Regression: <ID…>) · Retest: Closed <n> · Reopen <n>
- Chờ tester xác minh: <ID…>
- Tiêu chí go-live: <đạt / chưa đạt — lý do>
- Tin gửi khách: <đã soạn ở … / chưa>
