# Thiết bị, công cụ, môi trường (Phụ lục G, H + cách Claude điều khiển thiết bị)

## Việc chuẩn bị môi trường (Bước 1)

| Việc | Ai làm | Ghi chú |
|---|---|---|
| Nhận build iOS: TestFlight (mời email tester) / ad-hoc / **bản build simulator `.app`** | Người dùng xin khách | Xin thêm bản simulator để Claude tự chạy được |
| Nhận build Android: Firebase App Distribution / internal testing track / APK | Người dùng xin khách | APK cài thẳng được lên emulator |
| Bản debug cho phép proxy (Android: `network_security_config` tin chứng chỉ người dùng; tắt certificate pinning) | Khách | Không có → ghi rủi ro |
| Tài khoản test **từng vai trò** + admin web | Khách | Lưu ở file bí mật của dự án (`.env` đã gitignore) |
| Sandbox thanh toán (Apple sandbox tester, Google license tester, Stripe test mode…) | Khách | |
| Thiết bị theo ma trận (dưới) | Người dùng | |
| Proxy, đọc log, quay màn hình (dưới) | Người dùng | |
| Đề nghị khách gắn Crashlytics / Sentry | Người dùng đề nghị | Để có log crash |
| Nơi ghi defect: `defects.md` của dự án, hoặc sheet / Jira / GitLab nếu khách muốn | Người dùng chốt với khách | Dùng hệ thống khách → `defects.md` vẫn giữ làm bản gốc |

## G. Ma trận thiết bị tối thiểu

| Nền tảng | Thiết bị | Lý do | Claude dùng được |
|---|---|---|---|
| iOS | iPhone đời mới, iOS mới nhất | Người dùng chính | Simulator |
| iOS | iPhone màn nhỏ / đời cũ, iOS thấp nhất app hỗ trợ | Vỡ layout, tương thích | Simulator (nếu đã cài runtime iOS đó) |
| iOS | iPad (máy thật hoặc simulator) | Apple có thể duyệt trên iPad | Simulator |
| Android | Samsung tầm trung / cao | Thị phần lớn | Emulator tương đương (không có giao diện One UI) |
| Android | Xiaomi / Oppo / Vivo giá rẻ, RAM thấp | Tắt app nền mạnh, push hay lỗi, máy yếu | Không — cần máy thật |
| Mở rộng | BrowserStack / LambdaTest / Firebase Test Lab | Phủ thêm hãng, OS | Chỉ khi người dùng yêu cầu (tốn phí) |

## H. Công cụ

| Mục đích | Cơ bản (luôn dùng) | Nâng cao (khi có trong gói) |
|---|---|---|
| Soi / sửa API, giả lập lỗi, mạng chậm | Proxyman / Charles | — |
| Log, crash | adb logcat, Xcode Console, Crashlytics / Sentry | — |
| Quay / chiếu màn hình | Ghi màn hình có sẵn trên máy, scrcpy | — |
| Tự động hoá smoke | — | Maestro |
| Bảo mật app | — | jadx (giải nén APK), MobSF |
| Thiết bị | Máy thật, Android emulator, iOS simulator | Thiết bị cloud |
| Claude điều khiển thiết bị | mobile-mcp (iOS simulator, Android emulator, máy thật nếu đã thiết lập) | — |

Proxy, jadx, MobSF, thiết bị cloud: người dùng chạy (hoặc Claude chạy khi người dùng yêu cầu và công cụ đã cài).
Giải nén / quét app của khách chỉ khi hợp đồng có phần bảo mật.

## Claude điều khiển thiết bị

Chung cho cả hai nền tảng (mobile-mcp):
- `mobile_list_available_devices` lấy `device id`, truyền id cho mọi lệnh. Danh sách rỗng = chưa bật
  simulator / emulator nào.
- Đọc màn bằng `mobile_list_elements_on_screen`, ảnh chụp chỉ khi cần nhìn; gom thao tác bằng
  `mobile_batch_commands`; màn đổi bố cục (bàn phím, modal) → đọc lại trước thao tác theo toạ độ.
- Bằng chứng: `mobile_save_screenshot`, `mobile_start_screen_recording` / `mobile_stop_screen_recording`,
  `mobile_list_crashes` / `mobile_get_crash`, `mobile_get_device_logs`.
- Không dùng thiết bị remote / cloud của mobile-mcp trừ khi người dùng yêu cầu.

### iOS

Theo `run-mobile-manual-test`: mục *Thao tác bằng mobile-mcp*, `scripts/sim.sh` (cài `.app`, quyền, deep
link, push giả lập, dark mode, cỡ chữ, vị trí, clipboard để dán mật khẩu), `references/ios-device.md`
(simulator, máy thật). `.ipa` không cài được lên simulator.

### Android

Lệnh `adb` thông dụng (chưa chạy thử trên máy này — máy chưa có emulator; kiểm lại lần đầu dùng):

| Việc | Lệnh |
|---|---|
| Danh sách / bật emulator | `emulator -list-avds` · `emulator -avd <tên> &` (trong `$ANDROID_HOME/emulator`) |
| Thiết bị đang nối | `adb devices` |
| Cài / gỡ APK | `adb -s <id> install -r app.apk` · `adb -s <id> uninstall <package>` |
| Version app | `adb -s <id> shell dumpsys package <package> \| grep -E "versionName\|versionCode"` |
| Xoá dữ liệu app | `adb -s <id> shell pm clear <package>` (hoặc `mobile_clear_app_data`) |
| Cấp / thu hồi quyền | `adb -s <id> shell pm grant\|revoke <package> android.permission.CAMERA` |
| Deep link | `adb -s <id> shell am start -a android.intent.action.VIEW -d "myapp://…"` |
| Nút Back | `mobile_press_button` BACK |
| Dark mode | `adb -s <id> shell cmd uimode night yes\|no` |
| Cỡ chữ | `adb -s <id> shell settings put system font_scale 1.3` (mặc định `1.0`) |
| Chế độ máy bay / tắt mạng emulator | `adb -s <id> shell cmd connectivity airplane-mode enable\|disable` |
| Log của app | `adb -s <id> logcat --pid=$(adb -s <id> shell pidof <package>)` |
| Đưa văn bản vào clipboard (dán mật khẩu) | Không có lệnh `adb` chuẩn; dùng `mobile_clipboard` nếu nhận giá trị từ file được, không thì người dùng tự nhập mật khẩu |

Emulator dùng mạng riêng của nó, nên bật chế độ máy bay trên emulator **không** ảnh hưởng máy tính — MOB-02
một phần chạy được trên emulator (offline / online), mạng chậm vẫn cần proxy hoặc máy thật.
