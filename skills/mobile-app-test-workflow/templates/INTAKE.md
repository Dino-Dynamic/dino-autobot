# <TÊN DỰ ÁN> — TIẾP NHẬN & PHẠM VI

## 1. Câu hỏi intake

Câu hỏi từ `references/intake.md` mục A (đã bỏ câu biết sẵn). Trả lời của khách điền vào cột cuối.

| # | Nhóm | Câu hỏi | Trả lời của khách |
|---|---|---|---|
| 1 | App & nền tảng | | |

## 2. Quy mô

| Yếu tố | Giá trị | Ảnh hưởng tới phạm vi |
|---|---|---|
| Số màn hình (ước lượng) | | |
| Vai trò | | |
| Nền tảng | | |
| Thanh toán / AI / admin web / push | | |
| Môi trường | Staging / Chỉ PROD | |
| Bản cho phép proxy | Có / Không | |

## 3. Gói đề xuất

**Gói:** <Lite / Standard / Full> — lý do: <…>
Phần **không** nằm trong gói (sẽ là rủi ro chưa test): <…>

## 4. Khả thi mốc go-live

| Mục | Thời gian | Nguồn / ngày tra quy định |
|---|---|---|
| Mốc khách muốn | <dd/mm/yyyy> | |
| Chờ Apple duyệt | <…> | <ngày tra> |
| Closed test Google (nếu tài khoản cá nhân) | <…> | <ngày tra> |
| Số round × (test + khách sửa) | <…> | |
| **Kết luận** | Khả thi / Sát / Không khả thi — <đề xuất> | |

## 5. Đồng ý khi chỉ có PROD

| Việc trên PROD | Khách đồng ý? | Văn bản (email / tin nhắn, ngày) | Ghi chú |
|---|---|---|---|
| Tạo / sửa / xoá dữ liệu test (tiền tố `<…>`) | | | Ai dọn: |
| Gửi email / SMS / push | | | |
| Thanh toán test | | | |
| Thử bảo mật (IDOR, sửa request) | | | |

## 6. Phạm vi chốt (đưa vào hợp đồng / báo giá)

- Chức năng: <…>
- Nền tảng & thiết bị: <…>
- Số round: <N>; round thêm: <…>
- Thang severity: `Critical / Major / Minor / Low` (định nghĩa: `references/severity-golive.md`)
- Tiêu chí go-live: <mặc định / đã chỉnh: …>
- **Không bao gồm:** load test, pentest chuyên sâu, test trên quá nhiều thiết bị, sửa code, <…>
- Khách xác nhận: <ngày, hình thức>
