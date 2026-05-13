#!/bin/bash
# Generate 6 blog article pages from a single template.
set -euo pipefail

OUT_DIR="/Users/matijaskarabot/Desktop/Hypodermical/pages/blog"
mkdir -p "$OUT_DIR"

# Fields separated by `|`, paragraph breaks within body separated by `~~`
ARTICLES=(
"biomarkers|Science|April 2026|5 min read|What Are the 16 Biological Markers of Skin Aging?|A clinicians framework for understanding why skin ages and why the Hypodermical method addresses each marker rather than chasing symptoms.|photo-1559757175-0eb30cd8c063|The skin ages on sixteen biological fronts. Cellular senescence. Genomic instability. ECM degradation. Each marker tells part of the story and missing one means missing the cause.~~The Hypodermical method maps every protocol to specific markers. A lifting treatment isnt a label, its a defined intervention on markers 7, 14, and 16. That precision is what makes the results reproducible.~~This article walks through all sixteen markers, what each represents biologically, and which Hypodermical product or protocol addresses it. It is the foundation document for anyone serious about understanding the method.|exosomes|HY Exosomes: The Future of Regenerative Skin Care"
"exosomes|Innovation|March 2026|7 min read|HY Exosomes: The Future of Regenerative Skin Care|Cell-signalling molecules are quietly redefining what topical aesthetic medicine can do. Heres why HY Exosomes matter and how theyre applied without needles.|photo-1601049541271-25cf5dca5d4e|Exosomes are small lipid-bound packages of signalling molecules released by stem cells. They carry the same regenerative instructions that drive wound healing and tissue renewal.~~HY Exosomes deliver these signals topically through the Hypodermical protocols gentle barrier-opening preparations. No needles. No transdermal devices. Just biology that crosses the barrier because the barrier has been prepared to receive it.~~The clinical impact is regeneration without invasion: increased collagen synthesis, elastin reorganisation, and visible firming with continuity use.|anti-aging-guide|The Complete Guide to Non-Invasive Anti-Aging"
"anti-aging-guide|Guide|February 2026|9 min read|The Complete Guide to Non-Invasive Anti-Aging|From biomarkers to home care a structured tour of everything that actually moves the needle on skin ageing, and what doesnt.|photo-1590779033100-9f60a05a013d|Most anti-ageing advice is a list of products. This is a list of biological levers what they are, what they do, and how to pull them in the right order.~~Start with foundations: barrier integrity, hydration, oxygenation. Without these, no targeted treatment delivers consistent results. Thats the rationale behind the HYPO CORE phase of the Hypodermical method.~~Then layer in targeted protocols antiage, lifting, regeneration each mapped to specific biological markers. Finally, maintain with continuity. Skin doesnt improve in one session; it improves in rhythm.|needle-free|Why Needle-Free Is the Future"
"needle-free|Method|January 2026|6 min read|Why Needle-Free Is the Future of Aesthetic Medicine|Results come from biology, not invasion. The needle-free movement isnt a compromise its a more accurate way to treat skin.|photo-1616394584738-fc6e612e71b9|Aesthetic medicine spent the last two decades inventing more aggressive ways to deliver actives through the skin. Microneedles, mesotherapy, transdermal devices. All built around the same assumption that the barrier is an obstacle.~~The Hypodermical method takes the opposite position. The barrier is functional. It can be temporarily and biocompatibly opened with the right preparation, then closed again, leaving the actives where the cells can use them.~~No needles means no inflammation. No downtime. No accumulated trauma. Just biology, delivered.|hypo-core|Why We Always Start with HYPO CORE"
"hypo-core|Protocol|December 2025|4 min read|Why We Always Start with HYPO CORE|Foundation first. The biological argument for cleansing, oxygenation, and barrier restoration before anything else.|photo-1570172619644-dfd03ed5d881|The most common mistake in aesthetic medicine is treating problems on skin that isnt ready. A compromised barrier wont hold actives. Dehydrated tissue wont respond to peelings. Inflamed skin wont tolerate exosomes.~~HYPO CORE exists to fix this. Its not a basic treatment its the structured preparation phase that makes everything that follows actually work. Centres that skip it report inconsistent results. Centres that respect it report compounding gains.~~The 17 CORE protocols are not interchangeable, either. The right CORE protocol depends on the skins current state which is why training matters.|cellulite-science|The Biology of Cellulite"
"cellulite-science|Science|November 2025|8 min read|The Biology of Cellulite (and How to Actually Treat It)|Vascular dysfunction, ECM disorganisation, microcirculation collapse why most cellulite cures fail, and what a method-driven approach looks like.|photo-1487412912498-0447578fcca8|Cellulite is not a single condition. Its the visible consequence of three overlapping biological breakdowns: vascular dysfunction (marker 15), ECM alterations (marker 14), and adipocyte-microcirculation collapse driven in part by mitochondrial dysfunction (marker 6).~~Treat one and you treat none. The skin still looks the same. This is why creams, machines, and isolated body treatments deliver short-term water displacement and call it a result.~~The Anticellulite Way protocol targets all three biological pillars in coordination Carbossi Code for vascular work, Cell Code for ECM repair, and HF Anti-Cellulite for continuity. Measurable change in centimetres, not just visual.|biomarkers|What Are the 16 Biological Markers"
)

for entry in "${ARTICLES[@]}"; do
  IFS='|' read -r slug category date readtime title summary image body next_slug next_title <<< "$entry"
  body_html=$(echo "$body" | sed 's|~~|</p><p>|g')
  cat > "$OUT_DIR/$slug.html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$title — Hypodermical Benelux Blog</title>
  <meta name="description" content="$summary" />
  <link rel="stylesheet" href="/css/main.css" />
  <style>
    .article-body { max-width: 720px; margin: 0 auto; }
    .article-body p { font-family: var(--font-primary); font-size: 1.05rem; line-height: 1.85; color: var(--color-charcoal); margin: 0 0 1.5rem; }
    .article-body p.lede { font-size: 1.25rem; line-height: 1.65; color: var(--color-black); font-weight: var(--fw-light); }
    .article-body h2 { font-family: var(--font-display); font-weight: var(--fw-bold); font-size: 2rem; line-height: 1.1; margin: 3rem 0 1.25rem; color: var(--color-black); }
    .article-meta { font-family: var(--font-primary); font-size: 11px; font-weight: var(--fw-bold); letter-spacing: 0.16em; text-transform: uppercase; color: rgba(255,255,255,0.75); }
  </style>
</head>
<body class="has-dark-hero">

<div data-include="/partials/header.html"></div>

<main>

  <article>
    <section class="page-hero page-hero--dark page-hero--image" aria-labelledby="article-title">
      <div class="page-hero-bg" aria-hidden="true">
        <img src="https://images.unsplash.com/$image?w=1800&q=85&auto=format&fit=crop" alt="" loading="eager"/>
      </div>
      <span class="bubble-float light" style="width:260px;height:260px;top:15%;right:-80px" aria-hidden="true"></span>
      <div class="page-hero-inner align-left reveal" style="max-width:820px;margin:0 auto 0 0;">
        <span class="bubble-tag white page-hero-eyebrow">$category</span>
        <h1 class="page-hero-title" id="article-title" style="font-size:clamp(2rem,4.5vw,4rem);">$title</h1>
        <p class="article-meta" style="margin-top:2rem;">$date · $readtime</p>
      </div>
    </section>

    <nav class="breadcrumb" aria-label="Breadcrumb">
      <a href="/">Home</a><span class="sep">/</span><a href="/pages/blog.html">Blog</a><span class="sep">/</span><span>$title</span>
    </nav>

    <section class="section section--white">
      <div class="article-body">
        <p class="lede">$summary</p>
        <p>$body_html</p>
      </div>
    </section>

  </article>

  <section class="cta-strip">
    <h2 class="cta-strip__title">Up next.</h2>
    <p class="cta-strip__sub">Continue reading: <em>$next_title</em></p>
    <div class="cta-strip__actions">
      <a href="/pages/blog/$next_slug.html" class="btn btn-white btn-lg">Read next →</a>
      <a href="/pages/blog.html" class="btn btn-outline-white btn-lg">Back to Blog</a>
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
echo "✓ All 6 blog articles generated in $OUT_DIR"
