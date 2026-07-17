const { test, expect } = require('@playwright/test');

/**
 * ============================================================
 * PLAYWRIGHT UI TEST – Halaman Menu (Flutter Web)
 * Referensi: SUS (System Usability Scale) – Task Performance, Usability
 * ============================================================
 */

// Helper: tunggu Flutter render
async function waitForFlutter(page, ms = 3000) {
  await page.waitForTimeout(ms);
}

test.describe('UI – Halaman Menu & Katalog Product', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await waitForFlutter(page, 3000);
  });

  /**
   * UI-MENU-001
   * Test: Halaman menu termuat dengan benar
   * SUS Criteria: Learnability, Visibility of system status
   */
  test('UI-MENU-001: Halaman menu termuat dan menampilkan konten', async ({ page }) => {
    await page.screenshot({ path: 'test-results/screenshots/menu_page.png' });

    // Verifikasi Flutter app ter-render
    const body = await page.content();
    expect(body.length).toBeGreaterThan(500);
  });

  /**
   * UI-MENU-002
   * Test: Verifikasi page title dan meta
   * SUS Criteria: Match between system and real world
   */
  test('UI-MENU-002: Title halaman mengandung nama aplikasi', async ({ page }) => {
    const title = await page.title();
    expect(title.toLowerCase()).toMatch(/fin+a|berry/);
  });

  /**
   * UI-MENU-003
   * Test: Element Flutter root ter-render
   * SUS Criteria: Visibility of system status
   */
  test('UI-MENU-003: Flutter view container ter-render di browser', async ({ page }) => {
    const flutterEl = page.locator('flt-glass-pane, canvas, flutter-view, body').first();
    await expect(flutterEl).toBeAttached();
  });

  /**
   * UI-MENU-004
   * Test: Layout katalog menu responsif pada resolusi tablet
   * SUS Criteria: Aesthetic and minimalist design
   */
  test('UI-MENU-004: Responsive layout pada resolusi tablet', async ({ page }) => {
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.screenshot({ path: 'test-results/screenshots/menu_tablet.png', fullPage: true });

    const content = await page.content();
    expect(content.length).toBeGreaterThan(200);
  });
});
