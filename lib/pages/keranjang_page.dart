import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'checkout_page.dart';
import '../widgets/footer_widget.dart';
import '../widgets/menu_image_widget.dart';

// ─── Daftar voucher contoh yang bisa dipakai ───
class _Voucher {
  final String code;
  final String label;
  final double discountPercent; // 0 jika flat
  final double discountFlat;    // 0 jika persen

  const _Voucher({
    required this.code,
    required this.label,
    this.discountPercent = 0,
    this.discountFlat = 0,
  });
}

const List<_Voucher> _validVouchers = [
  _Voucher(code: 'FINABERRY10', label: 'Diskon 10%', discountPercent: 0.10),
  _Voucher(code: 'HEMAT20K', label: 'Potongan Rp 20.000', discountFlat: 20000),
  _Voucher(code: 'SPESIAL50', label: 'Diskon 50%', discountPercent: 0.50),
  _Voucher(code: 'GRATIS5K', label: 'Potongan Rp 5.000', discountFlat: 5000),
];

class KeranjangPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onNavigateToMenu;
  final VoidCallback? onNavigateToHome;

  const KeranjangPage({
    super.key,
    required this.appState,
    required this.onNavigateToMenu,
    this.onNavigateToHome,
  });

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  _Voucher? _appliedVoucher;

  double _calcDiscount(double subtotal) {
    if (_appliedVoucher == null) return 0;
    if (_appliedVoucher!.discountPercent > 0) {
      return subtotal * _appliedVoucher!.discountPercent;
    }
    return _appliedVoucher!.discountFlat;
  }

  void _applyVoucher(String code) {
    final trimmed = code.trim().toUpperCase();
    final found = _validVouchers.cast<_Voucher?>().firstWhere(
      (v) => v!.code == trimmed,
      orElse: () => null,
    );
    setState(() => _appliedVoucher = found);

    if (found != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Voucher "${found.label}" berhasil dipakai!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Voucher "$trimmed" tidak valid.'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _removeVoucher() => setState(() => _appliedVoucher = null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartItems = widget.appState.cartItems;

    String formatPrice(double price) {
      return 'Rp ${price.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
    }

    final subtotal = widget.appState.cartSubtotal;
    final tax      = widget.appState.cartTax;
    final discount = _calcDiscount(subtotal + tax);
    final total    = (subtotal + tax - discount).clamp(0.0, double.infinity);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            child: Text(
              'Keranjang Belanja',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                fontFamily: 'Montserrat',
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
          ),

          // Cart items list
          if (cartItems.isEmpty)
            _buildEmptyState(context, isDark)
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final item = cartItem.item;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: MenuImageWidget(
                            imageUrl: item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            iconSize: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.grey[900],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => widget.appState.removeFromCart(item.id),
                                    child: Icon(Icons.delete_outline, color: Colors.red[400], size: 22),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildQuantityBtn(
                                        icon: Icons.remove,
                                        onTap: () => widget.appState.decrementQuantity(item.id),
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.grey[900],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildQuantityBtn(
                                        icon: Icons.add,
                                        onTap: () => widget.appState.incrementQuantity(item.id),
                                        isDark: isDark,
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Text(
                                      formatPrice(cartItem.totalPrice),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF10B981),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Order Summary Section
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Subtotal (${widget.appState.cartCount} item)', formatPrice(subtotal), isDark),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Pajak & Layanan', formatPrice(tax), isDark),

                  // ── Voucher Input ──
                  const SizedBox(height: 16),
                  _VoucherInputWidget(
                    isDark: isDark,
                    appliedVoucher: _appliedVoucher?.label,
                    onApply: _applyVoucher,
                    onRemove: _removeVoucher,
                  ),

                  // ── Discount row (muncul hanya kalau voucher aktif) ──
                  if (_appliedVoucher != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_offer, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Text(
                              _appliedVoucher!.label,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '- ${formatPrice(discount)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.grey[900],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          formatPrice(total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              appState: widget.appState,
                              onNavigateToHome: () {
                                Navigator.pop(context);
                                if (widget.onNavigateToHome != null) widget.onNavigateToHome!();
                              },
                              onNavigateToMenu: () {
                                Navigator.pop(context);
                                widget.onNavigateToMenu();
                              },
                              onOrderSuccess: () {
                                Navigator.pop(context);
                                widget.onNavigateToMenu();
                              },
                              onCancel: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Lanjut ke Checkout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: widget.onNavigateToMenu,
                      child: const Text(
                        'Tambah Menu Lainnya',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
          FooterWidget(
            onNavigateToHome: widget.onNavigateToHome,
            onNavigateToMenu: widget.onNavigateToMenu,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: isDark ? Colors.grey[700] : Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Keranjang belanja kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan tambahkan menu lezat kami ke keranjang',
              style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[500] : Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onNavigateToMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Belanja Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBtn({required IconData icon, required VoidCallback onTap, required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[800],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Voucher Input Widget ───────────────────────────────────────────────────

class _VoucherInputWidget extends StatefulWidget {
  final bool isDark;
  final String? appliedVoucher;
  final void Function(String code) onApply;
  final VoidCallback onRemove;

  const _VoucherInputWidget({
    required this.isDark,
    required this.onApply,
    required this.onRemove,
    this.appliedVoucher,
  });

  @override
  State<_VoucherInputWidget> createState() => _VoucherInputWidgetState();
}

class _VoucherInputWidgetState extends State<_VoucherInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isApplied = widget.appliedVoucher != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextField(
                  controller: _controller,
                  enabled: !isApplied,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: isApplied ? widget.appliedVoucher : 'Masukkan kode voucher',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: isApplied
                          ? const Color(0xFF10B981)
                          : (widget.isDark ? Colors.grey[500] : Colors.grey[400]),
                      fontWeight: isApplied ? FontWeight.bold : FontWeight.normal,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    filled: true,
                    fillColor: isApplied
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : (widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: isApplied
                          ? const BorderSide(color: Color(0xFF10B981), width: 1.5)
                          : BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: isApplied
                          ? const BorderSide(color: Color(0xFF10B981), width: 1.5)
                          : BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      isApplied ? Icons.check_circle : Icons.local_offer_outlined,
                      size: 18,
                      color: isApplied
                          ? const Color(0xFF10B981)
                          : (widget.isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isDark ? Colors.white : Colors.black87,
                  ),
                  onSubmitted: (v) {
                    if (v.isNotEmpty) widget.onApply(v);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: isApplied
                  ? OutlinedButton(
                      onPressed: () {
                        _controller.clear();
                        widget.onRemove();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) widget.onApply(_controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Pakai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
            ),
          ],
        ),

        // ── Hint contoh voucher ──
        if (!isApplied)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4),
            child: Text(
              'Masukkan kode voucher jika ada',
              style: TextStyle(
                fontSize: 11,
                color: widget.isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ),
      ],
    );
  }
}
