const { defineConfig, devices } = require('@playwright/test');

/**
 * Playwright Configuration – Fina Berry UI Testing (CommonJS)
 *
 * Target: Flutter Web Build (http://localhost:8080)
 * Untuk menjalankan Flutter Web: flutter run -d web-server --web-port 8080
 */
module.exports = defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['list'],
    ['json', { outputFile: 'test-results/results.json' }],
  ],

  use: {
    // Base URL default untuk UI Flutter Web
    baseURL: process.env.BASE_URL || 'http://localhost:8080',

    // Tangkap screenshot dan video saat test gagal
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',

    // Timeout per aksi
    actionTimeout: 15_000,
    navigationTimeout: 30_000,
  },

  projects: [
    {
      name: 'ui-desktop',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 800 },
      },
    },
    {
      name: 'ui-mobile-android',
      use: {
        ...devices['Pixel 5'],
      },
    },
    {
      name: 'ui-mobile-ios',
      use: {
        ...devices['iPhone 13'],
      },
    },
  ],

  // Timeout global per test
  timeout: 60_000,
  expect: {
    timeout: 10_000,
  },
});
