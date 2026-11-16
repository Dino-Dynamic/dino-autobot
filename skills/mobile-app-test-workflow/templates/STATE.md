# <TÊN DỰ ÁN> — TRẠNG THÁI WORKFLOW TEST APP

> Skill `mobile-app-test-workflow` đọc file này mỗi lần được gọi. Cập nhật sau mỗi bước / cổng.

| Mục | Thông tin |
|---|---|
| Mã dự án (đầu Defect ID) | `<MÃ>` |
| Khách | <tên ngắn — không ghi thông tin liên lạc> |
| Nền tảng trong phạm vi | iOS · Android |
| Gói | Lite / Standard / Full |
| Số round theo hợp đồng | <N> (round thêm: <có tính phí / không>) |
| Môi trường | Staging · Chỉ PROD (đồng ý bằng văn bản: <đã có / chưa> — xem `0-intake.md`) |
| Ngôn ngữ văn bản gửi khách | Tiếng Việt / English |
| Mốc go-live khách muốn | <dd/mm/yyyy> |
| **Bước hiện tại** | Bước <n> — <tên> (round <N> nếu đang test) |
| **Đang chờ** | <ai · việc gì · từ ngày> (vd *Khách · duyệt baseline · 16/11*) |

## Cổng

| Bước | Cổng | Trạng thái | Ngày | Ghi chú |
|---|---|---|---|---|
| 0 | Khách xác nhận phạm vi, gói, số round | ⬜ | | |
| 1 | Cài được + đăng nhập được trên ≥ 1 iOS và ≥ 1 Android | ⬜ | | |
| 2 | Khách duyệt baseline (hoặc chấp nhận giả định) | ⬜ | | |
| 3 | Có checklist round 1 + bộ smoke, người dùng duyệt | ⬜ | | |
| 4–6 | Round 1…N: chạy hết checklist; khách xác nhận defect | ⬜ | | xem bảng Round |
| 7 | Release build pass smoke; store không còn mục chặn | ⬜ | | |
| 8 | Báo cáo + khuyến nghị đã gửi; khách chốt Go / No-go | ⬜ | | |
| 9 | Theo dõi sau go-live (nếu có trong gói) | ⬜ | | |

Trạng thái: ⬜ chưa · 🟡 đang làm · ✅ đạt · ⏭ bỏ qua (ghi ở *Quyết định*).

## Round

| Round | Build iOS | Build Android | Bắt đầu | Kết thúc | Kết quả (Pass / Fail / Blocked / Not run) | Defect mới | Tiêu chí go-live |
|---|---|---|---|---|---|---|---|
| R1 | | | | | | | Chưa đạt: <lý do> |

## Môi trường & thiết bị

| Việc | Ai làm | Trạng thái | Ghi chú |
|---|---|---|---|
| Build iOS (kênh: …; bản simulator: có / không) | | ⬜ | |
| Build Android (kênh: …) | | ⬜ | |
| Bản cho phép proxy | Khách | ⬜ | Không có → rủi ro |
| Tài khoản test từng vai (lưu ở `<file bí mật>`) | Khách | ⬜ | |
| Sandbox thanh toán | Khách | ⬜ | |
| Crashlytics / Sentry | Khách | ⬜ | |
| Nơi ghi defect | | ⬜ | `defects.md` / <hệ thống của khách> |

| Thiết bị | Loại | OS | Dùng cho | Ghi chú |
|---|---|---|---|---|
| iPhone 17 Pro | Simulator · udid `<…>` | iOS 26.5 | Smoke, FUNC, MOB | Claude chạy |
| <Samsung …> | Máy thật | Android <x> | Máy thật, PERF | Tester chạy |

## Quyết định

| Ngày | Quyết định (bỏ cổng / bỏ nhóm checklist / đổi phạm vi…) | Ai chốt | Rủi ro ghi vào báo cáo |
|---|---|---|---|
| | | | |
