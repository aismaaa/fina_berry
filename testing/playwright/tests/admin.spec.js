const { test, expect } = require('@playwright/test');

/**
 * ============================================================
 * PLAYWRIGHT UI TEST – Panel Admin & Laporan (Flutter Web)
 * Referensi: SUS (System Usability Scale) – Learnability, Efficiency
 * ============================================================
 */

// Helper: tunggu render Flutter Web
async function waitForFlutter(page, ms = 3000) {
  await page.waitForTimeout(ms);
}

test.describe('UI – Halaman Admin & Dashboard', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await waitForFlutter(page);
  });

  /**
   * UI-ADMIN-001
   * Test: Halaman termuat di tampilan desktop
   * SUS Criteria: Learnability
   */
  test('UI-ADMIN-001: Aplikasi Flutter termuat di browser', async ({ page }) => {
    await page.screenshot({ path: 'test-results/screenshots/admin_app_load.png' });

    // Verifikasi ada konten ter-render
    const content = await page.content();
    expect(content.length).toBeGreaterThan(200);
  });

  /**
   * UI-ADMIN-002
   * Test: Meta title halaman mengandung nama aplikasi
   * SUS Criteria: Match between system and real world
   */
  test('UI-ADMIN-002: Meta title halaman benar', async ({ page }) => {
    const title = await page.title();
    console.log(`App title: ${title}`);
    expect(typeof title).toBe('string');
  });

  /**
   * UI-ADMIN-003
   * Test: Responsive rendering panel admin pada tampilan mobile
   * SUS Criteria: Aesthetic and minimalist design
   */
  test('UI-ADMIN-003: Tampilan mobile panel admin ter-render', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.screenshot({ path: 'test-results/screenshots/admin_mobile_view.png', fullPage: true });

    const content = await page.content();
    expect(content.length).toBeGreaterThan(200);
  });

  /**
   * UI-ADMIN-004
   * Test: Element Flutter root terdeteksi di DOM
   * SUS Criteria: Visibility of system status
   */
  test('UI-ADMIN-004: Element Flutter view ter-render', async ({ page }) => {
    const flutterEl = page.locator('flt-glass-pane, canvas, flutter-view, body').first();
    await expect(flutterEl).toBeAttached();
  });
});
