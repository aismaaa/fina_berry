import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'pages/beranda_page.dart';
import 'pages/menu_page.dart';
import 'pages/keranjang_page.dart';
import 'pages/admin_page.dart';
import 'pages/scan_page.dart';
import 'pages/chat_screen.dart';
import 'pages/riwayat_transaksi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();
  bool _isScanned = false;

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  void _onScanSuccess() {
    setState(() {
      _isScanned = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Fina Berry',
          debugShowCheckedModeBanner: false,
          themeMode: _appState.themeMode,
          // Light theme configuration
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF10B981),
              brightness: Brightness.light,
              primary: const Color(0xFF10B981),
              background: const Color(0xFFF8FAFC),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            cardColor: Colors.white,
            fontFamily: 'Montserrat',
          ),
          // Premium dark theme configuration (matching screenshots)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF10B981),
              brightness: Brightness.dark,
              primary: const Color(0xFF10B981),
              background: const Color(0xFF0B0F19),
              surface: const Color(0xFF161F30),
            ),
            scaffoldBackgroundColor: const Color(0xFF0B0F19),
            cardColor: const Color(0xFF161F30),
            fontFamily: 'Montserrat',
          ),
          home: _isScanned 
              ? MainLayout(appState: _appState)
              : ScanPage(
                  appState: _appState, 
                  onScanSuccess: _onScanSuccess,
                ),
        );
      },
    );
  }
}

class MainLayout extends StatefulWidget {
  final AppState appState;

  const MainLayout({super.key, required this.appState});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _onNavigateToMenu() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _onNavigateToCart() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _onNavigateToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  Widget _buildChatFAB(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, animation, __) => const ChatScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.easeOutCubic),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 320),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = widget.appState.cartCount;

    // List of screens matching the bottom tabs
    final List<Widget> screens = [
      BerandaPage(
        onNavigateToHome: _onNavigateToHome,
        onNavigateToMenu: _onNavigateToMenu,
      ),
      MenuPage(
        appState: widget.appState,
        onNavigateToHome: _onNavigateToHome,
        onNavigateToMenu: _onNavigateToMenu,
      ),
      KeranjangPage(
        appState: widget.appState,
        onNavigateToHome: _onNavigateToHome,
        onNavigateToMenu: _onNavigateToMenu,
      ),
      RiwayatTransaksiPage(
        appState: widget.appState,
      ),
      AdminPage(
        appState: widget.appState,
        onBackToHome: _onNavigateToHome,
        onNavigateToMenu: _onNavigateToMenu,
      ),
    ];

    return Scaffold(
      // Chat FAB — opens AI chatbot
      floatingActionButton: _buildChatFAB(isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Top AppBar matching the screenshots
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF0B0F19)
            : const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo fina berry.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 18,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Fina Berry',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
          ],
        ),
        actions: [
          // Theme mode toggle (Sun / Moon)
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
            onPressed: () {
              widget.appState.toggleTheme();
            },
          ),
          // Cart Icon with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
                onPressed: _onNavigateToCart,
              ),
              if (cartCount > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF97316), // Orange badge
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Hamburger menu (placeholder)
          IconButton(
            icon: Icon(
              Icons.menu,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
            onPressed: () {
              // Standard aesthetic callback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu Fina Berry diaktifkan'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: screens[_selectedIndex]),
      // Bottom Navigation Bar matching screenshot color profiles
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF0B0F19) : Colors.white,
          selectedItemColor: const Color(0xFF10B981),
          unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  if (cartCount > 0)
                    Positioned(
                      top: -6,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF97316),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartCount > 0)
                    Positioned(
                      top: -6,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF97316),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Admin',
            ),
          ],
        ),
      ),
    );
  }
}

