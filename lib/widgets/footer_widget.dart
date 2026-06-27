import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onNavigateToMenu;

  const FooterWidget({
    super.key,
    this.onNavigateToHome,
    this.onNavigateToMenu,
  });

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
                'assets/images/logo fina berry.png',
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
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fina Berry',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'WARUNG MAKAN',
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Nikmati cita rasa autentik dengan bahan-bahan pilihan terbaik. Kami berkomitmen menghadirkan pengalaman kuliner yang tak terlupakan untuk setiap momen spesial Anda.',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon(
              Icons.camera_alt_outlined,
              isDark,
              url: 'https://www.instagram.com/fina.berry?igsh=MWR0OGRpdXB2bzQwMg==',
              color: const Color(0xFFE1306C), // Instagram pink
            ),
            const SizedBox(width: 12),
            _buildSocialIcon(
              Icons.chat_bubble_outline,
              isDark,
              url: 'https://wa.me/6285647731631',
              color: const Color(0xFF25D366), // WhatsApp green
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    bool isDark, {
    required String url,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
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
        _buildFooterLink('Beranda', isDark, onTap: onNavigateToHome),
        _buildFooterLink('Menu Kami', isDark, onTap: onNavigateToMenu),
       
      ],
    );
  }

  Widget _buildFooterLink(String title, bool isDark, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 13,
            decoration: onTap != null ? TextDecoration.underline : null,
            decorationColor: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
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
        _buildContactItem(
          Icons.access_time_outlined,
          'Setiap Hari · 08.00 - 22.00',
          isDark,
        ),
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
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
              height: 1.5,
            ),
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
                  Expanded(child: _buildCopyright(isDark)),
                  const SizedBox(width: 16),
                  Flexible(child: _buildMadeWithLove(isDark)),
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
        style: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontSize: 12,
        ),
        children: const [
          TextSpan(text: '© 2026 '),
          TextSpan(
            text: 'Warung Fina Berry',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontWeight: FontWeight.bold,
            ),
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
        Flexible(
          child: Text(
            'Dibuat dengan cinta untuk pelanggan kami',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
