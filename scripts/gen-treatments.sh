#!/bin/bash
# Generate 16 treatment detail pages from a single template.
set -euo pipefail

OUT_DIR="/Users/matijaskarabot/Desktop/Hypodermical/pages/treatments"
mkdir -p "$OUT_DIR"

# slug|category|name|tagline|image_id|concern_paragraph|stat1|stat2|stat3|protocols|markers|next_slug|next_name
TREATMENTS=(
  "anti-aging|Face|Anti-Aging & Lifting|Firmer, visibly lifted skin — without a needle in sight.|photo-1616394584738-fc6e612e71b9|Loss of volume, skin laxity, fine lines and wrinkles — these aren't surface problems, they're biological ones. Cellular senescence, ECM degradation, and hormonal shifts all show up on the face. The Hypodermical anti-aging pathway addresses each of these layers in sequence, with measurable improvement from the first session.|14 Protocols|From Session 1|0 Needles|Way Antiage · Way Lifting · Way VIP · HF Anti-Ageing Lifting · Age Lift|4 · 7 · 14 · 16|acne|Acne &amp; Impurities"
  "acne|Face|Acne &amp; Impurities|Clearer complexion. Calmer skin. From session two.|photo-1556228720-195a672e8a03|Acne isn't just about excess sebum — it's an inflammatory cascade involving altered microbiota, immune activation, and barrier disruption. The HY.Acne protocol reads these markers and treats them in coordination, not in isolation.|3 Protocols|Visible from week 2|Non-invasive|Deep Cleansing Acne · Way Acne · HY.Acne · HF Anti-Inflammatory|9 · 10 · 12|dark-spots|Dark Spots"
  "dark-spots|Face|Dark Spots &amp; Pigmentation|Even tone. Brighter complexion. Slow-built, lasting.|photo-1512290923902-8a9f81dc236c|Pigmentation is driven by epigenetic alteration of melanocyte signalling — sun damage, hormones, and inflammatory triggers all play a role. The HY.Spots protocol addresses the underlying signalling without aggressive bleaching agents.|2 Protocols|6-week programme|100% Natural|Way Spots · HY.Spots · Pearl White Mesococktail|3|sensitive|Sensitive Skin"
  "sensitive|Face|Sensitive Skin|Soothe. Strengthen. Restore the barrier.|photo-1570172619644-dfd03ed5d881|Reactive skin lives with a compromised barrier and an over-active immune response. Most treatments make this worse. The Hypodermical sensitive pathway calms the response while rebuilding the barrier — without provoking.|2 Protocols|Hypoallergenic|0 Stripping agents|Way Sensitive · Calm Code · Delicate Cleansing · HF Sensitive Anti-Ageing|11 · 13|eye-zone|Eye Zone"
  "eye-zone|Face|Eye Zone|Reduce fine lines, puffiness, and shadow. Periorbital, precisely.|photo-1499781350541-7783f6c6a0c8|The skin around the eye is thinner, more vascular, and ages on a faster clock. It needs its own protocol — not a face protocol scaled down.|1 Protocol|Periorbital-specific|Lymphatic|Way Eyezone · Illumineye · Eye Zone Mesococktail|4 · 15|hydration|Deep Hydration"
  "hydration|Face|Deep Hydration|Plump skin from cellular hydration — not surface gloss.|photo-1576091160399-112ba8d25d1d|Surface hydration is cosmetic. Cellular hydration is biological. The Hydra-Reset Code protocol restores aquaporin signalling and barrier lipid synthesis, so the skin holds its own water again.|2 Protocols|From Session 1|Aquaporin-targeted|Hydra-Reset Code · HydrO2 · Way Antiage (hydration phase)|5|cellulite|Cellulite Reduction"
  "cellulite|Body|Cellulite Reduction|Smoother texture, measurable. Not from a machine.|photo-1487412912498-0447578fcca8|Cellulite is a triad: vascular dysfunction, ECM disorganisation, and adipocyte-microcirculation breakdown. Treat one and you treat none. The Anticellulite Way addresses all three biological pillars.|5 Protocols|Measurable in cm|No machines|Anticellulite Way · Cell Code · Carbossi Code · HF Anti-Cellulite|6 · 14 · 15|contouring|Body Contouring"
  "contouring|Body|Body Contouring|Defined silhouette. Real inch loss. Real session count.|photo-1559757148-5c350d0d3c56|Contouring is about adipocyte metabolism, lymphatic drainage, and skin retraction — biology, not pressure. Each session targets a clear endpoint.|3 Protocols|Defined cycles|Measurable|Way Reducing · HF Reducing · Cell Code|6 · 14|stretch-marks|Stretch Marks"
  "stretch-marks|Body|Stretch Marks|Old marks, new marks — visible reduction either way.|photo-1544161515-4ab6ce6db874|Stretch marks are ECM rupture and disorganised collagen — and that means they respond to ECM-targeted protocols. The HF Stretch Marks pathway combines mesococktails, peelings, and exosomes to repair structure layer by layer.|2 Protocols|Old & new marks|Multi-modal|Way Stretch Marks · HF Stretch Marks · Anti-Stretch Marks Mesococktail|14|body-lifting|Body Lifting"
  "body-lifting|Body|Body Lifting|Firm. Tone. Skin retraction — without invasion.|photo-1598300042247-d088f8ab3a91|Body skin loses tone the same way the face does — through senescence, hormonal shifts, and ECM breakdown. The body-lifting pathway is the structural equivalent of the face's lifting protocol.|2 Protocols|Long-term programmes|Continuity-based|Way Lifting (body) · HF Anti-Ageing Lifting · Lift Code|7 · 14 · 16|detox|Detox &amp; Drainage"
  "detox|Body|Detox &amp; Drainage|Cleanse the system. Lighten the silhouette.|photo-1540555700478-4be289fbecef|Lymphatic stagnation and metabolic load show up as puffiness, heaviness, and dull skin. The detox pathway moves both — and prepares the body for any subsequent contouring or antiage work.|4 Protocols|Lymphatic-focused|Body wellness|Way Detox · HF Detox · Detox Relax · Anti-Inflammatory Detox|11 · 15|spa-antiage|Spa Anti-Age"
  "spa-antiage|Wellness|Spa Anti-Age|A time-reversing ritual for face and body.|photo-1540555700478-4be289fbecef|Anti-age applied as a wellness experience: full-body, slow, multi-sensory — but built on the same biological protocols that drive the clinical anti-age pathways.|1 Ritual|90-minute experience|Whole-body|Spa Anti-Age · Age Lift · Age Draining|4 · 7|spa-relax|Spa Relaxation"
  "spa-relax|Wellness|Spa Relaxation|Deep muscle release. Decontracting. Reset.|photo-1571019613454-1cb2f99b2d8b|Where Hypodermical biology meets bodywork — a decontracting ritual that releases muscle holding patterns while supporting drainage and oxygenation.|1 Ritual|60-minute experience|Decontracting|Spa Relaxation · Detox Relax · Lympho O2|—|spa-detox|Spa Detox"
  "spa-detox|Wellness|Spa Detox|Full-body purification, with science behind the experience.|photo-1519823551278-64ac92734fb1|A complete detox ritual that combines lymphatic drainage, oxygenation, and anti-inflammatory protocols. Wellness-grade application of clinical Hypodermical work.|1 Ritual|75-minute experience|Lymphatic + oxygen|Spa Detox · HF Detox · HF Anti-Inflammatory Detox|11 · 15|spa-oxygen|Spa Oxygenating"
  "spa-oxygen|Wellness|Spa Oxygenating|Re-energise. Illuminate. From the inside out.|photo-1532926381893-7542290edf1d|Oxygen is the single most underrated active in aesthetic medicine. The spa oxygenating ritual delivers it where the cells can actually use it — and the result is glow you can see.|1 Ritual|60-minute experience|Oxygen-driven|Spa Oxygenating · Lympho O2 · Oxy Mesopeeling|6|spa-regen|Spa Regenerating"
  "spa-regen|Wellness|Spa Regenerating|Cellular renewal. Restored vitality. Slow magic.|photo-1607008829749-c0f284a49841|The most advanced spa ritual — incorporating exosome signalling and regenerative mesococktails. For when the skin needs a reset, not maintenance.|1 Ritual|90-minute experience|Exosome-led|Spa Regenerating · HF Exosomes · Skin Revival|1 · 2 · 8|anti-aging|Anti-Aging &amp; Lifting"
)

for entry in "${TREATMENTS[@]}"; do
  IFS='|' read -r slug category name tagline image concern stat1 stat2 stat3 protocols markers next_slug next_name <<< "$entry"
  cat > "$OUT_DIR/$slug.html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$name — Hypodermical Benelux</title>
  <meta name="description" content="$tagline · Hypodermical Benelux $category treatment protocol." />
  <link rel="stylesheet" href="/css/main.css" />
  <style>
    .stat-circle { width: 120px; height: 120px; border-radius: 50%; border: 1px solid var(--color-black); display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 4px; padding: 8px; text-align: center; }
    .stat-circle__value { font-family: var(--font-display); font-weight: var(--fw-bold); font-size: 1.25rem; line-height: 1; }
    .stat-circle__label { font-family: var(--font-primary); font-size: 9px; font-weight: var(--fw-bold); letter-spacing: 0.14em; text-transform: uppercase; color: var(--color-grey-muted); }
    .stat-circles { display: flex; gap: 1rem; flex-wrap: wrap; justify-content: center; }
    .marker-chips { display: flex; flex-wrap: wrap; gap: 0.5rem; justify-content: center; margin-top: 2rem; }
    .markers-count { font-family: var(--font-accent); font-size: clamp(4rem, 8vw, 7rem); line-height: 1; }
  </style>
</head>
<body class="has-dark-hero">

<div data-include="/partials/header.html"></div>

<main>

  <section class="page-hero page-hero--dark page-hero--image" aria-labelledby="treatment-title">
    <div class="page-hero-bg" aria-hidden="true">
      <img src="https://images.unsplash.com/$image?w=1800&q=85&auto=format&fit=crop" alt="" loading="eager"/>
    </div>
    <span class="bubble-float light" style="width:240px;height:240px;top:10%;right:-60px" aria-hidden="true"></span>
    <div class="page-hero-inner align-left reveal" style="max-width:820px;margin:0 auto 0 0;">
      <span class="bubble-tag white page-hero-eyebrow">$category</span>
      <h1 class="page-hero-title" id="treatment-title">$name</h1>
      <p class="page-hero-sub" style="margin:0 0 2rem;">$tagline</p>
    </div>
  </section>

  <nav class="breadcrumb" aria-label="Breadcrumb">
    <a href="/">Home</a><span class="sep">/</span><a href="/pages/treatments.html">Treatments</a><span class="sep">/</span><span>$name</span>
  </nav>

  <section class="section section--white">
    <div class="section-inner">
      <div class="split">
        <div class="split__body bubble-border left">
          <span class="bubble-tag">The Concern</span>
          <h2 class="split__title">Understanding $name.</h2>
          <p>$concern</p>
        </div>
        <div class="stat-circles">
          <div class="stat-circle"><span class="stat-circle__value">$stat1</span><span class="stat-circle__label">Protocols</span></div>
          <div class="stat-circle"><span class="stat-circle__value">$stat2</span><span class="stat-circle__label">Timeframe</span></div>
          <div class="stat-circle"><span class="stat-circle__value">$stat3</span><span class="stat-circle__label">Method</span></div>
        </div>
      </div>
    </div>
  </section>

  <section class="section section--grey">
    <div class="section-inner" style="text-align:center;">
      <span class="bubble-tag section-eyebrow">The Protocol</span>
      <h2 class="section-title section-title--display">How it <em>works.</em></h2>
      <div class="value-grid" style="text-align:left; margin-top: 3rem;">
        <article class="value-card">
          <div class="value-card__num">01</div>
          <h3 class="value-card__title">Read</h3>
          <div class="value-card__rule"></div>
          <p class="value-card__desc">Your centre assesses the skin against the relevant biological markers and selects the right protocol from the HYPO WAY or HYPO FLOW family.</p>
        </article>
        <article class="value-card">
          <div class="value-card__num">02</div>
          <h3 class="value-card__title">Treat</h3>
          <div class="value-card__rule"></div>
          <p class="value-card__desc">A programmed series of sessions, each layered with the right active ingredients — mesococktails, peelings, exosomes — applied without needles.</p>
        </article>
        <article class="value-card">
          <div class="value-card__num">03</div>
          <h3 class="value-card__title">Maintain</h3>
          <div class="value-card__rule"></div>
          <p class="value-card__desc">A HYPO FLOW continuity protocol keeps results stable. Maintenance is part of the method — not an afterthought.</p>
        </article>
      </div>
      <p style="margin-top:3rem;font-family:var(--font-primary);font-size:0.85rem;letter-spacing:0.16em;text-transform:uppercase;color:var(--color-grey-muted);">Protocols in this pathway: <strong style="color:var(--color-black);letter-spacing:0;text-transform:none;">$protocols</strong></p>
    </div>
  </section>

  <section class="section section--black">
    <div class="section-inner" style="text-align:center;">
      <span class="bubble-tag white section-eyebrow">Biological Markers</span>
      <h2 class="section-title section-title--display">Works on markers <em>$markers.</em></h2>
      <p class="section-lede" style="margin-left:auto;margin-right:auto;color:rgba(255,255,255,0.8);">Out of the 16 biological markers of skin ageing, this protocol acts directly on the following.</p>
      <div class="marker-chips">
        $(for m in $(echo "$markers" | tr '·' ' '); do echo "<span class=\"bubble-tag white\">Marker $m</span>"; done)
      </div>
      <div style="margin-top:3rem;">
        <a href="/pages/method.html" class="btn btn-outline-white">Discover the 16 Markers</a>
      </div>
    </div>
  </section>

  <section class="cta-strip">
    <h2 class="cta-strip__title">Ready to <em>begin?</em></h2>
    <p class="cta-strip__sub">Book at a Hypodermical-certified partner centre near you.</p>
    <div class="cta-strip__actions">
      <a href="/pages/find-a-center.html" class="btn btn-white btn-lg">Find a Centre</a>
      <a href="/pages/treatments/$next_slug.html" class="btn btn-outline-white btn-lg">Next: $next_name →</a>
    </div>
  </section>

</main>

<div data-include="/partials/footer.html"></div>

<script src="/js/include.js"></script>
<script src="/js/main.js"></script>
</body>
</html>
HTML
  echo "Generated $slug.html"
done

echo ""
echo "✓ All 16 treatment pages generated in $OUT_DIR"
