#!/usr/bin/env bash
# Generate video shots via fal.ai API (cheapest model, not Kling)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$ROOT/.venv"

if [[ ! -d "$VENV" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q -r "$ROOT/requirements.txt"
fi

exec "$VENV/bin/python" "$ROOT/scripts/generate-video.py" "$@"
