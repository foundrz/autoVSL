#!/usr/bin/env python3
"""Generate VSL video shots via fal.ai API (cheapest: Wan 2.2, NOT Kling)."""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

# Pricing per video-second (fal.ai, March 2026)
MODELS = {
    "wan-480p": {
        "endpoint": "fal-ai/wan/v2.2-a14b/text-to-video",
        "cost_per_sec": 0.04,
        "resolution": "480p",
        "note": "Cheapest on fal.ai — good for drafts",
    },
    "wan-580p": {
        "endpoint": "fal-ai/wan/v2.2-a14b/text-to-video",
        "cost_per_sec": 0.06,
        "resolution": "580p",
        "note": "Balanced quality/cost",
    },
    "wan-720p": {
        "endpoint": "fal-ai/wan/v2.2-a14b/text-to-video",
        "cost_per_sec": 0.08,
        "resolution": "720p",
        "note": "Best Wan quality on fal",
    },
    "kling-turbo": {
        "endpoint": "fal-ai/kling-video/v2.5-turbo/pro/text-to-video",
        "cost_per_sec": 0.07,
        "resolution": "720p",
        "note": "Kling 2.5 Turbo — mid-price, better motion",
    },
}

DEFAULT_MODEL = "wan-480p"
DURATION_SEC = 5  # ~81 frames at 16fps
NUM_FRAMES = 81


def load_env() -> None:
    env_file = Path(__file__).resolve().parent.parent / ".env"
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, _, val = line.partition("=")
                os.environ.setdefault(key.strip(), val.strip())


def estimate_cost(model_key: str, num_shots: int) -> float:
    return MODELS[model_key]["cost_per_sec"] * DURATION_SEC * num_shots


def generate_shot(
    endpoint: str,
    prompt: str,
    negative_prompt: str,
    resolution: str,
    aspect_ratio: str,
) -> str:
    import fal_client

    result = fal_client.subscribe(
        endpoint,
        arguments={
            "prompt": prompt,
            "negative_prompt": negative_prompt,
            "resolution": resolution,
            "aspect_ratio": aspect_ratio,
            "num_frames": NUM_FRAMES,
            "frames_per_second": 16,
            "enable_safety_checker": False,
            "enable_output_safety_checker": False,
        },
        with_logs=True,
    )
    return result["video"]["url"]


def download(url: str, dest: Path) -> None:
    import httpx

    with httpx.Client(follow_redirects=True, timeout=120) as client:
        resp = client.get(url)
        resp.raise_for_status()
        dest.write_bytes(resp.content)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate VSL video shots via fal.ai (Wan = cheapest, not Kling)"
    )
    parser.add_argument("slug", nargs="?", default="fairy-flame")
    parser.add_argument(
        "--model",
        choices=list(MODELS.keys()),
        default=DEFAULT_MODEL,
        help=f"Model preset (default: {DEFAULT_MODEL})",
    )
    parser.add_argument("--shot", type=int, help="Generate only this shot number (for testing)")
    parser.add_argument("--dry-run", action="store_true", help="Show cost estimate, don't generate")
    parser.add_argument("--list-models", action="store_true", help="Show model pricing")
    args = parser.parse_args()

    if args.list_models:
        print("Model pricing (8 shots × 5s each):\n")
        for key, m in MODELS.items():
            total = estimate_cost(key, 8)
            print(f"  {key:14} ${m['cost_per_sec']}/s  → 8 shots ≈ ${total:.2f}  ({m['note']})")
        print("\nFree option: fal.ai signup credits (test 1-3 clips free)")
        print("Truly free: Hailuo website manual tier (~3 clips/day, no API)")
        return 0

    root = Path(__file__).resolve().parent.parent
    shots_file = root / "vsls" / args.slug / "kling-shots.json"
    out_dir = root / "vsls" / args.slug / "media" / "video"
    out_dir.mkdir(parents=True, exist_ok=True)

    if not shots_file.exists():
        print(f"Missing {shots_file}", file=sys.stderr)
        return 1

    with shots_file.open() as f:
        data = json.load(f)

    settings = data["settings"]
    shots = data["shots"]
    if args.shot:
        shots = [s for s in shots if s["id"] == args.shot]
        if not shots:
            print(f"Shot {args.shot} not found", file=sys.stderr)
            return 1

    model = MODELS[args.model]
    cost = estimate_cost(args.model, len(shots))

    print(f"VSL: {args.slug}")
    print(f"Model: {args.model} ({model['note']})")
    print(f"Shots: {len(shots)} × {DURATION_SEC}s = ~${cost:.2f}\n")

    if args.dry_run:
        for s in shots:
            print(f"  shot-{s['id']:02d} → {s['filename']}  ${model['cost_per_sec'] * DURATION_SEC:.2f}")
        print(f"\nTotal: ~${cost:.2f}")
        print("Run without --dry-run to generate (needs FAL_KEY)")
        return 0

    load_env()
    if not os.environ.get("FAL_KEY"):
        print("Set FAL_KEY in .env or environment.", file=sys.stderr)
        print("Get free credits: https://fal.ai/dashboard/keys", file=sys.stderr)
        return 1

    os.environ["FAL_KEY"] = os.environ["FAL_KEY"]  # fal-client reads this

    for shot in shots:
        dest = out_dir / shot["filename"]
        if dest.exists():
            print(f"  shot-{shot['id']:02d} … skip (exists)")
            continue

        print(f"  shot-{shot['id']:02d} … generating", end="", flush=True)
        try:
            url = generate_shot(
                model["endpoint"],
                shot["prompt"],
                settings.get("negative_prompt", ""),
                model["resolution"],
                settings.get("aspect_ratio", "9:16"),
            )
            download(url, dest)
            print(f" → {shot['filename']}")
        except Exception as e:
            print(f" FAILED: {e}", file=sys.stderr)
            return 1

    print(f"\n✓ Done. Files in {out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
