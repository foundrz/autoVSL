---
name: image-optimizer
description: Bulk-optimize images for the web — convert PNG/JPG to WebP with clean orientation-based names, quality tuned to the content, responsive srcset width variants, and copy-paste <img> snippets. Use whenever the user drops a folder of images (product shots, ad creative, brand/marketing graphics, screenshots) and wants them "optimized for web", "compressed", "made smaller", or "ready to ship on the site". Runs the fal-free ffmpeg/cwebp pipeline in scripts/optimize-web-images.sh. Non-destructive — originals are never touched.
---

# Image Optimizer — Web Delivery Engine

You turn a folder of heavy source images (typically 2–3 MB AI-generated PNGs) into a
lean, web-ready set: WebP at the right quality, clean URL-safe filenames, responsive
width variants for `srcset`, and paste-ready `<img>` markup. Typical result is an
**85–92% size reduction** with no visible quality loss.

Everything runs on `cwebp` (`brew install webp`), `sips` (macOS built-in), and `ffmpeg`.
The whole mechanical pipeline is one script: `scripts/optimize-web-images.sh`.

## The cardinal rules

1. **Non-destructive.** Never modify or delete the originals. All output goes to a new
   `web-optimized/` subfolder inside the source directory.
2. **Look before you compress.** Inspect the images first (§1) — the content type
   decides the quality setting and whether downscaling is safe. Never guess blind.
3. **Encode responsive variants from the ORIGINAL**, never by re-scaling an already-
   compressed WebP. Stacking lossy passes softens text. The script does this correctly;
   if you ever re-encode by hand, always start from the source PNG/JPG.
4. **Report real numbers.** Always show before/after MB and the per-file table from the
   manifest. Don't claim "optimized" without the savings.

## Workflow

### 1. Inspect (choose quality + naming)
Scan the folder: count, total MB, and per-file size + dimensions.

```bash
DIR="/path/to/images"
find "$DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) \
  | sort | while IFS= read -r f; do
    d=$(sips -g pixelWidth -g pixelHeight "$f" 2>/dev/null | awk '/pixelWidth/{w=$2}/pixelHeight/{h=$2}END{print w"x"h}')
    printf '%6.0fKB  %-11s  %s\n' "$(echo "$(stat -f '%z' "$f")/1024"|bc -l)" "$d" "${f##*/}"
  done
```

Then **look at a few** to judge content. Make 700px thumbnails with `sips -Z 700` and
Read them (view 3–4 representative samples spanning orientations — reliable and cheap).
The ffmpeg `tile` contact-sheet filter tends to flush early and only render the first
row, so prefer viewing individual sample thumbnails over one montage.

What you're deciding:
- **Text-heavy** (marketing infographics, packaging, feature callouts, tiny body copy)
  → **quality 80**, and **do NOT downscale the source** — small text is at its legibility
  floor already. `-sharp_yuv` (on by default in the script) keeps edges crisp.
- **Photographic** (clean product/lifestyle shots, few words) → quality 75 is safe.
- **Logos / flat graphics with hard edges** → quality 82–85, or consider keeping a PNG
  fallback if there's large flat color.

Pick a **name prefix** from the brand/product (e.g. `microflame-3pack`,
`liitt-fairy-flame`). Output files become `<prefix>-{square|portrait|landscape}-NN.webp`,
grouped by orientation because orientation implies use (landscape→hero/banner,
portrait→mobile/story, square→PDP/gallery).

### 2. Run the pipeline
```bash
scripts/optimize-web-images.sh <src-dir> <name-prefix> [quality] [base-url] [--no-responsive]
# e.g.
scripts/optimize-web-images.sh "/Users/me/Downloads/liitt rebrand" liitt-fairy-flame 80 /images/liitt/
```
Produces, inside `<src-dir>/web-optimized/`:
- `<prefix>-{orientation}-NN.webp` — full-size, quality `q`
- `responsive/<name>-{480,768,1200,native}w.webp` — width variants (skips any width ≥
  native so nothing upscales); omit with `--no-responsive`
- `srcset-snippets.html` — a ready `<img srcset sizes width height loading decoding>`
  block per image, with sensible per-orientation `sizes` defaults
- `_manifest.tsv` — new_name → orig_name, dims, and per-file savings

### 3. Verify quality
Read the **most-compressed** output (smallest KB / highest saved %) at full res and
confirm the smallest text is still crisp. If any artifacting on text, bump quality +4
and re-run just that file from the original. Report the before/after table + totals.

### 4. (Optional) push quality lower
If the user wants them even leaner, test one image at a lower q (e.g. q78, q72) and
Read it to show the tradeoff before committing the whole set. Re-encode **from the
original PNG**, not the existing WebP.

## Using the output on the site
- **Plain HTML / separate lander:** paste the blocks from `srcset-snippets.html`; fix the
  base path and write real per-image `alt` text (generic `alt` is only a placeholder).
- **Next.js repo:** you can skip `srcset` entirely — feed the **full-size** q-encoded
  WebP to `next/image`, which generates responsive widths at build time. Use
  `--no-responsive` in that case.
- `width`/`height` are set on every tag to prevent layout shift (CLS) — keep them.

## Also available
`scripts/optimize-images.sh <dir> [quality] [max-width]` — a simpler, recursive variant
that just drops a `.webp` next to every source image in place (no renaming, no responsive
set). Use it for quick one-off batches where clean naming and `srcset` don't matter.

## Requirements
- `cwebp` — `brew install webp` (check with `cwebp -version`)
- `sips` — macOS built-in (dimension reads)
- `ffmpeg` — optional, only for building inspection thumbnails/montages
- No `FAL_KEY`, network, or paid API needed — this is 100% local.
