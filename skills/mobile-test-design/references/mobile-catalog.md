# Danh mục test đặc thù mobile (iOS / Android)

Nguồn kiến thức chung cho các skill mobile:
- `mobile-test-design` lấy mục ở đây sinh requirement (R) + test condition (C) cho một scope.
- `mobile-app-test-workflow` cụ thể hoá nhóm MOB của checklist theo các mục ở đây (Bước 3).
- `run-mobile-manual-test` dùng làm hướng khám phá khi thấy bất thường.

## Cách đọc

Mỗi mục là một **mẫu** test condition. Chỉ dùng khi tính năng có **dấu hiệu** ở cột *Áp khi*; thay `<…>` bằng
màn / dữ liệu thật của scope. Không chép nguyên mẫu.

| Cột | Nghĩa |
|---|---|
| ID | Mã mục, ghi vào Source của R: `Implicit · Mobile <ID>` |
| Mẫu (thao tác → kỳ vọng) | Kỳ vọng ở đây là **hành vi đúng chung** của app mobile. Spec / baseline nói khác thì spec thắng; không có nguồn mà kỳ vọng có con số / câu chữ cụ thể → đặt câu hỏi, không bịa |
| Áp khi | Dấu hiệu tính năng (bảng *Dấu hiệu* dưới) |
| Type | Type của R trong `test-design` |
| Ưu tiên | Gợi ý; mức cuối cùng chấm theo Risk của scope (dữ liệu / tiền / đăng nhập → nâng) |
| Nền tảng | `Cả hai` · `iOS` · `Android`. Hành vi khác nhau giữa hai nền tảng → tách 2 condition |
| Chạy ở | `Sim` = iOS Simulator / Android Emulator chạy được · `Máy` = cần máy thật · `Proxy` = cần proxy giả lập lỗi / chậm |

## Dấu hiệu của tính năng

Gắn cho từng màn / chức năng của scope trước khi chọn mục.

| Mã | Dấu hiệu | Nhận ra từ |
|---|---|---|
| `form` | Có ô nhập, nút gửi | Màn có TextField / FIELD requirement |
| `list` | Danh sách, cuộn, phân trang | Màn có danh sách / D dạng bảng |
| `write` | Tạo / sửa / xoá dữ liệu, gửi lên server | R loại RULE / STATE / FLOW có lưu dữ liệu |
| `money` | Thanh toán, số dư, đơn hàng | R liên quan tiền |
| `api` | Tải / gửi dữ liệu qua mạng | Gần như mọi màn có dữ liệu động |
| `flow` | Luồng ≥ 3 bước hoặc ≥ 2 màn | R loại FLOW |
| `auth` | Đăng nhập, phiên, OTP, sinh trắc học | Màn đăng nhập / tài khoản |
| `sensitive` | Hiện dữ liệu nhạy cảm (tài khoản, giấy tờ, sức khoẻ, số dư) | D nhạy cảm |
| `perm:<loại>` | Xin quyền: `camera`, `photos`, `location`, `notif`, `mic`, `contacts`, `bluetooth`, `tracking` | Spec / hành vi app |
| `media` | Chụp / chọn ảnh, video, file, tải lên / tải xuống | Màn upload |
| `push` | Gửi hoặc nhận thông báo đẩy | MSG requirement dạng push |
| `deeplink` | Màn mở được từ link, push, QR | Spec / cấu hình link |
| `time` | Hiển thị / tính theo ngày giờ, hạn, đếm ngược | D / RULE có thời gian |
| `locale` | Đa ngôn ngữ, tiền tệ, số | Test Plan / spec |
| `iap` | Mua trong app, gói đăng ký | Thanh toán qua Apple / Google |
| `location` | Dùng vị trí, bản đồ | `perm:location` |
| `media-play` | Phát âm thanh / video | Màn player |
| `offline` | Spec nói có chế độ offline / đồng bộ sau | Spec |

---

## LC — Vòng đời app và gián đoạn

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| LC-01 | Đang nhập dở `<form>` → ra Home → mở lại app trong vòng 1 phút → dữ liệu đã nhập còn nguyên, không quay về màn đầu | `form` | NFR | P1 | Cả hai | Sim |
| LC-02 | Đang ở `<màn>` → để app ở nền lâu hơn thời hạn phiên (`<x>` phút) → mở lại → app xử lý hết phiên đúng luật (đăng nhập lại / làm mới token), không crash, không màn trắng | `auth` | NFR | P1 | Cả hai | Sim |
| LC-03 | Bấm `<gửi>` → tắt hẳn app ngay khi đang xử lý → mở lại → dữ liệu hoặc đã lưu đủ, hoặc chưa lưu; không lưu nửa vời, không tạo trùng khi gửi lại | `write` | NFR | P0 nếu `money`, còn lại P1 | Cả hai | Sim |
| LC-04 | Hệ thống thu hồi app ở nền (Android: bật *Don't keep activities* / iOS: app bị đóng khi thiếu bộ nhớ) → mở lại từ app switcher → app khôi phục đúng màn hoặc về màn hợp lệ, không crash | `flow`, `form` | NFR | P1 | Android (Sim); iOS (Máy) | Sim / Máy |
| LC-05 | Đang ở bước giữa của `<luồng>` → có cuộc gọi đến / báo thức → quay lại app → luồng tiếp tục được | `flow`, `money` | NFR | P1 | Cả hai | Máy |
| LC-06 | Kéo thanh thông báo / Control Center xuống rồi đóng khi đang ở `<màn>` → app không reload, không mất trạng thái | `form`, `media-play` | NFR | P2 | Cả hai | Sim |
| LC-07 | Đang phát `<âm thanh / video>` → có cuộc gọi / app khác phát âm thanh → app tạm dừng; hết gián đoạn → tiếp tục hoặc chờ người dùng đúng spec | `media-play` | NFR | P2 | Cả hai | Máy |
| LC-08 | Mở app lần đầu sau khi cài → onboarding / xin quyền đúng thứ tự spec; mở lần hai → không hiện lại onboarding | | FLOW | P1 | Cả hai | Sim |

## PM — Quyền của thiết bị

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| PM-01 | Lần đầu dùng `<tính năng>` → app giải thích lý do (nếu spec có) rồi mới hiện hộp thoại quyền `<loại>`; câu mô tả quyền đúng mục đích | `perm:*` | FLOW | P1 | Cả hai | Sim (trừ camera) |
| PM-02 | Từ chối quyền `<loại>` → tính năng báo rõ cần quyền và có đường sang Cài đặt; phần còn lại của app vẫn dùng được, không crash | `perm:*` | NFR | P1 | Cả hai | Sim (trừ camera) |
| PM-03 | Từ chối vĩnh viễn (Android: từ chối 2 lần / *Don't allow*; iOS: đã từ chối một lần) → bấm lại tính năng → app không xin lại vô ích, dẫn sang Cài đặt | `perm:*` | NFR | P2 | Cả hai | Sim |
| PM-04 | Đang dùng app → vào Cài đặt thu hồi quyền `<loại>` → quay lại app → app phát hiện mất quyền, không crash (app có thể bị hệ thống khởi động lại) | `perm:*` | NFR | P1 | Cả hai | Sim |
| PM-05 | Quyền cấp một lần (*Allow Once* / *Only this time*) → đóng app, mở lại dùng tính năng → app xin lại quyền đúng cách | `perm:camera`, `perm:location`, `perm:mic` | NFR | P2 | Cả hai | Máy |
| PM-06 | Ảnh: chỉ cho truy cập một số ảnh (iOS *Limited* / Android 14+ *Select photos*) → app chỉ thấy ảnh được chọn, có cách chọn thêm | `perm:photos` | NFR | P2 | Cả hai | Máy |
| PM-07 | Vị trí gần đúng (iOS tắt *Precise* / Android *Approximate*) → tính năng dựa vị trí vẫn chạy hoặc báo cần vị trí chính xác | `perm:location` | NFR | P2 | Cả hai | Sim (iOS) / Máy |
| PM-08 | Thông báo: Android 13+ phải xin quyền `POST_NOTIFICATIONS`; từ chối → app không lỗi, chức năng chính vẫn chạy | `push` | NFR | P1 | Android | Sim |
| PM-09 | Tracking (ATT): app có quảng cáo / tracking → hộp thoại ATT hiện **trước** khi thu thập; chọn *Ask App Not to Track* → không theo dõi | `perm:tracking` | NFR | P1 | iOS | Sim |

## NW — Mạng

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| NW-01 | Mở `<màn>` khi không có mạng → thông báo mất mạng rõ ràng, có nút thử lại; không loading mãi, không crash | `api` | NFR | P1 | Cả hai | Máy (Android: Emu) |
| NW-02 | Bấm `<gửi>` → mất mạng giữa lúc gửi → app báo lỗi; có mạng lại gửi lại → **không tạo trùng** `<bản ghi>` | `write` | NFR | P0 nếu `money`, còn lại P1 | Cả hai | Máy / Proxy |
| NW-03 | Mạng chậm (3G / độ trễ cao) → có trạng thái đang tải, nút gửi bị khoá khi đang xử lý, hết thời gian chờ thì báo lỗi | `api`, `write` | NFR | P2 | Cả hai | Proxy / Máy |
| NW-04 | Mất mạng rồi có lại khi đang ở `<màn danh sách>` → kéo làm mới / tự tải lại lấy dữ liệu mới, không hiện dữ liệu cũ như dữ liệu mới | `list` | NFR | P2 | Cả hai | Máy (Android: Emu) |
| NW-05 | Chuyển Wi-Fi ↔ 4G giữa lúc tải / gửi → thao tác hoàn tất hoặc báo lỗi rõ, không treo | `api` | NFR | P2 | Cả hai | Máy |
| NW-06 | Server trả lỗi 500 / dữ liệu rỗng / sai định dạng cho `<API của màn>` → app hiện thông báo dễ hiểu, không lộ thông tin kỹ thuật, không crash | `api` | NFR | P1 | Cả hai | Proxy |
| NW-07 | Chế độ offline (spec có): thao tác `<…>` khi offline → lưu tạm; có mạng lại → đồng bộ đúng, xử lý xung đột theo spec | `offline` | INTG | P1 | Cả hai | Máy (Android: Emu) |

## KB — Bàn phím và nhập liệu

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| KB-01 | Chạm ô ở cuối `<form>` → bàn phím không che ô đang nhập và nút gửi; cuộn được tới mọi ô | `form` | UI | P1 | Cả hai | Sim |
| KB-02 | Loại bàn phím đúng với ô: số điện thoại / số → bàn phím số; email → có `@`; mật khẩu → ẩn ký tự, tắt gợi ý | `form` | UI | P2 | Cả hai | Sim |
| KB-03 | Nút Return / Next chuyển sang ô kế tiếp đúng thứ tự; ô cuối → Done / gửi; chạm ra ngoài → đóng bàn phím | `form` | UI | P2 | Cả hai | Sim |
| KB-04 | Gõ tiếng Việt bằng bộ gõ Telex / VNI (bàn phím hệ thống, Laban Key / GBoard trên Android) → chữ có dấu không bị nhân đôi / mất dấu, kể cả khi ô có giới hạn độ dài hoặc định dạng tự động | `form`, `locale` | FIELD | P1 | Cả hai | Sim |
| KB-05 | Tự sửa chính tả / tự viết hoa đầu câu không làm sai email, mã, tên đăng nhập | `form` | FIELD | P2 | Cả hai | Sim |
| KB-06 | Dán nội dung dài / có xuống dòng / có khoảng trắng đầu cuối vào `<ô>` → xử lý theo luật FIELD (cắt / báo lỗi), không crash | `form` | FIELD | P2 | Cả hai | Sim |
| KB-07 | Tự điền mật khẩu (iCloud Keychain / Google Password Manager) và mã OTP từ SMS / email gợi ý trên bàn phím → điền đúng ô | `auth` | UI | P2 | Cả hai | Máy |
| KB-08 | Bấm `<gửi>` hai lần thật nhanh / chạm đúp → chỉ một yêu cầu được gửi, không tạo trùng | `write` | NFR | P0 nếu `money`, còn lại P1 | Cả hai | Sim |

## GS — Điều hướng và cử chỉ

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| GS-01 | Nút / cử chỉ Back hệ thống ở `<màn>` → quay về đúng màn trước; ở màn gốc → thoát app hoặc hỏi xác nhận theo spec, không thoát nhầm khi đang có dữ liệu chưa lưu | | UI | P1 | Android | Sim |
| GS-02 | Vuốt từ mép trái để quay lại ở `<màn>` → chạy như nút Back; màn có dữ liệu chưa lưu → hỏi xác nhận hoặc giữ theo spec | `form` | UI | P2 | iOS | Sim |
| GS-03 | Back khi đang ở bước giữa `<luồng>` (sau thanh toán, sau gửi) → không quay lại được màn đã hoàn tất để gửi lại; không tạo trùng | `flow`, `money` | FLOW | P1 | Cả hai | Sim |
| GS-04 | Kéo để làm mới, cuộn tới cuối tải trang tiếp, cuộn nhanh rồi chạm một dòng → mở đúng bản ghi | `list` | UI | P2 | Cả hai | Sim |
| GS-05 | Vuốt ngang trên dòng (xoá / thao tác nhanh) → chỉ có thao tác đúng quyền của vai; thao tác xoá có xác nhận | `list`, `write` | PERM | P2 | Cả hai | Sim |
| GS-06 | Chạm nhanh liên tiếp vào nút điều hướng → không mở hai màn chồng nhau | | UI | P2 | Cả hai | Sim |

## DP — Hiển thị

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| DP-01 | Màn nhỏ nhất app hỗ trợ (vd iPhone SE / 17e, Android 360 dp) → `<màn>` không bị cắt nút, không chồng chữ, cuộn được tới hết | | UI | P1 | Cả hai | Sim |
| DP-02 | Cỡ chữ hệ thống lớn nhất (Dynamic Type / font scale) → chữ không bị cắt mất thông tin quan trọng (số tiền, trạng thái), nút vẫn bấm được | | UI | P2 | Cả hai | Sim |
| DP-03 | Dark mode → chữ đọc được, không chữ cùng màu nền, ảnh / icon không biến mất | | UI | P2 | Cả hai | Sim |
| DP-04 | Nội dung không bị che bởi tai thỏ / Dynamic Island / thanh Home / thanh điều hướng Android | | UI | P2 | Cả hai | Sim |
| DP-05 | Xoay ngang (app hỗ trợ) → layout đúng, dữ liệu đang nhập không mất; app khoá dọc → không xoay | `form` | UI | P2 | Cả hai | Sim |
| DP-06 | Đổi dark mode / cỡ chữ **khi app đang mở** rồi quay lại → dữ liệu đang nhập không mất (Android tạo lại màn) | `form` | NFR | P2 | Android | Sim |
| DP-07 | iPad / tablet, chia đôi màn hình (Split View / multi-window) → app dùng được, kể cả app chỉ làm cho điện thoại | | UI | P2 | Cả hai | Sim |

## NT — Thông báo đẩy (push)

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| NT-01 | Sự kiện `<…>` xảy ra khi app **đang mở** → hiện thông báo trong app hoặc banner đúng spec, nội dung đúng nguyên văn | `push` | MSG | P1 | Cả hai | Máy (Sim: payload giả lập) |
| NT-02 | Sự kiện xảy ra khi app **ở nền** / **đã tắt hẳn** → nhận push; chạm vào → mở đúng màn `<…>` với đúng bản ghi | `push` | MSG | P1 | Cả hai | Máy (Sim: payload giả lập) |
| NT-03 | Chạm push khi **chưa đăng nhập / phiên hết hạn** → qua đăng nhập rồi về đúng màn đích | `push`, `auth` | FLOW | P2 | Cả hai | Máy |
| NT-04 | Đăng xuất (hoặc đăng nhập tài khoản khác trên cùng máy) → **không còn nhận push của tài khoản cũ** | `push`, `auth` | NFR | P0 nếu `sensitive`, còn lại P1 | Cả hai | Máy |
| NT-05 | Gỡ app cài lại / cài sang máy mới → vẫn nhận push (token được đăng ký lại) | `push` | MSG | P2 | Cả hai | Máy |
| NT-06 | Badge số trên icon đúng số chưa đọc; đọc xong thì giảm / mất | `push` | MSG | P3 | iOS (Android tuỳ launcher) | Máy |

## DL — Deep link / universal link

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| DL-01 | Mở `<link>` khi app đã tắt / đang ở nền / đang mở → luôn tới đúng màn `<…>`, đúng bản ghi | `deeplink` | FLOW | P1 | Cả hai | Sim |
| DL-02 | Mở `<link>` khi chưa đăng nhập → đăng nhập xong về đúng màn đích, không về Home | `deeplink`, `auth` | FLOW | P1 | Cả hai | Sim |
| DL-03 | Link tới bản ghi không tồn tại / không có quyền xem → thông báo phù hợp, không crash, không lộ dữ liệu | `deeplink` | PERM | P1 | Cả hai | Sim |
| DL-04 | Link https (universal link / App Links) mở thẳng app khi đã cài; chưa cài → mở web hoặc store theo spec | `deeplink` | INTG | P2 | Cả hai | Máy (Sim một phần) |

## SS — Phiên, dữ liệu trên máy, bảo mật cơ bản

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| SS-01 | Đăng xuất → mở lại app → không vào được màn cần đăng nhập, không còn dữ liệu của tài khoản cũ (cache, ảnh, bản nháp) | `auth` | NFR | P0 | Cả hai | Sim |
| SS-02 | Đăng nhập cùng tài khoản trên 2 máy / đổi mật khẩu ở máy kia → máy này xử lý đúng luật phiên của spec | `auth` | NFR | P1 | Cả hai | Sim (2 thiết bị) |
| SS-03 | Màn `<nhạy cảm>` → mở app switcher: ảnh chụp nhanh của app bị che (nếu spec / dự án yêu cầu) | `sensitive` | NFR | P2 | Cả hai | Sim |
| SS-04 | Chụp / quay màn hình ở `<màn nhạy cảm>` → bị chặn (Android) hoặc được cảnh báo theo spec | `sensitive` | NFR | P2 | Cả hai | Máy |
| SS-05 | Đăng nhập bằng sinh trắc học: thành công · sai nhiều lần → rơi về mật khẩu · đổi vân tay / Face ID trên máy → app yêu cầu đăng nhập lại theo spec | `auth` | FLOW | P1 | Cả hai | Máy (Sim: giả lập Face ID qua menu Simulator) |
| SS-06 | Xoá dữ liệu app (Android *Clear storage*) / gỡ cài đặt lại → app khởi động như cài mới, không crash, không còn phiên cũ (Keychain iOS có thể còn — đúng theo spec) | `auth` | NFR | P2 | Cả hai | Sim |
| SS-07 | Dữ liệu nhạy cảm không lưu dạng rõ trên máy (đọc container app trên simulator / emulator) | `sensitive`, `auth` | NFR | P1 | Cả hai | Sim |

## MD — Ảnh, video, file

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| MD-01 | Chọn ảnh rất lớn / ảnh HEIC (iOS) / ảnh xoay (EXIF) để `<upload>` → ảnh lên đúng chiều, đúng giới hạn dung lượng spec (nén hoặc báo lỗi) | `media` | FIELD | P1 | Cả hai | Sim (`addmedia` / kéo file vào emulator) |
| MD-02 | Mở trình chọn ảnh / camera rồi huỷ → quay về màn cũ, dữ liệu đã nhập không mất | `media`, `form` | UI | P2 | Cả hai | Sim |
| MD-03 | Tải lên khi mạng chậm / mất mạng giữa chừng → có tiến trình, huỷ được, lỗi thì báo và cho thử lại | `media`, `api` | NFR | P2 | Cả hai | Máy / Proxy |
| MD-04 | Tải xuống / mở file (PDF…) → mở được bằng trình xem trong app hoặc app khác; bộ nhớ đầy → báo lỗi rõ | `media` | NFR | P2 | Cả hai | Sim (bộ nhớ đầy: Máy) |
| MD-05 | Chụp ảnh bằng camera thật → ảnh đúng, không crash khi xoay máy lúc chụp | `perm:camera` | FLOW | P1 | Cả hai | Máy |

## LO — Vị trí

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| LO-01 | Vị trí ở `<điểm trong vùng phục vụ>` và `<ngoài vùng>` → kết quả đúng luật spec | `location` | RULE | P1 | Cả hai | Sim (giả lập vị trí) |
| LO-02 | Tắt dịch vụ vị trí của cả máy → app báo và hướng dẫn bật, không crash | `location` | NFR | P2 | Cả hai | Sim |
| LO-03 | Di chuyển (vị trí đổi liên tục) khi đang ở `<màn bản đồ / theo dõi>` → cập nhật đúng, không giật / crash | `location` | NFR | P2 | Cả hai | Sim (kịch bản di chuyển) |

## PY — Mua trong app (Apple IAP / Google Play Billing)

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| PY-01 | Mua `<gói>` bằng tài khoản sandbox → thanh toán xong quyền lợi mở ngay, đúng gói | `iap` | FLOW | P0 | Cả hai | Máy |
| PY-02 | Huỷ ở hộp thoại thanh toán / thanh toán thất bại → không mở quyền lợi, không trừ tiền, app báo đúng | `iap` | FLOW | P0 | Cả hai | Máy |
| PY-03 | Tắt app ngay sau khi thanh toán thành công → mở lại → quyền lợi vẫn được ghi nhận (giao dịch được xử lý lại) | `iap` | NFR | P0 | Cả hai | Máy |
| PY-04 | *Khôi phục giao dịch* trên máy mới / sau khi cài lại → quyền lợi trở lại | `iap` | FLOW | P1 | Cả hai | Máy |
| PY-05 | Gói đăng ký: gia hạn / hết hạn / huỷ (sandbox rút ngắn chu kỳ) → trạng thái trong app cập nhật đúng | `iap` | STATE | P1 | Cả hai | Máy |

## TM — Thời gian, ngôn ngữ, vùng

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| TM-01 | Đổi múi giờ máy → giờ hiển thị của `<bản ghi>` đúng theo luật spec (giờ máy hay giờ server) | `time` | RULE | P2 | Cả hai | Sim |
| TM-02 | Chỉnh tay giờ máy sai (tương lai / quá khứ) → hạn, OTP, đếm ngược `<…>` vẫn tính theo giờ server, không mở khoá được tính năng hết hạn | `time` | RULE | P1 | Cả hai | Máy (Sim lấy giờ máy tính) |
| TM-03 | Định dạng 12h / 24h, định dạng ngày và số theo vùng → hiển thị đúng, không lỗi khi parse | `time`, `locale` | UI | P2 | Cả hai | Sim |
| TM-04 | Đổi ngôn ngữ hệ thống → app hiển thị đúng ngôn ngữ spec hỗ trợ (hoặc mặc định), chuỗi dài không vỡ layout | `locale` | UI | P2 | Cả hai | Sim |

## AX — Accessibility cơ bản

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| AX-01 | Nút chỉ có icon trên `<màn>` có nhãn đọc được bằng VoiceOver / TalkBack | | UI | P3 (P2 nếu dự án cam kết accessibility) | Cả hai | Sim (đọc cây phần tử) |
| AX-02 | Vùng chạm của nút đủ lớn (iOS ≥ 44 pt, Android ≥ 48 dp) | | UI | P3 | Cả hai | Sim |

## PF — Hiệu năng quan sát được

Chỉ phần kiểm bằng tay; không thay cho performance test.

| ID | Mẫu (thao tác → kỳ vọng) | Áp khi | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|---|
| PF-01 | Mở app lần đầu (cold start) trên máy yếu nhất trong ma trận → tới màn đầu trong `<x>` giây (theo spec / thoả thuận) | | NFR | P2 | Cả hai | Máy |
| PF-02 | Cuộn `<danh sách>` dài, chuyển màn → không giật rõ rệt; dùng liên tục 15–30 phút → không chậm dần, không nóng bất thường | `list` | NFR | P2 | Cả hai | Máy |
| PF-03 | Không crash trong suốt các luồng của scope (đối chiếu crash log / Crashlytics) | | NFR | P0 | Cả hai | Sim + công cụ |

---

## Cấp bản phát hành (không gắn với một story)

Sinh **một lần cho mỗi bản phát hành** (scope riêng `mobile-release` trong `test-design`, hoặc nhóm REL / STORE
của `mobile-app-test-workflow`).

## IU — Cài đặt và cập nhật

| ID | Mẫu (thao tác → kỳ vọng) | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|
| IU-01 | Cài mới trên máy chưa từng cài → mở được, onboarding đúng | FLOW | P0 | Cả hai | Sim |
| IU-02 | Cập nhật từ **bản đang có trên store** lên bản mới → vẫn đăng nhập, dữ liệu cục bộ còn, cài đặt người dùng còn (migration đúng) | FLOW | P0 | Cả hai | Sim (cần build bản cũ) / Máy (qua store / TestFlight) |
| IU-03 | Bắt buộc cập nhật (force update) khi bản cũ dưới mức tối thiểu → chặn và dẫn sang store; bản đủ mới → không chặn | RULE | P1 | Cả hai | Máy |
| IU-04 | Phiên bản OS thấp nhất app khai báo hỗ trợ → cài và chạy luồng chính được | NFR | P1 | Cả hai | Sim (nếu có runtime) |
| IU-05 | Gỡ cài rồi cài lại → app như cài mới (trừ dữ liệu cố ý giữ: Keychain, sao lưu đám mây — theo spec) | NFR | P2 | Cả hai | Sim |

## CM — Ma trận tương thích

| ID | Mẫu (thao tác → kỳ vọng) | Type | Ưu tiên | Nền tảng | Chạy ở |
|---|---|---|---|---|---|
| CM-01 | Luồng P0 chạy trên mỗi thiết bị của ma trận (máy mới / màn nhỏ / máy yếu / tablet) | NFR | P0 | Cả hai | Sim + Máy |
| CM-02 | Hãng Android tắt app nền mạnh (Xiaomi / Oppo / Vivo) → push vẫn tới, tác vụ nền không mất | NFR | P1 | Android | Máy |
| CM-03 | Chế độ tiết kiệm pin / dữ liệu → app vẫn chạy luồng chính, đồng bộ đúng khi tắt chế độ | NFR | P2 | Cả hai | Máy |

Quy định duyệt store (xoá tài khoản trong app, Sign in with Apple, privacy manifest, Data safety, target API
level…) **không** nằm ở danh mục này: thay đổi theo thời gian, dùng nhóm STORE của
`mobile-app-test-workflow/references/checklists.md` và tra lại quy định hiện hành.
