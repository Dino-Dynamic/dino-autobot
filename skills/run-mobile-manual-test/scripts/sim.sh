#!/usr/bin/env bash
# sim.sh — việc trên iOS Simulator mà mobile-mcp không làm được (cài app, quyền, deep link, push,
# giao diện tối, cỡ chữ, vị trí, status bar, clipboard, thông tin môi trường cho defect).
# Dùng kèm skill run-mobile-manual-test. Chỉ dùng cho Simulator; máy thật không áp dụng.
#
#   sim.sh devices                               Thiết bị đang bật + danh sách iPhone/iPad sẵn có
#   sim.sh boot <tên|udid>                       Bật simulator, chờ xong, mở cửa sổ Simulator
#   sim.sh install <udid> <file.app|file.zip>    Cài bản build simulator (.zip chứa .app cũng được)
#   sim.sh info <udid> <bundle id>               Version · build của app đã cài
#   sim.sh env <udid> [bundle id]                Một dòng môi trường để ghi sổ phiên / defect
#   sim.sh perm <udid> grant|revoke|reset <dịch vụ> [bundle id]   Quyền (photos, location, contacts…)
#   sim.sh deeplink <udid> <url>                 Mở deep link / universal link (myapp://…, https://…)
#   sim.sh push <udid> <bundle id> <payload.json>  Push giả lập (payload APNs JSON)
#   sim.sh appearance <udid> light|dark
#   sim.sh textsize <udid> default|largest|smallest|<category>   Cỡ chữ (Dynamic Type)
#   sim.sh location <udid> <lat>,<lon>|clear
#   sim.sh statusbar <udid> clean|clear          Status bar gọn (9:41, đủ sóng/pin) cho ảnh bằng chứng
#   sim.sh clip <udid>                           Đưa stdin vào clipboard của simulator (không in ra)
#   sim.sh clip-clear <udid>                     Xoá clipboard
#   sim.sh reset-ui <udid>                       Trả giao diện về mặc định (light, cỡ chữ mặc định,
#                                                bỏ status bar override, bỏ vị trí, xoá clipboard)
set -euo pipefail

die() { echo "sim.sh: $*" >&2; exit 1; }
need() { [ -n "${1:-}" ] || die "thiếu tham số. Xem đầu file để biết cách dùng."; }

cmd="${1:-}"; shift || true

device_line() {  # udid -> "Tên|iOS x.y|state"
  xcrun simctl list devices -j | python3 -I -c '
import json, sys
udid = sys.argv[1]
for rt, devs in json.load(sys.stdin)["devices"].items():
    for d in devs:
        if d["udid"] == udid:
            ver = rt.split(".")[-1].replace("iOS-", "iOS ").replace("-", ".")
            print(d["name"] + "|" + ver + "|" + d["state"])
            sys.exit(0)
sys.exit(1)' "$1"
}

app_version() {  # udid bundle -> "x.y.z (build)"
  local path
  path=$(xcrun simctl get_app_container "$1" "$2" app 2>/dev/null) || { echo "chưa cài"; return; }
  local short build
  short=$(plutil -extract CFBundleShortVersionString raw -o - "$path/Info.plist" 2>/dev/null || echo "?")
  build=$(plutil -extract CFBundleVersion raw -o - "$path/Info.plist" 2>/dev/null || echo "?")
  echo "$short ($build)"
}

case "$cmd" in
  devices)
    echo "== Đang bật =="; xcrun simctl list devices booted | grep -E "\(Booted\)" || echo "(không có)"
    echo "== Sẵn có =="; xcrun simctl list devices available | grep -E "iPhone|iPad|^-- iOS"
    ;;
  boot)
    need "${1:-}"
    udid="$1"
    if ! [[ "$udid" =~ ^[0-9A-F-]{36}$ ]]; then
      udid=$(xcrun simctl list devices available | grep -F "    $1 (" | head -1 | sed -E 's/.*\(([0-9A-F-]{36})\).*/\1/')
      [ -n "$udid" ] || die "không tìm thấy simulator tên '$1'"
    fi
    xcrun simctl boot "$udid" 2>/dev/null || true
    xcrun simctl bootstatus "$udid" -b >/dev/null
    open -a Simulator
    echo "$udid · $(device_line "$udid" | tr '|' ' ')"
    ;;
  install)
    need "${1:-}"; need "${2:-}"
    src="$2"
    if [[ "$src" == *.zip ]]; then
      tmp=$(mktemp -d); unzip -q "$src" -d "$tmp"
      src=$(find "$tmp" -maxdepth 3 -name "*.app" -type d | head -1)
      [ -n "$src" ] || die "file zip không chứa .app"
    fi
    [[ "$src" == *.ipa ]] && die ".ipa là bản cho máy thật, không cài được lên simulator. Xin dev bản build simulator (.app)."
    [ -d "$src" ] || die "không thấy $src"
    xcrun simctl install "$1" "$src"
    bid=$(plutil -extract CFBundleIdentifier raw -o - "$src/Info.plist")
    echo "Đã cài $bid · $(app_version "$1" "$bid")"
    ;;
  info)
    need "${1:-}"; need "${2:-}"
    echo "$2 · $(app_version "$1" "$2")"
    ;;
  env)
    need "${1:-}"
    IFS='|' read -r name ver _state < <(device_line "$1") || die "không thấy thiết bị $1"
    line="$name (Simulator) · $ver · $(xcrun simctl ui "$1" appearance) · cỡ chữ $(xcrun simctl ui "$1" content_size)"
    [ -n "${2:-}" ] && line="$line · Build $(app_version "$1" "$2")"
    echo "$line"
    ;;
  perm)
    need "${1:-}"; need "${2:-}"; need "${3:-}"
    xcrun simctl privacy "$1" "$2" "$3" ${4:+"$4"}
    echo "privacy $2 $3 ${4:-(mọi app)} · xong (app đang chạy có thể bị tắt)"
    ;;
  deeplink)
    need "${1:-}"; need "${2:-}"
    xcrun simctl openurl "$1" "$2"; echo "Đã mở $2"
    ;;
  push)
    need "${1:-}"; need "${2:-}"; need "${3:-}"
    xcrun simctl push "$1" "$2" "$3"
    ;;
  appearance)
    need "${1:-}"; need "${2:-}"
    xcrun simctl ui "$1" appearance "$2"; echo "appearance = $2"
    ;;
  textsize)
    need "${1:-}"; need "${2:-}"
    case "$2" in
      default)  size=large ;;
      largest)  size=accessibility-extra-extra-extra-large ;;
      smallest) size=extra-small ;;
      *)        size="$2" ;;
    esac
    xcrun simctl ui "$1" content_size "$size"; echo "content_size = $size"
    ;;
  location)
    need "${1:-}"; need "${2:-}"
    if [ "$2" = clear ]; then xcrun simctl location "$1" clear; else xcrun simctl location "$1" set "$2"; fi
    echo "location = $2"
    ;;
  statusbar)
    need "${1:-}"; need "${2:-}"
    if [ "$2" = clean ]; then
      xcrun simctl status_bar "$1" override --time "9:41" --dataNetwork wifi --wifiMode active \
        --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
    else
      xcrun simctl status_bar "$1" clear
    fi
    echo "status bar = $2"
    ;;
  clip)
    need "${1:-}"
    xcrun simctl pbcopy "$1"; echo "Đã đưa vào clipboard (không hiển thị nội dung)"
    ;;
  clip-clear)
    need "${1:-}"
    printf '' | xcrun simctl pbcopy "$1"; echo "Đã xoá clipboard"
    ;;
  reset-ui)
    need "${1:-}"
    xcrun simctl ui "$1" appearance light
    xcrun simctl ui "$1" content_size large
    xcrun simctl status_bar "$1" clear
    xcrun simctl location "$1" clear 2>/dev/null || true
    printf '' | xcrun simctl pbcopy "$1"
    echo "Đã trả giao diện về mặc định"
    ;;
  *)
    sed -n '2,22p' "$0"; exit 1
    ;;
esac
