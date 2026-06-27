import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../state/app_state.dart';
import '../widgets/footer_widget.dart';

class CheckoutPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOrderSuccess;
  final VoidCallback onCancel;
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onNavigateToMenu;

  const CheckoutPage({
    super.key,
    required this.appState,
    required this.onOrderSuccess,
    required this.onCancel,
    this.onNavigateToHome,
    this.onNavigateToMenu,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TextEditingController _nameController;
  late TextEditingController _tableController;
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'QRIS'; // Default to QRIS
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'sobur');
    _tableController = TextEditingController(text: widget.appState.tableNumber ?? 'A4');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  Future<void> _processMidtransPayment(
    String name,
    String table,
    int amount,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil backend Laravel kita yang sudah terintegrasi dengan Midtrans
      final items = widget.appState.cartItems.map((cartItem) => {
        'menu_id': cartItem.item.id,
        'quantity': cartItem.quantity,
        'price': cartItem.item.price,
      }).toList();

      final response = await http.post(
        Uri.parse('${widget.appState.baseUrl}/orders'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customerName': name,
          'tableNumber': table,
          'paymentMethod': _selectedPaymentMethod,
          'total': amount,
          'items': items,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['redirect_url'] != null) {
        // Kosongkan keranjang lokal setelah order berhasil dibuat
        widget.appState.clearCart();

        final orderId = data['id']?.toString() ?? '-';
        final orderTotal = data['total']?.toString() ?? amount.toString();

        // Buka URL Pembayaran Midtrans di browser eksternal
        final redirectUrl = Uri.parse(data['redirect_url']);
        if (!await launchUrl(redirectUrl, mode: LaunchMode.externalApplication)) {
          throw Exception('Tidak dapat membuka halaman pembayaran');
        }

        // Refresh orders di background (agar muncul di kasir)
        widget.appState.fetchOrders();

        if (mounted) {
          // Tampilkan dialog notifikasi pembayaran
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Theme.of(ctx).brightness == Brightness.dark
                  ? const Color(0xFF161F30)
                  : Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 56),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pesanan Berhasil Dibuat!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pesanan #$orderId telah dikirim ke dapur.\nSelesaikan pembayaran di halaman yang baru dibuka.',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: Rp ${int.tryParse(orderTotal.split('.').first)?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.') ?? orderTotal}',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK, Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
          widget.onOrderSuccess();
        }

      } else if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['midtrans_error'] != null) {
        // Order berhasil dibuat tapi Midtrans error
        widget.appState.clearCart();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order dibuat, tapi pembayaran online gagal: ${data['midtrans_error']}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
          widget.onOrderSuccess();
        }
      } else {
        final errorMsg = data['error_messages'] != null
            ? data['error_messages'].toString()
            : data['details'] ?? data['error'] ?? 'Gagal membuat pesanan';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal: $errorMsg'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String formatPrice(double price) {
      return 'Rp ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0F19)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF0B0F19)
            : const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: widget.onCancel,
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CUSTOMER INFO CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161F30)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.3 : 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Pelanggan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[900],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nama Lengkap',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama lengkap wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nomor Meja',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _tableController,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nomor meja wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xFF10B981),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Dari QR Code scan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF059669),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // PAYMENT METHOD CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161F30)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.3 : 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Metode Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[900],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentMethodOption(
                              method: 'QRIS',
                              title: 'QRIS',
                              subtitle: 'Scan QR untuk bayar',
                              icon: Icons.qr_code_scanner,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildPaymentMethodOption(
                              method: 'Cash',
                              title: 'Cash',
                              subtitle: 'Bayar di kasir',
                              icon: Icons.account_balance_wallet_outlined,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildPaymentMethodOption(
                              method: 'Debit/Credit Card',
                              title: 'Debit/Credit Card',
                              subtitle: 'Bayar dengan kartu',
                              icon: Icons.credit_card,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FooterWidget(
                        onNavigateToHome: widget.onNavigateToHome,
                        onNavigateToMenu: widget.onNavigateToMenu,
                      ),
                    ],
                  ),
                ),
              ),

              // BOTTOM SHEET SUMMARY & ACTIONS
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            formatPrice(widget.appState.cartTotal),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final name = _nameController.text;
                                  final table = _tableController.text;
                                  final payment = _selectedPaymentMethod;
                                  final totalVal = widget.appState.cartTotal;

                                  if (payment == 'Cash') {
                                    // Cash: Proses langsung tanpa Midtrans
                                    widget.appState.checkout(
                                      customerName: name,
                                      tableNumber: table,
                                      paymentMethod: payment,
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        backgroundColor: isDark
                                            ? const Color(0xFF161F30)
                                            : Colors.white,
                                        title: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF10B981),
                                              size: 28,
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Pesanan Terkirim!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          'Terima kasih, $name! Pesanan Anda di meja $table sebesar ${formatPrice(totalVal)} telah dibuat dengan metode pembayaran $payment.',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[800],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onOrderSuccess();
                                            },
                                            child: const Text(
                                              'Selesai',
                                              style: TextStyle(
                                                color: Color(0xFF10B981),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // QRIS / Debit: Proses ke Midtrans
                                    _processMidtransPayment(
                                      name,
                                      table,
                                      totalVal.toInt(),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Konfirmasi & Buat Pesanan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required String method,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B).withOpacity(0.3)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF10B981)
                : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Icon
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF10B981) : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 16),
            // Leading Method Icon
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.grey[800],
              size: 24,
            ),
            const SizedBox(width: 16),
            // Text Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
