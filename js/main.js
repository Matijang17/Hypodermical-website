'use strict';

/* onSiteReady — runs fn once the header/footer partials are in place.
   On pages with no [data-include] (homepage with inline header), the
   include.js still fires `partials:ready` immediately, so we just listen. */
function onSiteReady(fn) {
  document.addEventListener('partials:ready', fn, { once: true });
}

/* ─── Preloader ─────────────────────────────────────────────── */
const preloader = document.getElementById('preloader');
function hidePreloader() {
  if (preloader) preloader.classList.add('hidden');
}
if (document.readyState === 'complete') {
  setTimeout(hidePreloader, 600);
} else {
  window.addEventListener('load', () => setTimeout(hidePreloader, 600));
}
setTimeout(hidePreloader, 2800); // failsafe

/* ─── Header scroll state (waits for partials so #main-nav exists) */
onSiteReady(() => {
  const mainNav = document.getElementById('main-nav');
  if (!mainNav) return;
  const hasDarkHero = document.body.classList.contains('has-dark-hero');
  function syncHeaderState() {
    const scrolled = window.scrollY > 60;
    mainNav.classList.toggle('scrolled', scrolled);
    if (hasDarkHero) mainNav.classList.toggle('transparent', !scrolled);
  }
  window.addEventListener('scroll', syncHeaderState, { passive: true });
  syncHeaderState();
});

/* ─── Mega menus (hover + click) ─────────────────────────────── */
onSiteReady(() => {
  const megaTriggers = document.querySelectorAll('.has-mega');
  megaTriggers.forEach((trigger) => {
    const link = trigger.querySelector(':scope > a');
    if (!link) return;
    let closeTimer = null;

    const closeAll = (except) => {
      megaTriggers.forEach((other) => {
        if (other === except) return;
        other.classList.remove('open');
        other.querySelector(':scope > a')?.setAttribute('aria-expanded', 'false');
      });
    };
    const open = () => {
      clearTimeout(closeTimer);
      closeAll(trigger);
      trigger.classList.add('open');
      link.setAttribute('aria-expanded', 'true');
    };
    const close = () => {
      closeTimer = setTimeout(() => {
        trigger.classList.remove('open');
        link.setAttribute('aria-expanded', 'false');
      }, 120);
    };

    trigger.addEventListener('mouseenter', open);
    trigger.addEventListener('mouseleave', close);
    link.addEventListener('click', (e) => {
      if (window.innerWidth < 768) {
        e.preventDefault();
        if (!trigger.classList.contains('open')) open(); else close();
      }
    });
    document.addEventListener('keydown', (e) => { if (e.key === 'Escape') close(); });
    document.addEventListener('click', (e) => { if (!trigger.contains(e.target)) close(); });
  });
});

/* ─── Hamburger / mobile menu ────────────────────────────────── */
onSiteReady(() => {
  const hamburger  = document.getElementById('hamburger');
  const mobileMenu = document.getElementById('mobile-menu');
  if (!hamburger || !mobileMenu) return;

  hamburger.addEventListener('click', () => {
    const isOpen = hamburger.classList.toggle('open');
    hamburger.setAttribute('aria-expanded', String(isOpen));
    mobileMenu.hidden = !isOpen;
    mobileMenu.classList.toggle('open', isOpen);
    document.body.style.overflow = isOpen ? 'hidden' : '';
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && !mobileMenu.hidden) {
      hamburger.classList.remove('open');
      hamburger.setAttribute('aria-expanded', 'false');
      mobileMenu.hidden = true;
      mobileMenu.classList.remove('open');
      document.body.style.overflow = '';
    }
  });
});

/* ─── Newsletter form (lives in footer partial) ─────────────── */
onSiteReady(() => {
  const newsletterForm = document.querySelector('.newsletter-form');
  if (!newsletterForm) return;
  newsletterForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const input = newsletterForm.querySelector('input[type="email"]');
    const btn   = newsletterForm.querySelector('button[type="submit"]');
    if (!input.value || !input.validity.valid) { input.focus(); return; }
    btn.textContent = '✓ Done';
    btn.disabled = true;
    input.value = '';
    setTimeout(() => { btn.textContent = 'Join'; btn.disabled = false; }, 3000);
  });
});

/* ─── Active nav link (lives in header partial) ─────────────── */
onSiteReady(() => {
  const path  = window.location.pathname;
  const links = document.querySelectorAll('.nav-links a');
  links.forEach((link) => {
    if (link.getAttribute('href') === path) link.closest('li')?.classList.add('active');
  });
});

/* ─── Scroll reveal (page content, runs immediately) ────────── */
const revealEls = document.querySelectorAll('.reveal');
if (revealEls.length) {
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
  revealEls.forEach((el) => revealObserver.observe(el));
}

/* ─── Counter animation ──────────────────────────────────────── */
const counters = document.querySelectorAll('.counter-num[data-target]');
if (counters.length) {
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      const el = entry.target;
      const target = parseInt(el.dataset.target, 10);
      if (target === 0) { el.textContent = '0'; counterObserver.unobserve(el); return; }
      const duration = 1600;
      const start = performance.now();
      function step(now) {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        const ease = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.round(ease * target);
        if (progress < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
      counterObserver.unobserve(el);
    });
  }, { threshold: 0.5 });
  counters.forEach((el) => counterObserver.observe(el));
}

/* ─── Results carousel (homepage) ────────────────────────────── */
const carousel = document.getElementById('results-carousel');
const prevBtn  = document.getElementById('carousel-prev');
const nextBtn  = document.getElementById('carousel-next');
if (carousel && prevBtn && nextBtn) {
  const getScroll = () => {
    const card = carousel.querySelector('.result-card');
    return card ? card.offsetWidth + 24 : 340;
  };
  prevBtn.addEventListener('click', () => carousel.scrollBy({ left: -getScroll(), behavior: 'smooth' }));
  nextBtn.addEventListener('click', () => carousel.scrollBy({ left:  getScroll(), behavior: 'smooth' }));
  let dragging = false, startX = 0, scrollLeft = 0;
  carousel.addEventListener('mousedown', (e) => { dragging = true; startX = e.pageX - carousel.offsetLeft; scrollLeft = carousel.scrollLeft; carousel.style.cursor = 'grabbing'; });
  carousel.addEventListener('mousemove', (e) => { if (!dragging) return; e.preventDefault(); carousel.scrollLeft = scrollLeft - (e.pageX - carousel.offsetLeft - startX) * 1.2; });
  ['mouseup', 'mouseleave'].forEach((ev) => carousel.addEventListener(ev, () => { dragging = false; carousel.style.cursor = ''; }));
}

/* ─── 16 Markers reveal + mobile accordion ───────────────────── */
(function initMarkers() {
  const items = document.querySelectorAll('.marker-item');
  if (items.length) {
    const obs = new IntersectionObserver((entries) => {
      entries.forEach((entry, i) => {
        if (entry.isIntersecting) {
          setTimeout(() => entry.target.classList.add('visible'), i * 60);
          obs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
    items.forEach((el) => obs.observe(el));
  }
  const acc = document.querySelector('.markers-accordion');
  if (!acc) return;
  const data = [
    { num: '1, 2', name: 'Genomic instability / Telomere shortening', product: 'Exosomes — cell regeneration, collagen, elastin' },
    { num: '3',    name: 'Epigenetic alterations',                    product: 'HY.Spots' },
    { num: '4',    name: 'Loss of proteostasis',                      product: 'HY.Age — revitalising, lifting, deep regenerating' },
    { num: '5',    name: 'Altered perception of nutrients',           product: 'Hydra-Reset Code — deep hydration, regeneration' },
    { num: '6',    name: 'Mitochondrial dysfunction',                 product: 'HY.Age' },
    { num: '7',    name: 'Cellular senescence',                       product: 'Lift Code — redensifying, plumping, tissue lifting' },
    { num: '8',    name: 'Stem cell depletion',                       product: 'Exosomes' },
    { num: '9',    name: 'Intercellular alterations',                 product: 'HY.Acne — sebum regulation' },
    { num: '10',   name: 'Chronic inflammation',                      product: 'Anti-Couperose — reduces redness, capillaries' },
    { num: '11',   name: 'Abnormal immune activation',                product: 'Calm Code — detoxifying, anti-inflammatory' },
    { num: '12',   name: 'Alterations in skin microbiota',            product: 'HY.Acne' },
    { num: '13',   name: 'Alterations in skin barrier',               product: 'Calm Code' },
    { num: '14',   name: 'ECM (extracellular matrix) alterations',    product: 'Cell Code — anti-cellulite' },
    { num: '15',   name: 'Vascular dysfunction',                      product: 'Carbossi Code — oxygenation, circulation' },
    { num: '16',   name: 'Hormonal changes',                          product: 'Lift Code — redensifying, lifting' }
  ];
  acc.innerHTML = data.map((m) => `
    <details class="marker-accordion-item">
      <summary><span class="num">${m.num}</span><span>${m.name}</span></summary>
      <p>${m.product}</p>
    </details>
  `).join('');
})();

/* ─── Treatments filter (treatments.html) ────────────────────── */
(function initFilter() {
  const buttons = document.querySelectorAll('[data-filter-btn]');
  if (!buttons.length) return;
  const cards = document.querySelectorAll('[data-category]');
  buttons.forEach((btn) => {
    btn.addEventListener('click', () => {
      const cat = btn.getAttribute('data-filter-btn');
      buttons.forEach((b) => b.classList.toggle('active', b === btn));
      cards.forEach((card) => {
        const show = cat === 'all' || card.dataset.category === cat;
        card.style.display = show ? '' : 'none';
      });
    });
  });
})();
