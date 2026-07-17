import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../state/app_state.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/menu_item.dart';
import '../models/bahan_baku_model.dart';
import '../widgets/footer_widget.dart';
import '../widgets/menu_image_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show max;

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
  bool _isRefreshingOrders = false;

  Future<void> _refreshOrders() async {
    setState(() => _isRefreshingOrders = true);
    await widget.appState.fetchOrders();
    if (mounted) setState(() => _isRefreshingOrders = false);
  }

  @override
  void initState() {
    super.initState();
    // Auto-refresh orders when admin page opens
    widget.appState.fetchOrders();
  }

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

    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Struk_${order.id}.pdf',
    );
  }

  Future<void> _printMonthlyReport(bool isDark) async {
    final pdf = pw.Document();
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));

    final monthlyOrders = widget.appState.orders
        .where((o) => o.date.isAfter(monthAgo) && o.status == OrderStatus.completed)
        .toList();

    final totalMonthly = monthlyOrders.fold<double>(0, (sum, o) => sum + o.total);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          pw.Center(
            child: pw.Text('LAPORAN BULANAN - FINA BERRY',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              '${dateFormatter.format(monthAgo)} s.d. ${dateFormatter.format(now)}',
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Divider(height: 24),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Transaksi: ${monthlyOrders.length} pesanan',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Text('Total Pendapatan: ${currencyFormatter.format(totalMonthly)}',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(height: 16),
          if (monthlyOrders.isEmpty)
            pw.Center(child: pw.Text('Tidak ada transaksi selesai dalam 30 hari terakhir.'))
          else
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Order ID', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Pelanggan / Meja', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Tgl', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  ],
                ),
                ...monthlyOrders.map((order) => pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(order.id, style: const pw.TextStyle(fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${order.customerName} / Meja ${order.tableNumber}', style: const pw.TextStyle(fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(DateFormat('dd/MM').format(order.date), style: const pw.TextStyle(fontSize: 9))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(currencyFormatter.format(order.total), style: const pw.TextStyle(fontSize: 9))),
                  ],
                )),
              ],
            ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'TOTAL: ${currencyFormatter.format(totalMonthly)}',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final monthStr = '${DateFormat('ddMMMyyyy').format(monthAgo)}_${DateFormat('ddMMMyyyy').format(now)}';
    await Printing.sharePdf(bytes: bytes, filename: 'Laporan_Bulanan_$monthStr.pdf');
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
    final tabCount = role == 'admin' ? 2 : 3;
    return DefaultTabController(
      length: tabCount,
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
              Expanded(
                child: Text(
                  role == 'admin' ? 'Fina Berry - Admin' : 'Fina Berry - Kasir',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.grey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
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
            tabs: role == 'admin'
                ? const [
                    Tab(icon: Icon(Icons.bar_chart), text: 'Analisis & Laporan'),
                    Tab(icon: Icon(Icons.restaurant_menu), text: 'Kelola Menu'),
                  ]
                : const [
                    Tab(icon: Icon(Icons.receipt_long), text: 'Antrean Aktif'),
                    Tab(icon: Icon(Icons.check_circle_outline), text: 'Pesanan Selesai'),
                    Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Stok Bahan'),
                  ],
          ),
        ),
        body: TabBarView(
          children: role == 'admin'
              ? [
                  _buildTabAdminStats(isDark),
                  _buildTabMenuManagement(role, isDark),
                ]
              : [
                  _buildTabKasirAntrian(isDark),
                  _buildTabKasirSelesai(isDark),
                  _buildTabStockInventory(isDark),
                ],
        ),
      ),
    );
  }

  // --- TAB 1 ADMIN: STATS + WEEKLY REPORT ---
  Widget _buildTabAdminStats(bool isDark) {
    final revenue = widget.appState.totalRevenue;
    final totalOrders = widget.appState.totalOrdersCount;
    final activeOrders = widget.appState.activeOrdersCount;
    final menuCount = widget.appState.availableMenuItemsCount;

    String formatRevenue(double rev) {
      if (rev >= 1000000) return 'Rp ${(rev / 1000000).toStringAsFixed(1)}M';
      if (rev >= 1000) return 'Rp ${(rev / 1000).toStringAsFixed(0)}K';
      return 'Rp 0';
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(title: 'Total Pendapatan', value: formatRevenue(revenue), subtext: 'Dari pesanan selesai', icon: Icons.attach_money, iconColor: Colors.green, accentColor: const Color(0xFF10B981), isDark: isDark),
            const SizedBox(height: 16),
            _buildStatsCard(title: 'Total Pesanan', value: '$totalOrders', subtext: 'Semua waktu', icon: Icons.shopping_bag_outlined, iconColor: Colors.blue, accentColor: Colors.blueAccent, isDark: isDark),
            const SizedBox(height: 16),
            _buildStatsCard(title: 'Pesanan Aktif', value: '$activeOrders', subtext: 'Perlu diproses', icon: Icons.trending_up, iconColor: Colors.orange, accentColor: Colors.orangeAccent, isDark: isDark),
            const SizedBox(height: 16),
            _buildStatsCard(title: 'Menu Tersedia', value: '$menuCount', subtext: 'Item menu', icon: Icons.restaurant, iconColor: Colors.purple, accentColor: Colors.purpleAccent, isDark: isDark),
            const SizedBox(height: 32),

            // Monthly Revenue Chart
            Text(
              'Grafik Pendapatan 30 Hari Terakhir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 250,
              padding: const EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 10),
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
              child: _buildRevenueChart(isDark),
            ),
            const SizedBox(height: 32),

            // Monthly PDF Report section
            Text(
              'Laporan Bulanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: Color(0xFF10B981), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cetak Laporan Per Bulan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[900],
                              ),
                            ),
                            Text(
                              'Ekspor data pesanan 30 hari terakhir ke PDF',
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _printMonthlyReport(isDark),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Unduh Laporan PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(bool isDark) {
    final now = DateTime.now();
    final int daysCount = 30;
    final List<FlSpot> spots = [];
    final List<String> dayLabels = List.filled(daysCount, '');
    final List<double> dailyRevenues = List.filled(daysCount, 0.0);

    for (int i = 0; i < daysCount; i++) {
      final dayIndex = (daysCount - 1) - i;
      final day = now.subtract(Duration(days: dayIndex));
      dayLabels[i] = DateFormat('dd/MM').format(day);

      final dailyOrders = widget.appState.orders.where((o) =>
          o.status == OrderStatus.completed &&
          o.date.year == day.year &&
          o.date.month == day.month &&
          o.date.day == day.day);

      final dailyRevenue = dailyOrders.fold<double>(0, (sum, o) => sum + o.total);
      dailyRevenues[i] = dailyRevenue;
      spots.add(FlSpot(i.toDouble(), dailyRevenue));
    }

    final maxRevenue = dailyRevenues.isEmpty ? 0.0 : dailyRevenues.reduce(max);
    double maxY = maxRevenue > 0 ? maxRevenue * 1.2 : 100000.0;
    
    if (maxY > 1000000) {
      maxY = (maxY / 1000000).ceil() * 1000000.0;
    } else if (maxY > 100000) {
      maxY = (maxY / 100000).ceil() * 100000.0;
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        minX: 0,
        maxX: (daysCount - 1).toDouble(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => isDark ? const Color(0xFF2A364E) : Colors.grey[800]!,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final revenue = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(touchedSpot.y);
                return LineTooltipItem(
                  '${dayLabels[touchedSpot.x.toInt()]}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  children: [
                    TextSpan(
                      text: revenue,
                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                // Show label every 5 days to avoid crowding
                if (value.toInt() % 5 != 0 && value.toInt() != (daysCount - 1)) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dayLabels[value.toInt()],
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              reservedSize: 28,
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == maxY || value == 0) return const SizedBox.shrink();
                
                String text = '';
                if (value >= 1000000) {
                  text = '${(value / 1000000).toStringAsFixed(1)}M';
                } else if (value >= 1000) {
                  text = '${(value / 1000).toStringAsFixed(0)}K';
                } else {
                  text = value.toStringAsFixed(0);
                }

                return Text(
                  text,
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY / 4) > 0 ? (maxY / 4) : 25000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.3),
                  const Color(0xFF10B981).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1 KASIR: ANTREAN AKTIF ---
  Widget _buildTabKasirAntrian(bool isDark) {
    final activeOrders = widget.appState.orders
        .where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.processing)
        .toList()
        .reversed
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        color: const Color(0xFF10B981),
        onRefresh: _refreshOrders,
        child: activeOrders.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined, size: 48, color: isDark ? Colors.grey[700] : Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text('Tidak ada antrean aktif.', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                        const SizedBox(height: 8),
                        Text('Tarik ke bawah untuk refresh', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[600] : Colors.grey[400])),
                      ],
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activeOrders.length,
                itemBuilder: (context, index) => _buildOrderListItem(activeOrders[index], isDark),
              ),
      ),
    );
  }

  // --- TAB 2 KASIR: PESANAN SELESAI ---
  Widget _buildTabKasirSelesai(bool isDark) {
    final doneOrders = widget.appState.orders
        .where((o) => o.status == OrderStatus.completed || o.status == OrderStatus.cancelled)
        .toList()
        .reversed
        .toList();

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM, HH:mm', 'id_ID');

    return doneOrders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: isDark ? Colors.grey[700] : Colors.grey[400]),
                const SizedBox(height: 12),
                Text('Belum ada pesanan selesai.', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doneOrders.length,
            itemBuilder: (context, index) {
              final order = doneOrders[index];
              final isCompleted = order.status == OrderStatus.completed;
              final statusColor = isCompleted ? const Color(0xFF10B981) : Colors.redAccent;
              final statusText = isCompleted ? 'Selesai & Lunas' : 'Dibatalkan';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order.id,
                            style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900], fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.customerName} • Meja ${order.tableNumber}',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                    Text(
                      dateFormatter.format(order.date),
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey[500]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormatter.format(order.total),
                          style: TextStyle(fontWeight: FontWeight.w800, color: statusColor, fontSize: 15),
                        ),
                        if (isCompleted)
                          ElevatedButton.icon(
                            onPressed: () => _printReceipt(order),
                            icon: const Icon(Icons.print, size: 14),
                            label: const Text('Struk', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  subtext,
                  style: TextStyle(
                    fontSize: 12,
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
    final dateFormatter = DateFormat('dd MMM, HH:mm', 'id_ID');

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
              Expanded(
                child: Text(
                  order.id,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.grey[900],
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
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
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
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
              Expanded(
                child: Text(
                  '${order.customerName} (Meja ${order.tableNumber})',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                dateFormatter.format(order.date),
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedPrice,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF10B981),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          // Action buttons — pakai Wrap agar tidak overflow di layar kecil
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (order.status == OrderStatus.pending) ...[
                TextButton(
                  onPressed: () => widget.appState.updateOrderStatus(
                    order.id, OrderStatus.cancelled),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Tolak', style: TextStyle(fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () => widget.appState.updateOrderStatus(
                    order.id, OrderStatus.processing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Terima Pesanan', style: TextStyle(fontSize: 12)),
                ),
              ],
              if (order.status == OrderStatus.processing)
                ElevatedButton(
                  onPressed: () => widget.appState.updateOrderStatus(
                    order.id, OrderStatus.completed),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Pesanan Selesai', style: TextStyle(fontSize: 12)),
                ),
              if (order.status == OrderStatus.completed || order.status == OrderStatus.processing)
                ElevatedButton.icon(
                  onPressed: () => _printReceipt(order),
                  icon: const Icon(Icons.print, size: 14),
                  label: const Text('Cetak Struk', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
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
                child: SingleChildScrollView(child: _MenuFormWidget(appState: widget.appState, isDark: isDark)),
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
                  child: MenuImageWidget(
                    imageUrl: item.imageUrl,
                    width: 60,
                    height: 60,
                    iconSize: 24,
                    borderRadius: BorderRadius.circular(12),
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
                    Icons.edit_outlined,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: isDark ? const Color(0xFF161F30) : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        content: SizedBox(
                          width: 400,
                          child: SingleChildScrollView(child: _MenuFormWidget(appState: widget.appState, isDark: isDark, menuToEdit: item)),
                        ),
                      ),
                    );
                  },
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

  // --- TAB 3: STOCK INVENTORY (KASIR ONLY) ---
  Widget _buildTabStockInventory(bool isDark) {
    final stockList = widget.appState.bahanBakuList;

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
                child: SingleChildScrollView(child: _BahanBakuFormWidget(appState: widget.appState, isDark: isDark)),
              ),
            ),
          );
        },
      ),
      body: ListView.builder(
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
                    Expanded(
                      child: Text(
                        material.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
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
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        widget.appState.removeBahanBaku(material.id);
                      },
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
    ),
    );
  }
}



class _MenuFormWidget extends StatefulWidget {
  final AppState appState;
  final bool isDark;
  final MenuItem? menuToEdit;

  const _MenuFormWidget({required this.appState, required this.isDark, this.menuToEdit});

  @override
  State<_MenuFormWidget> createState() => _MenuFormWidgetState();
}

class _MenuFormWidgetState extends State<_MenuFormWidget> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _category = 'Makanan';
  final _formKey = GlobalKey<FormState>();
  
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.menuToEdit != null) {
      _nameCtrl.text = widget.menuToEdit!.name;
      _descCtrl.text = widget.menuToEdit!.description;
      _priceCtrl.text = widget.menuToEdit!.price.toInt().toString();
      _category = widget.menuToEdit!.category;
    }
  }

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
              widget.menuToEdit == null ? 'Tambah Menu Baru' : 'Edit Menu',
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
                      id: widget.menuToEdit?.id ?? 'menu-${DateTime.now().millisecondsSinceEpoch}',
                      name: _nameCtrl.text,
                      description: _descCtrl.text,
                      category: _category,
                      price: double.parse(_priceCtrl.text),
                      imageUrl: widget.menuToEdit?.imageUrl ?? '',
                    );

                    if (widget.menuToEdit == null) {
                      await widget.appState.addMenuItem(
                        newItem,
                        imageBytes: imageBytes,
                        imageFilename: imageFilename,
                      );
                    } else {
                      await widget.appState.updateMenuItem(
                        newItem,
                        imageBytes: imageBytes,
                        imageFilename: imageFilename,
                      );
                    }

                    if (mounted) {
                      // Tutup form dialog dulu agar user bisa lihat foto yang baru diupload
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.menuToEdit == null
                                ? '✅ Menu baru berhasil ditambahkan!'
                                : '✅ Menu berhasil diperbarui!',
                          ),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
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

class _BahanBakuFormWidget extends StatefulWidget {
  final AppState appState;
  final bool isDark;

  const _BahanBakuFormWidget({required this.appState, required this.isDark});

  @override
  State<_BahanBakuFormWidget> createState() => _BahanBakuFormWidgetState();
}

class _BahanBakuFormWidgetState extends State<_BahanBakuFormWidget> {
  final _nameCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _minStockCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
    _stockCtrl.dispose();
    _minStockCtrl.dispose();
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
              'Tambah Bahan Baku Baru',
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
                labelText: 'Nama Bahan Baku',
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
              controller: _unitCtrl,
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Satuan (kg, pcs, dll)',
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
              controller: _stockCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Stok Awal',
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
              validator: (v) => v == null || double.tryParse(v) == null ? 'Wajib diisi angka' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _minStockCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Stok Minimum',
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
              validator: (v) => v == null || double.tryParse(v) == null ? 'Wajib diisi angka' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newItem = BahanBaku(
                      id: 'bb-${DateTime.now().millisecondsSinceEpoch}',
                      name: _nameCtrl.text,
                      stockAmount: double.parse(_stockCtrl.text),
                      unit: _unitCtrl.text,
                      minimumStock: double.parse(_minStockCtrl.text),
                    );
                    widget.appState.addBahanBaku(newItem);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Bahan baku berhasil ditambahkan!'),
                        backgroundColor: Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
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
                  'Simpan Bahan Baku',
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

