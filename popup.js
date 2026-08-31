// Hardcoded Netflix cookie – injected automatically every time the popup opens
const SAVED_COOKIES = [
  {
        "domain": ".netflix.com",
        "expirationDate": 1799760183.204523,
        "hostOnly": false,
        "httpOnly": false,
        "name": "nfvdid",
        "path": "/",
        "sameSite": null,
        "secure": true,
        "session": false,
        "storeId": null,
        "value": "BQFmAAEBEKoxorm4vHaKONu_2UTw-iJAyHHPE-apTyQrSZC_ldYslZSuWX2-BwPLusCrZLDRNseS9YASCMUScGUIj6tdVpuiu9_o69SykvN1WLKjRzJspg%3D%3D"
    }
];

document.addEventListener('DOMContentLoaded', async () => {
  const statusCard = document.getElementById('statusCard');
  const statusTitle = document.getElementById('statusTitle');
  const statusMessage = document.getElementById('statusMessage');
  const cookieNameEl = document.getElementById('cookieName');

  // Show the cookie name immediately
  cookieNameEl.textContent = SAVED_COOKIES[0]?.name || '—';

  try {
    // 1. Clear all existing Netflix cookies
    const existing = await chrome.cookies.getAll({ domain: 'netflix.com' });
    for (const c of existing) {
      const host = c.domain.startsWith('.') ? c.domain.slice(1) : c.domain;
      const url = `https://${host}${c.path || '/'}`;
      await chrome.cookies.remove({ url, name: c.name });
    }

    // 2. Inject the saved cookie(s)
    let successCount = 0;
    for (const cookie of SAVED_COOKIES) {
      await setCookie(cookie);
      successCount++;
    }

    // 3. Refresh all open Netflix tabs
    const tabs = await chrome.tabs.query({
      url: ['*://*.netflix.com/*', '*://netflix.com/*']
    });
    for (const tab of tabs) {
      await chrome.tabs.reload(tab.id);
    }

    // Success UI
    statusCard.classList.add('success');
    statusTitle.textContent = 'Cookie injected successfully';
    statusMessage.textContent = `Cleared ${existing.length} old cookie${existing.length !== 1 ? 's' : ''}, ` +
      `injected ${successCount} new one${successCount !== 1 ? 's' : ''}, ` +
      `refreshed ${tabs.length} Netflix tab${tabs.length !== 1 ? 's' : ''}.`;
  } catch (err) {
    statusCard.classList.add('error');
    statusTitle.textContent = 'Injection failed';
    statusMessage.textContent = err.message || 'An unexpected error occurred.';
    console.error(err);
  }
});

/**
 * Convert a cookie object into the format required by chrome.cookies.set
 */
async function setCookie(cookie) {
  if (!cookie.name || cookie.value === undefined) {
    throw new Error('Cookie is missing name or value');
  }

  let domain = cookie.domain || '.netflix.com';
  const host = domain.startsWith('.') ? domain.slice(1) : domain;
  const path = cookie.path || '/';
  const url = `https://${host}${path.startsWith('/') ? path : '/' + path}`;

  const details = {
    url,
    name: cookie.name,
    value: String(cookie.value),
    path,
    secure: Boolean(cookie.secure),
  };

  if (domain) {
    details.domain = domain;
  }

  if (typeof cookie.httpOnly === 'boolean') {
    details.httpOnly = cookie.httpOnly;
  }

  // expirationDate must be an integer (seconds since epoch)
  if (cookie.expirationDate != null) {
    details.expirationDate = Math.floor(Number(cookie.expirationDate));
  } else if (cookie.expires) {
    const exp = cookie.expires;
    details.expirationDate = typeof exp === 'number'
      ? Math.floor(exp)
      : Math.floor(new Date(exp).getTime() / 1000);
  }

  // sameSite handling
  if (cookie.sameSite != null) {
    const ss = String(cookie.sameSite).toLowerCase();
    if (ss === 'no_restriction' || ss === 'none') {
      details.sameSite = 'no_restriction';
      details.secure = true;
    } else if (ss === 'lax') {
      details.sameSite = 'lax';
    } else if (ss === 'strict') {
      details.sameSite = 'strict';
    } else {
      details.sameSite = 'unspecified';
    }
  } else {
    // null / undefined → unspecified
    details.sameSite = 'unspecified';
  }

  return chrome.cookies.set(details);
}
