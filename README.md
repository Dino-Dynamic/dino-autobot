# dino-autobot

Bộ skill Claude Code để kiểm thử ứng dụng di động. Dùng chung quy ước với bộ skill QA hiện có
(`write-test-execute`, `report-defect`, `run-manual-test`…).

## Skill

| Skill | Trạng thái | Việc |
|---|---|---|
| [`mobile-app-test-workflow`](skills/mobile-app-test-workflow/SKILL.md) | Giai đoạn 1 | Điều phối trọn dự án test app iOS / Android outsource không tài liệu: intake → baseline → kế hoạch theo rủi ro → round → defect → retest → release / store → Go / No-go. Độc lập với bộ skill QA nội bộ |
| [`run-mobile-manual-test`](skills/run-mobile-manual-test/SKILL.md) | Giai đoạn 1 | Claude tự test manual app iOS trên Simulator / iPhone thật qua mobile-mcp, theo TESTPROC của round hoặc khám phá thuần |
| [`mobile-test-design`](skills/mobile-test-design/SKILL.md) | Giai đoạn 1 | Thêm lớp test đặc thù mobile vào thiết kế test của `test-design` (R ngầm + test condition), và scope cấp bản phát hành. Giữ danh mục test mobile dùng chung cho các skill khác |
| Điều phối automation mobile (Maestro / Appium) | Giai đoạn 2 — chưa làm | |

## Yêu cầu

- macOS có Xcode (runtime iOS Simulator).
- MCP server [mobile-mcp](https://github.com/mobile-next/mobile-mcp) đã cấu hình cho Claude Code.
- Các skill QA dùng chung đã cài trong `~/.claude/skills`: `run-manual-test`, `write-test-execute`, `report-defect`.

## Cài

Liên kết các skill trong repo vào `~/.claude/skills` (sửa trong repo là skill cập nhật luôn):

```bash
./install.sh
```

## Cấu trúc một skill

```
skills/<tên>/
  SKILL.md        quy trình chính
  references/     tài liệu tra cứu, Claude đọc khi cần
  templates/      mẫu file sinh ra trong dự án test
  scripts/        script hỗ trợ
```
