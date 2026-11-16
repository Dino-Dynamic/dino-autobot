# <TÊN DỰ ÁN> — SỔ PHIÊN TEST MANUAL – ROUND <N>

> Ghi **cách đã chạy** và **những gì đã khám phá** trong các phiên Claude test manual (skill `run-manual-test`
> cho web, `run-mobile-manual-test` cho iOS). Kết quả chính thức của từng case nằm ở
> `TESTPROC_<TenDuAn>_R<N>.md`, defect ở `DEFECTLOG_<TenDuAn>_R<N>.md`.
> Mỗi phiên thêm một mục mới ở cuối file. Mã `EXP-xx` tăng dần trong cả round (chung web và mobile).

---

## Phiên <số> — <dd/mm/yyyy> — iOS

| Nội dung | Thông tin |
|---|---|
| Kiểu phiên | Theo TESTPROC · Khám phá thuần |
| Mission (khám phá thuần) | <một câu — bỏ dòng này nếu chạy theo TESTPROC> |
| Vai · Môi trường | <🧪 Tester · TST> |
| Nền tảng · Thiết bị | <iOS · iPhone 17 Pro (Simulator) · iOS 26.5 — máy thật thì ghi model> |
| Build | <x.y.z (build) — từ `sim.sh info`> |
| Trạng thái app đầu phiên | <cài mới · giữ dữ liệu từ phiên N> · quyền đã cấp sẵn: <…> · ngôn ngữ <vi-VN> |
| Trạng thái thiết bị | <light · cỡ chữ mặc định · dọc · không giả lập vị trí> |
| Công cụ | <mobile-mcp · sim.sh · (panel Simulator)> |
| Tài khoản (role) | <email · role — không ghi mật khẩu> |
| Đăng nhập | <Claude tự đăng nhập, mật khẩu dán qua clipboard simulator · hoặc người dùng tự nhập trên máy thật> |
| Phạm vi | <nhóm / dải TC ID / màn hình> |
| Cụm (theo luồng) | <Cụm 1: TC-01…TC-05 · Cụm 2: …> |
| Trạng thái cuối cụm (để phiên sau chạy tiếp) | <cụm đã xong · bản ghi đang dùng · màn đang mở · đang đăng nhập vai nào · cụm kế bắt đầu từ TC nào> |
| Thao tác ngoài kịch bản đã xin phép | <… hoặc "không có"> |

### Case đã chạy

| TC ID | Kết quả | Dữ liệu / bản ghi đã dùng | Bằng chứng | Ghi chú (giá trị đã nhập, chỗ phải chờ, cách hiểu bước mơ hồ, phần tử thiếu nhãn, chờ xác minh) |
|---|---|---|---|---|
| | | | `images/manual-TC-xx_….png` · `….mp4` · `logs/crash-….txt` | |

### Case cần máy thật

| TC ID | Lý do (phần cứng / tính năng Simulator không có) | Đã kiểm được phần nào trên Simulator |
|---|---|---|
| | | |

### Khám phá

| Mã | Từ case | Dấu hiệu | Đã thử (kể cả đổi trạng thái thiết bị và đã trả lại) | Thấy gì | Kết luận |
|---|---|---|---|---|---|
| EXP-01 | | | | | Defect `<ID>` · Quan sát chưa đủ bằng chứng · Đề xuất case · Câu hỏi · Không thấy vấn đề |

### Câu hỏi cần BA / Dev chốt (chỉ khi test adhoc — có TESTPROC thì ghi vào TESTPROC)

| # | Câu hỏi | Nguồn |
|---|---|---|
| Q1 | | EXP-xx / TC ID |

### Đề xuất bổ sung test case (chỉ khi test adhoc — có TESTPROC thì ghi vào TESTPROC)

| # | Thao tác → kỳ vọng | Lý do |
|---|---|---|
| D1 | | |

### Tổng kết phiên

- Thiết bị · Build: <…>
- Đã chạy: <x>/<y> case · Pass <a> · Fail <b> · Blocked <c> · Not run <d> (cần máy thật <e>)
- Defect mới: <ID…> — chờ tester tái hiện tay (chưa có `verify-defect` cho mobile)
- Chờ xác minh tay: <TC ID…>
- Khám phá: <n> mục (<EXP-xx> đáng chú ý)
- Đề xuất case / câu hỏi: <…>
- Chưa chạy và lý do: <…>
- Dữ liệu test: <bản ghi đã tạo / sửa / xoá, hoặc "không có">
- Thiết bị cuối phiên: <đã `reset-ui` · simulator để bật / đã tắt>
