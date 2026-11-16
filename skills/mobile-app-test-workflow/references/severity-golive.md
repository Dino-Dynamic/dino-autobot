# Severity và tiêu chí go-live (Phụ lục C, D)

## Severity — thang nội bộ

Dùng đúng 4 nhãn `Critical` · `Major` · `Minor` · `Low`, ghi nguyên văn tiếng Anh. Định nghĩa đầy đủ và luật
hạ mức: skill `qa-knowledge` (`references/severity-guide.md`). Tóm tắt:

| Mức | Định nghĩa |
|---|---|
| Critical | Tiến trình phần mềm ngưng, chức năng chính không chạy và kéo theo chức năng khác |
| Major | Chức năng chính chạy sai, dữ liệu lưu không chính xác, phần khác vẫn chạy |
| Minor | Hành vi ngoài mong đợi, hệ thống vẫn chạy, ảnh hưởng chủ yếu UX |
| Low | Sai message, chính tả, hiển thị; không gây sự cố |

Bước 2 của cách xếp: lỗi chỉ xảy ra ở thao tác / ngữ cảnh đặc biệt → hạ 1 mức (Major → Minor, Minor → Low;
Critical không hạ). Ghi lý do hạ mức vào Ghi chú của defect.

### Ví dụ cho app mobile

| Hiện tượng | Mức | Vì sao |
|---|---|---|
| App crash khi mở / ngay sau đăng nhập | Critical | Không phần nào dùng được |
| Không đăng nhập được với tài khoản hợp lệ | Critical | Chặn mọi chức năng sau đó |
| Mục **chặn duyệt store** (thiếu xoá tài khoản, release build crash, trỏ server dev) | Critical | Chặn phát hành — với dự án go-live coi như ngưng toàn bộ |
| Thanh toán thành công nhưng đơn không tạo; trừ tiền 2 lần | Major | Chức năng chính sai, dữ liệu / tiền không chính xác |
| Xem / sửa được dữ liệu của người dùng khác (IDOR, RLS hở); key bí mật nằm trong app | Major tối thiểu; Critical nếu lộ dữ liệu hàng loạt hoặc chiếm được tài khoản | Lộ dữ liệu — không áp luật hạ mức kể cả khi phải sửa request |
| Không sửa được hồ sơ, phải xoá đi tạo lại | Major | Chức năng chính sai, có cách đi vòng nhưng dữ liệu sai |
| Push không mở đúng màn; mất dữ liệu form khi đưa app xuống nền | Minor | Hệ thống vẫn chạy, ảnh hưởng UX |
| Lọc theo ngày sai khi đổi múi giờ | Minor (hạ từ Major) | Dữ liệu sai nhưng chỉ ở ngữ cảnh đặc biệt |
| Chữ bị cắt khi bật cỡ chữ lớn; lệch lề; sai chính tả | Low | Hiển thị |

Lỗi chỉ sai so với giả định `AS` **chưa xác nhận** → trạng thái `Cần xác nhận`, chưa xếp mức chính thức.

## Tiêu chí go-live (mặc định, chỉnh theo hợp đồng)

Ghi bộ tiêu chí đã chốt vào `0-intake.md`. Mặc định:

1. 100% mục P0 `Pass` trên mọi nền tảng trong phạm vi (`Pass - Need verify` phải đã được tester xác minh).
2. Không còn defect `Critical` / `Major` đang mở (Open / Reopen / Fixed chưa retest).
3. Smoke pass trên release build, không crash.
4. Checklist store không còn mục chặn.
5. Defect `Minor` / `Low` còn mở → liệt kê trong báo cáo, khách chấp nhận bằng văn bản.

### Khuyến nghị

| Tình trạng | Khuyến nghị |
|---|---|
| Đạt đủ 1–5 | **Go** |
| Đạt 1–4, còn điều kiện nhỏ (vd khách chưa xác nhận vài `AS` không thuộc P0, một mục store cần khách tự khai trên console) | **Go có điều kiện** — liệt kê từng điều kiện và ai làm |
| Trượt 1, 2, 3 hoặc 4 | **No-go** — liệt kê lý do (mục P0 nào, defect nào, mục store nào) |

Phần chưa test (theo gói, `Not run`, `N/A` vì chưa được phép trên PROD) không làm trượt tiêu chí nhưng **bắt
buộc** nằm trong *Rủi ro còn lại* của báo cáo.
