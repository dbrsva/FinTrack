'use strict';

const HTML_ESCAPE_MAP = {
  '&':  '&amp;',
  '<':  '&lt;',
  '>':  '&gt;',
  '"':  '&quot;',
  "'":  '&#x27;',
  '/':  '&#x2F;',
  '`':  '&#x60;',
  '=':  '&#x3D;',
};

/**
 * @param {string} str
 * @returns {string}
 */
export function escapeHtml(str) {
  if (typeof str !== 'string') return '';
  return str.replace(/[&<>"'`=/]/g, ch => HTML_ESCAPE_MAP[ch] || ch);
}

/**
 * @param {string} str
 * @returns {string}
 */

export function sanitizeInput(str) {
  if (typeof str !== 'string') return '';
  return escapeHtml(str.trim());
}

/**
 * @param {string|number} val
 * @returns {{ valid: boolean, value: number, error: string }}
 */

export function validateAmount(val) {
  const num = parseFloat(String(val).replace(',', '.'));
  if (isNaN(num) || num <= 0) {
    return { valid: false, value: 0, error: 'Введите сумму больше нуля' };
  }
  if (num > 999_999_999) {
    return { valid: false, value: 0, error: 'Слишком большая сумма' };
  }
  return { valid: true, value: num, error: '' };
}

/**
 * @param {string} val
 * @param {{ min?: number, max?: number, required?: boolean }} opts
 */

export function validateText(val, { min = 1, max = 200, required = true } = {}) {
  const trimmed = String(val ?? '').trim();
  if (required && trimmed.length === 0) {
    return { valid: false, value: '', error: 'Поле не может быть пустым' };
  }
  if (trimmed.length < min) {
    return { valid: false, value: trimmed, error: `Минимум ${min} символов` };
  }
  if (trimmed.length > max) {
    return { valid: false, value: trimmed, error: `Максимум ${max} символов` };
  }
  return { valid: true, value: trimmed, error: '' };
}

/**
 * @param {string} val 
 * @returns {{ valid: boolean, value: string, error: string }}
 */

export function validateDate(val) {
  if (!val) {
    return { valid: true, value: new Date().toISOString().slice(0, 10), error: '' };
  }
  const d = new Date(val);
  if (isNaN(d.getTime())) {
    return { valid: false, value: '', error: 'Неверная дата' };
  }
  return { valid: true, value: val, error: '' };
}


/**
 * @param {string} val
 * @returns {{ valid: boolean, error: string }}
 */

export function validateEmail(val) {
  const trimmed = String(val ?? '').trim();
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
  if (!re.test(trimmed)) {
    return { valid: false, error: 'Неверный формат email' };
  }
  return { valid: true, error: '' };
}

/**
 * @param {HTMLElement} inputEl
 * @param {string} message 
 */

export function setFieldError(inputEl, message) {
  if (!inputEl) return;
  if (message) {
    inputEl.classList.add('input-error');
    let hint = inputEl.nextElementSibling;
    if (!hint || !hint.classList.contains('field-hint')) {
      hint = document.createElement('span');
      hint.className = 'field-hint';
      inputEl.after(hint);
    }
    hint.textContent = message;
  } else {
    inputEl.classList.remove('input-error');
    const hint = inputEl.nextElementSibling;
    if (hint && hint.classList.contains('field-hint')) hint.remove();
  }
}

/**
 * @param {HTMLElement} formEl
 */
export function clearFormErrors(formEl) {
  formEl?.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
  formEl?.querySelectorAll('.field-hint').forEach(el => el.remove());
}

/**
 * @param {number} amount
 * @param {string} currency 
 * @returns {string}
 */

export function formatMoney(amount, currency = '₽') {
  return Number(amount).toLocaleString('ru-RU', { minimumFractionDigits: 0, maximumFractionDigits: 2 })
    + '\u00A0' + currency;
}
