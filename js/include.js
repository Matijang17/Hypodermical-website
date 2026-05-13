'use strict';

/* Async include: replaces every [data-include] element with the fetched HTML,
   then dispatches `partials:ready` once everything is in place. */
(async function () {
  const slots = document.querySelectorAll('[data-include]');
  if (!slots.length) {
    document.dispatchEvent(new CustomEvent('partials:ready'));
    return;
  }
  await Promise.all([...slots].map(async (slot) => {
    const url = slot.getAttribute('data-include');
    try {
      const res = await fetch(url, { credentials: 'same-origin' });
      if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
      const html = await res.text();
      slot.outerHTML = html;
    } catch (err) {
      console.error('include.js: failed to load', url, err);
      slot.outerHTML = `<!-- include failed: ${url} -->`;
    }
  }));
  document.dispatchEvent(new CustomEvent('partials:ready'));
})();
