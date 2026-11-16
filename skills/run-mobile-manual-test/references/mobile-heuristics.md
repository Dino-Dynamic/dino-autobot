# Heuristic khám phá app iOS

Dùng ở Bước 2 (khám phá khi thấy bất thường) và phiên khám phá thuần. Mỗi nhóm: dấu hiệu nên khám phá →
thử gì → làm trên Simulator bằng gì. Cột **Máy thật** = chỉ thử được trên iPhone thật; đang ở Simulator thì
ghi đề xuất, không giả lập.

File này là **hướng khám phá nhanh** khi đang chạy. Danh sách đầy đủ các tình huống mobile (có mã, dấu hiệu
áp dụng, nền tảng, cần máy thật hay không) nằm ở `mobile-test-design/references/mobile-catalog.md`; khám phá ra
chỗ kho test case chưa phủ thì đề xuất case kèm mã mục danh mục (vd `LC-03`).

Giới hạn vẫn như `run-manual-test`: khoảng 10–15 thao tác mỗi bất thường. Đổi trạng thái thiết bị xong thì
trả lại ngay.

## 1. Vòng đời app và gián đoạn

Dấu hiệu: mất dữ liệu đã nhập, màn trắng / quay về màn đầu sau khi quay lại app, phiên đăng nhập mất bất thường.

| Thử | Cách làm | Máy thật |
|---|---|---|
| Đang nhập form → ra Home → quay lại | `mobile_press_button` HOME → `mobile_launch_app` | |
| Để app ở nền lâu (≥ 30 giây, vài phút) rồi quay lại | như trên, chờ giữa hai bước | |
| Tắt hẳn app giữa luồng (đang gửi, đang tải) rồi mở lại: dữ liệu ghi dở? trùng? | `mobile_terminate_app` → `mobile_launch_app` | |
| Chuyển sang app khác (Safari, Settings) rồi quay lại | `mobile_launch_app` app khác → app test | |
| Cuộc gọi đến, khoá máy, thông báo che màn, Control Center | | ✔ |
| Hết hạn phiên đăng nhập khi app ở nền | chờ quá thời hạn token (theo `project-profile.md`) | |

## 2. Quyền (permission)

Dấu hiệu: tính năng im lặng không chạy, màn trống, app văng khi bấm tính năng cần quyền.

| Thử | Cách làm | Máy thật |
|---|---|---|
| Từ chối quyền ở hộp thoại lần đầu → app có giải thích, có đường dẫn sang Settings không | `sim.sh perm <udid> reset <dv> <bundle>` rồi chạy lại luồng | |
| Thu hồi quyền khi app đang chạy | `sim.sh perm <udid> revoke <dv> <bundle>` (app có thể bị tắt) | |
| Ảnh: chỉ cho chọn một số ảnh (Limited) | | ✔ (Simulator chỉ cấp / thu hồi) |
| Vị trí: *Khi dùng app* vs *Luôn luôn*, vị trí ở nước ngoài | `sim.sh perm … location` / `location-always`, `sim.sh location <lat>,<lon>` | |
| Camera, micro thật | | ✔ |
| Thông báo bị tắt → app có xử lý (nhắc bật, không lỗi) | Settings của Simulator → app → Notifications | |

## 3. Bàn phím và nhập liệu

Dấu hiệu: bàn phím che ô / nút, nhập không nhận, ký tự lạ, nút gửi bấm được hai lần.

| Thử | Cách làm |
|---|---|
| Ô ở cuối màn có bị bàn phím che, có cuộn lên được không | chạm ô cuối, đọc cây phần tử / chụp |
| Nút Return / Next có chuyển ô đúng thứ tự, Done có đóng bàn phím | `mobile_type_keys` với `submit` |
| Kiểu bàn phím đúng loại (số cho số điện thoại, email có @) | chụp màn khi bàn phím mở |
| Tiếng Việt có dấu, emoji, chuỗi dài, khoảng trắng đầu / cuối, dán đoạn văn dài | `mobile_type_keys`; dán: `printf … \| sim.sh clip` rồi chạm giữ → Paste |
| Bấm nút gửi hai lần liên tiếp → tạo trùng? | `mobile_double_tap_on_screen` hoặc hai lệnh chạm trong một batch |
| Tự động sửa chính tả / viết hoa đầu câu làm sai email, mã | quan sát giá trị sau khi nhập |

## 4. Hiển thị: cỡ chữ, dark mode, màn nhỏ, safe area

Dấu hiệu: chữ bị cắt `…`, chồng lên nhau, nút ra ngoài màn, chữ cùng màu nền.

| Thử | Cách làm |
|---|---|
| Cỡ chữ lớn nhất (Dynamic Type / Accessibility) | `sim.sh textsize <udid> largest`, mở lại màn → chụp. Xong `sim.sh textsize <udid> default` |
| Dark mode | `sim.sh appearance <udid> dark` → chụp; trả lại `light` |
| Màn nhỏ (iPhone 17e / SE nếu có) và màn lớn (Pro Max), iPad nếu app hỗ trợ | `sim.sh boot "<tên>"`, cài cùng build |
| Nội dung dưới Dynamic Island / notch / thanh Home | chụp màn có header và nút dưới cùng |
| Tăng tương phản | `xcrun simctl ui <udid> increase_contrast enabled` |
| Nút chỉ có icon thiếu nhãn (VoiceOver đọc không được) | cây phần tử thấy `Button` không có label |

## 5. Xoay màn

Chỉ khi app hỗ trợ xoay, hoặc để kiểm app **khoá** dọc đúng.

| Thử | Cách làm |
|---|---|
| Xoay khi đang nhập form, đang mở modal / bàn phím → mất dữ liệu? layout vỡ? | `mobile_set_orientation landscape` → đọc / chụp → `portrait` |
| App khoá dọc mà vẫn xoay được | như trên |

## 6. Deep link, universal link, push

Dấu hiệu: link mở sai màn, mở được màn cần đăng nhập khi chưa đăng nhập, push không dẫn tới đúng chỗ.

| Thử | Cách làm | Máy thật |
|---|---|---|
| Deep link khi app tắt / ở nền / đang mở | `sim.sh deeplink <udid> "myapp://…"` ở ba trạng thái | |
| Deep link khi **chưa đăng nhập** → phải qua đăng nhập rồi về đúng màn | như trên sau khi đăng xuất | |
| Deep link tới bản ghi không tồn tại / không có quyền | sửa id trong link | |
| Push khi app tắt / ở nền / đang mở, chạm vào push → đúng màn | `sim.sh push <udid> <bundle> payload.json` (payload theo spec / dev cung cấp) | |
| Push thật từ server, push khi máy khoá, badge | | ✔ |

## 7. Mạng

Simulator dùng mạng của máy Mac; tắt mạng hay giả lập mạng yếu sẽ ảnh hưởng cả máy → **hỏi người dùng
trước**, hoặc ghi đề xuất chạy trên máy thật.

| Thử | Máy thật |
|---|---|
| Mất mạng giữa lúc gửi form / tải danh sách → thông báo, gửi lại, dữ liệu trùng | ✔ |
| Mạng chậm (3G, Edge) → loading, timeout, bấm nhiều lần | ✔ |
| Có mạng lại → app tự tải lại hay phải kéo để làm mới | ✔ |

## 8. Ngôn ngữ, vùng, thời gian

| Thử | Cách làm |
|---|---|
| Mở app bằng ngôn ngữ khác (chuỗi thiếu dịch, chuỗi dài vỡ layout) | `mobile_launch_app` với `locale` (vd `en-US`, `vi-VN`) |
| Định dạng ngày, giờ, tiền theo vùng; múi giờ khác | Settings của Simulator → General → Language & Region / Date & Time |

## 9. Danh sách, cuộn, làm mới

| Thử | Cách làm |
|---|---|
| Kéo để làm mới (pull to refresh), cuộn tới cuối tải thêm trang | `mobile_swipe_on_screen` xuống / lên |
| Cuộn nhanh rồi mở một mục → đúng mục không | vuốt nhanh, chạm, so tiêu đề |
| Danh sách rỗng, một phần tử, rất nhiều phần tử | theo dữ liệu test có sẵn |
| Vuốt ngang trên dòng (xoá / thao tác nhanh) có đúng quyền của vai | vuốt trái trên dòng |
