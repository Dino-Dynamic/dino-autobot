# Thiết bị iOS: Simulator và máy thật

## Simulator

### Chuẩn bị máy Mac (một lần)

- Cần Xcode (đã có runtime iOS). Kiểm: `xcodebuild -version`, `xcrun simctl list runtimes`.
- mobile-mcp cấu hình ở `~/.claude.json` (hoặc `.mcp.json` của dự án). Kiểm trong phiên:
  `mobile_list_available_devices` trả danh sách rỗng khi **chưa có simulator nào đang bật** — bật một máy
  bằng `scripts/sim.sh boot "<tên>"` rồi gọi lại.

### Lệnh hay dùng

| Việc | Lệnh |
|---|---|
| Danh sách / bật máy | `sim.sh devices` · `sim.sh boot "iPhone 17 Pro"` |
| Cài bản build simulator | `sim.sh install <udid> <App.app hoặc build.zip>` |
| Version · build | `sim.sh info <udid> <bundle id>` |
| Dòng môi trường cho sổ phiên / defect | `sim.sh env <udid> <bundle id>` |
| App đã cài (tìm bundle id) | `mobile_list_apps` hoặc `xcrun simctl listapps <udid>` |
| Xoá dữ liệu app | `mobile_clear_app_data` (hoặc gỡ rồi cài lại) |
| Gỡ app | `mobile_uninstall_app` / `xcrun simctl uninstall <udid> <bundle id>` |
| Thêm ảnh / video vào thư viện | `xcrun simctl addmedia <udid> <file…>` |
| Quyền | `sim.sh perm <udid> grant\|revoke\|reset <dịch vụ> <bundle id>` — dịch vụ: `all`, `calendar`, `contacts`, `contacts-limited`, `location`, `location-always`, `photos`, `photos-add`, `media-library`, `microphone`, `motion`, `reminders`, `siri`. Không có camera (camera cần máy thật) |
| Nhân bản simulator cho agent khác | `xcrun simctl clone <udid> "<tên mới>"` |
| Tắt máy | `xcrun simctl shutdown <udid>` |

`sim.sh erase` không có, cố ý: `xcrun simctl erase` xoá sạch máy (mọi app, dữ liệu, cài đặt), chỉ chạy khi
người dùng yêu cầu.

### QA tự build từ source (khi dự án quy định)

Theo hướng dẫn build trong repo app hoặc `project-profile.md` (scheme, cấu hình, môi trường). Mẫu:

```bash
xcodebuild -project App.xcodeproj -scheme <Scheme> -configuration Debug \
  -destination 'platform=iOS Simulator,id=<udid>' -derivedDataPath build/ build
```

`.app` nằm ở `build/Build/Products/Debug-iphonesimulator/`. Trong app Claude desktop có thể dùng tool build
iOS Simulator nếu phiên có. Build lỗi → báo người dùng, không tự sửa code app.

## Máy thật

Dùng khi case cần phần cứng (bảng ở SKILL.md Bước 0 mục 2).

- **Người dùng làm:** cắm iPhone qua cáp, mở khoá, chọn *Tin cậy máy tính này*, bật Developer Mode
  (Settings → Privacy & Security → Developer Mode), cài app qua TestFlight / Ad Hoc.
- mobile-mcp điều khiển iPhone thật cần thêm thành phần chạy trên máy (WebDriverAgent hoặc tương đương,
  tuỳ phiên bản mobile-mcp) — cài theo tài liệu iOS real device của mobile-mcp. Việc này cần tài khoản
  Apple Developer để ký nên **người dùng tự làm**; Claude chỉ kiểm máy đã hiện trong
  `mobile_list_available_devices` chưa và báo lại.
- `sim.sh` không dùng được cho máy thật. Quyền, dark mode, cỡ chữ, ngôn ngữ đổi trong Settings của máy
  (qua mobile-mcp hoặc người dùng đổi tay); push / deep link thật theo cách dự án cung cấp.
- Mật khẩu, OTP, Face ID trên máy thật: người dùng tự nhập / xác thực.
- Môi trường cho defect: model máy (Settings → General → About), phiên bản iOS, build app.
