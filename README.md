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

Sistem informasi berbasis **Mobile** yang dirancang secara khusus untuk mendukung dan mengoptimalkan seluruh operasional UMKM Warung Makan Fina Berry. Sistem terpadu ini hadir sebagai solusi transformasi digital yang menggantikan proses manual tradisional (seperti penggunaan buku menu fisik dan pencatatan pesanan di atas kertas) menjadi proses terdigitalisasi yang efisien. Fokus utamanya mencakup digitalisasi menu, sistem pemesanan langsung melalui aplikasi mobile, serta manajemen bahan baku yang terintegrasi secara langsung dengan setiap pesanan yang masuk.

---

## 👥 Tim Pengembang — Kelompok 6

| Nama | NIM | Peran | LinkedIn / Keterangan |
|------|-----|-------|-----------------------|
| Aisma Haidy Putri Berry Ani Nur Rizeki | 20241320001 | 📋 Project Manager | [LinkedIn](https://www.linkedin.com/in/aisma-haidy-putri-berry-ani-nur-rizeki-834b7b422/) |
| Lulu Aeni Salsabila | 20241320008 | 🔍 System Analyst | [LinkedIn](https://www.linkedin.com/in/lulu-aeni-salsabila-3b6609422/) |
| Sobur | 20241320046 | 🎨 Frontend Developer & AI Chatbot Dev | [LinkedIn](https://www.linkedin.com/in/sobur344) |
| M. Fajar | 20241320042 | ⚙️ Backend Developer 1 | [LinkedIn](https://www.linkedin.com/in/muhammad-fajar-b237763a5) |
| M. Fauzi Akbar Rafsanjani | 20241320022 | ⚙️ Backend Developer 2 | - |
| M. Abdul Azis | 20241320033 | 🧪 QA & Testing | [LinkedIn](https://www.linkedin.com/in/muhammad-abdul-azis-97208a423) |
| **Gemini AI (Antigravity)** | - | 🤖 AI Coding Assistant | Pendamping *Pair Programming* & Dokumentasi |

> Program Studi Sistem Informasi — Fakultas Ilmu Komputer dan Sistem Informasi  
> Universitas Kebangsaan Republik Indonesia, 2026

---

## 📖 Deskripsi Proyek secara Mendetail

Sebelum adanya sistem ini, Warung Makan Fina Berry mengandalkan metode konvensional berupa buku menu fisik yang dicetak dan pencatatan pesanan secara manual oleh pelayan. Metode ini memiliki banyak kelemahan: rentan terhadap *human error* (salah catat), lambat dalam proses pelayanan saat ramai, dan sulitnya melacak stok bahan baku harian secara *real-time*.

Proyek **Sistem Optimasi Produksi dan Manajemen Pesanan** ini diinisiasi untuk memecahkan permasalahan tersebut melalui digitalisasi. Tujuan utama dari sistem ini adalah:

1. **Efisiensi Pemesanan**: Mengurangi waktu tunggu pelanggan dan meminimalisir kesalahan pesanan dengan fitur pemesanan mandiri melalui aplikasi mobile yang mudah diakses (Self-Service).
2. **Optimalisasi Manajemen Stok**: Memberikan kemudahan bagi pihak warung untuk memantau ketersediaan bahan baku secara akurat. Setiap pesanan yang masuk akan otomatis memotong stok bahan baku yang sesuai, mencegah terjadinya kehabisan stok saat pelanggan sudah memesan.
3. **Kemudahan Pelaporan**: Mendukung pengambilan keputusan bisnis melalui fitur laporan yang menyajikan data penjualan dan penggunaan bahan baku harian maupun bulanan secara otomatis.

---

## 🚀 Fitur Utama & Fungsionalitas

Berikut adalah penjelasan detail dari masing-masing fitur unggulan yang tersedia:

| Fitur | Deskripsi Detail | Prioritas |
|-------|------------------|-----------|
| 🔐 **Autentikasi (Login)** | Sistem keamanan berjenjang menggunakan JWT (JSON Web Token) untuk membedakan akses antara Admin (Pemilik) dan Kasir. | Tinggi |
| 📱 **Menu Digital (Aplikasi Mobile)** | Pelanggan membuka aplikasi, melihat **Loading Screen** beranimasi dengan branding Fina Berry, lalu menekan tombol **"Masuk ke Menu"** untuk langsung mengakses katalog menu digital interaktif tanpa perlu registrasi atau login. | Tinggi |
| 🛒 **Sistem Pemesanan Interaktif** | Pelanggan dapat memilih makanan/minuman, menyesuaikan kuantitas (jumlah pesanan), dan melihat total harga yang harus dibayar secara otomatis sebelum pesanan dikirim ke kasir/dapur. | Tinggi |
| 🥩 **Manajemen Bahan Baku Terintegrasi** | Admin dapat melakukan CRUD (Create, Read, Update, Delete) data bahan baku. Sistem juga melacak *stok minimum* dan akan memberikan peringatan jika stok hampir habis. | Tinggi |
| 🍽️ **Manajemen Katalog Menu** | Admin memiliki akses penuh untuk menambah menu baru, mengubah harga, memperbarui foto hidangan, atau menonaktifkan menu sementara apabila bahan bakunya sedang kosong. | Tinggi |
| 📉 **Pengurangan Stok Otomatis** | Merupakan fitur *core*. Saat pelanggan mengonfirmasi pesanan, sistem secara di balik layar (backend) menghitung komposisi resep dan mengurangi jumlah stok bahan baku terkait dari database secara akurat. | Tinggi |
| 🤖 **AI Chatbot Assistant** | Fitur asisten virtual pintar terintegrasi yang dikembangkan **sepenuhnya oleh Sobur** untuk melayani pertanyaan pelanggan seputar menu, jam operasional, atau rekomendasi makanan secara real-time. | Tinggi |
| 📊 **Laporan & Analitik** | Dashboard yang menyajikan grafik dan ringkasan data penjualan harian/bulanan, menu paling laris, serta rekapan penggunaan bahan baku untuk mempermudah evaluasi operasional. | Sedang |

---

## 🛠️ Tech Stack & Arsitektur

Teknologi yang digunakan dipilih berdasarkan skalabilitas, kecepatan pengembangan, dan kemudahan pemeliharaan:

- **Frontend (Mobile)**: Flutter (Dart) — Digunakan untuk membuat aplikasi kasir dan antarmuka yang sangat responsif, berjalan lancar di berbagai perangkat Android/iOS.
- **Frontend (Mobile)**: Flutter (Dart) — Digunakan untuk membuat aplikasi pelanggan (dengan loading screen & tombol masuk) dan antarmuka kasir yang responsif.
- **Backend API**: Laravel (PHP) — Framework handal dan matang untuk menangani logika bisnis yang kompleks, manajemen autentikasi (Sanctum/JWT), dan ORM (Eloquent).
- **Database**: MySQL — Sistem manajemen basis data relasional yang stabil untuk menyimpan data berelasi dengan kuat (seperti transaksi pesanan dan relasi menu dengan bahan baku).
- **AI Chatbot**: Google Gemini API (Generative AI) — Diintegrasikan ke Flutter oleh Sobur.
- **Komunikasi Data**: REST API menggunakan format standar JSON.

### Arsitektur Sistem Terdistribusi

```text
[Pelanggan]                      [Kasir]                        [Admin/Pemilik]
Aplikasi Flutter (Loading Screen) Aplikasi Flutter (Mobile/Web)  Dashboard Admin (Web)
       |                          |                               |
       └──────────────────────────┴───────────────────────────────┘
                                  |
                      HTTP / HTTPS Requests (REST API JSON)
                                  |
                        ┌────────────────────────┐
                        │   Laravel Backend API  │
                        │                        │
                        │ 🔑 Middleware (Auth)   │
                        │ 🍛 Menu Controller     │
                        │ 🛒 Pesanan Controller  │
                        │ 📦 Bahan Baku logic    │
                        │ 📈 Reporting Service   │
                        └──────────┬─────────────┘
                                   │ Eloquent ORM (Query)
                        ┌────────────────────────┐
                        │   Database (MySQL)     │
                        │                        │
                        │ 📄 Tabel Pengguna      │
                        │ 📄 Tabel Menu          │
                        │ 📄 Tabel Pesanan       │
                        │ 📄 Tabel Bahan Baku    │
                        │ 📄 Tabel Menu_Bahan    │
                        └────────────────────────┘
```

---

## 👤 Hak Akses Pengguna (Role-Based Access)

Sistem menerapkan RBAC (Role-Based Access Control) yang ketat:

1. **Admin / Pemilik Warung**
   - **Hak Akses**: Penuh (Super Admin).
   - **Kemampuan**: Dapat menambah/menghapus menu, mengelola inventaris bahan baku, melihat semua laporan penjualan, mengelola akun kasir, dan mengubah pengaturan sistem.
2. **Karyawan / Kasir**
   - **Hak Akses**: Terbatas pada operasional harian.
   - **Kemampuan**: Menerima pesanan yang masuk, mengubah status pesanan (misal: "Diproses" menjadi "Selesai"), membatalkan pesanan jika perlu, dan menerima pembayaran.
3. **Pelanggan**
   - **Hak Akses**: Publik / *Guest*.
   - **Kemampuan**: Hanya dapat melihat daftar menu yang tersedia (Katalog Digital), membuat pesanan baru dari meja, dan melihat total tagihan. Tidak memerlukan akun atau login.

---

## 🗄️ Struktur Database (Relasi Entitas)

Penjelasan mendalam tabel utama dalam sistem:

- **`pengguna`**: Menyimpan kredensial Admin dan Kasir. Kolom: `id`, `username`, `password` (hashed), `role`, `created_at`.
- **`menu`**: Daftar hidangan dan minuman. Kolom: `id`, `nama_menu`, `harga`, `deskripsi`, `gambar_url`, `kategori` (Makanan/Minuman/Snack), `is_tersedia` (Boolean).
- **`pesanan`**: Mencatat setiap transaksi. Kolom: `id`, `pengguna_id` (jika dibuat oleh kasir, null jika oleh pelanggan), `nomor_meja`, `total_harga`, `status` (Menunggu/Diproses/Selesai/Batal), `waktu_pesan`.
- **`detail_pesanan`**: Rincian item dalam satu transaksi. Kolom: `id`, `pesanan_id` (Foreign Key), `menu_id` (Foreign Key), `jumlah_pesanan`, `subtotal_harga`.
- **`bahan_baku`**: Inventaris bahan mentah. Kolom: `id`, `nama_bahan`, `stok_saat_ini`, `satuan` (kg, gram, liter, pcs), `batas_stok_minimum`.
- **`menu_bahan` (Tabel Pivot/Junction)**: Menyimpan resep (Berapa banyak bahan baku X untuk membuat menu Y). Kolom: `menu_id`, `bahan_baku_id`, `jumlah_dibutuhkan`. *Sangat penting untuk fitur pengurangan stok otomatis.*

---

## ⚙️ Kebutuhan Non-Fungsional (Kinerja & Keamanan)

Sistem harus memenuhi standar operasi berikut untuk memastikan kenyamanan pengguna:

| Kriteria | Parameter Target | Keterangan |
|----------|------------------|------------|
| **Kinerja Halaman** | Waktu muat (Load Time) ≤ 3 detik | Berlaku baik saat kondisi sinyal pelanggan 4G/Wifi maupun 3G (diusahakan aset ter-optimasi). |
| **Kinerja Transaksi** | Respons simpan pesanan ≤ 2 detik | Mencegah pelanggan menekan tombol 'Pesan' berulang kali. |
| **Konkurensi** | Minimal 50 pelanggan bersamaan | Harus mampu menangani pesanan di jam sibuk (jam makan siang/malam) tanpa *server down*. |
| **Keamanan** | Enkripsi Hash, JWT Auth | Password disimpan dengan metode *hashing* yang aman. Sesi menggunakan JSON Web Token (kedaluwarsa otomatis). |
| **Lokalisasi** | Bahasa Indonesia, Mata Uang IDR | Seluruh UI/UX dirancang agar mudah dipahami masyarakat Indonesia, nominal format 'Rp 10.000'. |
| **Zona Waktu** | WIB (UTC+7) | Memastikan pencatatan laporan harian akurat sesuai jam buka warung. |

---

## 📋 Batasan Sistem (Scope of Limitations)

Untuk menjaga fokus pengembangan di tahap ini (MVP / Minimum Viable Product), sistem **TIDAK** mencakup:

- ❌ **Integrasi Platform Delivery**: Tidak terhubung langsung dengan aplikasi GrabFood, GoFood, atau ShopeeFood.
- ❌ **Sistem Multi-Cabang**: Sistem ini dirancang *single-tenant* (hanya untuk 1 lokasi warung).

### ✅ Metode Pembayaran yang Didukung

| Metode | Keterangan | Status |
|--------|------------|--------|
| 💳 **Midtrans** | Pembayaran digital terintegrasi via Payment Gateway Midtrans (transfer bank, e-wallet, QRIS, kartu kredit, dll.) | ✅ Terintegrasi |
| 💵 **Tunai (Cash)** | Pelanggan membayar langsung kepada kasir menggunakan uang tunai | ✅ Tersedia |
| 💳 **Debit Card** | Pelanggan membayar menggunakan kartu debit melalui mesin EDC di kasir | ✅ Tersedia |

---

## 🚦 Alur Sistem Terperinci (Customer Journey)

Berikut adalah perjalanan pengguna (pelanggan) mulai dari membuka aplikasi hingga selesai memesan:

1. **Loading Screen**: Pelanggan membuka aplikasi Flutter Fina Berry di smartphone. Tampil **Loading Screen** beranimasi dengan logo dan branding Warung Fina Berry selama proses inisialisasi aplikasi.
2. **Masuk Aplikasi**: Setelah loading selesai, pelanggan menekan tombol **"Masuk ke Menu"** (atau tombol serupa) untuk masuk ke halaman utama katalog menu.
3. **Browsing Menu**: Pelanggan melihat daftar menu digital lengkap dengan gambar, nama, kategori, deskripsi, dan harga setiap hidangan.
4. **Cart (Keranjang)**: Pelanggan memilih "Nasi Goreng" (2 porsi) dan "Es Teh" (2 gelas). Item masuk ke keranjang digital. Sistem menampilkan subtotal tagihan secara otomatis.
5. **Checkout**: Pelanggan menekan tombol "Kirim Pesanan" untuk mengonfirmasi.
6. **Proses Backend**:
   - Sistem membaca *Cart* dan menyimpannya ke tabel `pesanan` dan `detail_pesanan`.
   - *Logic* otomatis bekerja: Nasi Goreng butuh Nasi (200gr), Ayam (50gr). Sistem akan mengupdate tabel `bahan_baku` dengan mengurangi jumlah tersebut secara akurat.
7. **Notifikasi**: Di meja kasir / dapur, perangkat yang menjalankan aplikasi akan memunculkan pesanan baru dan memberikan notifikasi.
8. **Penyajian**: Dapur memasak, pesanan disajikan, kasir menekan tombol "Pesanan Selesai" di sistem.
9. **Pembayaran**: Pelanggan membayar tagihan langsung di kasir (tunai/QRIS manual).

---

## 🤖 Fitur AI Chatbot Assistant — Dikembangkan Sepenuhnya oleh Sobur

Salah satu fitur unggulan dan inovatif dari sistem ini adalah **AI Chatbot Assistant**, sebuah asisten virtual cerdas yang terintegrasi langsung ke dalam antarmuka aplikasi Flutter. Fitur ini **sepenuhnya dirancang, dibangun, dan diimplementasikan oleh Sobur** (Frontend Developer & AI Chatbot Dev) sebagai nilai tambah inovatif untuk pengalaman pelanggan Warung Fina Berry.

### 🎯 Apa Itu Fitur Ini?

AI Chatbot adalah antarmuka percakapan (*conversational interface*) berbasis kecerdasan buatan yang memungkinkan pelanggan berinteraksi dengan warung secara alami menggunakan bahasa sehari-hari — tanpa perlu menavigasi menu atau menekan tombol secara manual. Cukup ketik pertanyaan, dan chatbot akan menjawab secara instan dan akurat.

### 💬 Kemampuan AI Chatbot

| Kemampuan | Contoh Pertanyaan Pelanggan | Respons Chatbot |
|-----------|----------------------------|-----------------|
| 🍛 **Rekomendasi Menu** | *"Ada menu apa yang paling enak?"* | Merekomendasikan menu terlaris berdasarkan data penjualan real-time dari database. |
| 💰 **Informasi Harga** | *"Berapa harga Nasi Goreng Spesial?"* | Menampilkan harga dan deskripsi menu secara akurat langsung dari database. |
| 📦 **Cek Ketersediaan** | *"Apakah Ayam Bakar masih tersedia?"* | Mengecek status `is_tersedia` dari tabel menu di database secara langsung dan real-time. |
| 🕐 **Jam Operasional** | *"Warung buka jam berapa?"* | Menjawab informasi operasional yang sudah dikonfigurasi oleh Admin. |
| 🛒 **Bantu Pemesanan** | *"Saya mau pesan 2 Mie Ayam"* | Membantu pelanggan menambahkan item ke keranjang pesanan langsung dari jendela obrolan. |
| 🌶️ **Filter Preferensi** | *"Apakah ada menu yang tidak pedas?"* | Memfilter menu berdasarkan kategori atau tag yang sudah dikonfigurasi oleh Admin. |
| 🎁 **Info Promo** | *"Ada promo hari ini tidak?"* | Menampilkan informasi promo atau diskon yang aktif sesuai konfigurasi Admin. |

### 🧠 Teknologi AI yang Digunakan

```text
Model AI      : Google Gemini API (Generative AI — Gemini 1.5 Flash / Pro)
Integrasi     : Dart package: google_generative_ai
Konteks Data  : Daftar menu aktif + stok real-time dari REST API Laravel
                (diambil sebelum setiap sesi chat dimulai)
UI Component  : Flutter Custom Widget (ChatBubble, TypingIndicator, MenuCard)
State Mgmt    : Provider / Riverpod (implementasi Sobur)
```

### 🔄 Alur Kerja Lengkap AI Chatbot

```text
[1] Pelanggan membuka tab "Chat" di aplikasi Flutter (Sobur's UI)
         ↓
[2] Sistem otomatis mengambil data menu terbaru dari REST API
    GET /api/menu → daftar menu, harga, dan status ketersediaan
         ↓
[3] Data menu diproses menjadi System Prompt Context untuk Gemini
    "Kamu adalah asisten Warung Fina Berry. Berikut menu kami: ..."
         ↓
[4] Pelanggan mengetik pertanyaan, misal: "Ada menu apa yang murah?"
         ↓
[5] Flutter mengirim: {systemPrompt + riwayat chat + pertanyaan baru}
    ke Google Gemini API
         ↓
[6] Gemini AI memproses dan menghasilkan respons bahasa natural Indonesia
         ↓
[7] Respons ditampilkan di UI chat (animasi gelembung + typing indicator)
         ↓
[8] (Opsional) Jika intent pemesanan terdeteksi →
    Chatbot memunculkan tombol "Tambah ke Keranjang" di dalam chat
```

### 🧩 Integrasi dengan Sistem Utama

AI Chatbot tidak berdiri sendiri — ia terintegrasi penuh dengan seluruh ekosistem aplikasi:

- **Membaca Data Menu Real-time**: Chatbot mengambil data menu terkini via `GET /api/menu` setiap sesi chat dibuka, memastikan info harga dan ketersediaan selalu akurat.
- **Verifikasi Stok Langsung**: Sebelum merekomendasikan menu, chatbot memverifikasi field `is_tersedia` untuk menghindari menyarankan menu yang sedang habis.
- **Intent-Based Action**: Jika chatbot mendeteksi niat memesan dari percakapan, sistem secara otomatis memunculkan *action button* untuk menambahkan item ke keranjang tanpa keluar dari jendela chat.
- **System Prompt Terkonfigurasi**: Admin dapat mengkonfigurasi informasi tambahan (jam buka, nomor kontak, info promo aktif) melalui dashboard, yang akan otomatis digunakan chatbot sebagai konteks pengetahuan dasarnya.

### 📌 Endpoint API Terkait Chatbot

| Method | Endpoint | Fungsi |
|--------|----------|--------|
| `GET` | `/api/menu` | Mengambil seluruh data menu aktif sebagai konteks pengetahuan chatbot |
| `GET` | `/api/chatbot/config` | Mengambil konfigurasi chatbot dari Admin (jam buka, promo, info warung) |
| `POST` | `/api/chatbot/log` | *(Opsional)* Menyimpan log percakapan ke DB untuk analisis dan peningkatan chatbot |

### 🎨 Desain UI/UX Chatbot (Dibuat oleh Sobur)

Antarmuka chat dirancang dari nol oleh Sobur dengan prinsip desain modern dan sangat intuitif:

- 💬 **Chat Bubble**: Gelembung pesan yang bersih dan modern — warna berbeda untuk pesan pelanggan vs respons AI.
- ✨ **Typing Indicator**: Animasi tiga titik bergerak yang ditampilkan saat Gemini AI sedang memproses jawaban — memberikan nuansa percakapan yang hidup.
- 🖼️ **Rich Message Card**: Saat chatbot merekomendasikan hidangan, ia menampilkan kartu interaktif bergambar menu, nama, dan harga — bukan sekadar teks biasa.
- 🛒 **Quick-Add Button**: Tombol "Tambah ke Keranjang" muncul langsung di dalam bubble chat untuk kemudahan pemesanan instan.
- 🌙 **Dark Mode Support**: Antarmuka chat mendukung tema gelap secara penuh, konsisten dengan desain keseluruhan aplikasi Flutter.

> 💡 **Catatan Pengembang (Sobur)**: Fitur AI Chatbot ini merupakan kontribusi ekstra inovatif di luar scope awal proyek, yang bertujuan untuk meningkatkan nilai teknologi sistem dan memberikan pengalaman pelanggan kelas dunia pada UMKM Fina Berry. Seluruh implementasi mulai dari desain UI, integrasi API Gemini, hingga logika pengambilan konteks dikerjakan mandiri oleh Sobur.

---

## 📁 Struktur Repositori Terpadu

Repositori ini menggunakan pendekatan *Monorepo* atau terstruktur per direktori untuk memudahkan pengerjaan tim:

```text
fina-berry-project/
├── frontend-mobile/        # Kode sumber Aplikasi Flutter (UI Mobile/Kasir) [Sobur]
│   ├── lib/
│   │   ├── pages/          # Halaman utama (Menu, Keranjang, Chatbot, dll.)
│   │   ├── widgets/        # Komponen reusable (ChatBubble, MenuCard, dll.)
│   │   ├── services/       # API Client & Gemini AI Integration (Sobur)
│   │   └── providers/      # State Management
│   ├── assets/             # Gambar, Icon, Font
│   └── pubspec.yaml        # Konfigurasi dependensi Flutter
│
├── frontend-web/           # Portal Web / Dashboard Admin (Opsional) [Sobur]
│
├── backend/                # API Engine dibangun dengan Laravel (PHP) [M. Fajar & M. Fauzi]
│   ├── app/Http/
│   │   ├── Controllers/    # Business Logic (Pesanan, Menu, Bahan Baku, Chatbot Config)
│   │   └── Middleware/     # Verifikasi JWT dan Role Akses
│   ├── routes/             # api.php untuk deklarasi semua endpoints
│   └── database/           # Migrations & Seeders (struktur dan data awal MySQL)
│
├── docs/                   # Sentralisasi Dokumen Proyek [Aisma & Lulu]
│   ├── SRS.pdf             # Kebutuhan Fungsional lengkap
│   ├── API_docs.md         # Kontrak API untuk Frontend & Backend
│   └── user_manual.md      # Panduan penggunaan untuk Pemilik Warung
│
├── tests/                  # Skrip Pengujian Mutu (QA) [M. Abdul Azis]
│   ├── Unit/
│   └── Feature/
│
└── README.md               # Anda sedang membaca file ini
```

---

## 📌 Dokumentasi API Endpoints (Ringkasan Detail)

*(Untuk dokumentasi penuh, silakan lihat file `docs/API_docs.md` nantinya)*

| HTTP Method | Endpoint | Tujuan & Fungsi | Role Akses | Status Auth |
|-------------|----------|-----------------|------------|-------------|
| `POST` | `/api/login` | Memvalidasi kredensial pengguna, mengembalikan JWT Token | Admin / Kasir | ❌ Public |
| `GET` | `/api/menu` | Mengambil semua daftar menu aktif (juga digunakan chatbot) | Semua | ❌ Public |
| `POST` | `/api/pesanan` | Menyimpan transaksi baru dari pelanggan ke DB (termasuk potong stok) | Semua | ❌ Public |
| `GET` | `/api/pesanan` | Kasir mengambil antrean pesanan masuk dan riwayatnya | Admin / Kasir | ✅ Bearer Token |
| `PUT` | `/api/pesanan/{id}/status` | Kasir/Admin mengupdate pesanan menjadi "Diproses" atau "Selesai" | Admin / Kasir | ✅ Bearer Token |
| `GET` | `/api/bahan-baku` | Mengambil status jumlah stok bahan baku mentah saat ini | Admin | ✅ Bearer Token |
| `POST` | `/api/bahan-baku` | Menambahkan inventaris bahan mentah baru (contoh: Cabai Rawit) | Admin | ✅ Bearer Token |
| `GET` | `/api/laporan/harian` | Menghasilkan rekap data total pendapatan dan pesanan hari ini | Admin | ✅ Bearer Token |
| `GET` | `/api/chatbot/config` | Mengambil konfigurasi konteks warung untuk AI Chatbot | Publik | ❌ Public |
| `POST` | `/api/chatbot/log` | Menyimpan log percakapan AI Chatbot untuk analisis Admin | Admin | ✅ Bearer Token |

---

## 📦 Panduan Instalasi & Setup Lingkungan Pengembangan

Ikuti panduan berikut untuk menjalankan proyek di komputer lokal (Localhost).

### Persiapan Perangkat Lunak (Prerequisites)
Pastikan sistem operasi Anda sudah terinstal:
- PHP versi 8.1 atau terbaru.
- Composer (Package Manager untuk PHP).
- MySQL Server (Bisa menggunakan XAMPP/Laragon).
- Flutter SDK (Versi stable terbaru).
- Node.js (Diperlukan jika Frontend Web akan di-build).

### 1. Instalasi Backend (Laravel API)
Jalankan perintah ini di terminal:
```bash
# Clone repositori
git clone https://github.com/username/fina-berry.git

# Masuk ke folder backend
cd fina-berry/backend

# Instalasi dependensi PHP
composer install

# Salin file environment
cp .env.example .env

# Generate Key aplikasi Laravel
php artisan key:generate
```

**Konfigurasi Database Backend:**
1. Buka file `.env`.
2. Sesuaikan konfigurasi ini dengan MySQL lokal Anda (misalnya Laragon):
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=db_fina_berry
   DB_USERNAME=root
   DB_PASSWORD=
   ```
3. Lanjutkan di terminal:
   ```bash
   # Buat tabel dan isi dengan data contoh (dummy data)
   php artisan migrate --seed

   # Nyalakan server lokal Laravel
   php artisan serve
   # API akan berjalan di http://localhost:8000
   ```

### 2. Instalasi Frontend Flutter (oleh Sobur)
Buka tab terminal baru:
```bash
# Masuk ke folder aplikasi flutter
cd fina-berry/flutter_application_finna_berry

# Unduh semua dependensi Dart (termasuk google_generative_ai)
flutter pub get

# Jalankan aplikasi (pilih device: Chrome untuk Web, atau Emulator Android)
flutter run
```

**Konfigurasi AI Chatbot (Sobur):**
1. Dapatkan API Key dari [Google AI Studio](https://aistudio.google.com/).
2. Buka file konfigurasi di `lib/services/chatbot_service.dart`.
3. Masukkan API Key Anda:
   ```dart
   const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
   ```

*Catatan: Pastikan mengubah variabel URL API di kode Flutter agar mengarah ke `http://localhost:8000/api` atau alamat IP lokal komputer jika diuji via HP sungguhan.*

---

## 📝 Referensi Dokumentasi

Dokumen penting terkait proyek ini dapat diakses pada tautan berikut:
- 📄 [Software Requirements Specification (SRS)](docs/SRS.pdf) — Dokumen spesifikasi resmi dari Analis Sistem.
- 📘 **User Manual** — *Tahap Penyusunan (Coming Soon)*
- 🔌 **API Documentation (Postman Collection)** — *Tahap Penyusunan (Coming Soon)*

---

## 📅 Rencana Kerja & Item TBD (To Be Determined)

Daftar aspek yang masih dalam tahap diskusi dan finalisasi oleh tim:

| ID | Fokus Tugas | Penanggung Jawab | Tenggat Waktu | Status |
|----|-------------|------------------|---------------|--------|
| TBD-001 | Finalisasi mockup desain UI/UX di Figma | Sobur | Sebelum Fase Implementasi | 🔄 Berlangsung |
| TBD-002 | Keputusan rilis Frontend (APK Android vs Web App) | Sobur & PM | Awal Pengembangan | 🔄 Berlangsung |
| TBD-003 | Rincian field data untuk ekspor laporan (Excel/PDF) | Seluruh tim | Sebelum Sprint Backend Laporan | ⏳ Menunggu |
| TBD-004 | Strategi Backup Database otomatis (Cron Job) | M. Fajar / M. Fauzi | Menjelang Deployment (Hosting) | ⏳ Menunggu |
| TBD-005 | Skema penempatan stiker QR Code tahan air di meja | Seluruh tim | Sebelum Testing Lapangan | ⏳ Menunggu |
| TBD-006 | Finalisasi Gemini API Key & prompt engineering chatbot | Sobur | Sebelum Sprint AI Chatbot | 🔄 Berlangsung |

---

## 🤝 Tujuan Kontribusi Akademik

Repositori dan proyek aplikasi ini murni dikembangkan dalam rangka pemenuhan Tugas Besar untuk Mata Kuliah **Rekayasa Sistem Informasi**, yang diampu pada Program Studi Sistem Informasi, Fakultas Ilmu Komputer dan Sistem Informasi (FIKSI) — Universitas Kebangsaan Republik Indonesia.

---

<p align="center">
  <i>© 2026 Kelompok 6 — Sistem Informasi UKRI</i><br>
  <i>Developed with passion for Warung Fina Berry's digital transformation.</i>
</p>
