// ===== NAVBAR SCROLL =====
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 50);
});

// ===== HAMBURGER MENU =====
const hamburger = document.getElementById('hamburger');
const navLinks = document.getElementById('navLinks');
hamburger.addEventListener('click', () => {
    navLinks.classList.toggle('open');
});
document.querySelectorAll('.nav-links a').forEach(link => {
    link.addEventListener('click', () => navLinks.classList.remove('open'));
});



// ===== SCROLL REVEAL =====
const reveals = document.querySelectorAll('.about-grid, .gallery-item, .testi-card, .contact-item');
reveals.forEach(el => el.classList.add('reveal'));
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.1 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

// ===== CONTACT FORM =====
document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const nama  = document.getElementById('nama').value.trim();
    const email = document.getElementById('email').value.trim();
    const pesan = document.getElementById('pesan').value.trim();

    const text = `Halo Warung Fina Berry! 👋\n\nNama  : ${nama}\nEmail : ${email}\nPesan : ${pesan}`;
    const waUrl = `https://wa.me/6285647731631?text=${encodeURIComponent(text)}`;

    const btn = this.querySelector('button[type="submit"]');
    btn.textContent = 'Membuka WhatsApp... ✅';
    btn.style.background = '#059669';

    window.open(waUrl, '_blank');

    setTimeout(() => {
        btn.textContent = 'Kirim Pesan ✉️';
        btn.style.background = '';
        this.reset();
    }, 3000);
});

// ===== ACTIVE NAV LINK ON SCROLL =====
const sections = document.querySelectorAll('section[id]');
window.addEventListener('scroll', () => {
    const scrollY = window.scrollY + 100;
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.offsetHeight;
        const id = section.getAttribute('id');
        const navLink = document.querySelector(`.nav-links a[href="#${id}"]`);
        if (navLink && scrollY >= sectionTop && scrollY < sectionTop + sectionHeight) {
            document.querySelectorAll('.nav-links a').forEach(a => a.style.color = '');
            navLink.style.color = '#10B981';
        }
    });
});

// ===== ORBIT MENU CLICK – UPDATE CENTER IMAGE + INFO CARD =====
const orbitItems = document.querySelectorAll('.orbit-item');
const centerImg  = document.getElementById('centerPlateImg');
const infoCard   = document.getElementById('orbitInfoCard');
const infoName   = document.getElementById('orbitInfoName');
const infoDesc   = document.getElementById('orbitInfoDesc');
const infoPrice  = document.getElementById('orbitInfoPrice');
const infoRating = document.getElementById('orbitInfoRating');
const infoBadge  = document.getElementById('orbitInfoBadge');

orbitItems.forEach(item => {
    item.addEventListener('click', () => {
        const imgSrc  = item.querySelector('img').src;
        const name    = item.dataset.name;
        const desc    = item.dataset.desc;
        const price   = item.dataset.price;
        const rating  = item.dataset.rating;
        const badge   = item.dataset.badge;

        // --- Highlight selected item ---
        orbitItems.forEach(i => i.classList.remove('selected'));
        item.classList.add('selected');

        // --- Animate center image swap ---
        centerImg.classList.add('switching');
        setTimeout(() => {
            centerImg.src = imgSrc;
            centerImg.classList.remove('switching');
        }, 320);

        // --- Update info card content ---
        infoName.textContent   = name;
        infoDesc.textContent   = desc;
        infoPrice.textContent  = price;
        infoRating.textContent = rating;
        infoBadge.textContent  = badge;

        // --- Show info card (animate in) ---
        if (!infoCard.classList.contains('active')) {
            infoCard.classList.add('active');
        } else {
            // Re-trigger animation for already-visible card
            infoCard.style.animation = 'none';
            infoCard.offsetHeight; // reflow
            infoCard.style.animation = '';
        }
    });
});

// ===== MENU TABS FILTER =====
const menuTabs  = document.querySelectorAll('.menu-tab');
const menuCards = document.querySelectorAll('.full-menu-card');

menuTabs.forEach(tab => {
    tab.addEventListener('click', () => {
        menuTabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');

        const cat = tab.dataset.cat;
        menuCards.forEach(card => {
            const match = cat === 'semua' || card.dataset.cat === cat;
            card.classList.toggle('hidden', !match);
        });
    });
});
