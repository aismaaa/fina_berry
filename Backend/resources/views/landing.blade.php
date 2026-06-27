<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warung Fina Berry â€“ Cita Rasa Nusantara</title>
    <!-- Menambahkan Favicon (Logo di Tab Browser) -->
    <link rel="icon" href="{{ asset('images/Fina Berry.png') }}" type="image/png">
    <meta name="description" content="Warung Fina Berry, tempat makan khas Indonesia dengan cita rasa autentik. Nikmati bakso, soto, nasi goreng, dan berbagai menu lezat lainnya.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/landing.css?v=' . time()) }}">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="#home" class="nav-logo">
            <img src="{{ asset('images/Fina Berry.png') }}" alt="Warung Fina Berry" class="nav-brand-img">
            <span>Fina Berry</span>
        </a>
        <ul class="nav-links" id="navLinks">
            <li><a href="#home">Beranda</a></li>
            <li><a href="#about">Tentang Kami</a></li>
            <li><a href="#menu">Menu</a></li>
            <li><a href="#gallery">Galeri</a></li>
            <li><a href="#contact">Kontak</a></li>
        </ul>
        <a href="#order" class="btn-order">Pesan Sekarang</a>
        <button class="hamburger" id="hamburger" aria-label="Menu">
            <span></span><span></span><span></span>
        </button>
    </div>
</nav>

<!-- ===== HERO ===== -->
<section class="hero" id="home">
    <div class="hero-bg">
        <img src="{{ asset('images/hero_food.png') }}" alt="Makanan Fina Berry" class="hero-img">
        <div class="hero-overlay"></div>
    </div>
    <div class="hero-content">
        <p class="hero-tag">Warung Fina Berry</p>
        <h1 class="hero-title">Cita Rasa <span class="highlight">Autentik</span><br>Nusantara</h1>
        <p class="hero-desc">Selamat datang di Warung Fina Berry. Kami menyediakan berbagai menu makanan dan minuman dengan cita rasa lezat, harga terjangkau, serta pelayanan yang ramah. Kepuasan pelanggan adalah prioritas utama kami.</p>
        <div class="hero-btns">
            <a href="#menu" class="btn-primary">Lihat Menu</a>
            <a href="#about" class="btn-ghost">Tentang Kami</a>
        </div>
        <div class="hero-stats">
            <div class="stat"><span class="stat-num">500+</span><span class="stat-label">Pelanggan Puas</span></div>
            <div class="stat-divider"></div>
            <div class="stat"><span class="stat-num">20+</span><span class="stat-label">Menu Pilihan</span></div>
            <div class="stat-divider"></div>
            <div class="stat"><span class="stat-num">5â­</span><span class="stat-label">Rating</span></div>
        </div>
    </div>
    <div class="hero-scroll">
        <span>Scroll</span>
        <div class="scroll-line"></div>
    </div>
</section>

<!-- ===== MARQUEE ===== -->
<div class="marquee-wrap">
    <div class="marquee-track">
        <span> Bakso Daging Sapi</span><span>•</span>
        <span> Nasi Goreng</span><span>•</span>
        <span> Soto Ayam</span><span>•</span>
        <span> Ayam Bakar Kampung</span><span>•</span>
        <span> Es Teh Manis</span><span>•</span>
        <span> Tempe Mendoan</span><span>•</span>
        <span> Bakso Spesial</span><span>•</span>
        <span> Nasi Goreng</span><span>•</span>
        <span> Soto Ayam</span><span>•</span>
        <span> Ayam Goreng Kampung</span><span>•</span>
        <span> Lemon Tea</span><span>•</span>
        <span> Jus Alpukat</span><span>•</span>
        <span> Bakso Daging Sapi</span><span>•</span>
        <span> Nasi Goreng</span><span>•</span>
        <span> Soto Ayam</span><span>•</span>
        <span> Ayam Goreng Kampung</span><span>•</span>
        <span> Lemon Tea</span><span>•</span>
        <span> Jus Alpukat</span><span>•</span>
    </div> 
</div>

<!-- ===== ABOUT ===== -->
<section class="about" id="about">
    <div class="container">
        <div class="about-grid">
            <div class="about-img-wrap">
                <img src="{{ asset('images/Fina Berry.png') }}" alt="Warung Fina Berry" class="about-img">
                <div class="about-badge">
                    <span class="badge-num">2012</span>
                    <span class="badge-label">Berdiri Sejak</span>
                </div>
            </div>
            <div class="about-content">
                <p class="section-tag">Tentang Kami</p>
                <h2 class="section-title">Warung Fina Berry <span class="highlight">Rasa Rumahan</span> yang Tak Terlupakan</h2>
                <p class="about-text">Warung Fina Berry berdiri sejak 2012, Warung Fina Berry hadir untuk memberikan pengalaman kuliner terbaik dengan berbagai pilihan menu yang lezat, berkualitas, dan terjangkau. Kami berkomitmen untuk selalu menyajikan makanan dengan bahan terbaik serta pelayanan yang cepat dan ramah.Kami berkomitmen menyajikan masakan Indonesia autentik dengan bahan segar pilihan setiap harinya.</p>
                <p class="about-text">Setiap hidangan kami dimasak dengan penuh cinta dan dedikasi, memastikan setiap suapan membawa kenangan hangat seperti masakan ibu di rumah.</p>
                <div class="about-features">
                    <div class="feature-item"><span class="feature-icon">🌿</span><span>Bahan Segar Setiap Hari</span></div>
                    <div class="feature-item"><span class="feature-icon">👨‍🍳</span><span>Resep Tradisional Autentik</span></div>
                    <div class="feature-item"><span class="feature-icon">💚</span><span>Tanpa Pengawet Buatan</span></div>
                    <div class="feature-item"><span class="feature-icon">⚡</span><span>Proses Cepat & Higienis</span></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== MENU ===== -->
<section class="menu-section" id="menu">
    <div class="container">
        <!-- Rotating Menu Featured Section -->
        <div class="menu-orbit-section">
            <!-- Left Text Content -->
            <div class="menu-orbit-content">
                <p class="menu-orbit-tag">Menu Pilihan</p>
                <h2 class="menu-orbit-title">Eksplorasi<br><span class="highlight-light">Rasa Autentik</span><br>Nusantara</h2>
                <p class="menu-orbit-desc">Setiap hidangan dimasak segar sesuai pesanan dengan resep rahasia keluarga. Rasakan kenikmatan dari berbagai pilihan menu makanan, minuman, hingga cemilan lezat.</p>

                <!-- Menu Info Card (muncul saat klik orbit item) -->
                <div class="orbit-info-card" id="orbitInfoCard">
                    <div class="orbit-info-inner">
                        <div class="orbit-info-badge" id="orbitInfoBadge">Best Seller</div>
                        <h3 class="orbit-info-name" id="orbitInfoName">Bakso Daging Sapi</h3>
                        <p class="orbit-info-desc" id="orbitInfoDesc">Bakso sapi kenyal dengan kuah kaldu gurih, mie, dan topping lengkap — cita rasa autentik yang menggugah selera.</p>
                        <div class="orbit-info-footer">
                            <span class="orbit-info-price" id="orbitInfoPrice">Rp 15.000</span>
                            <span class="orbit-info-rating" id="orbitInfoRating">⭐ 4.9</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Orbiting UI -->
            <div class="menu-orbit-visual">
                <div class="orbit-wrapper">
                    <!-- Main Center Image -->
                    <div class="center-plate">
                        <img id="centerPlateImg" src="{{ asset('images/menu_bakso.png') }}" alt="Main Dish">
                    </div>
                    
                    <!-- Orbit Ring and Items -->
                    <div class="orbit-ring">
                        <!-- Orbit Item 1 -->
                        <div class="orbit-item item-1"
                            data-name="Bakso Daging Sapi"
                            data-desc="Bakso sapi kenyal dengan kuah kaldu gurih, mie, dan topping lengkap — cita rasa autentik yang menggugah selera."
                            data-price="Rp 15.000"
                            data-rating="⭐ 4.9"
                            data-badge="Best Seller">
                            <img src="{{ asset('images/menu_bakso.png') }}" alt="Bakso Daging Sapi">
                        </div>
                        <!-- Orbit Item 2 -->
                        <div class="orbit-item item-2"
                            data-name="Mendoan"
                            data-desc="Tempe mendoan hangat khas Banyumasan, seporsi isi banyak dan renyah — cocok buat ngemil santai kapan saja."
                            data-price="Rp 10.000"
                            data-rating="⭐ 4.8"
                            data-badge="Cemilan">
                            <img src="{{ asset('images/mendoan.jpeg') }}" alt="Mendoan">
                        </div>
                        <!-- Orbit Item 3 -->
                        <div class="orbit-item item-3"
                            data-name="Ayam Bakar Kampung"
                            data-desc="Paket ayam kampung komplit dengan nasi, lalapan segar, dan sambal pedas mantap yang bikin nagih."
                            data-price="Mulai Rp 25.000"
                            data-rating="⭐ 4.9"
                            data-badge="Spesial">
                            <img src="{{ asset('images/ayam bakar kampung penyet .jpg') }}" alt="Ayam Bakar Kampung">
                        </div>
                        <!-- Orbit Item 4 -->
                        <div class="orbit-item item-4"
                            data-name="Jus Strawberry"
                            data-desc="Jus strawberry segar perpaduan manis dan asam alami — minuman pelepas dahaga favorit pelanggan."
                            data-price="Rp 12.000"
                            data-rating="⭐ 4.8"
                            data-badge="Segar">
                            <img src="{{ asset('images/WhatsApp Image 2026-05-15 at 08.56.33 (1).jpeg') }}" alt="Jus Strawberry">
                        </div>
                        <!-- Orbit Item 5 -->
                        <div class="orbit-item item-5"
                            data-name="Soto Ayam"
                            data-desc="Soto ayam dengan kuah bening gurih, suwiran daging ayam lembut, dan pelengkap yang kaya rempah."
                            data-price="Rp 12.000"
                            data-rating="⭐ 4.7"
                            data-badge="Favorit">
                            <img src="{{ asset('images/soto ayam.jpg') }}" alt="Soto Ayam">
                        </div>
                        <!-- Orbit Item 6 -->
                        <div class="orbit-item item-6"
                            data-name="Soto Ayam Kumplit"
                            data-desc="Soto ayam versi lengkap dengan telur rebus, kentang goreng, dan perkedel — porsi lebih besar, lebih puas."
                            data-price="Rp 15.000"
                            data-rating="⭐ 4.8"
                            data-badge="Populer">
                            <img src="{{ asset('images/soto ayam kumplit.jpg') }}" alt="Soto Ayam Kumplit">
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>

<!-- ===== GALLERY ===== -->
<section class="gallery-section" id="gallery">
    <div class="container">
        <div class="section-header">
            <p class="section-tag">Galeri</p>
            <h2 class="section-title">Momen <span class="highlight">Lezat</span> Kami</h2>
        </div>
        <div class="gallery-grid">
            <div class="gallery-item item-hero">
                <img src="{{ asset('images/hero_food.png') }}" alt="Gallery 1">
                <div class="gallery-overlay"><span>Momen Spesial</span></div>
            </div>
            <div class="gallery-item item-top-right">
                <img src="{{ asset('images/soto ayam kumplit.jpg') }}" alt="soto ayam kumplit">
                <div class="gallery-overlay"><span>soto ayam kumplit</span></div>
            </div>
            <div class="gallery-item item-bottom-right">
                <img src="{{ asset('images/wrung.jpeg') }}" alt="Suasana Warung">
                <div class="gallery-overlay"><span>Suasana Warung</span></div>
            </div>
            <div class="gallery-item item-bottom-left">
                <img src="{{ asset('images/fina.jpeg') }}" alt="Warung Fina Berry">
                <div class="gallery-overlay"><span>Warung Fina Berry</span></div>
            </div>
            <div class="gallery-item item-bottom-right-large">
                <img src="{{ asset('images/ayam bakar kampung (2).jpg') }}" alt="ayam bakar kampung">
                <div class="gallery-overlay"><span>ayam bakar kampung</span></div>
            </div>
        </div>
    </div>
</section>

<!-- ===== TESTIMONIAL ===== -->
<section class="testimonial-section">
    <div class="container">
        <div class="section-header">
            <p class="section-tag">Testimoni</p>
            <h2 class="section-title">Kata <span class="highlight">Pelanggan</span> Kami</h2>
        </div>
        <div class="testimonial-grid">
            <div class="testi-card">
                <div class="testi-stars">⭐⭐⭐⭐⭐</div>
                <p class="testi-text">"Bakso di sini enak banget! Kuahnya gurih, dagingnya kenyal. Sudah langganan sejak lama dan tidak pernah kecewa."</p>
                <div class="testi-author">
                    <div class="testi-avatar">A</div>
                    <div><strong>pajar DPO</strong><span>Pelanggan Setia</span></div>
                </div>
            </div>
            <div class="testi-card featured">
                <div class="testi-stars">⭐⭐⭐⭐⭐</div>
                <p class="testi-text">"Soto ayamnya otentik banget, mengingatkan masakan nenek. Porsinya besar, harganya tetap terjangkau. Recommended!"</p>
                <div class="testi-author">
                    <div class="testi-avatar">R</div>
                    <div><strong>Kang Hj Sona</strong><span>Food Blogger</span></div>
                </div>
            </div>
            <div class="testi-card">
                <div class="testi-stars">⭐⭐⭐⭐⭐</div>
                <p class="testi-text">"Nasi goreng spesialnya juara! Selalu jadi pilihan makan siang saya. Pelayanannya ramah dan tempatnya bersih."</p>
                <div class="testi-author">
                    <div class="testi-avatar">B</div>
                    <div><strong>Alvin Ramadhan</strong><span>Pelanggan Setia</span></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== ORDER CTA ===== -->
<section class="order-section" id="order">
    <div class="container">
        <div class="order-card">
            <div class="order-content">
                <p class="section-tag light">Pesan Sekarang</p>
                <h2>Lapar? Yuk <span class="highlight-light">Pesan Sekarang!</span></h2>
                <p>Tersedia layanan pesan antar dan dine-in. Unduh aplikasi kami untuk pengalaman memesan yang lebih mudah dan praktis.</p>
                <div class="order-btns">
                    <a href="https://www.mediafire.com/file/r15ylr53fiu5tfo/app-release.apk/file" class="btn-primary">ðŸ“± Download App</a>
                    <a href="https://wa.me/6281234567890" class="btn-whatsapp" target="_blank">ðŸ’¬ WhatsApp</a>
                </div>
            </div>
            <div class="order-img">
                <div class="phone-mockup">
                    <div class="phone-screen">
                        <div class="app-preview">
                            <div class="app-logo-wrapper">
                                <img src="{{ asset('images/Fina Berry.png') }}" alt="Fina Berry Logo">
                            </div>
                            <p class="app-welcome-text">Welcome to</p>
                            <div class="app-title-text">Warung Fina Berry</div>
                            <p class="app-desc-text">Rasakan sensasi hidangan lezat dengan bahan berkualitas terbaik.</p>
                            <div class="app-btn-new">Lihat Menu <span style="font-size: 14px;">ðŸ´</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== CONTACT ===== -->
<section class="contact-section" id="contact">
    <div class="container">
        <div class="section-header">
            <p class="section-tag">Kontak</p>
            <h2 class="section-title">Hubungi <span class="highlight">Kami</span></h2>
        </div>
        <div class="contact-grid">
            <div class="contact-info">
                <div class="contact-item">
                    <span class="contact-icon">📍</span>
                    <div>
                        <strong>Alamat</strong>
                        <p>Lokasi Warung Makan Fina Berry berada di kawasan Dâ€™LAS (Desa Wisata Lembah Asri), tepatnya di area dekat pintu keluar, Desa Serang, Kecamatan Karangreja, Kabupaten Purbalingga, Jawa Tengah.</p>
                    </div>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">⏰</span>
                    <div>
                        <strong>Jam Buka</strong>
                        <p>Senin Hari: 08.00 â€“ 17.00</p>
                    </div>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">📞</span>
                    <div>
                        <strong>Telepon</strong>
                        <p>+62 856-4773-1631</p>
                    </div>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">📧</span>
                    <div>
                        <strong>Email</strong>
                        <p>aismahaidy@gmail.com</p>
                    </div>
                </div>
                <div class="social-links">
                    <a href="https://www.instagram.com/fina.berry?igsh=azdla2ZtZWV0bWpo" class="social-btn">Instagram</a>
                </div>
            </div>
            <div class="contact-form-wrap">
                <form class="contact-form" id="contactForm">
                    <h3>Kirim Pesan</h3>
                    <div class="form-group">
                        <input type="text" id="nama" placeholder="Nama Anda" required>
                    </div>
                    <div class="form-group">
                        <input type="email" id="email" placeholder="Email Anda" required>
                    </div>
                    <div class="form-group">
                        <textarea id="pesan" rows="4" placeholder="Pesan Anda..." required></textarea>
                    </div>
                    <button type="submit" class="btn-primary full-width">Kirim Pesan ✉️</button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- ===== TIM DEVELOPER (NEW LAYOUT) ===== -->
<section class="team-section-new reveal" id="team">
    <div class="container">
        <!-- HEADER -->
        <div class="team-header-new">
            <p class="team-tag-line"><span class="line-dash"></span> // ANGGOTA.TIM</p>
            <h2 class="team-title-new">TIM <span class="highlight-glow">DEVELOPER</span></h2>
            <p class="team-subtitle-new">Enam spesialis yang berkolaborasi membangun produk digital berperforma tinggi.</p>
        </div>

        <!-- LIST OF DEVELOPERS -->
        <div class="team-list-new">
            <!-- Developer 1 -->
            <div class="team-row-new team-row-reverse reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/Aismaaa.jpeg') }}" alt="Developer 1" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">PROJECT MANAGER</span>
                    </div>
                    <h3 class="team-name-big">Aisma Haidy Putri Berry Ani Nur Rizeki</h3>
                    <p class="team-desc-text">Bertanggung jawab atas koordinasi tim dan memastikan proyek berjalan sesuai jadwal. Spesialis dalam metodologi agile dan manajemen sumber daya.</p>
                    <blockquote class="team-quote-text">
                        "Kepemimpinan adalah tindakan, bukan posisi."
                    </blockquote>
                </div>
            </div>

            <!-- Developer 2 -->
            <div class="team-row-new reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/Lulu Aeni.jpeg') }}" alt="Developer 2" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">SYSTEM ANALYST</span>
                    </div>
                    <h3 class="team-name-big">Lulu Aeni Salsabila</h3>
                    <p class="team-desc-text">Menganalisis kebutuhan bisnis dan menerjemahkannya menjadi spesifikasi teknis untuk tim developer. Bertanggung jawab untuk memastikan aplikasi selaras dengan tujuan bisnis.</p>
                    <blockquote class="team-quote-text">
                        "Pikirkan seperti seorang profesional, bekerjalah seperti seorang profesional."
                    </blockquote>
                </div>
            </div>

            <!-- Developer 3 -->
            <div class="team-row-new team-row-reverse reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/sobur.jpeg') }}" alt="Developer 3" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">FRONTEND DEVELOPER</span>
                    </div>
                    <h3 class="team-name-big">Sobur</h3>
                    <p class="team-desc-text">Merancang antarmuka yang intuitif dan responsif. Mengubah desain menjadi kode yang interaktif dan memanjakan mata pengguna.</p>
                    <blockquote class="team-quote-text">
                        "Semakin sedikit pengguna membutuhkan panduan, semakin baik kualitas UI."
                    </blockquote>
                </div>
            </div>

            <!-- Developer 4 -->
            <div class="team-row-new reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/fajar.jpeg') }}" alt="Developer 4" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">BACKEND DEVELOPER</span>
                    </div>
                    <h3 class="team-name-big">MUHAMMAD FAJAR</h3>
                    <p class="team-desc-text">Berfokus pada pengembangan API, autentikasi pengguna, dan integrasi layanan backend</p>
                    <blockquote class="team-quote-text">
                        "Membangun Logika, Menghubungkan Sistem."
                    </blockquote>
                </div>
            </div>

            <!-- Developer 5 -->
            <div class="team-row-new team-row-reverse reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/fauzi.jpeg') }}" alt="Developer 5" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">BACKEND DEVELOPER</span>
                    </div>
                    <h3 class="team-name-big">M. Fauzi Akbar Rafsanjani</h3>
                    <p class="team-desc-text">Berfokus pada pengembangan logika bisnis, integrasi database, dan optimasi performa server agar sistem dapat berjalan stabil dan responsif..</p>
                    <blockquote class="team-quote-text">
                        "Mengelola Data, Menjaga Stabilitas."
                    </blockquote>
                </div>
            </div>

            <!-- Developer 6 -->
            <div class="team-row-new reveal">
                <div class="team-photo-side">
                    <img src="{{ asset('images/bedul.jpeg') }}" alt="Developer 6" class="team-photo">
                </div>
                <div class="team-info-side">
                    <div class="team-role-tag">
                        <span class="role-icon">&lt;/&gt;</span>
                        <span class="role-text">QA & TESTER</span>
                    </div>
                    <h3 class="team-name-big">MUHAMMAD ABDUL AZIS</h3>
                    <p class="team-desc-text">Bertanggung jawab untuk memastikan aplikasi berjalan lancar di semua perangkat. Berfokus pada performa tinggi dan UX native yang nyaman.</p>
                    <blockquote class="team-quote-text">
                        "Semangat Pagi, Tetap Semangat"
                    </blockquote>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== FOOTER ===== -->

<footer class="footer">
    <div class="container">
        <div class="footer-top">
            <div class="footer-brand">
                <div class="footer-logo-wrapper" style="display: flex; align-items: center; gap: 16px; margin-bottom: 12px;">
                    <span class="logo-icon"><img src="{{ asset('images/Fina Berry.png') }}" alt="Fina Berry Logo" style="width: 60px; height: 60px; object-fit: cover; border-radius: 50%; max-width: 60px;"></span>
                    <span class="footer-logo" style="margin: 0; padding: 0;">Fina Berry</span>
                </div>
                <p>Warung makan dengan cita rasa autentik Indonesia yang menggunakan bahan segar pilihan setiap harinya.Lokasi Warung Makan Fina Berry berada di kawasan Dâ€™LAS (Desa Wisata Lembah Asri), tepatnya di area dekat pintu keluar, Desa Serang, Kecamatan Karangreja, Kabupaten Purbalingga, Jawa Tengah.</p>
            </div>
            <div class="footer-links">
                <h4>Tautan</h4>
                <ul>
                    <li><a href="#home">Beranda</a></li>
                    <li><a href="#about">Tentang Kami</a></li>
                    <li><a href="#menu">Menu</a></li>
                    <li><a href="#gallery">Galeri</a></li>
                </ul>
            </div>
            <div class="footer-links">
                <h4>Menu Unggulan</h4>
                <ul>
                    <li><a href="#menu">Bakso Daging Sapi</a></li>
                    <li><a href="#menu">Jus Strawberry</a></li>
                    <li><a href="#menu">Jus Jeruk</a></li>
                    <li><a href="#menu">Ayam Bakar kampung</a></li>
                    <li><a href="#menu">Ayam Goreng kampung</a></li>
                    <li><a href="#menu">Mendoan</a></li>
                </ul>
            </div>
            <div class="footer-links">
                <h4>Ikuti Kami</h4>
                <ul>
                    <li><a href="">Instagram</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2026 Warung Fina Berry. All rights reserved.</p>
            <p>Made with ❤️ in Indonesia</p>
        </div>
    </div>
</footer>

<script src="{{ asset('js/landing.js') }}"></script>
</body>
</html>

