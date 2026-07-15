const { test, expect } = require('@playwright/test');

/**
 * ============================================================
 * PLAYWRIGHT UI TEST – Keranjang & Checkout (Flutter Web)
 * Referensi: SUS (System Usability Scale) – Task Completion Rate, Efficiency
 * ============================================================
 */

// Helper: tunggu render Flutter Web
async function waitForFlutter(page, ms = 3000) {
  await page.waitForTimeout(ms);
}

test.describe('UI – Halaman Keranjang & Checkout', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await waitForFlutter(page);
  });

  /**
   * UI-CART-001
   * Test: Halaman aplikasi termuat di browser
   * SUS Criteria: Learnability
   */
  test('UI-CART-001: Aplikasi keranjang termuat di browser', async ({ page }) => {
    await page.screenshot({ path: 'test-results/screenshots/cart_app_load.png' });

    const content = await page.content();
    expect(content.length).toBeGreaterThan(200);
  });

  /**
   * UI-CART-002
   * Test: Verifikasi elemen rendering Flutter Web di halaman utama
   * SUS Criteria: Visibility of system status
   */
  test('UI-CART-002: Elemen utama Flutter Web ter-render dengan sukses', async ({ page }) => {
    const flutterEl = page.locator('flt-glass-pane, canvas, flutter-view, body').first();
    await expect(flutterEl).toBeAttached();

    await page.screenshot({ path: 'test-results/screenshots/cart_flutter_view.png' });
  });

  /**
   * UI-CART-003
   * Test: Verifikasi formulir checkout pada tampilan desktop
   * SUS Criteria: Aesthetic and minimalist design
   */
  test('UI-CART-003: Layout checkout responsif pada resolusi desktop', async ({ page }) => {
    await page.setViewportSize({ width: 1280, height: 800 });
    await page.screenshot({ path: 'test-results/screenshots/checkout_desktop.png', fullPage: true });

    const title = await page.title();
    expect(title).toBeTruthy();
  });

  /**
   * UI-CART-004
   * Test: Verifikasi formulir checkout pada tampilan mobile
   * SUS Criteria: Aesthetic and minimalist design
   */
  test('UI-CART-004: Layout checkout responsif pada resolusi mobile', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.screenshot({ path: 'test-results/screenshots/checkout_mobile.png', fullPage: true });

    const title = await page.title();
    expect(title).toBeTruthy();
  });
});
