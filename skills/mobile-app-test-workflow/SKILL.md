---
name: mobile-app-test-workflow
description: >-
  Điều phối trọn quy trình test app mobile iOS / Android cho dự án outsource không có tài liệu (thường app khách tự làm bằng AI), từ tiếp nhận tới Go / No-go: intake và chốt phạm vi / gói, chuẩn bị môi trường, khám phá app và dựng baseline requirement cho khách duyệt, lập kế hoạch theo rủi ro (P0–P3, checklist round, bộ smoke), chạy round, ghi defect, retest + regression, kiểm release build và quy định store, báo cáo Go / No-go, theo dõi sau go-live. Mỗi lần gọi: đọc `STATE.md` của dự án, làm bước hiện tại, kiểm cổng rồi mới sang bước sau. Dùng khi người dùng nói "test app mobile cho khách", "nhận dự án test app", "workflow test app", "bước tiếp theo của dự án app", "dựng baseline app", "lập checklist round", "app này go-live được chưa", "check store trước khi nộp".
---

# Workflow test app mobile (outsource, không tài liệu)

Skill này là **người điều phối** trọn một dự án test app. Mỗi lần được gọi làm đúng 4 việc:

```
1. Xác định đang ở bước nào      (đọc STATE.md của dự án; chưa có → Bước 0)
2. Làm việc của bước đó           (Claude làm phần của Claude, chuẩn bị sẵn phần người dùng / khách phải làm)
3. Kiểm cổng ra                   (chưa đạt → nói rõ còn thiếu gì, không sang bước sau)
4. Cập nhật STATE.md              (bước, cổng, quyết định, việc đang chờ ai)
```

Bối cảnh: tester (người dùng) nhận test app iOS / Android do khách tự làm, không có requirement. Mục tiêu:
xác nhận app đủ chất lượng để go-live. Skill **độc lập** với bộ skill QA nội bộ (`write-test-execute`,
`report-defect`…): mọi tài liệu dùng mẫu trong `templates/` của skill này. Chỉ dùng lại
`run-mobile-manual-test` cho **cách điều khiển thiết bị iOS** khi Claude tự chạy test.

## Nguyên tắc cốt lõi

1. **Không cam kết "hết lỗi".** Cam kết: *đã test phạm vi X trên thiết bị Y qua N round, không còn defect
   Critical / Major đang mở, rủi ro còn lại liệt kê trong báo cáo.* Mọi văn bản gửi khách giữ đúng giọng này.
2. **Không có tài liệu → dựng lại requirement từ app (baseline) và cho khách duyệt** trước khi test sâu.
   Baseline là mốc phân xử "bug hay tính năng".
3. **Test theo rủi ro:** P0 trước, phần còn lại tuỳ gói và ngân sách.
4. **Code do AI sinh → sửa chỗ này dễ hỏng chỗ khác:** mỗi build mới đều chạy **bộ smoke cố định** trước.
5. **Smoke cuối chạy trên đúng file sẽ nộp store** (release build), không phải bản debug.

## Ai làm gì

| Claude | Người dùng (tester) | Khách |
|---|---|---|
| Soạn bộ câu hỏi intake, ước lượng, đề xuất gói, kiểm khả thi mốc go-live | Gửi intake, chốt hợp đồng / báo giá | Trả lời intake, xác nhận phạm vi |
| Tự khám phá app trên simulator / emulator, dựng baseline nháp | Bổ sung phần Claude không vào được, gửi khách duyệt | Duyệt baseline, trả lời giả định |
| Xếp ưu tiên, chọn nhóm checklist, dựng checklist round + bộ smoke | Duyệt kế hoạch | |
| Chạy checklist phần chạy được trên simulator / emulator, ghi kết quả + bằng chứng, ghi defect | Chạy phần cần máy thật, proxy, thanh toán sandbox; xác minh kết quả `Need verify` | Sửa lỗi, gửi build mới |
| Tính tiêu chí go-live, soạn danh sách defect / báo cáo / khuyến nghị | Gửi khách, chốt Go / No-go với khách | Nhận báo cáo, chấp nhận rủi ro còn lại |

**Claude không liên lạc với khách.** Mọi thứ gửi khách (intake, baseline, danh sách defect, báo cáo) Claude
soạn thành file, người dùng gửi. Ngôn ngữ văn bản gửi khách chốt ở Bước 0 (ghi `STATE.md`), mặc định tiếng Việt.

---

## Thư mục dự án

Người dùng chỉ thư mục dự án; chưa có thì hỏi đặt ở đâu. Bước 0 dựng khung từ `templates/`:

```
<dự án>/
├── STATE.md            bước hiện tại, cổng, quyết định, môi trường & thiết bị, việc đang chờ   (templates/STATE.md)
├── 0-intake.md         câu hỏi + câu trả lời intake, quy mô, gói, phạm vi, đồng ý trên PROD    (templates/INTAKE.md)
├── 2-baseline.md       màn hình, chức năng, user flow, business rule, giả định, bất thường    (templates/BASELINE.md)
├── 3-plan.md           ưu tiên P0–P3, nhóm checklist chọn, bộ smoke, lịch                      (templates/PLAN.md)
├── rounds/R<N>.md      checklist round N: smoke, retest, regression, kết quả iOS | Android    (templates/ROUND.md)
├── defects.md          sổ defect xuyên round                                                  (templates/DEFECTS.md)
├── 7-release.md        REL + STORE-IOS + STORE-AND trên release build                         (templates/RELEASE.md)
├── 8-report.md         test report + khuyến nghị Go / No-go                                   (templates/REPORT.md)
└── evidence/           baseline/ (ảnh màn hình) · R<N>/ (ảnh, video, log của round)
```

Tên file bằng chứng: `evidence/R<N>/<ID mục hoặc defect>_<mo-ta>.png|mp4|txt`.

## ID dùng xuyên dự án

| Loại | ID | Ở đâu |
|---|---|---|
| Màn hình · Chức năng · User flow · Business rule | `SC-xx` · `FT-xx` · `UF-xx` · `BR-xx` | `2-baseline.md` |
| Giả định / câu hỏi cho khách | `AS-xx` (Chưa xác nhận / Đã xác nhận / Khách sửa lại) | `2-baseline.md` |
| Bất thường thấy khi khám phá (chưa phải defect) | `OB-xx` | `2-baseline.md`, `rounds/R<N>.md` |
| Mục checklist mẫu | `FUNC-02`, `MOB-03`… | `references/checklists.md` |
| Mục checklist của dự án (ổn định qua các round) | `CK-xxx` | `3-plan.md`, `rounds/R<N>.md` |
| Bước smoke | `SM-xx` | `3-plan.md`, `rounds/R<N>.md` |
| Defect | `<MÃ>-xxx` (mã dự án 2–5 chữ hoa, chốt Bước 0) | `defects.md` |

---

## Bước 0 — Tiếp nhận & chốt phạm vi

**Claude làm:**
1. Dựng thư mục dự án từ `templates/`, chốt mã dự án và ngôn ngữ văn bản gửi khách. Thông tin người dùng
   đã biết sẵn (nền tảng; có thanh toán / AI / admin web / push không; staging hay chỉ PROD; gói; tài khoản
   Google Play cá nhân hay tổ chức) → hỏi người dùng **một lần bằng `AskUserQuestion`** (trắc nghiệm) trước
   khi soạn intake gửi khách; câu người dùng chưa biết thì để trong intake.
2. Soạn bộ câu hỏi intake từ `references/intake.md` mục A vào `0-intake.md`, **bỏ câu đã biết** từ thông tin
   người dùng đưa. Người dùng gửi khách; có câu trả lời thì điền vào.
3. Ước lượng quy mô (số màn, vai, nền tảng; có thanh toán / AI / admin web / push không) và **đề xuất gói**
   Lite / Standard / Full (`references/intake.md` mục F) kèm lý do.
4. **Kiểm khả thi mốc go-live** (`references/intake.md` mục *Khả thi mốc go-live*). Quy định store thay đổi
   theo thời gian → tra lại quy định hiện hành (web search) trước khi kết luận, ghi ngày tra vào `0-intake.md`.
5. **Chỉ có PROD** → ghi rủi ro, soạn đoạn xin **đồng ý bằng văn bản** cho: ghi dữ liệu test, gửi email / SMS /
   push, thanh toán, thử bảo mật (IDOR, sửa request), ai dọn dữ liệu. Chưa có đồng ý thì các mục đó là `N/A`
   (lý do: chưa được phép trên PROD) và vào rủi ro của báo cáo.
6. Soạn phần chốt phạm vi cho hợp đồng / báo giá: chức năng, nền tảng, thiết bị, số round (round thêm có tính
   phí không), thang severity và tiêu chí go-live (`references/severity-golive.md`), mục **không bao gồm**
   (load test, pentest chuyên sâu, test quá nhiều thiết bị, sửa code).

**Cổng 0:** khách xác nhận phạm vi, gói, số round (người dùng báo lại). → ⏸ **Điểm dừng**: chờ người dùng.

## Bước 1 — Chuẩn bị môi trường

**Claude làm:** lập danh sách việc chuẩn bị trong `STATE.md` mục *Môi trường & thiết bị* theo
`references/devices-tools.md` (kênh nhận build iOS / Android, bản debug cho phép proxy, tài khoản test từng vai,
sandbox thanh toán, ma trận thiết bị, công cụ, Crashlytics / Sentry, nơi ghi defect); đánh dấu mục nào người
dùng / khách phải làm. Phần Claude tự làm được: bật simulator iOS / emulator Android, cài build simulator /
APK, kiểm mobile-mcp thấy thiết bị, thử mở app và đăng nhập.

- Không có bản cho phép proxy → ghi rủi ro: không soi được API, khó test bảo mật và giả lập lỗi.
- Tài khoản test lưu ở file bí mật của dự án (vd `.env` đã gitignore), không ghi mật khẩu vào file khác.
  Đăng nhập theo luật đăng nhập của người dùng (CLAUDE.md toàn cục) và cách nhập trên thiết bị của
  `run-mobile-manual-test` Bước 0 mục 5.

**Cổng 1:** cài được app và đăng nhập được trên **≥ 1 máy iOS và ≥ 1 máy Android** (simulator / emulator tính).
Phạm vi chỉ một nền tảng thì chỉ cần nền tảng đó.

## Bước 2 — Khám phá & dựng baseline

Mục tiêu: biến "app hiện có" thành mốc chuẩn. Khám phá có thời lượng (gói Standard: 1–2 ngày công).

**Claude làm** (trên thiết bị qua mobile-mcp, từng vai trò có tài khoản):
1. Đi hết app như người dùng thật: mỗi màn chụp một ảnh vào `evidence/baseline/SC-xx_<ten>.png`.
2. Ghi vào `2-baseline.md`:
   - **Feature map:** màn hình `SC` → chức năng `FT` trên màn → vai dùng được.
   - **User flow chính** `UF`: đăng ký, đăng nhập, luồng giá trị cốt lõi, thanh toán… (bước + màn đi qua).
     Cần hình luồng thì vẽ bằng `write-user-flow` nếu người dùng muốn.
   - **Business rule suy ra** `BR` từ hành vi app (giới hạn, điều kiện, trạng thái), ghi "suy ra từ: thao tác gì".
   - **Giả định / câu hỏi** `AS` cho mọi chỗ không chắc là đúng ý khách ("mật khẩu tối thiểu 8 ký tự?").
   - **Bất thường** `OB` thấy được (chưa báo lỗi chính thức).
   - **Đặc điểm app** dùng cho Bước 3: có thanh toán / AI / admin web / push / quyền nào / deep link / iPad.
3. Phần không vào được (máy thật, thanh toán, vai chưa có tài khoản) → ghi "chưa khám phá: lý do" để người dùng bổ sung.
4. Soạn bản gửi khách: baseline rút gọn + danh sách `AS` cần trả lời.

Thao tác thiết bị: iOS theo `run-mobile-manual-test` (mục *Thao tác bằng mobile-mcp*, `scripts/sim.sh`);
Android theo `references/devices-tools.md` mục *Android*. Luật an toàn: không gửi email / SMS / push thật,
không thanh toán, không xoá dữ liệu người khác khi chưa có đồng ý ở Bước 0.

**Cổng 2:** khách duyệt baseline. `AS` khách chưa trả lời → test theo giả định, giữ trạng thái *Chưa xác nhận*
để báo cáo nêu rõ. → ⏸ **Điểm dừng**.

## Bước 3 — Lập kế hoạch theo rủi ro

**Claude làm** vào `3-plan.md`:
1. **Xếp ưu tiên từng chức năng `FT`:** P0 hỏng là không go-live (đăng ký / đăng nhập, luồng giá trị cốt lõi,
   thanh toán, mất hoặc lộ dữ liệu) · P1 tính năng phụ hay dùng, push, hồ sơ · P2 giao diện, câu chữ, case
   hiếm · P3 chỉ khi còn thời gian. Ghi lý do cho từng P0.
2. **Chọn nhóm checklist** trong `references/checklists.md` theo đặc điểm app và gói (cột *Áp dụng khi*).
   Nhóm không chọn → ghi lý do (vd "app không có AI → bỏ AIF").
3. **Dựng checklist round 1** (`CK-xxx`) = luồng và chức năng theo baseline (FUNC cụ thể hoá cho từng `FT` /
   `UF` / `BR`) + các mục của nhóm đã chọn. Mỗi mục: ID, nhóm, nguồn (`FUNC-02` / `UF-03` / `BR-05`), thao tác →
   kỳ vọng, ưu tiên, **chạy ở đâu** (Simulator / Emulator / Máy thật / Proxy), cột kết quả iOS | Android.
   Kỳ vọng lấy từ baseline hoặc giả định — ghi ID `BR` / `AS` làm căn cứ.
4. **Dựng bộ smoke cố định** 15–30 bước `SM` phủ toàn bộ P0, chạy được trong khoảng 30 phút. Gói Full → ghi
   đề xuất tự động hoá smoke bằng Maestro (giai đoạn sau).
5. Ước lượng thời gian mỗi round, soạn lịch gửi khách.

**Cổng 3:** có checklist round 1 + bộ smoke, người dùng duyệt `3-plan.md`.

## Bước 4 — Test round (round 1; round sau xem Bước 6)

Tạo `rounds/R<N>.md` từ mẫu, chép các mục `CK` / `SM` cần chạy. **Thứ tự chạy:**

1. **Smoke** (P0) trên 1 iOS + 1 Android. P0 hỏng nặng (không đăng nhập được, crash luồng chính) → ⏸ **dừng
   ngay**, soạn tin báo khách, chờ build mới.
2. Chức năng theo baseline (FUNC) → 3. Đặc thù mobile (MOB) → 4. Lỗi điển hình app AI (AIC) + bảo mật nhanh
   (SEC, chỉ khi được phép) → 5. Tính năng AI (AIF) → 6. Hiệu năng / crash (PERF) → 7. Mở rộng sang thiết bị
   còn lại trong ma trận cho mục P0–P1.

**Claude chạy** các mục *chạy ở* Simulator / Emulator; mục Máy thật / Proxy / thanh toán sandbox → để
`Not run`, gom vào danh sách *Cần người chạy* của round. Cách chạy:
- Đi đúng thao tác → kỳ vọng của mục; so với baseline / giả định, **không so với cảm giác**. Kỳ vọng mơ hồ →
  không kết luận, thêm `AS` mới.
- Kết quả: `Pass` · `Fail` (kèm Defect ID) · `Blocked` (lý do) · `N/A` (lý do) · `Not run` (lý do), ghi theo
  **từng nền tảng**. Ghi chú thêm `AI` + thiết bị. Mục P0 `Pass` và mục `Fail` Critical / Major do Claude chạy
  → ghi `… - Need verify` để tester xác minh tay.
- Bằng chứng: ảnh ở bước kiểm kỳ vọng của mọi Fail; **mỗi defect kèm video** — khi ghi defect, tái hiện lại
  các bước trong lúc quay (`mobile_start_screen_recording` → các bước → `mobile_stop_screen_recording`), lần
  tái hiện này cũng cho biết *Tần suất*; crash → lấy crash log (`mobile_list_crashes` / `mobile_get_crash`).
  Lưu `evidence/R<N>/`.
- Thấy bất thường ngoài checklist → khám phá quanh đó **khoảng 10–15 thao tác**, ghi `OB-xx` trong round,
  hướng thử theo `run-mobile-manual-test/references/mobile-heuristics.md`.
- Chạy liên tục, mỗi vài mục báo 1 dòng tiến độ. **Chỉ dừng hỏi khi:** smoke hỏng nặng; thao tác có hậu quả
  ngoài dữ liệu test (gửi thật, thanh toán thật, xoá hàng loạt); đăng nhập bị chặn (captcha / OTP không đọc
  được); nghi đang ở PROD mà chưa có đồng ý.
- Defect **Critical** → soạn ngay tin báo khách (người dùng gửi), không chờ hết round.

**Cổng 4:** đã chạy hết checklist trong phạm vi (mọi mục có kết quả; `Not run` có lý do và người chạy).

## Bước 5 — Báo lỗi & phân loại

Mỗi Fail → một defect trong `defects.md` theo mẫu (`templates/DEFECTS.md`, dựa trên Phụ lục E):
- Tiêu đề `[Màn / chức năng] hiện tượng`; bước tái hiện đúng các bước vừa làm; mong đợi (căn cứ `BR` / `AS` /
  mục checklist) và thực tế; nền tảng **iOS / Android / Cả hai** (đã thử nền tảng kia chưa); thiết bị + OS +
  build; tài khoản (vai, không mật khẩu); điều kiện (mạng, quyền, dữ liệu); tần suất; bằng chứng.
- **Severity theo thang nội bộ** `Critical / Major / Minor / Low` — cách xếp và ví dụ cho app mobile ở
  `references/severity-golive.md`.
- Lỗi chỉ sai so với **giả định chưa được khách xác nhận** → trạng thái `Cần xác nhận`, **không tính là
  defect** cho tới khi khách trả lời `AS` đó.
- Cuối round: soạn danh sách defect gửi khách kèm tóm tắt (số lượng theo severity, chức năng nào chặn go-live).

**Cổng 5:** khách nhận và xác nhận danh sách defect. → ⏸ **Điểm dừng** cuối mỗi round.

## Bước 6 — Retest + regression (round 2…N)

Khi có build mới + danh sách defect khách báo đã sửa (kèm số build):
1. Tạo `rounds/R<N>.md`. Chạy **smoke** trước (như Bước 4 mục 1).
2. **Retest** từng defect đã sửa → `Closed` / `Reopen` (lý do, bằng chứng mới, build).
3. **Regression quanh chỗ sửa:** mục `CK` cùng màn, cùng dữ liệu, cùng API với defect đã sửa. Code AI → thêm
   **mọi luồng P0** dù không liên quan trực tiếp. Ghi lý do chọn từng nhóm mục.
4. Defect mới phát sinh → đánh dấu `Regression: có` (từng Pass ở round trước).
5. Kiểm **tiêu chí go-live** (`references/severity-golive.md`). Chưa đạt và còn round → lặp lại Bước 6. Hết
   round → Bước 8 với khuyến nghị No-go hoặc Go có điều kiện. Đạt → Bước 7.

## Bước 7 — Sẵn sàng phát hành

1. Nhận **đúng file sẽ nộp store** (không dùng bản debug); ghi version / build number vào `7-release.md`.
2. Chạy checklist **REL**, rồi **smoke trên release build** cả iOS và Android, rồi **STORE-IOS / STORE-AND**
   (`references/checklists.md`). Quy định store đổi theo thời gian → tra lại quy định hiện hành trước khi chạy,
   ghi ngày tra.
3. Mục nào chặn việc duyệt store → ghi defect **Critical** (chặn phát hành).

**Cổng 7:** release build pass smoke, không crash; checklist store không còn mục chặn.

## Bước 8 — Báo cáo & Go / No-go

Soạn `8-report.md` từ mẫu: phạm vi đã / chưa test, thiết bị, build, số round; thống kê defect theo severity và
trạng thái; kết quả theo chức năng P0–P3; **giả định chưa được khách xác nhận**; **rủi ro còn lại** (phần chưa
test, defect còn mở, giới hạn môi trường như không soi được API, mục `N/A` do chưa được phép trên PROD); và
**khuyến nghị** Go / Go có điều kiện (liệt kê điều kiện) / No-go (liệt kê lý do) theo tiêu chí go-live.
Số liệu đếm từ `defects.md` và các `rounds/R<N>.md`, không ước lượng. Cần PDF thì xuất theo cách người dùng
quy định (CLAUDE.md toàn cục).

→ ⏸ **Điểm dừng**: người dùng chốt Go / No-go với khách.

## Bước 9 — Sau go-live (chỉ khi có trong gói)

Soạn checklist theo dõi 3–7 ngày: tỉ lệ crash và crash mới trên Crashlytics / Sentry (người dùng / khách cung
cấp số liệu), review đầu tiên trên store, smoke nhanh trên bản tải từ store. Ghi kết quả vào cuối `8-report.md`.

---

## Gói ảnh hưởng tới các bước thế nào

| Gói | Bỏ / rút gọn |
|---|---|
| Lite | Bước 2 rút gọn (chỉ luồng P0); 1 round; chỉ smoke P0 trên 1 iOS + 1 Android, SEC-01→03, MOB-01 + MOB-02 cho luồng P0, REL + STORE. Phần còn lại ghi là **rủi ro chưa test** |
| Standard | Đủ Bước 0–8, 2 round, ma trận thiết bị tối thiểu, đủ FUNC / MOB / AIC / SEC / PERF (AIF nếu có AI) |
| Full | Standard + round 3, thiết bị cloud, AIF chuyên sâu, đề xuất smoke tự động (Maestro), Bước 9 |

Người dùng muốn bỏ một cổng / một nhóm checklist → làm theo, ghi vào mục *Quyết định* của `STATE.md` (bỏ gì,
ai chốt, ngày) và đưa vào rủi ro của báo cáo.

## Khi được gọi giữa chừng

- Đọc `STATE.md`: bước hiện tại, cổng, *Đang chờ*. Nói 1 dòng: `Dự án <MÃ> · Bước 4 round 2 · chờ: tester chạy 6 mục máy thật`.
- Người dùng báo tin của khách (đã trả lời intake, duyệt baseline, gửi build mới, xác nhận defect) → cập nhật
  file tương ứng, kiểm cổng, sang bước sau.
- Người dùng hỏi "app go-live được chưa" → tính tiêu chí go-live trên số liệu hiện có, trả lời kèm điều còn thiếu.
- Yêu cầu nhảy bước (vd test ngay khi chưa có baseline) → nói rủi ro một câu; người dùng vẫn muốn thì làm và
  ghi *Quyết định*.

## Không làm

- Không liên lạc khách, không gửi gì ra ngoài thay người dùng.
- Không cam kết "hết lỗi" trong văn bản nào.
- Không test ghi dữ liệu / thanh toán / bảo mật trên PROD khi chưa có đồng ý bằng văn bản ghi ở `0-intake.md`.
- Không tính lỗi theo giả định chưa xác nhận là defect; không sửa kỳ vọng cho khớp app.
- Không ghi `Pass` cho mục chưa đi hết, không giả lập trên simulator thứ chỉ máy thật mới kiểm được.
- Không in mật khẩu / token / OTP; không đăng nhập Apple ID / Google Play Console / TestFlight thay người dùng.
- Không sửa code app của khách.
