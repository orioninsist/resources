#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
index_file="$repo_root/resources-index.md"

start_marker="<!-- index:start -->"
end_marker="<!-- index:end -->"

title_from_name() {
  local name="$1"

  name="${name%.md}"
  printf '%s\n' "$name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g'
}

print_indent() {
  local depth="$1"
  local i

  for ((i = 0; i < depth; i++)); do
    printf '  '
  done
}

append_file() {
  local file="$1"
  local depth="$2"
  local rel="${file#"$repo_root/"}"
  local name
  name="$(title_from_name "$(basename "$file")")"

  print_indent "$depth"
  printf -- '- [%s](%s)\n' "$name" "$rel"
}

append_dir() {
  local dir="$1"
  local depth="$2"
  local rel="${dir#"$repo_root/"}"
  local name
  name="$(title_from_name "$(basename "$dir")")"

  print_indent "$depth"
  printf -- '- **%s/**\n' "$name"
  append_tree "$dir" "$((depth + 1))"
}

append_tree() {
  local base="$1"
  local depth="$2"
  local entry

  while IFS= read -r entry; do
    if [[ -d "$entry" ]]; then
      append_dir "$entry" "$depth"
    else
      append_file "$entry" "$depth"
    fi
  done < <(
    find "$base" -mindepth 1 -maxdepth 1 \
      ! -name '.git' \
      ! -name 'README.md' \
      ! -name 'resources-index.md' \
      \( -type d -o \( -type f -name '*.md' \) \) \
      | sort
  )
}

new_index="$(mktemp)"
{
  printf '%s\n' "$start_marker"
  append_tree "$repo_root" 0
  printf '%s\n' "$end_marker"
} > "$new_index"

tmp="$(mktemp)"
awk -v start="$start_marker" -v end="$end_marker" -v block_file="$new_index" '
  $0 == start {
    while ((getline line < block_file) > 0) {
      print line
    }
    close(block_file)
    in_block = 1
    next
  }
  $0 == end {
    in_block = 0
    next
  }
  !in_block {
    print
  }
' "$index_file" > "$tmp"

if cmp -s "$index_file" "$tmp"; then
  rm "$tmp" "$new_index"
  printf 'Sonuc: degisiklik yok. resources-index.md zaten guncel.\n'
  exit 0
fi

mv "$tmp" "$index_file"
rm "$new_index"
printf 'Sonuc: resources-index.md guncellendi.\n'
