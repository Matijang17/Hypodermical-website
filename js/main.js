'use strict';

/* ─── Preloader ─────────────────────────────────────────────── */
const preloader = document.getElementById('preloader');
function hidePreloader() {
  preloader.classList.add('hidden');
}
if (document.readyState === 'complete') {
  setTimeout(hidePreloader, 600);
} else {
  window.addEventListener('load', () => setTimeout(hidePreloader, 600));
}
setTimeout(hidePreloader, 2800); // failsafe

/* ─── Nav scroll shadow ──────────────────────────────────────── */
const mainNav = document.getElementById('main-nav');
let lastScroll = 0;
window.addEventListener('scroll', () => {
  const scrollY = window.scrollY;
  mainNav.classList.toggle('scrolled', scrollY > 20);
  lastScroll = scrollY;
}, { passive: true });

/* ─── Mega menu (hover + click) ──────────────────────────────── */
const treatmentsTrigger = document.getElementById('treatments-trigger');
const treatmentsLink    = document.getElementById('treatments-link');

if (treatmentsTrigger) {
  let closeTimer = null;

  function openMega() {
    clearTimeout(closeTimer);
    treatmentsTrigger.classList.add('open');
    treatmentsLink.setAttribute('aria-expanded', 'true');
  }
  function closeMega() {
    closeTimer = setTimeout(() => {
      treatmentsTrigger.classList.remove('open');
      treatmentsLink.setAttribute('aria-expanded', 'false');
    }, 120);
  }

  treatmentsTrigger.addEventListener('mouseenter', openMega);
  treatmentsTrigger.addEventListener('mouseleave', closeMega);

  treatmentsLink.addEventListener('click', (e) => {
    const isMobile = window.innerWidth < 768;
    if (isMobile) {
      e.preventDefault();
      treatmentsTrigger.classList.toggle('open');
      const expanded = treatmentsTrigger.classList.contains('open');
      treatmentsLink.setAttribute('aria-expanded', String(expanded));
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeMega();
  });
  document.addEventListener('click', (e) => {
    if (!treatmentsTrigger.contains(e.target)) closeMega();
  });
}

/* ─── Hamburger / mobile menu ────────────────────────────────── */
const hamburger  = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobile-menu');

if (hamburger && mobileMenu) {
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
}

/* ─── Scroll reveal ─────────────────────────────────────────── */
const revealEls = document.querySelectorAll('.reveal');
if (revealEls.length) {
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
  revealEls.forEach(el => revealObserver.observe(el));
}

/* ─── Counter animation ──────────────────────────────────────── */
const counters = document.querySelectorAll('.counter-num[data-target]');
if (counters.length) {
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      const el     = entry.target;
      const target = parseInt(el.dataset.target, 10);
      if (target === 0) { el.textContent = '0'; counterObserver.unobserve(el); return; }

      const duration = 1600;
      const start    = performance.now();
      function step(now) {
        const elapsed  = now - start;
        const progress = Math.min(elapsed / duration, 1);
        const ease     = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.round(ease * target);
        if (progress < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
      counterObserver.unobserve(el);
    });
  }, { threshold: 0.5 });
  counters.forEach(el => counterObserver.observe(el));
}

/* ─── Results carousel ───────────────────────────────────────── */
const carousel    = document.getElementById('results-carousel');
const prevBtn     = document.getElementById('carousel-prev');
const nextBtn     = document.getElementById('carousel-next');

if (carousel && prevBtn && nextBtn) {
  function getScrollAmount() {
    const card = carousel.querySelector('.result-card');
    return card ? card.offsetWidth + 24 : 340;
  }
  prevBtn.addEventListener('click', () => {
    carousel.scrollBy({ left: -getScrollAmount(), behavior: 'smooth' });
  });
  nextBtn.addEventListener('click', () => {
    carousel.scrollBy({ left: getScrollAmount(), behavior: 'smooth' });
  });

  let isDragging = false, startX = 0, scrollLeft = 0;
  carousel.addEventListener('mousedown', e => {
    isDragging = true;
    startX     = e.pageX - carousel.offsetLeft;
    scrollLeft = carousel.scrollLeft;
    carousel.style.cursor = 'grabbing';
  });
  carousel.addEventListener('mousemove', e => {
    if (!isDragging) return;
    e.preventDefault();
    const x    = e.pageX - carousel.offsetLeft;
    const walk = (x - startX) * 1.2;
    carousel.scrollLeft = scrollLeft - walk;
  });
  ['mouseup', 'mouseleave'].forEach(ev => {
    carousel.addEventListener(ev, () => {
      isDragging = false;
      carousel.style.cursor = '';
    });
  });
}

/* ─── Newsletter form ────────────────────────────────────────── */
const newsletterForm = document.querySelector('.newsletter-form');
if (newsletterForm) {
  newsletterForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const input = newsletterForm.querySelector('input[type="email"]');
    const btn   = newsletterForm.querySelector('button[type="submit"]');
    if (!input.value || !input.validity.valid) {
      input.focus();
      return;
    }
    btn.textContent = '✓ Done';
    btn.disabled    = true;
    input.value     = '';
    setTimeout(() => {
      btn.textContent = 'Join';
      btn.disabled    = false;
    }, 3000);
  });
}

/* ─── Active nav link ────────────────────────────────────────── */
(function markActiveLink() {
  const path  = window.location.pathname;
  const links = document.querySelectorAll('.nav-links a');
  links.forEach(link => {
    if (link.getAttribute('href') === path) {
      link.closest('li')?.classList.add('active');
    }
  });
})();
