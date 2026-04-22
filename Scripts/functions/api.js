'use strict';

export const USER_ID  = 1; 
export const API_BASE = (() => {
  const port = location.port;
  const base = location.protocol + '//' + location.hostname + (port ? ':' + port : '');

  const path = location.pathname.replace(/\/Pages\/.*$/, '').replace(/\/index\.html$/, '');
  return base + path + '/Backend';
})();

/**
 * @param {string} url
 * @param {RequestInit} options
 * @returns {Promise<any>}
 */

async function apiFetch(url, options = {}) {
  const res = await fetch(url, {
    credentials: 'same-origin',
    headers: { 'Content-Type': 'application/json', ...(options.headers ?? {}) },
    ...options,
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

export const Operations = {
  list: (params = {}) => {
    const q = new URLSearchParams(params);
    return apiFetch(`${API_BASE}/operations/index.php?${q}`);
  },
  add: (body) => apiFetch(`${API_BASE}/operations/index.php`, {
    method: 'POST', body: JSON.stringify(body),
  }),
  update: (body) => apiFetch(`${API_BASE}/operations/index.php`, {
    method: 'PUT', body: JSON.stringify(body),
  }),
  remove: (operationId) => apiFetch(`${API_BASE}/operations/index.php`, {
    method: 'DELETE', body: JSON.stringify({ operation_id: operationId }),
  }),
};

export const Categories = {
  list: () => apiFetch(`${API_BASE}/categories/index.php`),
  add:  (name) => apiFetch(`${API_BASE}/categories/index.php`, {
    method: 'POST', body: JSON.stringify({ name }),
  }),
  remove: (categoryId) => apiFetch(`${API_BASE}/categories/index.php`, {
    method: 'DELETE', body: JSON.stringify({ category_id: categoryId }),
  }),
};

export const Budget = {
  get:  (period) => apiFetch(`${API_BASE}/budget/index.php?period=${period}`),
  save: (period, limit) => apiFetch(`${API_BASE}/budget/index.php`, {
    method: 'POST', body: JSON.stringify({ period, limit }),
  }),
};

export const Summary = {
  get: () => apiFetch(`${API_BASE}/summary/index.php`),
};

