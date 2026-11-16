# Checklist mẫu theo nhóm (Phụ lục B)

Dùng ở Bước 3 để chọn nhóm và cụ thể hoá thành mục `CK-xxx` của dự án, ở Bước 7 cho REL / STORE.

Cột:
- **Ưu tiên gợi ý:** mức mặc định khi đưa vào checklist; chỉnh theo ưu tiên của chức năng mà mục gắn vào.
- **Áp dụng khi:** đặc điểm app (ghi ở `2-baseline.md`) khiến mục này cần chạy. Trống = mọi app.
- **Chạy ở:** `Sim` = iOS Simulator / Android Emulator (Claude chạy được) · `Máy` = cần máy thật ·
  `Proxy` = cần proxy (Proxyman / Charles) và bản build cho phép proxy · `Tool` = cần công cụ riêng
  (jadx, MobSF, Crashlytics…). Nhiều giá trị = phần nào chạy ở đâu; Claude chạy phần `Sim`, phần còn lại để
  `Not run` kèm người chạy.

Mục FUNC là **mẫu**: ở Bước 3 nhân ra cho từng chức năng / luồng của baseline (vd FUNC-02 cho mọi form có ô
nhập), mỗi bản là một `CK` có cột *Nguồn* = `FUNC-02 · FT-07`.

> Quy định store (nhóm STORE, ngưỡng closed test, target API level) **đổi theo thời gian**. Nội dung dưới đây
> lấy từ tài liệu workflow gốc của người dùng, chưa kiểm lại. Trước khi dùng cho dự án: tra quy định hiện hành
> và ghi ngày tra vào `0-intake.md` / `7-release.md`.
> Ngày kiểm gần nhất: _chưa kiểm_.

## FUNC — Chức năng

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| FUNC-01 | Luồng P0 chạy từ đầu đến cuối với từng vai trò | P0 | | Sim (+ Máy nếu luồng cần phần cứng) |
| FUNC-02 | Validate ô nhập: để trống, quá dài, ký tự đặc biệt, emoji, tiếng Việt có dấu, khoảng trắng đầu / cuối, dán nội dung | P1 | Có form | Sim |
| FUNC-03 | Trạng thái màn hình: đang tải, danh sách rỗng, lỗi, rất nhiều dữ liệu (phân trang / cuộn vô hạn) | P1 | Có danh sách / tải dữ liệu | Sim (lỗi API: Proxy) |
| FUNC-04 | CRUD: tạo / xem / sửa / xoá → dữ liệu cập nhật đúng ở mọi màn liên quan | P0–P1 | Có tạo / sửa dữ liệu | Sim |
| FUNC-05 | Phân quyền theo vai: vai thấp không thấy / không làm được chức năng của vai cao | P0 | Nhiều vai trò | Sim |
| FUNC-06 | Phiên đăng nhập: hết hạn, đăng xuất rồi đăng nhập lại, đăng nhập cùng lúc trên 2 máy, đổi mật khẩu ở máy kia | P1 | Có đăng nhập | Sim (2 máy = 2 simulator / emulator) |
| FUNC-07 | Quên mật khẩu / OTP: nhận được, hết hạn, nhập sai nhiều lần, gửi lại | P0 | Có OTP / quên mật khẩu | Sim (cần hộp thư / SĐT test) |
| FUNC-08 | Thanh toán (sandbox): thành công, thất bại, huỷ giữa chừng, khôi phục giao dịch (restore purchase), webhook cập nhật trạng thái | P0 | Có thanh toán | Máy (IAP sandbox); Sim nếu cổng web có test mode |
| FUNC-09 | Đồng bộ với admin web: thao tác ở admin phản ánh đúng sang app và ngược lại | P1 | Có admin web | Sim + trình duyệt |
| FUNC-10 | Push notification: nhận khi app đang mở / chạy nền / đã tắt; bấm vào mở đúng màn | P1 | Có push | Máy (Sim chỉ giả lập payload) |

## MOB — Đặc thù mobile

Mỗi mục MOB dưới đây là nhóm lớn. Khi dựng `CK`, cụ thể hoá theo chức năng bằng các mục chi tiết của
`mobile-test-design/references/mobile-catalog.md` (vd MOB-01 → LC-01, LC-03 cho form chuyển tiền).

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| MOB-01 | Ngắt quãng: cuộc gọi đến, notification, đưa app xuống nền rồi mở lại, tắt hẳn app giữa thao tác | P1 (P0 cho luồng P0) | | Sim (nền / tắt app); Máy (cuộc gọi) |
| MOB-02 | Mạng: offline, mạng chậm, chuyển wifi ↔ 4G, bật chế độ máy bay giữa lúc gửi dữ liệu | P1 (P0 cho luồng P0) | Gọi API | Máy (Sim dùng mạng của máy tính); Proxy để giả lập chậm |
| MOB-03 | Quyền (camera, vị trí, ảnh, thông báo, micro): cho phép / từ chối / từ chối vĩnh viễn / thu hồi trong Cài đặt rồi quay lại app | P1 | App xin quyền | Sim (trừ camera); Máy (camera, ảnh chọn giới hạn) |
| MOB-04 | Giao diện: màn nhỏ, tai thỏ / Dynamic Island, xoay ngang, dark mode, cỡ chữ lớn, bàn phím che ô nhập | P2 | | Sim |
| MOB-05 | Điều hướng: nút / cử chỉ Back trên Android, vuốt back trên iOS, deep link, mở từ push | P1 | | Sim (deep link); Máy (mở từ push thật) |
| MOB-06 | Vòng đời: cài mới, cập nhật từ bản cũ (dữ liệu còn), gỡ cài rồi cài lại | P0 nếu là bản cập nhật | | Sim (cần build bản cũ) |
| MOB-07 | Thiết bị: sắp hết bộ nhớ, tiết kiệm pin, máy RAM thấp, hãng tắt app nền mạnh (Xiaomi / Oppo / Vivo) | P2 | Có Android | Máy |
| MOB-08 | Ngôn ngữ & giờ: đổi múi giờ, định dạng ngày / số / tiền tệ, đổi ngôn ngữ hệ thống | P2 | Hiển thị ngày giờ / tiền / đa ngôn ngữ | Sim |
| MOB-09 | iPad / tablet: giao diện dùng được (kể cả app chỉ làm cho iPhone) | P1 (iOS) | Có iOS | Sim |

## AIC — Lỗi điển hình của code do AI sinh

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| AIC-01 | API trả lỗi / rỗng / chậm → app không crash, không tải mãi; có thông báo lỗi | P1 | Gọi API | Proxy (Sim một phần: dữ liệu rỗng) |
| AIC-02 | Bấm liên tục / bấm 2 lần → không tạo trùng bản ghi, không trừ tiền 2 lần | P0 | Có tạo dữ liệu / thanh toán | Sim |
| AIC-03 | Không còn dữ liệu giả, lorem ipsum, nút không làm gì, màn "Coming soon", TODO, màn debug | P1 | | Sim |
| AIC-04 | Nhất quán giữa các màn: style, câu chữ, cách validate cùng một loại dữ liệu | P2 | | Sim |
| AIC-05 | Hành vi iOS và Android giống nhau cho cùng chức năng | P1 | Cả hai nền tảng | Sim |
| AIC-06 | Không còn log in token / dữ liệu nhạy cảm ra console | P1 | | Sim (đọc log thiết bị) |
| AIC-07 | Không trỏ về server dev / localhost ở build gửi test | P0 | | Proxy / Tool |

## SEC — Bảo mật nhanh (cần khách đồng ý nếu chạy trên PROD)

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| SEC-01 | Không có API key / secret viết thẳng trong app (giải nén APK bằng jadx / quét MobSF) | P0 | | Tool |
| SEC-02 | Firebase rules / Supabase RLS: người chưa đăng nhập hoặc user khác không đọc / ghi được dữ liệu không thuộc về mình | P0 | Backend Firebase / Supabase | Tool / Proxy |
| SEC-03 | IDOR: đổi ID trong request (qua proxy) không xem / sửa được dữ liệu người khác | P0 | Có dữ liệu theo người dùng | Proxy |
| SEC-04 | Kiểm quyền ở server: sửa request để gọi chức năng của vai cao hơn → bị chặn | P0 | Nhiều vai trò | Proxy |
| SEC-05 | Dữ liệu nhạy cảm không lưu dạng rõ trên máy; đăng xuất xoá token | P1 | | Sim (đọc container app trên simulator) / Tool |
| SEC-06 | Endpoint admin / debug không lộ ra ngoài | P1 | | Proxy |

## AIF — Tính năng AI trong app (nếu có)

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| AIF-01 | Key của nhà cung cấp AI không nằm trong app (gọi qua backend) | P0 | Có AI | Tool / Proxy |
| AIF-02 | Có giới hạn số lần gọi / chi phí; người dùng spam không đốt tiền khách | P0 | Có AI | Sim |
| AIF-03 | AI trả rỗng / lỗi / timeout → app xử lý được | P1 | Có AI | Proxy |
| AIF-04 | Prompt injection: nội dung người dùng nhập không điều khiển được AI làm việc ngoài phạm vi, không lộ system prompt / dữ liệu người khác | P0 | Có AI | Sim |
| AIF-05 | Nội dung AI trả về phù hợp, không vi phạm chính sách store | P1 | Có AI | Sim |

## PERF — Hiệu năng & ổn định

| ID | Mục | Ưu tiên gợi ý | Áp dụng khi | Chạy ở |
|---|---|---|---|---|
| PERF-01 | Mở app lần đầu (cold start) trong thời gian chấp nhận được trên máy yếu | P1 | | Máy |
| PERF-02 | Cuộn danh sách dài, chuyển màn không giật | P2 | | Máy (Sim chỉ tham khảo) |
| PERF-03 | Dùng liên tục 15–30 phút: không nóng máy bất thường, không chậm dần | P2 | | Máy |
| PERF-04 | Không crash trong toàn bộ smoke và round test (đối chiếu Crashlytics / Sentry) | P0 | | Sim + Tool |

## REL — Release build

| ID | Mục | Ưu tiên gợi ý | Chạy ở |
|---|---|---|---|
| REL-01 | Test trên đúng file sẽ nộp store | P0 | Máy (bản TestFlight / track nội bộ) |
| REL-02 | Release build trỏ đúng server PROD, đúng key PROD | P0 | Proxy / Tool |
| REL-03 | Smoke pass trên release build (bắt crash chỉ có ở bản release do rút gọn code) | P0 | Máy |
| REL-04 | Số version / build number đúng, tăng so với bản trước | P0 | Máy / Tool |
| REL-05 | Tên app, icon, splash đúng | P1 | Máy |

## STORE-IOS — Kiểm duyệt Apple

| ID | Mục | Chặn duyệt? | Áp dụng khi |
|---|---|---|---|
| STORE-IOS-01 | Có đăng ký tài khoản → có chức năng **xoá tài khoản trong app** | Có | Có đăng ký |
| STORE-IOS-02 | Có đăng nhập bằng tài khoản bên thứ ba → có thêm lựa chọn đăng nhập bảo vệ quyền riêng tư (thường là Sign in with Apple) | Có | Có social login |
| STORE-IOS-03 | Bán hàng số → tuân thủ quy định thanh toán của Apple theo thị trường phát hành | Có | Bán hàng số |
| STORE-IOS-04 | Có **tài khoản demo cho người duyệt**; backend chạy suốt thời gian duyệt | Có | Có đăng nhập |
| STORE-IOS-05 | Có privacy policy; câu giải thích khi xin quyền rõ ràng, đúng mục đích | Có | |
| STORE-IOS-06 | Khai báo App Privacy, privacy manifest; có hộp thoại ATT nếu tracking / quảng cáo | Có | |
| STORE-IOS-07 | Không còn tính năng dở dang, link hỏng, nội dung placeholder | Có | |
| STORE-IOS-08 | Giao diện dùng được trên iPad | Có thể | |

## STORE-AND — Kiểm duyệt Google Play

| ID | Mục | Chặn duyệt? | Áp dụng khi |
|---|---|---|---|
| STORE-AND-01 | Có đăng ký tài khoản → cho xoá tài khoản trong app **và** có link web để yêu cầu xoá | Có | Có đăng ký |
| STORE-AND-02 | Target API level đạt mức Google yêu cầu tại thời điểm nộp | Có | |
| STORE-AND-03 | Biểu mẫu Data safety khai đúng với dữ liệu app thực sự thu thập | Có | |
| STORE-AND-04 | Có privacy policy; chỉ xin quyền cần thiết | Có | |
| STORE-AND-05 | Tài khoản developer cá nhân tạo từ 13/11/2023 → đã / sẽ chạy closed test ≥ 12 người, 14 ngày liên tục | Có (chặn xin production) | Tài khoản cá nhân |
