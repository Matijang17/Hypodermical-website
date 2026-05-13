#!/bin/bash
# Generate individual product pages from a single template.
set -euo pipefail

OUT_DIR="/Users/matijaskarabot/Desktop/Hypodermical/pages/products"
mkdir -p "$OUT_DIR"

# slug|line|name|tagline|image_id|description|markers|protocols
PRODUCTS=(
"hyaluronic-acid|Mesococktail|Hyaluronic Acid|Deep cellular hydration. The plumping baseline.|photo-1556228720-195a672e8a03|A low-molecular-weight hyaluronic complex designed to cross the prepared barrier and reach the cells that actually use it. The foundation mesococktail behind every hydration-driven protocol.|5|Way Antiage · HF Anti-Ageing Lifting · Hydra-Reset Code"
"lift-active|Mesococktail|Lift Active|Firmness through ECM and senescence work.|photo-1598300042247-d088f8ab3a91|A blend of bio-mimetic peptides and ECM-stimulating actives. Targets cellular senescence and ECM disorganisation directly.|7 · 14|Way Lifting · Lift Code · HF Anti-Ageing Lifting"
"pearl-white|Mesococktail|Pearl White|Brightening, evenly. Without bleach.|photo-1512290923902-8a9f81dc236c|Acts on epigenetic alteration of melanocyte signalling rather than pigment displacement. Slower than bleach, lasts longer, doesn't compromise the barrier.|3|Way Spots · HY.Spots"
"skin-revival|Mesococktail|Skin Revival|Multi-marker regeneration cocktail.|photo-1499781350541-7783f6c6a0c8|A broad-spectrum regenerative mix used at the close of intensive protocols. Includes regenerative peptides and antioxidant activators.|1 · 2 · 7 · 8|HF Anti-Ageing Lifting · Spa Regenerating"
"hydro2|Mesococktail|HydrO2|Oxygenating mesococktail.|photo-1576091160399-112ba8d25d1d|Pairs the Hyaluronic baseline with stabilised oxygen carriers. Restores the cellular respiratory environment.|6|Lympho O2 · Spa Oxygenating · Oxy Mesopeeling"
"3-layer-mesopeeling|Peeling|3-Layer Mesopeeling|Progressive renewal across three depths.|photo-1556228852-80b6e5eeff06|A graduated peeling system applied in three layers — each addressing a different depth of skin renewal without aggressive trauma. The flagship Hypodermical resurfacing protocol.|14|HF Mesopeeling · Oxy Mesopeeling"
"phyto-peeling|Peeling|Phyto Peeling|Botanical resurfacing for sensitive skin.|photo-1556228578-8c89e6adf883|Plant-derived enzymatic actives that exfoliate without acid trauma. Suitable for reactive or compromised skin.|11 · 13|Way Sensitive · Calm Code"
"retinol-peeling|Peeling|Retinol Peeling|Controlled cell turnover, biocompatibly delivered.|photo-1556228724-69d1ed5e8e9e|A stabilised retinol formulation that drives cell turnover without the typical irritation curve. Built for use inside the HYPO method's preparation sequences.|3 · 4|Way Antiage · Way Spots"
"oxy-mesopeeling|Peeling|Oxy Mesopeeling|Oxygen-charged resurface.|photo-1556228841-a3c527ebefe5|Pairs resurfacing with oxygenation, so the skin recovers faster and shows results immediately.|6 · 14|Oxy Mesopeeling · HF Mesopeeling"
"exosomes|Specific|HY Exosomes|Regenerative cell-signalling.|photo-1559757175-0eb30cd8c063|Lipid-bound packages of regenerative signalling molecules. Cross the prepared barrier and instruct the skin to rebuild like it did when it was younger.|1 · 2 · 8|HF Exosomes · Spa Regenerating · Oxy Exosomes"
"carboxy-facial|Specific|Carboxy Facial|CO₂ oxygenation through the skin.|photo-1601049541271-25cf5dca5d4e|Carboxytherapy delivered topically — supports microcirculation and vascular tone without injection.|15|Carbossi Code · Way Capillaries · Anticellulite Way"
"lift-code|Specific|Lift Code|Coded lifting active.|photo-1590779033100-9f60a05a013d|Targeted formula combining senescence inhibitors, ECM stimulators, and bio-mimetic peptides — the signature lifting active.|7 · 14 · 16|Way Lifting · HF Anti-Ageing Lifting"
"hydra-reset-code|Specific|Hydra-Reset Code|Cellular hydration reset.|photo-1607008829749-c0f284a49841|Restores aquaporin signalling and barrier lipid synthesis. Brings the skin's own hydration system back online.|5|Hydra-Reset Code protocol · Way Antiage"
"illumineye|Specific|Illumineye|Periorbital contour.|photo-1499781350541-7783f6c6a0c8|Built specifically for the thinner, more vascular skin around the eye. Reduces shadow, puffiness, and fine lines.|4 · 15|Way Eyezone"
)

for entry in "${PRODUCTS[@]}"; do
  IFS='|' read -r slug line name tagline image description markers protocols <<< "$entry"
  cat > "$OUT_DIR/$slug.html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$name — Hypodermical Benelux</title>
  <meta name="description" content="$tagline · $line · Hypodermical Benelux professional product." />
  <link rel="stylesheet" href="/css/main.css" />
</head>
<body class="has-dark-hero">

<div data-include="/partials/header.html"></div>

<main>

  <section class="page-hero page-hero--dark page-hero--image" aria-labelledby="product-title">
    <div class="page-hero-bg" aria-hidden="true">
      <img src="https://images.unsplash.com/$image?w=1800&q=85&auto=format&fit=crop" alt="" loading="eager"/>
    </div>
    <span class="bubble-float light" style="width:260px;height:260px;top:10%;right:-80px" aria-hidden="true"></span>
    <div class="page-hero-inner align-left reveal" style="max-width:820px;margin:0 auto 0 0;">
      <span class="bubble-tag white page-hero-eyebrow">$line</span>
      <h1 class="page-hero-title" id="product-title">$name</h1>
      <p class="page-hero-sub" style="margin:0 0 2rem;">$tagline</p>
    </div>
  </section>

  <nav class="breadcrumb" aria-label="Breadcrumb">
    <a href="/">Home</a><span class="sep">/</span><a href="/pages/products.html">Products</a><span class="sep">/</span><span>$name</span>
  </nav>

  <section class="section section--white">
    <div class="section-inner" style="max-width:760px;">
      <span class="bubble-tag">What it does</span>
      <h2 class="split__title" style="margin:1rem 0 1.5rem;">$name in the method.</h2>
      <p style="font-family:var(--font-primary);font-size:1.1rem;line-height:1.75;color:var(--color-charcoal);">$description</p>

      <div style="margin-top:3rem;display:grid;grid-template-columns:1fr 1fr;gap:2rem;">
        <div>
          <p style="font-family:var(--font-primary);font-size:11px;font-weight:var(--fw-bold);letter-spacing:0.16em;text-transform:uppercase;color:var(--color-grey-muted);margin-bottom:0.75rem;">Targets markers</p>
          <p style="font-family:var(--font-accent);font-size:2.5rem;color:var(--color-black);line-height:1;">$markers</p>
        </div>
        <div>
          <p style="font-family:var(--font-primary);font-size:11px;font-weight:var(--fw-bold);letter-spacing:0.16em;text-transform:uppercase;color:var(--color-grey-muted);margin-bottom:0.75rem;">Used in protocols</p>
          <p style="font-family:var(--font-primary);font-size:0.95rem;line-height:1.6;color:var(--color-black);">$protocols</p>
        </div>
      </div>
    </div>
  </section>

  <section class="cta-strip">
    <h2 class="cta-strip__title">Professional <em>only.</em></h2>
    <p class="cta-strip__sub">$name is available only to certified Hypodermical centres. Become a partner to access the full product line.</p>
    <div class="cta-strip__actions">
      <a href="/pages/professionals.html" class="btn btn-white btn-lg">For Professionals</a>
      <a href="/pages/products.html" class="btn btn-outline-white btn-lg">All Products</a>
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
echo "✓ All 14 product pages generated in $OUT_DIR"
