# Warung Fina Berry App

<p align="center">
  <img src="assets/images/logo fina berry.jpeg" alt="Warung Fina Berry Logo" width="300"/>
</p>

**Warung Fina Berry** is a modern Point of Sale (POS) and restaurant management application built with Flutter. It aims to streamline operations, including manual menu management, order processing, and administrative tasks, while featuring an intuitive user interface and a custom branding aesthetic.
# 🍜 Sistem Optimasi Produksi dan Manajemen Pesanan
### Warung Makan Fina Berry

![Version](https://img.shields.io/badge/version-1.0-green)
![Status](https://img.shields.io/badge/status-in%20development-yellow)
![Platform](https://img.shields.io/badge/platform-Web%20%7C%20Mobile-blue)
![License](https://img.shields.io/badge/license-MIT-orange)

Sistem informasi berbasis **Web & Mobile** untuk mendukung operasional UMKM Warung Makan Fina Berry. Sistem ini menggantikan proses manual (buku menu & catatan kertas) dengan digitalisasi menu, pemesanan via QR Code, dan manajemen bahan baku terintegrasi.

---

## 👥 Tim Pengembang — Kelompok 6

| Nama | NIM | Peran |
|------|-----|-------|
| Aisma Haidy Putri Berry Ani Nur Rizeki | 20241320001 | 📋 Project Manager |
| Lulu Aeni Salsabila | 20241320008 | 🔍 System Analyst |
| Sobur | 20241320046 | 🎨 Frontend Developer |
| M. Fajar | 20241320042 | ⚙️ Backend Developer 1 |
| M. Fauzi Akbar Rafsanjani | 20241320022 | ⚙️ Backend Developer 2 |
| M. Abdul Azis | 20241320033 | 🧪 QA & Testing |

> Program Studi Sistem Informasi — Fakultas Ilmu Komputer dan Sistem Informasi  
> Universitas Kebangsaan Republik Indonesia, 2026

---

## 📖 Deskripsi Proyek

Warung Makan Fina Berry sebelumnya mengandalkan buku menu fisik dan pencatatan pesanan secara manual, yang rentan terhadap kesalahan dan tidak efisien. Sistem ini hadir untuk:

- ✅ Menyajikan **menu digital** yang dapat diakses pelanggan via scan QR Code
- ✅ Memungkinkan **pemesanan online** langsung dari meja
- ✅ Mengelola **stok bahan baku** secara otomatis
- ✅ Menyediakan **laporan operasional** harian

---

## 🚀 Fitur Utama

| Fitur | Deskripsi | Prioritas |
|-------|-----------|-----------|
| 🔐 Login | Autentikasi admin & kasir | Tinggi |
| 📱 Menu Digital (QR Code) | Pelanggan scan QR → lihat menu tanpa login | Tinggi |
| 🛒 Pemesanan | Pilih menu, tentukan jumlah, hitung total otomatis | Tinggi |
| 🥩 Manajemen Bahan Baku | CRUD bahan baku + pantau stok | Tinggi |
| 🍽️ Manajemen Menu | CRUD menu makanan & minuman | Tinggi |
| 📉 Pengurangan Stok Otomatis | Stok berkurang saat pesanan masuk | Tinggi |
| 📊 Laporan | Laporan pesanan & penggunaan bahan baku | Sedang |

---

## 🛠️ Tech Stack

```
Frontend (Mobile)  : Flutter
Frontend (Web)     : Web Browser
Backend            : Laravel (PHP)
Database           : MySQL
API                : REST API (HTTP/HTTPS, JSON)
Autentikasi        : JWT
```

### Arsitektur Sistem

```
[Pelanggan]          [Kasir]           [Admin/Pemilik]
Flutter/QR Code   Web Browser         Web Browser
      |                |                    |
      └────────────────┴────────────────────┘
                       |
              REST API (HTTPS/JSON)
                       |
              ┌────────────────┐
              │  Laravel Backend│
              │  ├ Auth         │
              │  ├ Menu         │
              │  ├ Pesanan      │
              │  ├ Bahan Baku   │
              │  └ Laporan      │
              └────────┬───────┘
                       │ Eloquent ORM
              ┌────────────────┐
              │   MySQL DB     │
              │ menu | pesanan │
              │ bahan_baku     │
              │ pengguna       │
              └────────────────┘
```

---

## 👤 Hak Akses Pengguna

| Role | Akses |
|------|-------|
| **Admin / Pemilik** | Full access — kelola menu, bahan baku, pesanan, laporan |
| **Karyawan / Kasir** | Kelola pesanan, lihat menu |
| **Pelanggan** | Lihat menu & buat pesanan (tanpa login) |

---

## 🗄️ Struktur Database

Tabel utama dalam sistem:

- **`pengguna`** — id, username, password, role, created_at
- **`menu`** — id, nama_menu, harga, deskripsi, gambar, kategori, tersedia
- **`pesanan`** — id, pengguna_id, nomor_meja, total_harga, status, tanggal
- **`detail_pesanan`** — id, pesanan_id, menu_id, jumlah, subtotal
- **`bahan_baku`** — id, nama_bahan, stok, satuan, stok_minimum
- **`menu_bahan`** — menu_id, bahan_baku_id, jumlah_dibutuhkan, satuan

---

## ⚙️ Kebutuhan Non-Fungsional

| Aspek | Target |
|-------|--------|
| Waktu respons halaman | ≤ 3 detik |
| Waktu proses pemesanan | ≤ 2 detik |
| Waktu tampil laporan | ≤ 5 detik |
| Pengguna simultan | Minimal 5 tanpa degradasi |
| Keamanan | HTTPS + password terenkripsi + role-based access |
| Bahasa antarmuka | Bahasa Indonesia |
| Format mata uang | Rupiah (Rp) |
| Zona waktu | WIB (UTC+7) |

---

## 📋 Batasan Sistem

- ❌ Tidak mencakup fitur pembayaran online terintegrasi
- ❌ Tidak terintegrasi dengan platform delivery pihak ketiga
- ❌ Hanya untuk satu UMKM (tidak multi-cabang)
- ✅ Tersedia pilihan metode pembayaran: QRIS, Cash, Debit/Credit Card (diproses manual)

---

## 🚦 Cara Penggunaan (Alur Pemesanan)

```
1. Pelanggan scan QR Code di meja
         ↓
2. Sistem tampilkan menu digital (nama, harga, gambar)
         ↓
3. Pelanggan pilih menu & jumlah → masukkan keranjang
         ↓
4. Konfirmasi pesanan → sistem hitung total harga
         ↓
5. Sistem cek stok bahan baku
         ↓
6. Pesanan tersimpan di DB → stok bahan baku berkurang otomatis
         ↓
7. Admin/Kasir terima notifikasi pesanan baru di dashboard
         ↓
8. Proses di dapur → update status selesai
```

---

## 📁 Struktur Repositori (Rencana)

```
fina-berry/
├── frontend-mobile/        # Flutter app (Sobur)
│   ├── lib/
│   └── pubspec.yaml
├── frontend-web/           # Web admin dashboard (Sobur)
│   └── ...
├── backend/                # Laravel API (M. Fajar & M. Fauzi)
│   ├── app/
│   │   ├── Http/Controllers/
│   │   │   ├── AuthController.php
│   │   │   ├── MenuController.php
│   │   │   ├── PesananController.php
│   │   │   └── BahanBakuController.php
│   │   ├── Models/
│   │   └── Services/
│   ├── routes/api.php
│   └── database/migrations/
├── docs/                   # Dokumentasi (Aisma & Lulu)
│   ├── SRS.pdf
│   ├── API_docs.md
│   └── user_manual.md
├── tests/                  # Test cases (Azis)
│   ├── Unit/
│   └── Feature/
└── README.md
```

---

## 📌 API Endpoints (Ringkasan)

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| POST | `/api/login` | Login admin/kasir | ❌ |
| GET | `/api/menu` | Ambil daftar menu | ❌ |
| POST | `/api/pesanan` | Buat pesanan baru | ❌ |
| GET | `/api/pesanan` | List semua pesanan | ✅ |
| PUT | `/api/pesanan/{id}/status` | Update status pesanan | ✅ |
| GET | `/api/bahan-baku` | List bahan baku | ✅ |
| POST | `/api/bahan-baku` | Tambah bahan baku | ✅ |
| PUT | `/api/bahan-baku/{id}` | Edit bahan baku | ✅ |
| DELETE | `/api/bahan-baku/{id}` | Hapus bahan baku | ✅ |
| GET | `/api/laporan` | Ambil data laporan | ✅ |

> ✅ = Butuh autentikasi JWT &nbsp;&nbsp; ❌ = Publik (tanpa login)

---

## 📦 Instalasi & Setup

### Prasyarat
- PHP >= 8.1
- Composer
- MySQL
- Flutter SDK
- Node.js (untuk web build)

### Backend (Laravel)
```bash
git clone https://github.com/username/fina-berry.git
cd backend

composer install
cp .env.example .env
php artisan key:generate

# Konfigurasi database di .env
php artisan migrate --seed
php artisan serve
```

### Frontend Mobile (Flutter)
```bash
cd flutter_application_finna_berry
flutter pub get
flutter run
```

---

## 📝 Dokumentasi

- 📄 [Software Requirements Specification (SRS)](docs/SRS.pdf)
- 📘 User Manual — *coming soon*
- 🔌 API Documentation — *coming soon*

---

## 📅 Item TBD (To Be Determined)

| ID | Item | PIC | Target |
|----|------|-----|--------|
| TBD-001 | Desain UI final | Sobur | Sebelum implementasi |
| TBD-002 | Teknologi frontend final | Sobur | Awal pengembangan |
| TBD-003 | Detail fitur laporan | Seluruh tim | Sebelum implementasi |
| TBD-004 | Mekanisme backup data | M. Fajar / M. Fauzi | Sebelum deployment |
| TBD-005 | Struktur detail database akhir | M. Fajar / M. Fauzi | Sebelum implementasi |
| TBD-006 | Desain & penempatan QR Code | Seluruh tim | Sebelum uji coba |

---

## 🤝 Kontribusi

Repositori ini dikembangkan untuk keperluan Tugas Besar Mata Kuliah **Rekayasa Sistem Informasi**, Program Studi Sistem Informasi, FIKSI — Universitas Kebangsaan Republik Indonesia.

---

*© 2026 Kelompok 6 — Sistem Informasi UKRI*
---
*Developed for Warung Fina Berry.*
