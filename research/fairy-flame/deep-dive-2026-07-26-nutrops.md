# Deep-Dive — Nütrops (Grüns) Competitor Ad Census
**Date:** 2026-07-26 · **Mode:** 3 (Winning-Ad Hunt) · **Analyst:** prospector

> **⚠️ ADDENDUM (same day, deeper pull):** the finding in §5 Winner #1 below was
> made from a 60-ad sample. A full-library pull (265 ad-archive entries, ~the
> entire active account) revealed the real mechanism is bigger and different
> in kind than "one silent montage wins." See **§9 — Addendum: The Real #1
> Winner** at the end of this report. §5's original writeup is left intact
> below for the record, but §9 supersedes it as the actionable finding.

**Target:** Facebook Page "Nütrops" (page id `484441681425692`), a Grüns sub-brand.
**Source:** Meta Ad Library, sorted by total impressions desc, US, active ads.
Scraped via `apify/facebook-ads-scraper` (60 ad-archive entries, per-ad details +
About-page data enabled). Raw data: `research/raw/fb-adlibrary-484441681425692-2026-07-26.json`,
parsed concepts: `research/raw/nutrops-concepts-parsed.json`, downloaded video
creative + Whisper transcripts: `research/raw/nutrops-videos/`.

---

## 1. Executive read

- **Nütrops** ("nootropic mushroom gummies," 10:1 concentration, six mushrooms:
  Lion's Mane, Cordyceps, Reishi, Maitake, Chaga + one more) launched its ad
  account 2026-06-04 and is running hard — 60 sampled ad-archive entries collapse
  into **33 distinct creative concepts**, all still active, all US-only (no
  spend/reach visible — confirms longevity + scaling IS the winner signal here,
  per playbook).
- **Biggest single finding:** their #1 most-scaled creative is a **silent,
  no-voiceover, no-spokesperson before/after meme montage** — the cheapest
  possible ad to produce in this entire category, and it's their clear winner
  by variant-count (13 of 60 sampled entries, running unbroken 52+ days).
- **Direct language/mechanism overlap with our own bank**: "running on empty,"
  "feel like myself again," and the push-vs-refill framing all appear
  independently in Nütrops creative — strong external validation of angles we
  already built (Fairy Flame Scripts 01, 02, 03).
- **Two white-space avatars** Nütrops is expanding into that we have zero
  coverage of: a **weight-loss/fitness energy-seeker** (Cordyceps-for-workouts)
  and a **younger ADHD-adjacent consistency-seeker** (male UGC talent, newest
  test in the account — started 10 days before this scrape).
- **Recommended first tests**: (1) clone the silent before/after format at near-zero
  production cost using our existing b-roll bank + avatar language, (2) treat the
  "running on empty" / "feel like myself" overlap as confirmation to keep pushing
  Scripts 01/02/03 rather than second-guessing them, (3) scope a cheap test into
  the weight-loss-energy white space before Nütrops fully proves it out.

## 2. Awareness & sophistication diagnosis

Nütrops is operating at **awareness level 2-4 depending on the specific
creative** (mixed intentionally — the account runs top-of-funnel education
alongside mid-funnel testimonial/mechanism content simultaneously) and
**sophistication stage 3-5**. The market is sophisticated enough that Nütrops
never claims to be first — instead it wins on **mechanism specificity**
(named ingredients, numeric potency comparisons — "10:1 concentration," "5x more
than the leading mushroom coffee") and **format novelty** (silent meme montages,
UGC-authentic testimonials) rather than a new claim. This matches our own Ryze-style
scripts' approach (Scripts 02/05/08/09) — same stage, same "disqualify conventional
solutions before introducing yours" structure.

## 3. Ad census — by scaling signal

| Rank | Concept | Ad-archive count | Earliest seen | Format |
|---|---|---|---|---|
| 1 | "Powerful Mushroom Formula" / silent before-after montage | **13** | 2026-06-04 | silent, no talent |
| 2 | "Elevate Your Mind and Body" / full ingredient claim | 4 | 2026-06-04 | static/carousel |
| 3 | "Save up to 52% off" / carbs-gym-belly cortisol | 3 | 2026-06-12 | static |
| 4-8 | (5 concepts, 2 archives each) | 2 | 2026-06-04 to 06-12 | mixed video/static |
| 9-33 | (25 concepts) | 1 each | 2026-06-04 to 07-16 | mixed — the live test queue |

33 distinct concepts total. The long tail of 1-instance concepts (25 of 33) is
the account's **active test queue** — Nütrops is constantly feeding new hooks
against the same core mechanisms and killing what doesn't scale to a 2nd+ instance.

## 4. Avatar map (ranked by ad volume + earliest investment)

1. **Burned-out mom / mid-40s woman, cognitive-load avatar** (dominant, ~60% of
   creative volume) — brain fog, forgetting things in front of kids, 3pm crash,
   "running on empty," wants to "feel like myself." **Direct 1:1 overlap with our
   own `burned-out-mom.md` avatar.**
2. **Perimenopause-specific woman, 45-55** — explicit hormone-fog-mood-energy
   cluster ("Plant-based brain support for hormone-fueled chaos," "Perimenopause
   might be behind the brain fog..."). Overlaps our nurse-avatar scripts (07-09)
   but names the life-stage directly rather than implying it through a nurse
   narrator.
3. **Appearance-anxiety woman** (hair thinning, visceral belly fat) — same core
   mom/woman avatar, but entered through a physical/visible symptom rather than
   a cognitive one. **New pain-point angle** we don't currently use (see pp-0003).
4. **Weight-loss/fitness energy-seeker** — gym-going, diet-conscious, gender-open.
   **Entirely new avatar**, zero overlap with current Fairy Flame bank.
5. **ADHD-adjacent young male, consistency-seeker** — newest test in the account
   (started 2026-07-16, 10 days old at scrape time = live signal, not yet proven).
   **Entirely new avatar and the youngest cohort found.**

## 5. Top winning ads — full teardowns

### Winner #1 — Silent Before/After Meme Montage (an-0011 / hk-0023)
**The single most-scaled asset in the account.** No spokesperson, no voiceover,
no lip-sync, no script. Structure:
1. **Before beat 1:** on-screen text "Me: Before having mushrooms daily" over
   b-roll of a woman scrolling her phone in bed, unmade sheets
2. **Before beat 2:** "Bloated" over a torso/waistband touch shot
3. **After beat 1:** "Actually getting things done" over making-the-bed b-roll
4. **After beat 2:** "Aerobic endurance supported" over a gym dumbbell set
5. **Close:** starfield end-card, "Prioritize Your Mind, Every Day / Get Started
   with Nütrops / nutrops.co," product pouch hero shot
- **Why it wins:** kinetic on-screen text carries 100% of the persuasion; the
  footage only needs to loosely match the caption, so it's infinitely cheap to
  reshoot/relocalize/re-caption. Zero avatar, VO, or lip-sync spend — the
  opposite end of the cost spectrum from our current founder/nurse VSL pipeline.
- **Steal the structure, not the footage:** this maps directly onto our existing
  b-roll bank tags (`pain_mirror`/`before_state` → `transformation`/`after_state`)
  with zero new production. See recommendation in §7.

### Winner #2 — "Are You Running on Empty?" / Caffeine-Crash Cluster (an-0015)
Two sibling UGC talking-head ads, verbatim:
> "It wasn't more caffeine that I needed. It was a better routine... it's not
> like my life suddenly got less chaotic. My kitchen still gets messy. My
> to-do list is still way too long. But I don't feel like I'm fighting my own
> brain. I feel more focused and honestly, more like myself."

**This is close to word-for-word our own core phrase and Script 02's mechanism**
("push vs. refill the tank," "feel like myself again"). Independent proof the
angle converts in this exact category — treat this as validation, not
coincidence, and don't dilute Scripts 01/02/03 chasing novelty.

### Winner #3 — Cortisol-Made-Visible: Hair Loss (an-0013 / hk-0025)
70-second UGC testimonial, full verbatim transcript captured. Beat structure
(mapped to Kell VSL framework):
- **Hook (pain, visible):** "I started noticing more hairs in the shower first,
  and then on my brush, and then kind of everywhere."
- **Failed solutions (disqualify):** switched shampoos twice, tried biotin,
  scalp massages — all surface-level fixes.
- **Root-cause reveal:** "someone told me stress actually leads to hair loss...
  I was trying to fix something on the outside that was being caused on the
  inside."
- **Mechanism (named ingredient, hedged claim):** Reishi "supporting the body's
  natural response to occasional stress" — explicitly NOT marketed as a hair
  product. This compliance hedge (claim stays on stress-support, never on
  hair-regrowth) is a disciplined pattern worth matching if we ever test a
  visible-symptom angle.
- **Ease/format close:** "daily gummy, no prep, no brewing, no pills," tastes
  like lemon "which came as a pleasant surprise."
- **Reframe CTA:** "your hair is typically one of the last things to show
  stress... if you're wondering why is my hair falling out, I'd start looking
  at what's going on inside."

### Winner #4 — Mom Comparison-Anchored Testimonial (an-0014 / hk-0027)
Longest-form creative found (106 seconds) — likely a top-of-funnel trust asset
that feeds the shorter scaled cutdowns. Opens on an identity-threat detail
("the kids were literally making me feel really bad about myself" re:
forgetting things), names all five ingredients, and anchors superiority with a
**specific numeric comparison** against a category leader she'd already used:
"5x more nutrients than the leading mushroom coffee... 3x more than the
leading gummy." Closes on unprompted social proof from her kids. Near-identical
emotional arc to our own Scripts 01 and 03.

### Winner #5 — Weight-Loss Energy Bridge (an-0012 / hk-0024) — early-stage test
Not yet scaled (1 instance), but flagged because it's the clearest white-space
signal in the account: "The most frustrating part of my weight-loss journey
wasn't hunger. It was the exhaustion... That's why I started paying more
attention to ingredients that support energy. Like Cordyceps." Full FDA
disclaimer on screen throughout. A gym/diet avatar we have zero current coverage
of.

## 6. Angle map — proven vs. testing vs. white space

**Proven (scaled to 2+ instances, running 3+ weeks):**
- Silent before/after montage (an-0011) — #1 by far
- Cognitive-load education carousel ("82% of Americans affected by brain health")
- Cortisol → visible symptom (hair, belly) cluster (an-0013) — 3 sibling angles
- "Feel like myself" / running-on-empty identity reset (an-0015)

**Actively testing (1 instance, recent starts — the live queue):**
- Weight-loss energy bridge (an-0012) — 2026-06-22
- ADHD-adjacent consistency (an-0016) — 2026-07-16, freshest in the account
- Perimenopause-named hormone angle — 2026-06-19
- 401(k)/compound-interest metaphor for brain health — 2026-06-10

**White space for Fairy Flame** (angles Nütrops hasn't touched, or where our
avatar has language they don't use):
- Nütrops never uses "3am wake-ups" / evening-wine framing — our sober-ritual
  and wine-isn't-calming angles (Scripts 05, our sober-ritual-seeker avatar)
  have zero competitive pressure here.
- Nütrops has no founder-transparency/lab-report angle at all (our Script 10)
  — pure DTC-brand voice, no visible founder.
- Nütrops has no "husband/partner notices the change" angle distinct from
  "kids notice" — our Script 03 territory is unclaimed by them specifically.

## 7. Recommendations — what to model

1. **Build the silent before/after montage as a Fairy Flame test, immediately.**
   This is the highest-leverage finding in the whole census: it's their proven
   #1 winner AND it is nearly free to produce from assets we already have.
   Draft edit plan: `Before: snapping over nothing` (b-roll: mom exhaling,
   hand on forehead) → `Before: fog by 10am` (desk/coffee b-roll — we already
   have `br-0001` fog-at-desk in the bank) → `After: singing again` (kitchen
   b-roll) → `After: patience back` (calm-with-kids b-roll) → end-card with
   pouch + "60-day guarantee" + link. Zero avatar/VO/lip-sync spend — the
   cheapest test we've ever run.
2. **Don't touch Scripts 01/02/03 defensively.** The independent "feel like
   myself" / "running on empty" convergence is confirmation, not a signal to
   differentiate away from it.
3. **Scope one cheap test into the weight-loss-energy white space** before
   Nütrops fully proves it out and the CPMs there get competitive — same
   product, new bridge: "the reset that gives you energy back for the gym,
   not just the morning."
4. **Steal the hair-loss compliance hedge** (claim stays on "stress response,"
   never on the visible symptom directly) as a template if we test any
   appearance-anxiety angle later.
5. Hold off on the ADHD-adjacent/younger-male avatar — it's a 10-day-old test
   with a single instance, not proven yet. Worth a Mode 4 re-check in 2-3 weeks.

## 8. Bank delta (this run)

- **Angles:** an-0011 through an-0016 (6 new entries) — `banks/angles.jsonl`
- **Hooks:** hk-0023 through hk-0030 (8 new entries) — `banks/hooks.jsonl`
- **Pain points:** pp-0001 through pp-0004 (4 new entries, first entries in a
  previously-empty bank) — `banks/pain-points.jsonl`
- **New avatars flagged, not yet formalized as avatar files:**
  `weight-loss-energy-seeker`, `adhd-consistency-seeker` — recommend a
  Mode 1-style avatar file only if we commit to testing either.
- **Raw scrape data preserved:** `research/raw/fb-adlibrary-484441681425692-2026-07-26.json`
  (full 60-entry census), `research/raw/nutrops-concepts-parsed.json` (33
  deduplicated concepts), `research/raw/nutrops-videos/` (6 downloaded ad
  videos + `transcripts.json`).

---

## 9. Addendum — The Real #1 Winner (full-library pull, same day)

The user asked for a deeper pull to see every variant of Winner #1. Re-scraped
the account at `resultsLimit: 300`, capturing **265 ad-archive entries** — the
account's full active library (up from the initial 60-ad sample). Re-running
the concept clustering on the complete set surfaced something more important
than a bigger count.

### The correction

Winner #1's exact card — title **"Nütrops: Powerful Mushroom Formula"**, body
**"How to get your focus back, naturally"** — isn't running in 13 ads. It's
running in **57 distinct ad-archive entries** (28 still active today), in
**14+ separate creative-refresh batches** launched roughly every 3-7 days,
continuously, from **2026-06-04 through 2026-07-16** — over seven straight
weeks.

But durations across those 14 batches range from **14 to 91 seconds**, which
was the tell that something was off with the original read. Pulling frames
from each confirmed it: **the footage is completely different in every
batch.** The silent before/after montage (§5 Winner #1) is real, and it's
one of the executions — but it is not "the winner." It's one of at least
**ten unrelated creative formats**, all carrying the identical locked
headline and body text:

| Format | What's in frame |
|---|---|
| Silent before/after meme montage | doomscrolling → bloated → making the bed → gym set |
| Lifestyle mom-in-kitchen | "Welcome to afternoons," striped dress, kitchen |
| Physician/urologist reply | on-camera doctor answering a comment: "what are your thoughts on mushroom supplements?" |
| POV car-selfie | "Investing in your brain, mood and energy every day," pouch in hand |
| Wordplay text-overlay | "Don't Forget To Feed Your [brain]," product held to camera |
| Influencer collab/event | "Brand alert 🚨 — 16 days away from the event" |
| Casual demo | "ask me how i stay [sharp]," eating a gummy direct to camera |
| Cartoon-mascot crossover | a skincare-brand mascot animation repurposed with Nütrops overlay |
| Ingredient-read testimonial | creator reading the six mushrooms off the bag: "I don't even know how to say" |
| Fitness selfie | "look right now," gym-clothed torso |
| **Fibromyalgia-flare testimonial** | "This is the one thing that's honestly helping me stay productive during a fibromyalgia flare" — names a real diagnosed condition on screen |
| Outdoor lifestyle | waterfall/hot-spring scene, kinetic word-by-word caption |

(full per-batch archive IDs, dates, and video URLs: `research/raw/nutrops-winner-archives.json`;
downloaded sample videos: `research/raw/nutrops-videos/winner-timeline/`)

### What this actually means

**The proven asset is the headline/body pair, not any piece of footage.**
Nütrops locks one winning copy line and runs it through Meta's Dynamic
Creative Optimization against a continuously refreshed portfolio of UGC
creators, influencer whitelisting, doctor-authority replies, repurposed
organic content, and zero-cost silent montages — DCO auto-serves whichever
execution performs best per placement/user, and the account keeps feeding it
fresh footage weekly rather than fatiguing on one asset.

This is a materially different, and more valuable, finding than "clone the
silent montage." It means:

1. **The copy itself is the thing to steal**, not a shot list. "How to get
   your focus back, naturally" (or our own equivalent — likely
   "feel like yourself again" / "get your mornings back") is the asset worth
   locking and testing across *many* cheap, disposable executions, not
   perfecting once.
2. **Format diversity is the strategy, not a side effect.** Rather than one
   polished VSL per script, the higher-leverage move is many inexpensive
   variants (silent b-roll cuts, a founder POV clip, a nurse "replying to a
   comment" bit, a plain ingredient-read) all pointed at the same locked hook
   line, refreshed weekly.
3. **One format is genuinely free** (the silent montage — still worth
   building first, per §7's original recommendation) and several others are
   near-free (a phone selfie reading the lab report, a UGC creator eating a
   gummy on camera) — this expands, not replaces, the original "build the
   silent montage" recommendation.
4. **Flag, don't imitate:** the fibromyalgia-flare execution is their
   riskiest asset — naming a real diagnosed condition on screen. Do not
   model this one; every Fairy Flame parallel should stay on
   observable-behavior language, never a named diagnosis.

### Bank update
`an-0011` in `banks/angles.jsonl` has been rewritten in place to capture this
corrected finding (old text preserved in git history / superseded, not
duplicated). No new hook entries needed — `hk-0023` (the silent montage) is
still valid as one execution of this angle.
