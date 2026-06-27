import 'package:flutter/material.dart';
import 'package:flutter_application_finna_berry/pages/scan_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'state/app_state.dart';
import 'pages/beranda_page.dart';
import 'pages/menu_page.dart';
import 'pages/keranjang_page.dart';
import 'pages/admin_page.dart';
import 'pages/splash_screen.dart';
import 'pages/chat_screen.dart';
import 'pages/riwayat_transaksi_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
  bool _showSplash = true;

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
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
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
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
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: _showSplash
                ? SplashScreen(
                    key: const ValueKey('splash'),
                    onSplashComplete: _onSplashComplete,
                  )
                : _isScanned
                ? MainLayout(key: const ValueKey('main'), appState: _appState)
                : ScanPage(
                    key: const ValueKey('scan'),
                    appState: _appState,
                    onScanSuccess: _onScanSuccess,
                  ),
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
  Offset? _fabPosition;

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
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
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
      RiwayatTransaksiPage(appState: widget.appState),
      AdminPage(
        appState: widget.appState,
        onBackToHome: _onNavigateToHome,
        onNavigateToMenu: _onNavigateToMenu,
      ),
    ];

    final screenSize = MediaQuery.of(context).size;
    _fabPosition ??= Offset(screenSize.width - 80, screenSize.height - 160);

    return Stack(
      children: [
        Scaffold(
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
                Flexible(
                  child: Text(
                    'Fina Berry',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                    overflow: TextOverflow.ellipsis,
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
              // The hamburger menu icon was removed here
              const SizedBox(width: 8),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ));
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_selectedIndex),
              child: screens[_selectedIndex],
            ),
          ),
          // Modern Material 3 NavigationBar (pill-shaped indicator like phone apps)
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            animationDuration: const Duration(milliseconds: 400),
            indicatorColor: const Color(0xFF10B981).withOpacity(0.2),
            backgroundColor: isDark ? const Color(0xFF0B0F19) : Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: Color(0xFF10B981)),
                label: 'Beranda',
              ),
              const NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu, color: Color(0xFF10B981)),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  backgroundColor: const Color(0xFFF97316),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  backgroundColor: const Color(0xFFF97316),
                  child: const Icon(Icons.shopping_cart, color: Color(0xFF10B981)),
                ),
                label: 'Keranjang',
              ),
              const NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history, color: Color(0xFF10B981)),
                label: 'Riwayat',
              ),
              const NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view, color: Color(0xFF10B981)),
                label: 'Admin',
              ),
            ],
          ),
        ),
        Positioned(
          left: _fabPosition!.dx,
          top: _fabPosition!.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _fabPosition = Offset(
                  _fabPosition!.dx + details.delta.dx,
                  _fabPosition!.dy + details.delta.dy,
                );
              });
            },
            child: _buildChatFAB(isDark),
          ),
        ),
      ],
    );
  }
}
