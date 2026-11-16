# <TÊN DỰ ÁN> — SẴN SÀNG PHÁT HÀNH

| Mục | iOS | Android |
|---|---|---|
| File sẽ nộp store (nguồn) | <TestFlight build …> | <AAB / internal track …> |
| Version (build number) | | |
| Bản trước trên store | | |
| Ngày tra quy định store hiện hành | <dd/mm/yyyy — nguồn> | <dd/mm/yyyy — nguồn> |

## 1. REL

| ID | iOS | Android | Ghi chú |
|---|---|---|---|
| REL-01 Test trên đúng file sẽ nộp store | | | |
| REL-02 Trỏ đúng server PROD, đúng key PROD | | | |
| REL-03 Smoke pass trên release build | | | xem mục 2 |
| REL-04 Version / build number đúng, tăng so với bản trước | | | |
| REL-05 Tên app, icon, splash đúng | | | |

## 2. Smoke trên release build

| ID | iOS | Android | Ghi chú |
|---|---|---|---|
| SM-01 | | | |

## 3. STORE-IOS

| ID | Kết quả | Chặn duyệt? | Ghi chú / Defect |
|---|---|---|---|
| STORE-IOS-01 | | | |

## 4. STORE-AND

| ID | Kết quả | Chặn duyệt? | Ghi chú / Defect |
|---|---|---|---|
| STORE-AND-01 | | | |

## Kết luận cổng 7

- Release build pass smoke, không crash: <có / không>
- Mục store còn chặn: <không / danh sách + Defect ID (Critical)>
