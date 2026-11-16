---
name: mobile-test-design
description: >-
  Thêm lớp test đặc thù mobile (iOS / Android) vào thiết kế test của một scope: gắn dấu hiệu cho từng màn / chức năng (form, danh sách, ghi dữ liệu, quyền, push, deep link, thanh toán…), chọn mục phù hợp trong danh mục test mobile (vòng đời và gián đoạn, quyền, mạng, bàn phím, điều hướng, hiển thị, push, deep link, phiên và bảo mật, ảnh / file, vị trí, IAP, thời gian / ngôn ngữ, accessibility, hiệu năng), rồi ghi thành requirement ngầm + test condition đúng định dạng `test-design` để review và viết test case chung. Cũng dựng scope cấp bản phát hành (cài mới, cập nhật từ bản cũ, force update, ma trận thiết bị). Dùng khi người dùng nói "test case mobile", "thêm case đặc thù mobile", "case iOS / Android cho story X", "test condition cho app", "checklist mobile cho bản phát hành", hoặc sau `test-design` của một scope thuộc app mobile.
---

# Test design cho app mobile

`test-design` lo phần chức năng theo spec / AC. App mobile còn một lớp lỗi spec hầu như không viết: app bị đưa
xuống nền, mất mạng giữa lúc gửi, từ chối quyền, bàn phím che nút, push mở sai màn, cập nhật từ bản cũ mất dữ
liệu… Skill này thêm lớp đó vào **cùng bộ tài liệu của `test-design`**, không tạo bộ tài liệu riêng:

```
test-design Bước 1          mobile-test-design                         test-design Bước 2–4
1-requirements.md   ──►  A. gắn dấu hiệu cho từng màn / chức năng  ──►  review chung, viết test case,
(R, D đã có)             B. chọn mục trong danh mục mobile              check_coverage.py
                         C. ghi R ngầm (Source "Implicit · Mobile …")
                         D. ghi C trong mục "Mobile — …" của 2-test-conditions.md
```

Vì R / C mới theo đúng định dạng của `test-design` (R có ID, Type, Risk; C trỏ Ref tới R), script
`check_coverage.py` kiểm được độ phủ như mọi R khác. Mục mobile là **edge case**: cột AC để trống, không đếm vào
độ phủ AC — trừ khi AC của story nói rõ hành vi đó (vd AC "khi mất mạng thì lưu nháp"): lúc đó R đã có từ spec,
skill này chỉ thêm condition còn thiếu cho R đó.

Danh mục: `references/mobile-catalog.md` (mẫu condition, dấu hiệu áp dụng, Type, ưu tiên gợi ý, nền tảng, chạy
trên Simulator / Emulator hay cần máy thật). Đọc mục cần dùng, không đọc lại cả file mỗi scope.

Hai chế độ:

| Chế độ | Khi nào | Kết quả |
|---|---|---|
| **Theo scope** (mặc định) | Story / màn / module của app mobile, đã có `1-requirements.md` | R + C mobile thêm vào thư mục scope đó |
| **Bản phát hành** | Mỗi bản phát hành lên store (người dùng nói "checklist mobile cho bản x.y") | Scope riêng `mobile-release-<x.y>` với R + C cấp bản phát hành |

Dự án theo `mobile-app-test-workflow` (không dùng `test-design`) → không chạy skill này; Bước 3 của workflow
dùng thẳng danh mục để cụ thể hoá nhóm MOB thành mục `CK` (xem cuối file).

---

## Bước 0 — Chuẩn bị

1. **Scope:** thư mục `test-case-management/test-design/<scope>/`. Chưa có `1-requirements.md` → chạy
   `test-design` Bước 0–1 trước (cần biết màn hình, R, D của scope).
2. **Nền tảng và thiết bị:** đọc Test Plan / `_knowledge/project-profile.md`: iOS, Android hay cả hai; có máy
   thật không; tên Platform dùng trong kho test case. Test Plan không có nền tảng mobile → dừng, hỏi người dùng.
3. **Đã chạy skill này cho scope chưa:** `grep -c "Implicit · Mobile" 1-requirements.md`. Đã có → chỉ bổ sung
   phần thiếu (màn mới, dấu hiệu mới), không sinh lại.
4. **Quy tắc chung đã có:** `_knowledge/business-rules.md` / NFR của spec có luật mobile (thời hạn phiên, chính
   sách offline, force update…) → dùng làm kỳ vọng, ghi `Rule · BR-xx` như `test-design` mục 1e-bis.

## Bước A — Gắn dấu hiệu

Với mỗi màn / chức năng **mới hoặc đổi trong scope** (màn cũ không đổi thì không gắn lại — đã có ở scope trước),
gắn dấu hiệu theo bảng *Dấu hiệu của tính năng* của danh mục. Ghi vào `1-requirements.md` một bảng phụ ngay
trước bảng R:

```markdown
### Mobile — dấu hiệu (mobile-test-design, <dd/mm/yyyy>)

| Màn / chức năng | R / D liên quan | Dấu hiệu | Ghi chú |
|---|---|---|---|
| Form chuyển tiền | <MÃ>-R03, <MÃ>-R04 | form, write, money, api, auth | Có xác nhận OTP |
```

Dấu hiệu suy từ R / D / spec / Figma; không chắc (vd không rõ app có xin quyền ảnh không) → ghi `?` và đặt
câu hỏi ở bảng câu hỏi của `test-design` (1f), không bỏ qua.

## Bước B — Chọn mục

1. Với mỗi dòng dấu hiệu, lấy các mục trong danh mục có *Áp khi* khớp. Mục không có *Áp khi* (DP-01…04,
   GS-01, AX…) áp cho **mọi màn mới** của scope.
2. Bỏ mục mà nền tảng không thuộc phạm vi (mục `iOS` khi dự án chỉ Android).
3. **Gộp trước khi viết:** một mục áp cho nhiều màn **cùng kiểu** (vd LC-01 cho 3 form giống nhau) → **một R**
   cho nhóm màn đó (giống luật "rule × nhóm màn = 1 requirement" của `test-design` 1e-bis), condition chọn màn
   rủi ro cao nhất làm dữ liệu, các màn còn lại ghi trong cột Note.
4. Spec / R đã nói rõ hành vi của mục → không thêm R ngầm; chỉ thêm condition còn thiếu, Ref tới R có sẵn.
5. **Không áp cho có.** Danh sách chọn dài quá (thường > 25 mục cho một story) → giữ mục có ưu tiên P0–P1 và mục
   gắn với `money` / `write` / `auth` / `sensitive`; còn lại liệt kê ở phần tóm tắt là *đã cân nhắc, không thêm*
   để người review quyết.

## Bước C — Ghi requirement ngầm

Thêm vào bảng R của `1-requirements.md`, ID nối tiếp `<MÃ>-Rxx` của scope:

| Cột | Ghi gì |
|---|---|
| Requirement | Hành vi kiểm được, cụ thể cho scope: "Đang nhập dở form chuyển tiền, đưa app xuống nền rồi mở lại → dữ liệu đã nhập còn nguyên" — không chép mẫu nguyên văn |
| Source | `Implicit · Mobile <ID mục>` (vd `Implicit · Mobile LC-01`); có luật dự án thì `Rule · BR-xx · Mobile LC-02` |
| Type | Theo cột Type của mục |
| Risk | Impact / Likelihood theo bảng của `test-design`. Màn có `money` / `sensitive` / `auth` → nâng Impact |
| Status | `Confirmed` khi hành vi đúng là hiển nhiên (không crash, không tạo trùng, không mất dữ liệu đã nhập). Kỳ vọng phụ thuộc quyết định của BA (thời hạn phiên, có cho xoay không, offline lưu nháp hay chặn, nội dung thông báo) → `Pending Qxx` + câu hỏi ở 1f |

Không bịa con số, câu thông báo, thời gian chờ. Danh mục ghi `<x>` thì phải có nguồn hoặc câu hỏi.

## Bước D — Ghi test condition

Thêm vào `2-test-conditions.md` các mục riêng ở **cuối** file, trước `## Coverage`, mỗi nhóm danh mục một mục:
`## Mobile — Vòng đời & gián đoạn`, `## Mobile — Quyền`, `## Mobile — Mạng`… Cùng bảng cột với `test-design`.

| Cột | Ghi gì |
|---|---|
| ID | Nối tiếp `<MÃ>-Cxxx` của scope |
| Test condition | Tình huống cụ thể **có dữ liệu**: "Nhập 1.500.000 vào Số tiền → Home → mở lại sau 30 giây → ô Số tiền vẫn 1.500.000". Hành vi khác nhau giữa iOS và Android (GS-01 / GS-02, PM-08, quyền vĩnh viễn) → **tách 2 condition** ghi rõ nền tảng |
| Ref | R vừa thêm ở Bước C (hoặc R có sẵn) |
| AC | Để trống (edge case), trừ khi AC nói rõ hành vi này |
| Technique | Dùng đúng bộ của `test-design`: vòng đời / mạng / gửi trùng / gián đoạn → `Error Guessing`; cấp – từ chối – thu hồi quyền, gia hạn gói → `State Transition`; luồng push / deep link / IAP / cập nhật app → `Use Case`; bàn phím, hiển thị, điều hướng → `UI`; múi giờ, định dạng, vùng vị trí → `EP` / `BVA` |
| Priority | Theo Risk của R; ưu tiên gợi ý của danh mục chỉ là điểm xuất phát |
| Rationale | Hậu quả nếu sai, rồi nền tảng và nơi chạy: `Chuyển tiền hai lần · Cả hai · Sim`, `Mất quyền lợi đã mua · iOS · Máy` |
| TC | Trống (điền ở Bước 3 của `test-design`) |
| Note | **Để trống** khi condition sẽ được test — script của `test-design` lấy Note làm lý do "chưa có test case", ghi thông tin khác vào đây sẽ in sai nghĩa. Chỉ dùng cho các cụm của `test-design` (`Pending Qxx`, `Covered by`…). Cần máy thật mà dự án **không có máy thật** → TC `—` và Note bắt đầu `Not testable on test env: cần máy thật (<lý do>)` để script tính N/A |

## Bước E — Kiểm và trình review

1. Chạy script của `test-design` cho scope:
   `python3 ~/.claude/skills/test-design/scripts/check_coverage.py test-case-management/test-design/<scope>`
   Sửa mọi lỗi script báo (Ref sai, Priority sai, `—` thiếu lý do). Chưa viết test case thì cảnh báo "chưa có
   test case" là bình thường.
2. Trình người dùng, **gộp vào lần review Bước 2 của `test-design`** nếu đang ở bước đó:
   - Bảng dấu hiệu (Bước A).
   - Số R / C mobile theo nhóm và theo Priority; số condition `Sim` / `Máy` / `Proxy`; số `Not testable`.
   - Mục *đã cân nhắc, không thêm* (Bước B mục 5) và câu hỏi mới cho BA.
3. **Dừng chờ review.** File `2-test-conditions.md` đã `Approved` trước đó → đổi Status về
   `Pending review (thêm mục Mobile <ngày>)`.

## Bước F — Viết test case (sau khi duyệt)

Theo `test-design` Bước 3 và `references/test-case-writing-rules.md` của nó, thêm:
- **Gộp** nhiều condition mobile của **cùng một màn, cùng dữ liệu chuẩn bị** vào một test case khi không làm
  khó đọc kết quả (vd LC-01 + DP-05 + KB-01 trên cùng form). Không gộp condition cần máy thật với condition chạy
  trên Simulator.
- Cột **Platform** theo tên nền tảng của kho test case; condition `Cả hai` mà chạy giống nhau → một case, ghi cả
  hai nền tảng theo quy ước của dự án.
- **Tags:** `mobile` + `mobile:<nhóm>` (vd `mobile:LC`, `mobile:PM`); cần máy thật thêm `real-device`. Tag giúp
  lọc khi dựng TESTPROC (chạy riêng phần máy thật, hoặc giao `run-mobile-manual-test` phần chạy được trên
  simulator).
- Precondition ghi rõ **trạng thái thiết bị** cần có: quyền đã cấp / chưa, app cài mới / có dữ liệu, mạng, dark
  mode, cỡ chữ, ngôn ngữ.

Rồi chạy lại `check_coverage.py` như `test-design` Bước 4.

---

## Chế độ bản phát hành

Một scope cho mỗi bản phát hành: `test-case-management/test-design/mobile-release-<x.y>/`, mã scope `REL<xy>`
(vd `REL14`).

1. `1-requirements.md` (mẫu của `test-design`): không có bảng AC. R lấy từ nhóm **IU** và **CM** của danh mục,
   cụ thể cho bản này: bản đang trên store là gì (để test IU-02 cập nhật), OS thấp nhất app hỗ trợ, ma trận thiết
   bị của dự án, có force update không. Source `Implicit · Mobile IU-02`.
2. `2-test-conditions.md`: condition như Bước D. IU-02 cần **build của bản cũ** → ghi trong Note nguồn lấy build.
3. Quy định duyệt store (xoá tài khoản, Sign in with Apple, privacy manifest, Data safety, target API level…)
   **không** sinh từ danh mục: thay đổi theo thời gian. Người dùng cần → dùng nhóm STORE của
   `mobile-app-test-workflow/references/checklists.md`, tra lại quy định hiện hành, ghi ngày tra trong Note.
4. Bản phát hành sau: chép scope cũ sang thư mục mới, cập nhật bản cũ / OS / thiết bị, không viết lại từ đầu.

---

## Dùng danh mục ở dự án `mobile-app-test-workflow`

Workflow không có R / C. Ở Bước 3 của workflow, khi chọn nhóm MOB: lấy dấu hiệu từ mục *Đặc điểm app* và
*Feature map* của `2-baseline.md`, chọn mục danh mục như Bước B ở trên, rồi ghi thành mục `CK-xxx` trong
`3-plan.md` với cột *Nguồn* `MOB-01 · LC-03 · FT-05`, kỳ vọng theo `BR` / `AS` của baseline (không có thì thêm
`AS` mới cho khách xác nhận), cột *Chạy ở* lấy từ danh mục.

## Không làm

- Không sinh condition chung chung ("kiểm tra app khi mất mạng") — mỗi dòng có màn, dữ liệu, kỳ vọng.
- Không bịa con số / câu thông báo / thời gian; không có nguồn thì `Pending Qxx`.
- Không đưa mục mobile vào cột AC khi AC không nói tới; không đổi độ phủ AC bằng mục mobile.
- Không sửa skill `test-design` hay script của nó; không đọc cả `testcase_detail.md` (luật đọc của `test-design`).
- Không sinh quy định store từ trí nhớ.
