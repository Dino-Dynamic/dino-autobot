# <TÊN DỰ ÁN> — SỔ DEFECT

Một dòng mỗi defect ở bảng tóm tắt, chi tiết ở mục bên dưới. Severity theo thang nội bộ
`Critical / Major / Minor / Low` (`references/severity-golive.md`).

Trạng thái: `Open` · `Fixed` (khách báo đã sửa, chờ retest) · `Closed` · `Reopen` · `Won't fix` (khách chấp
nhận, ghi văn bản) · `Cần xác nhận` (sai so với giả định `AS` chưa xác nhận — chưa tính là defect).

## Tóm tắt

| ID | Tiêu đề | Severity | Nền tảng | Trạng thái | Round phát hiện | Regression | Build sửa | Cập nhật |
|---|---|---|---|---|---|---|---|---|
| <MÃ>-001 | | | iOS / Android / Cả hai | Open | R1 | Không | | <dd/mm> |

## Chi tiết

### <MÃ>-001 — [<Màn / chức năng>] <Mô tả ngắn hiện tượng>

| Trường | Giá trị |
|---|---|
| Severity | <Critical / Major / Minor / Low> — <lý do; hạ mức thì ghi vì sao> |
| Nền tảng | <iOS / Android / Cả hai> — đã thử nền tảng kia: <có / chưa> |
| Thiết bị | <model, OS version, Simulator / Emulator / máy thật> |
| Build | <version (build number)> |
| Tài khoản | <vai trò — không ghi mật khẩu> |
| Điều kiện | <mạng, quyền, dữ liệu có trước, trạng thái app (cài mới / có dữ liệu)> |
| Mục checklist | <CK-xxx / SM-xx / OB-xx> |
| Tần suất | <Luôn luôn / x/y lần> |
| Bằng chứng | <`evidence/R1/<MÃ>-001_….mp4`, ảnh, log / request> |
| Regression | <Không / Có — Pass ở round …> |
| Giả định liên quan | <AS-xx (trạng thái) / không> |

**Các bước**
1. …
2. …

**Kết quả mong đợi:** … (theo `BR-xx` / `AS-xx` / mục `CK-xxx`)

**Kết quả thực tế:** …

**Lịch sử**

| Ngày | Round · Build | Trạng thái | Ghi chú |
|---|---|---|---|
| | R1 · <b> | Open | |
