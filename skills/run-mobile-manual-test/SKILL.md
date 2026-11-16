---
name: run-mobile-manual-test
description: >-
  Claude tự test manual app iOS trên iOS Simulator hoặc iPhone thật qua mobile-mcp: đi từng case trong TESTPROC của round, so với expected, ghi Pass / Fail / Blocked kèm bằng chứng (ảnh, video, crash log); thấy bất thường thì khám phá thêm theo heuristic riêng của mobile (gián đoạn, quyền, xoay màn, bàn phím, cỡ chữ, deep link, push) rồi quay lại. Cũng chạy phiên khám phá thuần theo charter. Defect giao `report-defect`. Dùng khi người dùng nói "test app iOS", "test trên iPhone / simulator", "chạy case TC-xxx trên iOS", "explore app mobile", "test manual mobile". Test web trên trình duyệt thì dùng `run-manual-test`; dựng TESTPROC thì dùng `write-test-execute`.
---

# Test manual app iOS

Claude đóng vai tester trên thiết bị iOS: tự mở app, thao tác, quan sát, kết luận. Thao tác bằng
**mobile-mcp** (đọc cây phần tử, chạm, nhập, vuốt, chụp, quay video, đọc log / crash); việc mobile-mcp không
làm được trên Simulator (cài app, quyền, deep link, push, giao diện tối, cỡ chữ, vị trí) làm bằng
`scripts/sim.sh`. Kết luận của AI có thể lệch nên phải để lại bằng chứng đủ cho người kiểm lại.

Skill này là bản mobile của `run-manual-test`. **Các luật chung giữ nguyên như `run-manual-test`**, đọc
skill đó khi cần chi tiết: luật nền *chạy đúng tầng của case*, cách điền kết quả (`Pass - Need verify`…),
luật khám phá (giới hạn, trong quyền của vai, mã `EXP-xx`), chia cụm theo luồng, chạy song song nhiều agent,
khi nào dừng hỏi. File này ghi **cách làm trên thiết bị iOS** và những chỗ khác với web.

Phạm vi hiện tại: **iOS** (Simulator mặc định, iPhone thật khi case cần phần cứng). Chưa gom locator cho
automation (để cho skill automation Maestro / Appium sau này).

```
0. Chuẩn bị phiên    (round, vai, môi trường, thiết bị, bản build, trạng thái app, đăng nhập, danh sách case)
1. Chạy từng case    (đúng bước của case → so expected → ghi kết quả + bằng chứng)
2. Khám phá khi thấy bất thường   (heuristic mobile, có giới hạn, rồi quay lại)
3. Kết thúc phiên    (tổng hợp, trả thiết bị về mặc định, nhắc việc còn chờ)
```

Sổ phiên: `test-execute/round<N>/MANUAL_RUN_<TenDuAn>_R<N>.md` như `run-manual-test`, dùng mẫu
`templates/MANUAL_RUN_MOBILE.md` (thêm thiết bị, build, trạng thái thiết bị, case cần máy thật). Dự án đã
có sổ phiên web cùng round → thêm phiên mobile vào cuối cùng file đó, ghi rõ `Nền tảng: iOS`. Test adhoc:
`test-execute/adhoc/` như `run-manual-test`.

---

## Bước 0 — Chuẩn bị phiên

1. **Round, vai, môi trường, danh sách case:** như `run-manual-test` Bước 0 mục 1–3. Lấy case có cột
   kết quả iOS trong TESTPROC; case ghi `—` ở cột iOS thì bỏ qua.

2. **Thiết bị.** Mặc định **Simulator**. Cần **iPhone thật** khi case kiểm thứ Simulator không có:

   | Simulator làm được | Cần máy thật |
   |---|---|
   | Luồng nghiệp vụ, form, validation, điều hướng, layout nhiều cỡ màn, dark mode, cỡ chữ, xoay màn | Camera, quét QR / tài liệu |
   | Quyền: cấp / từ chối / đặt lại (`sim.sh perm`) | Face ID / Touch ID thật, Keychain trên thiết bị |
   | Deep link, universal link (`sim.sh deeplink`) | Push thật từ server (APNs), push khi máy khoá |
   | Push giả lập payload (`sim.sh push`) | Mất mạng / mạng yếu (Airplane mode, Network Link Conditioner trên máy) |
   | Vị trí giả lập (`sim.sh location`) | Cuộc gọi đến, pin yếu, bộ nhớ đầy, Bluetooth, NFC |
   | Ảnh / video trong thư viện (`xcrun simctl addmedia`) | In-app purchase sandbox, hiệu năng thực, nhiệt |

   - Chọn model theo danh sách thiết bị hỗ trợ trong `_knowledge/project-profile.md`. Không có → iPhone
     mới nhất trên iOS mới nhất đang cài; case layout / màn nhỏ → thêm một máy màn nhỏ (vd iPhone 17e);
     app hỗ trợ iPad → thêm một iPad. `sim.sh devices` xem danh sách, `sim.sh boot "<tên>"` để bật.
   - Đọc `mobile_list_available_devices` lấy `device id`, **truyền id đó cho mọi lệnh** mobile-mcp.
     Không dùng thiết bị remote / cloud (tốn tiền) trừ khi người dùng yêu cầu.
   - Máy thật: người dùng cắm máy, mở khoá, đã cài app; Claude kiểm máy hiện trong
     `mobile_list_available_devices`. Không hiện → xem `references/ios-device.md` mục *Máy thật*, báo
     người dùng, không tự cài công cụ ký app.
   - Người dùng muốn xem trực tiếp: cửa sổ Simulator đã mở sẵn khi boot; hoặc mở panel Simulator của app
     Claude (`mcp__Claude_Code_iOS_Simulator__control` action `attach`).

3. **Bản build.** Nguồn build theo `project-profile.md` (mục môi trường / cách bàn giao):
   - Simulator: bản build simulator `.app` / `.zip` → `sim.sh install <udid> <file>`. File `.ipa` là bản
     máy thật, không cài lên Simulator được → xin dev bản simulator hoặc chuyển sang máy thật. Dự án quy
     định QA tự build từ source → build bằng Xcode theo hướng dẫn của dự án (xem `references/ios-device.md`).
   - Máy thật: cài qua TestFlight / Ad Hoc **do người dùng làm** (Claude không đăng nhập Apple ID,
     TestFlight).
   - Đọc version / build (`sim.sh info <udid> <bundle id>`; máy thật xem màn *Giới thiệu* của app hoặc hỏi
     người dùng). Build khác build của round (TESTPROC / Test Plan) → hỏi trước khi chạy.

4. **Trạng thái thiết bị đầu phiên** — chốt và ghi sổ phiên, vì cùng một case có thể ra kết quả khác:
   - App **cài mới** (dữ liệu sạch, hiện onboarding, hỏi quyền lần đầu) hay **giữ dữ liệu** từ phiên trước.
     Case kiểm onboarding / hộp thoại quyền lần đầu → cài lại app hoặc `mobile_clear_app_data` +
     `sim.sh perm <udid> reset all <bundle id>`.
   - Giao diện mặc định: `sim.sh reset-ui <udid>` (light, cỡ chữ mặc định, không giả lập vị trí).
   - Ngôn ngữ app: case theo ngôn ngữ nào thì mở app bằng `mobile_launch_app` có `locale` (vd `vi-VN`).
   - Một dòng đầu phiên: `Vai: 🧪 Tester · Môi trường: TST · iPhone 17 Pro (Simulator) · iOS 26.5 · Build 1.4.0 (212)`
     (lấy từ `sim.sh env <udid> <bundle id>`).

5. **Đăng nhập** — theo luật đăng nhập của `run-manual-test` Bước 0 mục 5 (tài khoản từ file bí mật của
   dự án, không bao giờ PROD, không in mật khẩu / OTP). Khác ở cách nhập trên thiết bị:
   - **Không gõ mật khẩu bằng `mobile_type_keys`**: giá trị nằm trong lệnh gọi tool, lộ trong transcript.
     Trên Simulator: đọc mật khẩu bằng lệnh và **đưa thẳng vào clipboard của simulator**
     (`grep … | <lọc đúng giá trị> | scripts/sim.sh clip <udid>`), rồi: chạm ô mật khẩu → **đọc lại cây
     phần tử** (bàn phím bật làm ô dời chỗ) → chạm giữ ô ở toạ độ mới → chạm *Paste* / *Dán* trong menu →
     `sim.sh clip-clear <udid>` ngay sau đó. Email / tên đăng nhập gõ bằng `mobile_type_keys` được.
   - Ô mật khẩu đúng chuẩn hiện giá trị dạng `•••` trong cây phần tử. Thấy mật khẩu hiện rõ → đó là defect
     (ô không phải secure field); ghi defect **không chép giá trị**, và không đọc cây phần tử màn đó thêm.
   - Hộp thoại hệ thống *Save Password?* / *Lưu mật khẩu?* → chọn *Not Now*.
   - Máy thật: người dùng tự nhập mật khẩu / OTP trên máy, Claude chờ rồi chạy tiếp.
   - OTP qua mail sink / TOTP: như `run-manual-test`, mã OTP gõ bằng `mobile_type_keys` được (dùng một lần).
   - Đăng nhập xong app giữ phiên; **đừng xoá dữ liệu app / cài lại giữa phiên** trừ khi case cần, vì phải
     đăng nhập lại.

6. **Dữ liệu và chia cụm:** như `run-manual-test` mục 6, 8, 9. Cụm khoảng **3–5 case** (mỗi màn phải đọc cây
   phần tử, context đầy nhanh); case nối tiếp nhau thì chạy liền một cụm. Chạy song song nhiều agent → mỗi
   agent **một simulator riêng** (`xcrun simctl clone`), một bộ tài khoản riêng.

---

## Bước 1 — Chạy từng case

Luật nền *chạy đúng tầng của case* giữ nguyên: bước thao tác và kiểm tra của case làm **trên app**; API chỉ
để dựng dữ liệu hoặc đọc đối chiếu (bảng ở `run-manual-test` Bước 1).

### Thao tác bằng mobile-mcp

| Việc | Cách làm |
|---|---|
| Đọc màn hình | `mobile_list_elements_on_screen` (ref, nhãn, toạ độ). Ảnh chụp chỉ khi cần **nhìn**: layout, màu, ảnh, phần tử không có trong cây (WebView, bản đồ, canvas, game) |
| Sau khi mở app / chuyển màn | Màn có thể chưa vẽ xong: đọc lại cây phần tử; còn thấy màn cũ (vd vẫn là màn Home) → chờ rồi đọc lại, **không kết luận từ cây cũ** |
| Chạm, nhập, nhiều bước liền nhau | `mobile_batch_commands` gom các bước đã biết (chạm → nhập → chạm), bật `listElementsAtEnd` để thấy màn kết quả trong cùng một lệnh |
| Toạ độ sau khi màn đổi | Ref và toạ độ chỉ đúng khi màn **không đổi**. Bàn phím bật, modal mở, danh sách cuộn → ô có thể dời chỗ: đọc lại cây phần tử trước thao tác theo toạ độ tiếp theo. Đừng gom vào một batch hai thao tác mà thao tác đầu làm đổi bố cục |
| Nhập chữ | Chạm vào ô trước, rồi `mobile_type_keys` (`submit` khi cần nhấn Return). Bàn phím che nút → chạm vùng trống, vuốt xuống hoặc nhấn nút Done / Return; không chạm mò lên bàn phím |
| Phần tử ngoài màn hình | Không có trong cây → vuốt (`mobile_swipe_on_screen`) rồi đọc lại. Ghi số lần vuốt nếu là danh sách dài |
| Quay lại | Nút Back trên thanh điều hướng; hoặc vuốt từ mép trái (điểm bắt đầu cách mép ≤ 4 pt). Cả hai đều phải chạy được nếu app dùng điều hướng chuẩn |
| Ra màn Home / về lại app | `mobile_press_button` HOME, rồi `mobile_launch_app` (app được mở lại từ nền, không phải khởi động lại) |
| Tắt hẳn rồi mở lại | `mobile_terminate_app` → `mobile_launch_app` |
| Deep link `myapp://…` | `sim.sh deeplink` (`mobile_open_url` chỉ nhận http / https) |
| Hộp thoại hệ thống (quyền, thông báo, ATT, mở link ngoài) | Case kiểm chính hộp thoại → làm theo bước case. Không kiểm → cấp sẵn bằng `sim.sh perm … grant` trước case, hoặc chọn đúng theo Precondition và ghi lại |
| Xoay màn | `mobile_set_orientation`; chỉ khi app hỗ trợ xoay hoặc case kiểm việc khoá hướng |

Phần tử **không có nhãn / accessibility id** (nút chỉ có icon, cây phần tử chỉ thấy `Button` trống) → vẫn
chạm theo toạ độ để chạy tiếp, ghi vào sổ phiên. Nhiều nút như vậy là một phát hiện về accessibility
(VoiceOver không đọc được), ghi `EXP-xx`.

### Với mỗi case

1. **Đi đúng Precondition + Steps, so với Expected / spec** — như `run-manual-test` Bước 1 mục 1–2 (đối
   chiếu Spec / Figma 80/20, spec thắng, không sửa expected cho khớp app). Ghi chú của case ghi đủ để làm
   lại: giá trị đã nhập, bản ghi đã dùng, chỗ phải chờ, cách hiểu bước mơ hồ.

2. **Bằng chứng:**
   - Ảnh: `mobile_save_screenshot` lưu thẳng vào `test-execute/round<N>/images/manual-<TC ID>_<mo-ta>.png`
     (đường dẫn tuyệt đối; adhoc: `test-execute/adhoc/images/`). Fail bắt buộc; Pass chụp khi kết quả hiển
     thị đáng giữ. Cần ảnh gọn để gửi khách → `sim.sh statusbar <udid> clean` trước khi chụp.
   - **Video** khi lỗi thoáng qua hoặc cần thấy cả chuỗi (nháy, giật, animation sai, toast biến mất, chuyển
     màn sai): `mobile_start_screen_recording` trước bước nghi ngờ, `mobile_stop_screen_recording` sau đó,
     lưu `.mp4` cạnh ảnh với cùng quy tắc tên. Chỉ giữ video gắn với defect / case Fail.
   - **Toast / banner tự tắt:** gom thao tác và đọc màn vào một `mobile_batch_commands` có
     `listElementsAtEnd` để bắt kịp; vẫn không thấy → lặp lại có quay video. Không thấy toast **chưa phải** Fail.
   - **App văng (crash) / treo:** chụp màn lúc đó, `mobile_list_crashes` → `mobile_get_crash` lấy log, lưu
     `test-execute/round<N>/logs/crash-<TC ID>_<yyyymmdd-hhmm>.txt`; lỗi không văng nhưng nghi do app →
     `mobile_get_device_logs` lọc theo app, lưu đoạn liên quan. Ghi đường dẫn log vào Ghi chú và defect.

3. **Kết quả** — theo luật *Điền kết quả* của `write-test-execute` và phần thêm cho AI của `run-manual-test`
   (`Pass - Need verify` cho P0 / Fail Major-Critical, `Not run` thay vì để trống). Ghi vào **cột iOS** của
   TESTPROC. Ghi chú thêm `AI` và thiết bị: `AI · R2 phiên 3 · iPhone 17 Pro sim · iOS 26.5`.
   - Case **cần máy thật** mà đang chạy Simulator → không giả lập cho có: ghi `Not run`, Ghi chú
     `Cần máy thật: <lý do>`, gom vào mục *Case cần máy thật* của sổ phiên.
   - Case chạy được ở Simulator nhưng kết quả phụ thuộc phần cứng (push thật, mạng thật) → kết quả trên
     Simulator chỉ ghi phần đã kiểm, ghi rõ phần chưa kiểm, không ghi `Pass` cho cả case.

4. **Thấy lỗi → `report-defect`.** Trường *Môi trường* / *Nền tảng* của defect ghi: `iOS` · thiết bị ·
   Simulator hay máy thật · phiên bản iOS · Build · (dark mode / cỡ chữ / ngôn ngữ / hướng màn nếu liên quan).
   Lấy nhanh bằng `sim.sh env <udid> <bundle id>`. Steps của defect = đúng các bước vừa làm, kèm trạng thái
   app đầu case (cài mới / giữ dữ liệu, đã cấp quyền gì).
   - `verify-defect` hiện chạy trên trình duyệt, **chưa tái hiện được trên thiết bị iOS** → với defect
     mobile, không gọi `verify-defect`; ghi trường Verify `Chưa verify (mobile) — tester tái hiện tay`.
   - **Chạy liên tục, không dừng hỏi giữa chừng**; chỉ dừng và báo ngay trong các trường hợp của
     `run-manual-test` (Smoke Fail chặn luồng chính, thao tác có hậu quả ngoài data test, đăng nhập bị chặn,
     nghi nhầm PROD) và thêm: **app văng liên tục ngay khi mở**.

5. **Thấy bất thường** → Bước 2 trước khi sang case kế tiếp.

Cứ vài case báo tiến độ 1 dòng (`5/12 · 4 Pass · 1 Fail ABC-QA-051 · 1 cần máy thật`).

---

## Bước 2 — Khám phá khi thấy bất thường

Luật khám phá như `run-manual-test` Bước 2: chốt case trước, mỗi bất thường khoảng **10–15 thao tác**, trong
quyền của vai, ghi `EXP-xx`, kết quả khám phá đưa về defect / quan sát / đề xuất case / câu hỏi. Phiên khám
phá thuần (2b) cũng như vậy, vai 🔍 Explorer.

Dấu hiệu và hướng thử **riêng của mobile** nằm ở `references/mobile-heuristics.md` (gián đoạn và vòng đời
app, quyền, bàn phím, cỡ chữ / dark mode / màn nhỏ, xoay màn, deep link, push, mạng, ngôn ngữ). Đọc file đó
khi gặp bất thường hoặc khi chạy phiên khám phá thuần. Thử trên Simulator trước; hướng chỉ thử được trên
máy thật → ghi vào đề xuất, không giả lập.

Đổi trạng thái thiết bị để khám phá (dark mode, cỡ chữ, vị trí, quyền) → **trả lại như cũ ngay sau khi
thử** để case sau không chạy sai, và ghi trong `EXP-xx`.

---

## Bước 3 — Kết thúc phiên

1. Sổ phiên: điền *Tổng kết* như `run-manual-test` Bước 3, thêm **Case cần máy thật** (TC ID · lý do) và
   thiết bị / build đã dùng.
2. Trả thiết bị về mặc định: `sim.sh reset-ui <udid>` (cũng xoá clipboard). Simulator do Claude bật trong
   phiên → hỏi người dùng có tắt không (`xcrun simctl shutdown <udid>`). Không xoá (`erase`) simulator, không
   gỡ app nếu người dùng không yêu cầu.
3. Báo người dùng ngắn gọn:
   - `Đã chạy x/y case trên iOS · Pass a · Fail b · Blocked c · Not run d (cần máy thật e)` + Defect ID mới.
   - Case `… - Need verify` chờ tester xác minh tay; defect mobile chờ tester tái hiện (chưa có `verify-defect` cho mobile).
   - Khám phá đáng chú ý, đề xuất case, câu hỏi cần chốt, case cần chạy trên máy thật.
4. Không tự cập nhật `testcase_tracker.md` / `defect_tracker.md`.

---

## Không làm

- Không ghi `Pass` khi chưa đi hết bước kiểm tra, không đổi expected cho khớp app, không kết luận từ cây
  phần tử cũ khi màn chưa chuyển xong.
- Không gõ mật khẩu bằng `mobile_type_keys`, không in mật khẩu / OTP / token, không để mật khẩu nằm lại
  trong clipboard của simulator, không đăng nhập trên PROD.
- Không giả lập thứ chỉ máy thật mới kiểm được rồi ghi `Pass`.
- Không dùng thiết bị cloud / remote, không `erase` simulator, không đổi cài đặt máy Mac (Network Link
  Conditioner, mạng) khi người dùng chưa đồng ý.
- Không đăng nhập Apple ID / TestFlight, không cài công cụ ký app hay WebDriverAgent thay người dùng.
- Không tự dựng / sửa cấu trúc TESTPROC (`write-test-execute`), không viết defect bỏ qua `report-defect`.
