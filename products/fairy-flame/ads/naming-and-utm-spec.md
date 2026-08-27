# Fairy Flame — Ad Naming + UTM Spec

The system that makes by-hand launches and future API launches use the **same
structure**, and makes Triple Whale (TW) attribution work. TW ties revenue to
`utm_content`, so **ad name === utm_content** is the golden rule.

**Landing page (destination / Website URL field):** `https://getliitt.com/lp/`

---

## 1. Naming taxonomy

Meta allows letters, numbers, `_`, `-`. No spaces. Keep segments in fixed order
so they're parseable by script later.

### Campaign
`{brand}_{objective}_{funnel}_{yyyy-mm}_{version}`
- **FF**_PUR_TOF_2026-07_v1  → Fairy Flame · Purchase · Top-of-funnel · Jul 2026 · v1

### Ad Set
`{anglefamily}_{audience}`
- angle families: `STORY` (identity/mom), `NURSE` (education), `FOUNDER` (trust)
- **NURSE**_BROAD-W35-60  → nurse angle · broad women 35–60

### Ad (this string is also utm_content)
`{vsl}_{creative}_{PT}_{HL}`
- **vsl** = script id (VSL02, VSL08…)
- **creative** = source tag (UGC-car, AVATAR, FOUNDER-vid)
- **PT / HL** = copy-bank ids from `batch-01-copy-bank.md`
- example: `VSL02_UGC-car_PT02_H15`

Because copy-bank ids are baked into the ad name, a winning ad in TW points
straight back to the exact video + primary text + headline. No lookup needed.

---

## 2. UTM parameters (Triple Whale — official template)

Triple Whale's own recommended string. Paste **once** in Meta's **"URL parameters"**
field (Ad level → Tracking → URL parameters) — NOT the Website URL box. Identical
on every ad. TW uses **IDs**, not names: the Triple Pixel resolves `adset.id` /
`ad.id` back to names + creatives through your connected Meta integration, which is
why it's simpler than a name-based scheme.

```
utm_medium=cpc&utm_source=facebook&utm_campaign={{campaign.name}}&utm_content={{adset.id}}&utm_term={{ad.id}}
```

- `utm_medium=cpc`, `utm_source=facebook` → static, exactly as TW specifies
- `utm_content={{adset.id}}` → ad set ID (TW's ad-set attribution key)
- `utm_term={{ad.id}}` → ad ID (TW's ad/creative attribution key)
- tokens are Meta dynamic params; the `{{ }}` format is required, case-sensitive
- append after an `&` if you already have UTMs on the URL

Our naming taxonomy (§1) still matters — it's how the ads read inside Meta and TW's
dashboards — but attribution runs on IDs, so the UTM string never changes per ad.

### Verify before scaling spend
1. TW → confirm Triple Pixel is installed on getliitt.com AND survives the age-gate
   (the `/lp/` gateway must pass the query string through to post-enter pages, or
   attribution dies at the gate — test one real click).
2. Confirm the Meta ad account is connected in TW (this is what maps IDs → names).
3. Fire one test click; check it lands in TW's UTM view resolved to the right ad.

> ⚠️ Age-gate risk: if clicking "Enter" navigates without preserving the query
> string, UTMs are lost. Either pass params through on Enter, or point ads at the
> post-gate URL directly. Test this first — it's the #1 way DTC attribution breaks.

---

## 3. Future API mapping (Meta Marketing API)

The taxonomy maps 1:1 to API objects, so `launch-tracker.csv` becomes the payload:
- campaign_name → `AdCampaign.name`
- adset_name → `AdSet.name`
- ad_name → `Ad.name`
- destination_url → creative `link_data.link`
- utm string → creative `url_tags`
- video_file → uploaded `AdVideo`, id back-filled into `meta_video_id`

Keep `launch-tracker.csv` as the single source of truth. By hand now: read a row,
build the ad, paste the id back into `meta_ad_id`. By API later: iterate the rows.
