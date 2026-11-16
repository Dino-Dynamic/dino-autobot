#!/usr/bin/env bash
# Liên kết mọi skill trong skills/ vào ~/.claude/skills. Skill trùng tên mà không phải link tới repo này
# thì bỏ qua và báo, không ghi đè.
set -euo pipefail
repo="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$dest"
for dir in "$repo"/skills/*/; do
  name="$(basename "$dir")"
  target="$dest/$name"
  if [ -L "$target" ]; then
    ln -sfn "${dir%/}" "$target"; echo "cập nhật  $name -> ${dir%/}"
  elif [ -e "$target" ]; then
    echo "bỏ qua    $name (đã có thư mục cùng tên ở $target, không phải link)"
  else
    ln -s "${dir%/}" "$target"; echo "đã cài    $name -> ${dir%/}"
  fi
done
