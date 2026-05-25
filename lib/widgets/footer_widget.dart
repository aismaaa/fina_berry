import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark aesthetic footer inspired by standard web/app premium layouts
    return Container(
      width: double.infinity,
      color: const Color(0xFF0B0F19), // Match the dark theme background
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;

          if (isWide) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildBrandSection()),
                    const SizedBox(width: 40),
                    Expanded(flex: 1, child: _buildNavSection()),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildContactSection()),
                  ],
                ),
                const SizedBox(height: 40),
                _buildBottomSection(),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandSection(),
                const SizedBox(height: 32),
                _buildNavSection(),
                const SizedBox(height: 32),
                _buildContactSection(),
                const SizedBox(height: 40),
                _buildBottomSection(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo fina berry.jpeg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fina Berry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'WARUNG MAKAN',
                  style: TextStyle(
                    color: const Color(0xFF10B981),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Nikmati cita rasa autentik dengan bahan-bahan pilihan terbaik. Kami berkomitmen menghadirkan pengalaman kuliner yang tak terlupakan untuk setiap momen spesial Anda.',
          style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon(Icons.camera_alt_outlined), // Instagram placeholder
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.chat_bubble_outline), // WhatsApp placeholder
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.facebook_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF161F30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Icon(icon, color: Colors.grey[400], size: 18),
    );
  }

  Widget _buildNavSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NAVIGASI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink('Beranda'),
        _buildFooterLink('Menu Kami'),
        _buildFooterLink('Masuk'),
        _buildFooterLink('Daftar Akun'),
      ],
    );
  }

  Widget _buildFooterLink(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HUBUNGI KAMI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          Icons.location_on_outlined,
          "Warung Makan Fina Berry berada di kawasan D'LAS (Desa Wisata Lembah Asri), tepatnya di area dekat pintu keluar, Desa Serang, Kecamatan Karangreja, Kabupaten Purbalingga, Jawa Tengah.",
        ),
        const SizedBox(height: 16),
        _buildContactItem(Icons.phone_outlined, '+62 812-3456-7890'),
        const SizedBox(height: 16),
        _buildContactItem(Icons.access_time_outlined, 'Setiap Hari · 08.00 - 22.00'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF10B981), size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Divider(color: Colors.grey[800]),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCopyright(),
                  _buildMadeWithLove(),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildCopyright(),
                  const SizedBox(height: 12),
                  _buildMadeWithLove(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
        children: const [
          TextSpan(text: '© 2026 '),
          TextSpan(
            text: 'Warung Fina Berry',
            style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '. Semua hak cipta dilindungi.'),
        ],
      ),
    );
  }

  Widget _buildMadeWithLove() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: Colors.redAccent, size: 14),
        const SizedBox(width: 6),
        Text(
          'Dibuat dengan cinta untuk pelanggan kami',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}
