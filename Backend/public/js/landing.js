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

// ===== MENU TABS FILTER =====
const tabBtns = document.querySelectorAll('.tab-btn');
const menuCards = document.querySelectorAll('.menu-card');
tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        tabBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        const category = btn.dataset.category;
        menuCards.forEach(card => {
            if (category === 'all' || card.dataset.category === category) {
                card.classList.remove('hidden');
                card.style.animation = 'fadeInUp 0.4s ease forwards';
            } else {
                card.classList.add('hidden');
            }
        });
    });
});

// ===== SCROLL REVEAL =====
const reveals = document.querySelectorAll('.about-grid, .menu-card, .gallery-item, .testi-card, .contact-item');
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
    const btn = this.querySelector('button[type="submit"]');
    btn.textContent = 'Terkirim! ✅';
    btn.style.background = '#059669';
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
