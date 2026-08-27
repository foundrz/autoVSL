#!/usr/bin/env bash
# Bulk web-optimize images: generate a .webp next to every png/jpg/jpeg.
# Non-destructive — originals are never touched.
#
# Usage:
#   scripts/optimize-images.sh <dir> [quality] [max-width]
#
#   <dir>       Folder to scan (recursive). Required.
#   [quality]   WebP quality 0-100 (default 82). Higher = bigger/sharper.
#   [max-width] Downscale so width <= N px before encoding (default 0 = no resize).
#
# Examples:
#   scripts/optimize-images.sh ./incoming
#   scripts/optimize-images.sh ./incoming 80 2000
#
# Re-running is cheap: a .webp that is newer than its source is skipped.
set -euo pipefail

SRC="${1:-}"
QUALITY="${2:-82}"
MAXW="${3:-0}"

if [[ -z "$SRC" || ! -d "$SRC" ]]; then
  echo "Usage: $0 <dir> [quality=82] [max-width=0]" >&2
  echo "  <dir> must be an existing directory." >&2
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "cwebp not found. Install with: brew install webp" >&2
  exit 1
fi

JOBS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

echo "Scanning:   $SRC"
echo "Quality:    $QUALITY"
echo "Max width:  $([[ "$MAXW" == 0 ]] && echo 'none' || echo "${MAXW}px")"
echo "Parallel:   $JOBS jobs"
echo

# Worker: encode one file to .webp beside it. Skips if up to date.
# Args: <src-file> <quality> <max-width>
convert_one() {
  local src="$1" q="$2" maxw="$3"
  local out="${src%.*}.webp"

  # Skip if a fresh .webp already exists (newer than source).
  if [[ -f "$out" && "$out" -nt "$src" ]]; then
    printf 'skip  %s\n' "$out"
    return 0
  fi

  local resize=()
  [[ "$maxw" != 0 ]] && resize=(-resize "$maxw" 0)

  # -m 6 best compression, -mt multithread, -metadata none strips EXIF/ICC bloat.
  # -q applies to both lossy RGB and alpha; cwebp auto-preserves transparency.
  if cwebp -quiet -q "$q" -m 6 -mt -metadata none "${resize[@]}" "$src" -o "$out" 2>/dev/null; then
    local before after
    before=$(stat -f '%z' "$src")
    after=$(stat -f '%z' "$out")
    awk -v b="$before" -v a="$after" -v f="$out" \
      'BEGIN { printf "ok    %-55s %6.1fKB -> %6.1fKB  (-%d%%)\n", f, b/1024, a/1024, (b-a)*100/b }'
  else
    printf 'FAIL  %s\n' "$src" >&2
    return 1
  fi
}
export -f convert_one

# Find all raster sources (skip already-generated webp) and fan out.
find "$SRC" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0 \
  | xargs -0 -P "$JOBS" -I{} bash -c 'convert_one "$@"' _ {} "$QUALITY" "$MAXW"

echo
# Totals: sum source bytes vs generated webp bytes.
find "$SRC" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0 \
  | xargs -0 stat -f '%z %N' 2>/dev/null \
  | awk '
    { src_total += $1
      out = $2; sub(/\.[^.]+$/, ".webp", out)
      ("test -f \"" out "\" && stat -f %z \"" out "\"" ) | getline os
      close("test -f \"" out "\" && stat -f %z \"" out "\"")
      out_total += os + 0
    }
    END {
      printf "TOTAL: %.1f MB source  ->  %.1f MB webp  (saved %.1f MB, -%d%%)\n",
        src_total/1048576, out_total/1048576,
        (src_total-out_total)/1048576, (src_total-out_total)*100/src_total
    }'
