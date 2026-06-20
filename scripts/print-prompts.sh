#!/usr/bin/env bash
# Print all generation prompts for a VSL — copy-paste into Kling, ElevenLabs, Suno
set -euo pipefail

SLUG="${1:-fairy-flame}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VSL_DIR="$ROOT/vsls/$SLUG"

if [[ ! -d "$VSL_DIR" ]]; then
  echo "VSL not found: $VSL_DIR" >&2
  exit 1
fi

echo "═══════════════════════════════════════════════════════════════"
echo "  VSL PROMPTS: $SLUG"
echo "═══════════════════════════════════════════════════════════════"

if [[ -f "$VSL_DIR/kling-shots.json" ]]; then
  echo ""
  echo "── KLING (9:16, 720p, 5–10s each) ──────────────────────────"
  python3 -c "
import json, sys
with open('$VSL_DIR/kling-shots.json') as f:
    data = json.load(f)
neg = data.get('settings', {}).get('negative_prompt', '')
print(f'Negative prompt (all shots): {neg}\n')
for shot in data['shots']:
    print(f\"Shot {shot['id']} → save as {shot['filename']}\")
    print(f\"  {shot['prompt']}\")
    print()
"
fi

if [[ -f "$VSL_DIR/elevenlabs-vo.json" ]]; then
  echo "── ELEVENLABS VO ─────────────────────────────────────────────"
  python3 -c "
import json
with open('$VSL_DIR/elevenlabs-vo.json') as f:
    data = json.load(f)
print(f\"Voice: {data.get('voice', 'Daniel')} (alt: {data.get('voice_alternate', 'Adam')})\")
print('Paste each line as a separate generation:\n')
for line in data['lines']:
    print(f\"{line['id']}. [{line['filename']}] {line['text']}\")
    print()
"
fi

if [[ -f "$VSL_DIR/suno-music.txt" ]]; then
  echo "── SUNO MUSIC ─────────────────────────────────────────────────"
  cat "$VSL_DIR/suno-music.txt"
  echo ""
  echo "  → save as media/music/background.mp3"
fi

echo "═══════════════════════════════════════════════════════════════"
echo "  Drop files into: vsls/$SLUG/media/{video,audio,music}/"
echo "  Then in Cursor: Build the VSL from vsls/$SLUG/timeline.json"
echo "═══════════════════════════════════════════════════════════════"
