#!/usr/bin/env bash
# Full web-image optimization pipeline:
#   PNG/JPG  ->  WebP (clean names by orientation)  ->  responsive widths  ->  srcset snippets
# Non-destructive: originals are never touched. Everything lands in <src>/web-optimized/.
#
# Usage:
#   scripts/optimize-web-images.sh <src-dir> <name-prefix> [quality] [base-url] [--no-responsive]
#
#   <src-dir>       Folder of source images (scanned non-recursively). Required.
#   <name-prefix>   Slug for output names, e.g. "microflame-3pack". Required.
#   [quality]       WebP quality 0-100 (default 80). 80 is the sweet spot for
#                   text-heavy marketing graphics; drop to 75 for photos.
#   [base-url]      URL path used in the generated <img> snippets (default /images/).
#   --no-responsive Skip the responsive width variants (full-size webp only).
#
# Output (in <src-dir>/web-optimized/):
#   <prefix>-{square|portrait|landscape}-NN.webp   full-size q<quality>
#   responsive/<name>-{480,768,1200,native}w.webp  responsive variants (unless --no-responsive)
#   srcset-snippets.html                           copy-paste <img srcset> per image
#   _manifest.tsv                                  new_name -> orig_name + sizes
#
# Requires: cwebp (brew install webp), sips (macOS built-in).
set -euo pipefail

SRC="${1:-}"
PREFIX="${2:-}"
QUALITY="${3:-80}"
BASEURL="${4:-/images/}"
RESPONSIVE=1
for a in "$@"; do [[ "$a" == "--no-responsive" ]] && RESPONSIVE=0; done
BASEURL="${BASEURL%/}/"

if [[ -z "$SRC" || ! -d "$SRC" ]]; then
  echo "Usage: $0 <src-dir> <name-prefix> [quality=80] [base-url=/images/] [--no-responsive]" >&2
  exit 1
fi
if [[ -z "$PREFIX" || "$PREFIX" == --* ]]; then
  echo "Error: <name-prefix> is required (e.g. microflame-3pack)." >&2
  exit 1
fi
if ! command -v cwebp >/dev/null 2>&1; then
  echo "cwebp not found. Install with: brew install webp" >&2
  exit 1
fi

OUT="$SRC/web-optimized"
RESP="$OUT/responsive"
MAN="$OUT/_manifest.tsv"
SNIP="$OUT/srcset-snippets.html"
WIDTHS=(480 768 1200)
mkdir -p "$OUT"
[[ "$RESPONSIVE" == 1 ]] && mkdir -p "$RESP"

# cwebp flags: -q quality, -m 6 best compression, -mt multithread,
# -sharp_yuv sharper high-contrast edges (text/logos), -metadata none strips bloat.
CWEBP=(cwebp -quiet -q "$QUALITY" -m 6 -mt -sharp_yuv -metadata none)

echo "Source:     $SRC"
echo "Prefix:     $PREFIX"
echo "Quality:    $QUALITY"
echo "Responsive: $([[ "$RESPONSIVE" == 1 ]] && echo "yes (${WIDTHS[*]} + native)" || echo no)"
echo

printf 'new_name\torig_name\tdims\torig_KB\twebp_KB\tsaved_pct\n' > "$MAN"
sq=0; po=0; la=0

# Convert every png/jpg/jpeg (non-recursive), name by orientation.
while IFS= read -r f; do
  w=$(sips -g pixelWidth  "$f" 2>/dev/null | awk '/pixelWidth/{print $2}')
  h=$(sips -g pixelHeight "$f" 2>/dev/null | awk '/pixelHeight/{print $2}')
  [[ -z "$w" || -z "$h" ]] && { echo "skip (no dims): $f" >&2; continue; }

  if   [ "$w" -gt "$h" ]; then la=$((la+1)); base=$(printf '%s-landscape-%02d' "$PREFIX" "$la")
  elif [ "$h" -gt "$w" ]; then po=$((po+1)); base=$(printf '%s-portrait-%02d'  "$PREFIX" "$po")
  else                        sq=$((sq+1)); base=$(printf '%s-square-%02d'    "$PREFIX" "$sq")
  fi

  "${CWEBP[@]}" "$f" -o "$OUT/$base.webp"
  ob=$(stat -f '%z' "$f"); nb=$(stat -f '%z' "$OUT/$base.webp")
  printf '%s\t%s\t%sx%s\t%.0f\t%.0f\t%d\n' "$base.webp" "${f##*/}" "$w" "$h" \
    "$(echo "$ob/1024"|bc -l)" "$(echo "$nb/1024"|bc -l)" "$(( (ob-nb)*100/ob ))" >> "$MAN"
  printf '  %-42s %5.0fKB -> %4.0fKB  (-%d%%)\n' "$base.webp" \
    "$(echo "$ob/1024"|bc -l)" "$(echo "$nb/1024"|bc -l)" "$(( (ob-nb)*100/ob ))"

  if [[ "$RESPONSIVE" == 1 ]]; then
    for wd in "${WIDTHS[@]}"; do
      [ "$wd" -lt "$w" ] && "${CWEBP[@]}" -resize "$wd" 0 "$f" -o "$RESP/${base}-${wd}w.webp"
    done
    "${CWEBP[@]}" "$f" -o "$RESP/${base}-${w}w.webp"   # native width
  fi
done < <(find "$SRC" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

# Build copy-paste <img srcset> snippets (only when responsive variants exist).
if [[ "$RESPONSIVE" == 1 ]]; then
  {
  echo "<!-- $PREFIX — responsive <img srcset> snippets"
  echo "     Base path: ${BASEURL}  (adjust to your asset path)"
  echo "     'sizes' are sensible defaults — tune to your actual CSS layout. -->"
  echo
  tail -n +2 "$MAN" | while IFS=$'\t' read -r name orig dims _ _ _; do
    base="${name%.webp}"; nw="${dims%x*}"; nh="${dims#*x}"
    case "$base" in
      *landscape*) sizes="(max-width: 1000px) 100vw, 1000px" ;;
      *portrait*)  sizes="(max-width: 640px) 100vw, 512px" ;;
      *)           sizes="(max-width: 768px) 100vw, 600px" ;;
    esac
    srcset=""
    for w in 480 768 1200 "$nw"; do
      [ -f "$RESP/${base}-${w}w.webp" ] && \
        srcset="${srcset}${srcset:+,\n              }${BASEURL}${base}-${w}w.webp ${w}w"
    done
    printf '<img\n  src="%s%s-%sw.webp"\n  srcset="%b"\n  sizes="%s"\n  width="%s" height="%s"\n  loading="lazy" decoding="async"\n  alt="%s">\n\n' \
      "$BASEURL" "$base" "$nw" "$srcset" "$sizes" "$nw" "$nh" "$PREFIX"
  done
  } > "$SNIP"
fi

# Totals.
echo
o=$(find "$SRC" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0 | xargs -0 stat -f '%z' | awk '{s+=$1}END{print s+0}')
n=$(find "$OUT" -maxdepth 1 -type f -iname '*.webp' -print0 | xargs -0 stat -f '%z' | awk '{s+=$1}END{print s+0}')
c=$(find "$OUT" -maxdepth 1 -type f -iname '*.webp' | wc -l | tr -d ' ')
awk -v o="$o" -v n="$n" -v c="$c" 'BEGIN{
  printf "TOTAL: %.1f MB -> %.2f MB  (saved %.1f MB, -%d%%)  across %d images, avg %.0f KB\n",
    o/1048576, n/1048576, (o-n)/1048576, (o-n)*100/o, c, n/c/1024 }'
[[ "$RESPONSIVE" == 1 ]] && echo "Responsive variants: $(find "$RESP" -iname '*.webp' | wc -l | tr -d ' ') files"
echo "Output: $OUT"
