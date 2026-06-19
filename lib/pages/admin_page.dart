import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../state/app_state.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/menu_item.dart';
import '../widgets/footer_widget.dart';

class AdminPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onBackToHome;
  final VoidCallback? onNavigateToMenu;

  const AdminPage({
    super.key,
    required this.appState,
    required this.onBackToHome,
    this.onNavigateToMenu,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isPasswordVisible = false;

  // Stock controller maps to track user edits
  final Map<String, TextEditingController> _stockControllers = {};

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    for (var controller in _stockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.appState.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        setState(() {
          _errorMessage = null;
          _usernameController.clear();
          _passwordController.clear();
        });
      } else {
        setState(() {
          _errorMessage = widget.appState.lastLoginError ?? 'Username atau Password salah!';
        });
      }
    }
  }

  Future<void> _printReceipt(OrderModel order) async {
    final pdf = pw.Document();
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('WARUNG FINA BERRY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Order ID: ${order.id}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Tanggal: ${dateFormatter.format(order.date)}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Pelanggan: ${order.customerName}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Meja: ${order.tableNumber}', style: const pw.TextStyle(fontSize: 10)),
              pw.Divider(),
              ...order.items.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text('${item.item.name} x${item.quantity}', style: const pw.TextStyle(fontSize: 10))),
                    pw.Text(currencyFormatter.format(item.totalPrice), style: const pw.TextStyle(fontSize: 10)),
                  ],
                );
              }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(currencyFormatter.format(order.total), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text('Terima Kasih!', style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Struk_${order.id}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userRole = widget.appState.currentUserRole;

    if (userRole != null) {
      return _buildDashboard(userRole, isDark);
    }

    return _buildLoginForm(isDark);
  }

  // --- LOGIN FORM WIDGET ---
  Widget _buildLoginForm(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo fina berry.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fina Berry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sistem Manajemen Warung Makan',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login Staff',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Area Khusus Pegawai (Admin/Kasir). Pelanggan tidak perlu login.',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Username field
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        hintText: 'admin / kasir',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintText: '••••••••',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF10B981),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        return null;
                      },
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login',
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
            ),
            const SizedBox(height: 32),

            // Back to Client Link
            TextButton(
              onPressed: widget.onBackToHome,
              child: const Text(
                'Kembali ke halaman pelanggan',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
          ),
          FooterWidget(
            onNavigateToHome: widget.onBackToHome,
            onNavigateToMenu: widget.onNavigateToMenu,
          ),
        ],
      ),
    );
  }

  // --- DASHBOARD LAYOUT WITH TAB CONTROLLER ---
  Widget _buildDashboard(String role, bool isDark) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: isDark
              ? const Color(0xFF0B0F19)
              : const Color(0xFFF8FAFC),
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                role == 'admin' ? 'Fina Berry - Admin' : 'Fina Berry - Kasir',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () {
                  widget.appState.logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil keluar dari dashboard.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF10B981),
            labelColor: const Color(0xFF10B981),
            unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            tabs: [
              Tab(
                icon: Icon(
                  role == 'admin' ? Icons.bar_chart : Icons.receipt_long,
                ),
                text: role == 'admin' ? 'Analisis' : 'Antrean',
              ),
              Tab(
                icon: const Icon(Icons.restaurant_menu),
                text: 'Kelola Menu',
              ),
              Tab(
                icon: const Icon(Icons.inventory_2_outlined),
                text: 'Stok Bahan',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabOrdersAndStats(role, isDark),
            _buildTabMenuManagement(role, isDark),
            _buildTabStockInventory(isDark),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: ORDERS AND STATS ---
  Widget _buildTabOrdersAndStats(String role, bool isDark) {
    final revenue = widget.appState.totalRevenue;
    final totalOrders = widget.appState.totalOrdersCount;
    final activeOrders = widget.appState.activeOrdersCount;
    final menuCount = widget.appState.availableMenuItemsCount;
    final ordersList = widget.appState.orders;

    String formatRevenue(double rev) {
      if (rev >= 1000000) {
        return 'Rp ${(rev / 1000000).toStringAsFixed(1)}M';
      } else if (rev >= 1000) {
        return 'Rp ${(rev / 1000).toStringAsFixed(0)}K';
      }
      return 'Rp 0K';
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If Admin, show full financial stats
            if (role == 'admin') ...[
              _buildStatsCard(
                title: 'Total Pendapatan',
                value: formatRevenue(revenue),
                subtext: '+12.5% dari kemarin',
                icon: Icons.attach_money,
                iconColor: Colors.green,
                accentColor: const Color(0xFF10B981),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                title: 'Total Pesanan',
                value: '$totalOrders',
                subtext: 'Semua waktu',
                icon: Icons.shopping_bag_outlined,
                iconColor: Colors.blue,
                accentColor: Colors.blueAccent,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                title: 'Pesanan Aktif',
                value: '$activeOrders',
                subtext: 'Perlu diproses',
                icon: Icons.trending_up,
                iconColor: Colors.orange,
                accentColor: Colors.orangeAccent,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                title: 'Menu Tersedia',
                value: '$menuCount',
                subtext: 'Item menu',
                icon: Icons.restaurant,
                iconColor: Colors.purple,
                accentColor: Colors.purpleAccent,
                isDark: isDark,
              ),
              const SizedBox(height: 32),
            ],

            Text(
              'Daftar Antrean Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),

            ordersList.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Belum ada pesanan masuk.',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ordersList.length,
                    itemBuilder: (context, index) {
                      // Show newest first
                      final order = ordersList[ordersList.length - 1 - index];
                      return _buildOrderListItem(order, isDark);
                    },
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 12,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderListItem(OrderModel order, bool isDark) {
    String getStatusText(OrderStatus status) {
      switch (status) {
        case OrderStatus.pending:
          return 'Menunggu Konfirmasi';
        case OrderStatus.processing:
          return 'Sedang Diproses';
        case OrderStatus.completed:
          return 'Selesai & Lunas';
        case OrderStatus.cancelled:
          return 'Dibatalkan';
      }
    }

    Color getStatusColor(OrderStatus status) {
      switch (status) {
        case OrderStatus.pending:
          return Colors.orange;
        case OrderStatus.processing:
          return Colors.blue;
        case OrderStatus.completed:
          return const Color(0xFF10B981);
        case OrderStatus.cancelled:
          return Colors.redAccent;
      }
    }

    String formattedPrice =
        'Rp ${order.total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.grey[900],
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(order.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getStatusText(order.status),
                  style: TextStyle(
                    color: getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Items
          Text(
            order.items
                .map((e) => '${e.item.name} (${e.quantity}x)')
                .join(', '),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          // Customer details row
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${order.customerName} (Meja ${order.tableNumber})',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.paymentMethod,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedPrice,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10B981),
                  fontSize: 15,
                ),
              ),

              // Action buttons based on status
              Row(
                children: [
                  if (order.status == OrderStatus.pending) ...[
                    TextButton(
                      onPressed: () {
                        widget.appState.updateOrderStatus(
                          order.id,
                          OrderStatus.cancelled,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      child: const Text('Tolak'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Menerima Pemesanan -> moves to processing
                        widget.appState.updateOrderStatus(
                          order.id,
                          OrderStatus.processing,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Terima Pemesanan'),
                    ),
                  ],
                  if (order.status == OrderStatus.processing) ...[
                    ElevatedButton(
                      onPressed: () {
                        // Menerima Pembayaran -> moves to completed
                        widget.appState.updateOrderStatus(
                          order.id,
                          OrderStatus.completed,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Terima Pembayaran'),
                    ),
                  ],
                  if (order.status == OrderStatus.completed || order.status == OrderStatus.processing) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _printReceipt(order);
                      },
                      icon: const Icon(Icons.print, size: 16),
                      label: const Text('Cetak Struk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenuManagement(String role, bool isDark) {
    final items = widget.appState.menuItems;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF161F30) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(child: _AddMenuFormWidget(appState: widget.appState, isDark: isDark)),
              ),
            ),
          );
        },
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.category} • Rp ${item.price.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    widget.appState.removeMenuItem(item.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- TAB 3: STOCK INVENTORY (ADMIN & KASIR) ---
  Widget _buildTabStockInventory(bool isDark) {
    final stockList = widget.appState.bahanBakuList;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: stockList.length,
      itemBuilder: (context, index) {
        final material = stockList[index];
        final isLowStock = material.stockAmount <= material.minimumStock;

        // Initialize controllers if not existing
        if (!_stockControllers.containsKey(material.id)) {
          _stockControllers[material.id] = TextEditingController(
            text: material.stockAmount.toString(),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLowStock
                  ? Colors.orangeAccent.withOpacity(0.3)
                  : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
              width: isLowStock ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    material.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  if (isLowStock)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orangeAccent,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Stok Menipis!',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stok Saat Ini: ${material.stockAmount} ${material.unit}\n(Minimum: ${material.minimumStock} ${material.unit})',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),

                  // Stock Controller Buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xFF10B981),
                        ),
                        onPressed: () {
                          final newVal = material.stockAmount - 1.0;
                          if (newVal >= 0) {
                            widget.appState.updateStock(material.id, newVal);
                            _stockControllers[material.id]!.text = newVal
                                .toString();
                          }
                        },
                      ),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _stockControllers[material.id],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (v) {
                            final parsed = double.tryParse(v);
                            if (parsed != null && parsed >= 0) {
                              widget.appState.updateStock(material.id, parsed);
                            } else {
                              _stockControllers[material.id]!.text = material
                                  .stockAmount
                                  .toString();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF10B981),
                        ),
                        onPressed: () {
                          final newVal = material.stockAmount + 1.0;
                          widget.appState.updateStock(material.id, newVal);
                          _stockControllers[material.id]!.text = newVal
                              .toString();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddMenuFormWidget extends StatefulWidget {
  final AppState appState;
  final bool isDark;

  const _AddMenuFormWidget({required this.appState, required this.isDark});

  @override
  State<_AddMenuFormWidget> createState() => _AddMenuFormWidgetState();
}

class _AddMenuFormWidgetState extends State<_AddMenuFormWidget> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _category = 'Makanan';
  final _formKey = GlobalKey<FormState>();
  
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Menu Baru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameCtrl,
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Nama Menu',
                labelStyle: TextStyle(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                filled: true,
                fillColor: widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              maxLines: 2,
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                filled: true,
                fillColor: widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: widget.isDark ? const Color(0xFF161F30) : Colors.white,
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: TextStyle(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                filled: true,
                fillColor: widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Makanan', 'Minuman', 'Cemilan']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _category = v;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Harga (Rp)',
                labelStyle: TextStyle(
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                filled: true,
                fillColor: widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => v == null || double.tryParse(v) == null
                  ? 'Harga tidak valid'
                  : null,
            ),
            const SizedBox(height: 16),
            
            // Image Upload Section
            Text(
              'Gambar Menu',
              style: TextStyle(
                fontSize: 14,
                color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF1E293B) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 40,
                            color: widget.isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk upload gambar (JPG/PNG)',
                            style: TextStyle(
                              color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FutureBuilder<List<int>>(
                          future: _selectedImage!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Image.memory(
                                snapshot.data as dynamic,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Menyimpan menu...')),
                    );
                    
                    List<int>? imageBytes;
                    String? imageFilename;
                    if (_selectedImage != null) {
                      imageBytes = await _selectedImage!.readAsBytes();
                      imageFilename = _selectedImage!.name;
                    }

                    final newItem = MenuItem(
                      id: 'menu-${DateTime.now().millisecondsSinceEpoch}',
                      name: _nameCtrl.text,
                      description: _descCtrl.text,
                      category: _category,
                      price: double.parse(_priceCtrl.text),
                      imageUrl: '', // Backend akan mengembalikan URL gambar sebenarnya
                    );

                    await widget.appState.addMenuItem(
                      newItem,
                      imageBytes: imageBytes,
                      imageFilename: imageFilename,
                    );

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          backgroundColor: widget.isDark
                              ? const Color(0xFF161F30)
                              : Colors.white,
                          title: const Text('Berhasil!'),
                          content: const Text('Menu baru berhasil ditambahkan.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(c);
                              },
                              child: const Text(
                                'Tutup',
                                style: TextStyle(color: Color(0xFF10B981)),
                              ),
                            ),
                          ],
                        ),
                      );

                      _nameCtrl.clear();
                      _descCtrl.clear();
                      _priceCtrl.clear();
                      setState(() {
                        _selectedImage = null;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
