import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF0B0F19) : Colors.white,
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
                    Expanded(flex: 2, child: _buildBrandSection(isDark)),
                    const SizedBox(width: 40),
                    Expanded(flex: 1, child: _buildNavSection(isDark)),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildContactSection(isDark)),
                  ],
                ),
                const SizedBox(height: 40),
                _buildBottomSection(isDark),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandSection(isDark),
                const SizedBox(height: 32),
                _buildNavSection(isDark),
                const SizedBox(height: 32),
                _buildContactSection(isDark),
                const SizedBox(height: 40),
                _buildBottomSection(isDark),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBrandSection(bool isDark) {
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
                Text(
                  'Fina Berry',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
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
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon(Icons.camera_alt_outlined, isDark), // Instagram placeholder
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.chat_bubble_outline, isDark), // WhatsApp placeholder
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.facebook_outlined, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
      ),
      child: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey[700], size: 18),
    );
  }

  Widget _buildNavSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NAVIGASI',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink('Beranda', isDark),
        _buildFooterLink('Menu Kami', isDark),
        _buildFooterLink('Masuk', isDark),
        _buildFooterLink('Daftar Akun', isDark),
      ],
    );
  }

  Widget _buildFooterLink(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildContactSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HUBUNGI KAMI',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          Icons.location_on_outlined,
          "Warung Makan Fina Berry berada di kawasan D'LAS (Desa Wisata Lembah Asri), tepatnya di area dekat pintu keluar, Desa Serang, Kecamatan Karangreja, Kabupaten Purbalingga, Jawa Tengah.",
          isDark,
        ),
        const SizedBox(height: 16),
        _buildContactItem(Icons.phone_outlined, '+62 812-3456-7890', isDark),
        const SizedBox(height: 16),
        _buildContactItem(Icons.access_time_outlined, 'Setiap Hari · 08.00 - 22.00', isDark),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, bool isDark) {
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
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(bool isDark) {
    return Column(
      children: [
        Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCopyright(isDark),
                  _buildMadeWithLove(isDark),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildCopyright(isDark),
                  const SizedBox(height: 12),
                  _buildMadeWithLove(isDark),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCopyright(bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], fontSize: 12),
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

  Widget _buildMadeWithLove(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: Colors.redAccent, size: 14),
        const SizedBox(width: 6),
        Text(
          'Dibuat dengan cinta untuk pelanggan kami',
          style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}
