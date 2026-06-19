<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Warung Fina Berry</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,400;1,600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-color: #2b3324;
            --surface-color: #353f2c;
            --surface-hover: #3f4a35;
            --text-primary: #f2f5f0;
            --text-secondary: #a6b59c;
            --accent-color: #8da673;
            --border-color: #4c5941;
            
            --font-heading: 'Poppins', sans-serif;
            --font-body: 'Poppins', sans-serif;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-primary);
            font-family: var(--font-body);
            line-height: 1.6;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        /* Utilities */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 5%;
        }

        .section-padding {
            padding: 120px 0;
        }

        .text-accent {
            color: var(--accent-color);
        }

        /* Typography */
        h1, h2, h3, h4 {
            font-family: var(--font-heading);
            font-weight: 400;
            line-height: 1.1;
        }

        .section-title {
            font-size: 3.5rem;
            margin-bottom: 2rem;
            letter-spacing: -0.02em;
        }

        .section-eyebrow {
            font-family: var(--font-body);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.2em;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2.5rem;
        }

        .section-eyebrow::before {
            content: '';
            display: block;
            width: 30px;
            height: 1px;
            background-color: var(--accent-color);
        }

        /* Navbar */
        nav {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            padding: 1.5rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
            background: linear-gradient(to bottom, rgba(43, 51, 36, 0.9), transparent);
            backdrop-filter: blur(8px);
            transition: all 0.3s ease;
        }

        .logo {
            font-family: var(--font-heading);
            font-size: 1.5rem;
            font-weight: 600;
            text-decoration: none;
            color: var(--text-primary);
            display: flex;
            align-items: baseline;
            gap: 0.5rem;
        }

        .logo span {
            font-family: var(--font-body);
            font-size: 0.65rem;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--accent-color);
        }

        .nav-links {
            display: flex;
            gap: 3rem;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--text-secondary);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: var(--text-primary);
        }

        .btn-outline {
            border: 1px solid var(--border-color);
            background: transparent;
            color: var(--text-primary);
            padding: 0.6rem 1.5rem;
            border-radius: 2px;
            font-size: 0.75rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-outline:hover {
            border-color: var(--accent-color);
            background: rgba(141, 166, 115, 0.05);
        }

        .btn-solid {
            background: var(--accent-color);
            color: #fff;
            padding: 0.6rem 1.5rem;
            border-radius: 2px;
            font-size: 0.75rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid var(--accent-color);
        }

        .btn-solid:hover {
            background: #748c5e;
            border-color: #748c5e;
        }

        .btn-outline.large, .btn-solid.large {
            padding: 1rem 2.5rem;
            font-size: 0.85rem;
            text-transform: none;
            letter-spacing: 0.05em;
        }

        /* Hero */
        .hero {
            height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
        }

        .hero-content {
            width: 55%;
            padding-left: 5%;
            position: relative;
            z-index: 2;
        }

        .hero-subtitle {
            color: var(--accent-color);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.2em;
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .hero-subtitle::before, .hero-subtitle::after {
            content: '';
            display: block;
            width: 30px;
            height: 1px;
            background-color: var(--accent-color);
        }

        .hero-title {
            font-size: 6.5rem;
            line-height: 0.95;
            margin: 1rem 0 2rem 0;
            display: flex;
            flex-direction: column;
        }

        .hero-title span.italic-accent {
            font-style: italic;
            color: var(--accent-color);
            padding-left: 0;
        }

        .hero-title span.indent {
            padding-left: 0;
        }

        .hero-image {
            position: absolute;
            top: 0;
            right: 0;
            width: 60%;
            height: 100%;
            background-image: url('{{ asset("images/hero_berries_1781839756886.png") }}');
            background-size: cover;
            background-position: center;
            z-index: 1;
        }

        .hero-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 50%;
            height: 100%;
            background: linear-gradient(to right, var(--bg-color) 0%, rgba(43, 51, 36, 0.8) 50%, transparent 100%);
        }
        
        .hero-image::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 30%;
            background: linear-gradient(to top, var(--bg-color), transparent);
        }

        .hero-buttons {
            display: flex;
            gap: 1.5rem;
            margin-top: 3rem;
        }

        /* Marquee */
        .marquee-wrapper {
            background-color: rgba(53, 63, 44, 0.5);
            padding: 1.5rem 0;
            overflow: hidden;
            border-top: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
            position: relative;
            z-index: 3;
        }

        .marquee {
            display: flex;
            white-space: nowrap;
            animation: scroll 40s linear infinite;
        }

        .marquee span {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
            margin-right: 3rem;
            display: inline-flex;
            align-items: center;
            gap: 1.5rem;
        }
        
        .marquee span b {
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .marquee span i {
            display: inline-block;
            width: 16px;
            height: 16px;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%238da673" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>'); /* leaf icon placeholder */
            background-size: contain;
            opacity: 0.5;
        }

        @keyframes scroll {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        /* About / Intro */
        .about-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6rem;
            align-items: center;
        }
        
        .about-image {
            width: 100%;
            height: 600px;
            object-fit: cover;
            border-radius: 2px;
            filter: brightness(0.8);
        }

        .about-text h2 {
            font-size: 3.8rem;
            margin-bottom: 2rem;
        }
        
        .about-text h2 span {
            display: block;
            font-style: italic;
            color: var(--accent-color);
        }

        /* Profile */
        .profile-section {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 5rem;
            align-items: stretch;
        }

        .profile-card {
            position: relative;
            background: var(--surface-color);
            border-radius: 2px;
            overflow: hidden;
        }

        .profile-image {
            width: 100%;
            height: 100%;
            min-height: 500px;
            object-fit: cover;
            filter: brightness(0.7);
            transition: filter 0.5s ease;
        }
        
        .profile-card:hover .profile-image {
            filter: brightness(0.9);
        }

        .badge {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            background: var(--accent-color);
            color: white;
            padding: 0.8rem 1.2rem;
            font-size: 1rem;
            font-family: var(--font-heading);
            font-weight: 600;
            border-radius: 2px;
            text-align: center;
            line-height: 1.1;
            z-index: 2;
        }

        .profile-info {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            padding: 2.5rem 2rem 2rem;
            background: linear-gradient(to top, rgba(43, 51, 36, 1) 10%, transparent);
            z-index: 2;
        }

        .profile-info h3 {
            font-size: 1.8rem;
            margin-bottom: 0.3rem;
            color: #fff;
        }

        .profile-info p {
            font-size: 0.7rem;
            color: var(--accent-color);
            letter-spacing: 0.15em;
            text-transform: uppercase;
        }

        .profile-content blockquote {
            font-family: var(--font-heading);
            font-size: 2.2rem;
            line-height: 1.3;
            font-style: italic;
            margin-bottom: 1.5rem;
            color: var(--text-primary);
        }

        .profile-content .author {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--text-secondary);
            margin-bottom: 3rem;
            display: block;
        }

        .profile-content p.bio {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            max-width: 650px;
            line-height: 1.8;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1px;
            margin-top: 4rem;
            background-color: var(--border-color);
        }

        .stat-item {
            background-color: var(--bg-color);
            padding: 2rem 0;
            text-align: left;
            padding-left: 1.5rem;
        }

        .stat-item h4 {
            font-size: 2rem;
            font-family: var(--font-heading);
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .stat-item p {
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
        }

        /* Menu */
        .menu-list {
            margin-top: 3rem;
        }

        .menu-header {
            display: grid;
            grid-template-columns: 50px 2fr 1fr 100px 30px;
            padding-bottom: 1rem;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
        }

        .menu-item {
            display: grid;
            grid-template-columns: 50px 2fr 1fr 100px 30px;
            align-items: center;
            padding: 1.5rem 0;
            border-bottom: 1px solid var(--border-color);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }
        
        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -1rem;
            width: calc(100% + 2rem);
            height: 100%;
            background-color: var(--surface-hover);
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
            border-radius: 4px;
        }

        .menu-item:hover::before {
            opacity: 1;
        }

        .menu-item .num {
            font-size: 0.75rem;
            color: var(--text-secondary);
            font-family: var(--font-body);
            letter-spacing: 0.1em;
        }

        .menu-item .name {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: var(--text-primary);
        }

        .menu-item .tag {
            font-family: var(--font-body);
            font-size: 0.6rem;
            padding: 0.2rem 0.5rem;
            border: 1px solid var(--border-color);
            border-radius: 2px;
            color: var(--accent-color);
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .menu-item .category {
            font-size: 0.75rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            text-align: right;
            padding-right: 2rem;
        }

        .menu-item .price {
            font-weight: 500;
            font-size: 0.95rem;
            text-align: right;
        }

        .menu-item .arrow {
            text-align: right;
            color: var(--text-secondary);
            transition: transform 0.3s ease, color 0.3s ease;
            font-size: 1.2rem;
        }
        
        .menu-item:hover .arrow {
            transform: translateX(5px) translateY(-5px);
            color: var(--text-primary);
        }

        /* Gallery */
        .gallery-wrapper {
            display: flex;
            gap: 1.5rem;
            height: 600px;
            overflow: hidden;
            position: relative;
            margin-top: 3rem;
            background: var(--bg-color);
        }
        
        .gallery-wrapper::before, .gallery-wrapper::after {
            content: '';
            position: absolute;
            left: 0;
            width: 100%;
            height: 120px;
            z-index: 2;
            pointer-events: none;
        }
        .gallery-wrapper::before {
            top: 0;
            background: linear-gradient(to bottom, var(--bg-color) 10%, transparent);
        }
        .gallery-wrapper::after {
            bottom: 0;
            background: linear-gradient(to top, var(--bg-color) 10%, transparent);
        }

        .gallery-col {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            will-change: transform;
        }

        .gallery-item {
            border-radius: 2px;
            overflow: hidden;
            position: relative;
            flex-shrink: 0;
        }
        
        .gallery-item.large {
            height: 400px;
        }
        .gallery-item:not(.large) {
            height: 250px;
        }

        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            filter: brightness(0.85);
            transition: filter 0.3s ease;
        }
        
        .gallery-item:hover img {
            filter: brightness(1.1);
        }

        @keyframes scroll-up {
            0% { transform: translateY(0); }
            100% { transform: translateY(calc(-50% - 0.75rem)); }
        }
        @keyframes scroll-down {
            0% { transform: translateY(calc(-50% - 0.75rem)); }
            100% { transform: translateY(0); }
        }

        .col-up { animation: scroll-up 35s linear infinite; }
        .col-down { animation: scroll-down 40s linear infinite; }
        .col-up-slow { animation: scroll-up 45s linear infinite; }
        
        .gallery-item.large {
            grid-row: span 2;
        }

        /* Testimonial */
        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 3rem;
        }

        .testimonial-card {
            border: 1px solid var(--border-color);
            padding: 2.5rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            transition: border-color 0.3s ease;
        }
        
        .testimonial-card:hover {
            border-color: var(--accent-color);
        }

        .stars {
            color: var(--accent-color);
            display: flex;
            gap: 0.2rem;
        }

        .stars svg {
            width: 16px;
            height: 16px;
        }

        .testimonial-quote {
            font-family: var(--font-heading);
            font-style: italic;
            font-size: 1.1rem;
            color: var(--text-primary);
            flex-grow: 1;
            line-height: 1.6;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
        }

        .avatar {
            width: 40px;
            height: 40px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            color: var(--accent-color);
            font-family: var(--font-body);
            letter-spacing: 0.05em;
        }

        .author-info h4 {
            font-size: 0.85rem;
            font-family: var(--font-body);
            margin-bottom: 0.2rem;
        }

        .author-info p {
            font-size: 0.65rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        /* Contact Section */
        .contact-section {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 6rem;
            margin-top: 2rem;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
        }

        .contact-item {
            display: flex;
            gap: 1.5rem;
            align-items: flex-start;
        }

        .contact-icon {
            color: var(--accent-color);
            margin-top: 0.2rem;
        }

        .contact-text h4 {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }

        .contact-text p {
            color: var(--text-primary);
            font-size: 0.95rem;
            line-height: 1.6;
            white-space: pre-line;
        }

        .contact-form-card {
            background-color: var(--surface-color);
            padding: 3.5rem;
            border-radius: 2px;
        }

        .contact-form-card h3 {
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
        }

        .contact-form-card > p {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 2.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.15em;
            color: var(--text-secondary);
            margin-bottom: 0.8rem;
        }

        .form-control {
            width: 100%;
            background-color: var(--bg-color);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 1rem;
            font-family: var(--font-body);
            font-size: 0.9rem;
            border-radius: 2px;
            transition: border-color 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--accent-color);
        }

        .form-control::placeholder {
            color: var(--text-secondary);
            opacity: 0.5;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            width: 100%;
            background-color: var(--accent-color);
            color: white;
            border: none;
            padding: 1rem;
            font-family: var(--font-body);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            cursor: pointer;
            border-radius: 2px;
            transition: background-color 0.3s ease;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            background-color: #748c5e;
        }

        /* Footer */
        footer {
            padding: 3rem 5%;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--text-secondary);
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            background-color: var(--surface-color);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .hero-title { font-size: 4rem; }
            .about-section, .profile-section { grid-template-columns: 1fr; gap: 3rem; }
            .hero-image { width: 100%; opacity: 0.3; }
            .hero-content { width: 100%; padding-right: 5%; }
            .menu-item { grid-template-columns: 40px 1fr 90px 20px; }
            .menu-item .category { display: none; }
            .menu-header { grid-template-columns: 40px 1fr 90px 20px; }
            .menu-header .category-col { display: none; }
            .gallery-grid { grid-template-columns: 1fr 1fr; }
            .gallery-item.large { grid-row: auto; grid-column: span 2; }
            .nav-links { display: none; }
            .testimonial-grid { grid-template-columns: 1fr; gap: 1.5rem; }
            .contact-section { grid-template-columns: 1fr; gap: 4rem; }
        }
        @media (max-width: 768px) {
            .gallery-grid { grid-template-columns: 1fr; }
            .gallery-item.large { grid-column: auto; }
            footer { flex-direction: column; gap: 1.5rem; text-align: center; }
            .hero-buttons { flex-direction: column; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    
        /* Reveal Animations */
        .reveal {
            opacity: 0;
            transform: translateY(40px);
            transition: all 0.8s cubic-bezier(0.5, 0, 0, 1);
            will-change: opacity, transform;
        }
        .reveal-left {
            opacity: 0;
            transform: translateX(-40px);
            transition: all 0.8s cubic-bezier(0.5, 0, 0, 1);
            will-change: opacity, transform;
        }
        .reveal-right {
            opacity: 0;
            transform: translateX(40px);
            transition: all 0.8s cubic-bezier(0.5, 0, 0, 1);
            will-change: opacity, transform;
        }
        .reveal.visible, .reveal-left.visible, .reveal-right.visible {
            opacity: 1;
            transform: translate(0, 0);
        }
        .delay-100 { transition-delay: 100ms; }
        .delay-200 { transition-delay: 200ms; }
        .delay-300 { transition-delay: 300ms; }

</style>
</head>
<body>

    <nav id="navbar">
        <a href="#" class="logo">Fina <span>BERRY</span></a>
        <ul class="nav-links">
            <li><a href="#tentang">Tentang</a></li>
            <li><a href="#menu">Menu</a></li>
            <li><a href="#galeri">Galeri</a></li>
            <li><a href="#kontak">Kontak</a></li>
        </ul>
        <a href="#pesan" class="btn-outline">Pesan ↗</a>
    </nav>

    <section class="hero">
        <div class="hero-image reveal"></div>
        <div class="hero-content reveal-right">
            <div class="hero-subtitle">Bandung &bull; Est. 2021</div>
            <h1 class="hero-title">
                <span>Warung</span>
                <span class="italic-accent">Fina</span>
                <span class="indent">Berry</span>
            </h1>
            <p style="color: var(--text-secondary); letter-spacing: 0.05em; font-size: 0.9rem; max-width: 400px; line-height: 1.8;">
                Buah berry pilihan dari kebun terbaik Jawa Barat —
            </p>
            
            <div class="hero-buttons">
                <a href="#menu" class="btn-solid large">Lihat Menu ↗</a>
                <a href="#tentang" class="btn-outline large">Tentang Kami</a>
            </div>
        </div>
    </section>

    <div class="marquee-wrapper reveal">
        <div class="marquee">
            <span><b>500+</b> Pelanggan <i></i> <b>12</b> Varian Menu <i></i> <b>3+</b> Tahun Berdiri <i></i> RASPBERRY LOKAL <i></i> BERRY SMOOTHIE <i></i> DESSERT BOX <i></i> BUAH LANGSUNG KEBUN <i></i> TANPA PENGAWET <i></i> STRAWBERRY PREMIUM <i></i> MIXED BERRY BOWL <i></i> BLUEBERRY SEGAR <i></i></span>
            <span><b>500+</b> Pelanggan <i></i> <b>12</b> Varian Menu <i></i> <b>3+</b> Tahun Berdiri <i></i> RASPBERRY LOKAL <i></i> BERRY SMOOTHIE <i></i> DESSERT BOX <i></i> BUAH LANGSUNG KEBUN <i></i> TANPA PENGAWET <i></i> STRAWBERRY PREMIUM <i></i> MIXED BERRY BOWL <i></i> BLUEBERRY SEGAR <i></i></span>
        </div>
    </div>

    <section id="tentang" class="section-padding container">
        <div class="about-section">
            <div class="about-text reveal-right" style="order: 2;">
                <div class="section-eyebrow">01 &nbsp; Tentang Kami</div>
                <h2>Dari kebun langsung <span>ke tanganmu</span></h2>
            </div>
            <img src="{{ asset('images/gallery_1_1781839918072.png') }}" alt="Fresh Strawberries" class="about-image reveal-left" style="order: 1;">
        </div>
    </section>

    <section class="section-padding container">
        <div class="section-eyebrow">02 &nbsp; Profil Pemilik</div>
        <div class="profile-section">
            <div class="profile-card reveal-left">
                <img src="{{ asset('images/profile_farmer_1781839852678.png') }}" alt="Rafina Aulia" class="profile-image">
                <div class="badge">2021<br><span style="font-size:0.6rem; font-weight:normal;">EST.</span></div>
                <div class="profile-info">
                    <h3>Rafina Aulia</h3>
                    <p>Founder - Head Grower</p>
                </div>
            </div>
            <div class="profile-content reveal-right">
                <blockquote>"Saya percaya bahwa buah yang baik tidak perlu banyak tambahan — cukup kejujuran, kesegaran, dan cinta dari petaninya."</blockquote>
                <span class="author">— Rafina Aulia, Pendiri Warung Fina Berry</span>
                
                <p class="bio">Rafina Aulia, atau akrab dipanggil <strong>Fina</strong>, adalah perempuan asal Bandung yang memulai perjalanannya di dunia berry pada 2018 — ketika ia pertama kali mengunjungi kebun strawberry di Ciwidey bersama keluarganya.</p>
                <p class="bio">Terpesona oleh warna, rasa, dan potensi buah lokal yang masih kurang diapresiasi, Fina memutuskan berhenti dari pekerjaannya sebagai desainer grafis dan mendirikan <strong>Warung Fina Berry</strong> pada Maret 2021 — awalnya hanya dari lapak kecil berukuran 2x2 meter.</p>
                <p class="bio">Kini, Fina secara langsung menjaga hubungan dengan 4 petani lokal di Ciwidey dan Lembang, memastikan setiap buah yang sampai ke pelanggan memenuhi standar kesegaran yang ia percayai.</p>
                
                <div class="stats-grid">
                    <div class="stat-item">
                        <h4>4</h4>
                        <p>Petani Mitra</p>
                    </div>
                    <div class="stat-item">
                        <h4>6+</h4>
                        <p>Varian Berry</p>
                    </div>
                    <div class="stat-item">
                        <h4>500+</h4>
                        <p>Pelanggan Aktif</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="menu" class="section-padding container">
        <div class="section-eyebrow">03 &nbsp; Menu</div>
        <div style="display:flex; justify-content:space-between; align-items:flex-end;">
            <h2 class="section-title reveal" style="margin-bottom:0;">Pilihan hari ini</h2>
            <p style="color: var(--text-secondary); font-size:0.85rem; max-width:250px; text-align:right;">Klik setiap item untuk melihat detail dan foto produk.</p>
        </div>
        
        <div class="menu-list reveal">
            <div class="menu-header">
                <div>NO</div>
                <div>NAMA</div>
                <div class="category-col" style="text-align:right; padding-right:2rem;">KATEGORI</div>
                <div style="text-align:right;">HARGA</div>
                <div></div>
            </div>
            
            <div class="menu-item">
                <div class="num">01</div>
                <div class="name">Strawberry Premium <span class="tag">Terlaris</span></div>
                <div class="category">Berry Segar</div>
                <div class="price">Rp 28.000</div>
                <div class="arrow">↗</div>
            </div>
            <div class="menu-item">
                <div class="num">02</div>
                <div class="name">Mixed Berry Bowl <span class="tag" style="color: var(--text-secondary); border-color: var(--border-color);">Favorit</span></div>
                <div class="category">Dessert</div>
                <div class="price">Rp 35.000</div>
                <div class="arrow">↗</div>
            </div>
            <div class="menu-item">
                <div class="num">03</div>
                <div class="name">Berry Glass</div>
                <div class="category">Dessert</div>
                <div class="price">Rp 42.000</div>
                <div class="arrow">↗</div>
            </div>
            <div class="menu-item">
                <div class="num">04</div>
                <div class="name">Strawberry Slice</div>
                <div class="category">Berry Segar</div>
                <div class="price">Rp 22.000</div>
                <div class="arrow">↗</div>
            </div>
            <div class="menu-item">
                <div class="num">05</div>
                <div class="name">Raspberry Lokal <span class="tag">Baru</span></div>
                <div class="category">Berry Segar</div>
                <div class="price">Rp 32.000</div>
                <div class="arrow">↗</div>
            </div>
            <div class="menu-item">
                <div class="num">06</div>
                <div class="name">Berry Smoothie</div>
                <div class="category">Minuman</div>
                <div class="price">Rp 18.000</div>
                <div class="arrow">↗</div>
            </div>
        </div>
    </section>

    <section id="galeri" class="section-padding container">
        <div class="section-eyebrow reveal">04 &nbsp; Galeri</div>
        <h2 class="section-title reveal-left" style="margin-bottom:0.5rem;">Warna-warni</h2>
        <h2 class="section-title reveal-right delay-100" style="color:var(--accent-color); font-style:italic;">kesegaran alam</h2>
        
        <div class="gallery-wrapper reveal delay-200">
            <div class="gallery-col col-up">
                <div class="gallery-item large"><img src="{{ asset('images/gallery_1_1781839918072.png') }}" alt="Strawberry"></div>
                <div class="gallery-item large"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" style="object-position: left;" alt="Mixed berries"></div>
                <div class="gallery-item large"><img src="{{ asset('images/gallery_1_1781839918072.png') }}" alt="Strawberry"></div>
                <div class="gallery-item large"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" style="object-position: left;" alt="Mixed berries"></div>
            </div>
            
            <div class="gallery-col col-down">
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" alt="Mixed berries"></div>
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" alt="Sliced strawberries"></div>
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" alt="Mixed berries"></div>
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" alt="Sliced strawberries"></div>
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" alt="Mixed berries"></div>
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" alt="Sliced strawberries"></div>
            </div>
            
            <div class="gallery-col col-up-slow">
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" style="object-position: bottom right;" alt="Berries bowl"></div>
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" style="object-position: top right;" alt="More berries"></div>
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" style="object-position: bottom right;" alt="Berries bowl"></div>
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" style="object-position: top right;" alt="More berries"></div>
                <div class="gallery-item"><img src="{{ asset('images/gallery_2_1781839941412.png') }}" style="object-position: bottom right;" alt="Berries bowl"></div>
                <div class="gallery-item"><img src="{{ asset('images/hero_berries_1781839756886.png') }}" style="object-position: top right;" alt="More berries"></div>
            </div>
        </div>
    </section>

    <section id="testimoni" class="section-padding container">
        <div class="section-eyebrow">05 &nbsp; Testimoni</div>
        <h2 class="section-title">Apa kata mereka</h2>
        
        <div class="testimonial-grid">
            <div class="testimonial-card reveal">
                <div class="stars">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                </div>
                <div class="testimonial-quote">"Strawberry-nya selalu konsisten segar dan manis. Sudah jadi langganan tetap setiap minggu."</div>
                <div class="testimonial-author">
                    <div class="avatar">AR</div>
                    <div class="author-info">
                        <h4>Anisa Rahma</h4>
                        <p>Pelanggan Setia &middot; 1 tahun</p>
                    </div>
                </div>
            </div>
            
            <div class="testimonial-card reveal delay-100">
                <div class="stars">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                </div>
                <div class="testimonial-quote">"Mixed Berry Bowl estetiknya sempurna buat konten. Rasanya juga tidak mengecewakan sama sekali."</div>
                <div class="testimonial-author">
                    <div class="avatar">DS</div>
                    <div class="author-info">
                        <h4>Dika Santoso</h4>
                        <p>Food Content Creator</p>
                    </div>
                </div>
            </div>
            
            <div class="testimonial-card reveal delay-200">
                <div class="stars">
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                </div>
                <div class="testimonial-quote">"Pelayanan cepat dan ramah. Berry Glass jadi favorit saya tiap akhir pekan."</div>
                <div class="testimonial-author">
                    <div class="avatar">MP</div>
                    <div class="author-info">
                        <h4>Maya Putri</h4>
                        <p>Pelanggan</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="kontak" class="section-padding container">
        <div class="section-eyebrow">06 &nbsp; Kontak & Lokasi</div>
        
        <div class="contact-section">
            <div class="contact-content reveal-left">
                <h2 class="section-title">Temukan kami</h2>
                
                <div class="contact-info">
                    <div class="contact-item">
                        <div class="contact-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        </div>
                        <div class="contact-text">
                            <h4>Alamat</h4>
                            <p>Jl. Raya Ciwidey No. 12<br>Bandung Selatan, Jawa Barat 40973</p>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <div class="contact-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                        </div>
                        <div class="contact-text">
                            <h4>Jam Buka</h4>
                            <p>Sen &ndash; Sab: 07.00 &ndash; 19.00<br>Minggu: 08.00 &ndash; 17.00</p>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <div class="contact-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        </div>
                        <div class="contact-text">
                            <h4>WhatsApp</h4>
                            <p>+62 812 3456 7890</p>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <div class="contact-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
                        </div>
                        <div class="contact-text">
                            <h4>Instagram</h4>
                            <p>@warungfinaberry</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="contact-form-card reveal-right delay-100">
                <h3>Pesan Sekarang</h3>
                <p>Isi form dan kami hubungi sesegera mungkin.</p>
                
                <form action="#" method="POST">
                    <div class="form-group">
                        <label>Nama Lengkap</label>
                        <input type="text" class="form-control" placeholder="Contoh: Budi Santoso">
                    </div>
                    
                    <div class="form-group">
                        <label>Nomor WhatsApp</label>
                        <input type="text" class="form-control" placeholder="+62 812 xxxx xxxx">
                    </div>
                    
                    <div class="form-group">
                        <label>Detail Pesanan</label>
                        <textarea class="form-control" placeholder="Sebutkan produk dan jumlah yang diinginkan..."></textarea>
                    </div>
                    
                    <button type="button" class="btn-submit">Kirim Pesanan ↗</button>
                </form>
            </div>
        </div>
    </section>

    <footer>
        <div>&copy; {{ date('Y') }} Warung Fina Berry. All rights reserved.</div>
        <div class="logo">Fina <span style="font-size:0.5rem;">BERRY</span></div>
        <div>Bandung, Jawa Barat</div>
    </footer>

    <script>
        window.addEventListener('scroll', () => {
            const nav = document.getElementById('navbar');
            if (window.scrollY > 50) {
                nav.style.background = 'rgba(43, 51, 36, 0.95)';
                nav.style.borderBottom = '1px solid var(--border-color)';
                nav.style.padding = '1rem 5%';
            } else {
                nav.style.background = 'linear-gradient(to bottom, rgba(43, 51, 36, 0.9), transparent)';
                nav.style.borderBottom = 'none';
                nav.style.padding = '1.5rem 5%';
            }
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                    } else {
                        // Remove class when out of view to make it animate again
                        entry.target.classList.remove('visible');
                    }
                });
            }, { 
                root: null,
                rootMargin: '0px',
                threshold: 0.15 
            });

            document.querySelectorAll('.reveal, .reveal-left, .reveal-right').forEach((el) => {
                observer.observe(el);
            });
        });
    </script>

</body>
</html>
