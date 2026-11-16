# Intake, gói, khả thi mốc go-live (Phụ lục A, F)

## A. Bộ câu hỏi intake (gửi khách)

Bỏ câu đã biết câu trả lời. Ngôn ngữ theo `STATE.md`. Câu 6, 10, 11, 14 ảnh hưởng thẳng tới phạm vi → nếu
khách bỏ trống thì hỏi lại trước khi chốt.

**App & nền tảng**
1. App chạy iOS, Android hay cả hai? Có hỗ trợ iPad / tablet không?
2. Làm bằng công nghệ gì (Flutter, React Native / Expo, native)? Dùng công cụ AI nào để code?
3. Lần đầu lên store hay cập nhật bản đã có? Nếu cập nhật: phiên bản đang chạy là bao nhiêu?
4. Mục tiêu người dùng, thị trường, ngôn ngữ?

**Build & phát hành**
5. Gửi build test qua kênh nào (TestFlight, Firebase App Distribution, APK)?
6. Cung cấp được bản debug cho phép proxy không?
7. Đã có tài khoản Apple Developer / Google Play Console chưa? Google là tài khoản cá nhân hay tổ chức, tạo khi nào?
8. Mốc go-live mong muốn?

**Backend & môi trường**
9. Backend dùng gì (Firebase, Supabase, server riêng…)? Có trang admin web không?
10. Có môi trường test (staging) riêng không, hay chỉ PROD?
11. Nếu chỉ PROD: có đồng ý cho tạo dữ liệu test, gửi email / SMS / push, test thanh toán, thử bảo mật trên PROD không? Ai dọn dữ liệu sau test?

**Tài khoản & dữ liệu**
12. Có những vai trò người dùng nào? Cung cấp tài khoản test cho từng vai trò.
13. Có dữ liệu mẫu sẵn chưa?

**Tích hợp**
14. Có thanh toán không? Loại gì (IAP, Stripe, ví điện tử…), có chế độ sandbox không?
15. Có OTP qua SMS / email, push notification, bản đồ, đăng nhập Google / Facebook / Apple không?
16. App có tính năng AI (gọi LLM / API AI) không?
17. Có gắn Crashlytics / Sentry / analytics không?

**Phạm vi**
18. Có chức năng nào khách lo nhất hoặc đã từng lỗi nhiều không?
19. Mong muốn bao nhiêu round? Khách sẽ sửa lỗi trong bao lâu mỗi round?

## Ước lượng quy mô

Từ câu trả lời (và lần mở app đầu tiên nếu đã có build) ghi vào `0-intake.md`:

| Yếu tố | Cách đếm | Ảnh hưởng |
|---|---|---|
| Số màn hình | Đếm màn chính (bỏ hộp thoại) | Thời gian Bước 2 và FUNC |
| Số vai trò | Câu 12 | Nhân FUNC-01, FUNC-05 |
| Số nền tảng | Câu 1 | Nhân gần như toàn bộ round |
| Thanh toán / AI / admin web / push | Câu 9, 14–16 | Bật FUNC-08, AIF, FUNC-09, FUNC-10 |
| Chỉ có PROD | Câu 10 | Thu hẹp SEC, FUNC-08; cần đồng ý bằng văn bản |
| Không có bản proxy | Câu 6 | AIC-01, SEC-02…04 thành rủi ro chưa test |

## F. Gói theo ngân sách

| Gói | Thời lượng gợi ý | Gồm |
|---|---|---|
| Lite | 2–3 ngày | Smoke P0 trên 1 iOS + 1 Android; SEC-01→03; checklist STORE + REL; MOB-01, MOB-02 cho luồng P0. Phần còn lại ghi là rủi ro chưa test |
| Standard | 1–2 tuần | Bước 0–8 đủ, 2 round, ma trận thiết bị tối thiểu, đủ nhóm FUNC / MOB / AIC / SEC / PERF |
| Full | 2–4 tuần | Standard + round 3, thiết bị cloud, AIF chuyên sâu, smoke tự động hoá (Maestro), theo dõi sau go-live |

Thời lượng chưa tính: thời gian closed test của Google (nếu áp dụng), thời gian chờ Apple duyệt, thời gian
khách sửa lỗi giữa các round.

Đề xuất gói: so quy mô với thời lượng gợi ý; app có thanh toán hoặc dữ liệu nhạy cảm mà khách chọn Lite → nói
rõ phần rủi ro chưa test trong đề xuất.

## Khả thi mốc go-live

Tính ngược từ mốc khách muốn: `mốc go-live − thời gian chờ duyệt store − thời gian closed test (nếu có) −
số round × (thời gian test + thời gian khách sửa)`. Âm hoặc quá sát → báo khách ngay ở Bước 0.

Các ngưỡng theo tài liệu gốc (**tra lại quy định hiện hành trước khi dùng**, ghi ngày tra):
- Google Play, tài khoản developer **cá nhân** tạo từ 13/11/2023 → phải closed test **≥ 12 người test, liên
  tục 14 ngày** trước khi xin production.
- Apple duyệt thường 1–3 ngày, có thể bị từ chối và nộp lại.

## Đoạn xin đồng ý khi chỉ có PROD (mẫu)

> Ứng dụng hiện chỉ có môi trường chính thức (PROD). Để kiểm thử, chúng tôi cần anh / chị đồng ý bằng văn bản
> cho các việc sau trên PROD: (1) tạo / sửa / xoá dữ liệu test; (2) gửi email / SMS / push tới tài khoản test;
> (3) thực hiện thanh toán test <hình thức>; (4) thử bảo mật cơ bản (đổi ID trong request, gọi chức năng của vai
> khác). Dữ liệu test được đặt tiền tố `<TIỀN TỐ>` và do <ai> dọn sau khi test. Mục nào không đồng ý sẽ không
> được kiểm và được ghi là rủi ro trong báo cáo.
