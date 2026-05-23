#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
index_file="$repo_root/resources-index.md"

start_marker="<!-- index:start -->"
end_marker="<!-- index:end -->"
max_files_per_dir="${RESOURCES_INDEX_MAX_FILES_PER_DIR:-100}"

title_from_name() {
  local name="$1"

  name="${name%.md}"
  printf '%s\n' "$name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g'
}

load_tracked_dirs() {
  awk '
    /^!\/[^/*][^*]*\/$/ {
      dir = $0
      sub(/^!\//, "", dir)
      sub(/\/$/, "", dir)
      print dir
    }
  ' "$repo_root/.gitignore"
}

is_git_ignored() {
  local path="$1"

  git -C "$repo_root" check-ignore -q -- "$path"
}

print_indent() {
  local depth="$1"
  local i

  for ((i = 0; i < depth; i++)); do
    printf '  '
  done
}

has_markdown() {
  local dir="$1"

  [[ -n "$(find "$dir" -type f -name '*.md' -print -quit)" ]]
}

count_markdown() {
  local dir="$1"
  local file
  local rel
  local count=0

  while IFS= read -r file; do
    rel="${file#"$repo_root/"}"
    if ! is_git_ignored "$rel"; then
      count="$((count + 1))"
    fi
  done < <(find "$dir" -type f -name '*.md')

  printf '%s\n' "$count"
}

count_direct_markdown() {
  local dir="$1"
  local file
  local rel
  local count=0

  while IFS= read -r file; do
    rel="${file#"$repo_root/"}"
    if ! is_git_ignored "$rel"; then
      count="$((count + 1))"
    fi
  done < <(find "$dir" -maxdepth 1 -type f -name '*.md')

  printf '%s\n' "$count"
}

append_file() {
  local file="$1"
  local depth="$2"
  local rel="${file#"$repo_root/"}"
  local name

  if is_git_ignored "$rel"; then
    return
  fi

  name="$(title_from_name "$(basename "$file")")"

  print_indent "$depth"
  printf -- '- [%s](%s)\n' "$name" "$rel"
}

append_dir() {
  local dir="$1"
  local depth="$2"
  local rel="${dir#"$repo_root/"}"
  local name
  local total
  name="$(title_from_name "$(basename "$dir")")"
  total="$(count_markdown "$dir" | tr -d ' ')"

  print_indent "$depth"
  printf -- '- **[%s/](%s/)** (%s md)\n' "$name" "$rel" "$total"
  append_tree "$dir" "$((depth + 1))"
}

append_tree() {
  local base="$1"
  local depth="$2"
  local entry
  local direct_count
  local printed_files=0

  direct_count="$(count_direct_markdown "$base" | tr -d ' ')"

  while IFS= read -r entry; do
    if [[ -d "$entry" ]]; then
      if ! has_markdown "$entry"; then
        continue
      fi
      append_dir "$entry" "$depth"
    else
      if ((printed_files >= max_files_per_dir)); then
        continue
      fi
      append_file "$entry" "$depth"
      printed_files="$((printed_files + 1))"
    fi
  done < <(
    find "$base" -mindepth 1 -maxdepth 1 \
      ! -name 'README.md' \
      ! -name 'resources-index.md' \
      \( -type d -o \( -type f -name '*.md' \) \) \
      | sort
  )

  if ((direct_count > max_files_per_dir)); then
    print_indent "$depth"
    printf -- '- ... %s more md files hidden in this folder\n' "$((direct_count - max_files_per_dir))"
  fi
}

append_tracked_dirs() {
  local dir

  while IFS= read -r dir; do
    if [[ -d "$repo_root/$dir" ]] && has_markdown "$repo_root/$dir"; then
      append_dir "$repo_root/$dir" 0
    fi
  done < <(load_tracked_dirs)
}

new_index="$(mktemp)"
{
  printf '%s\n' "$start_marker"
  append_tracked_dirs
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
