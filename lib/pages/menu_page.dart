import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/menu_item.dart';
import '../widgets/footer_widget.dart';
import '../widgets/menu_image_widget.dart';

class MenuPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onNavigateToMenu;

  const MenuPage({
    super.key,
    required this.appState,
    this.onNavigateToHome,
    this.onNavigateToMenu,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter items based on selected category AND search query
    final filteredItems = widget.appState.menuItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return RefreshIndicator(
      onRefresh: () => widget.appState.fetchMenus(),
      color: const Color(0xFF10B981),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu Kami',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'times new roman',
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Silahkan Pilih menu favorit Anda',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.grey[900],
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari menu...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: const Color(0xFF10B981),
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: isDark ? Colors.grey[400] : Colors.grey[500],
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categories row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton('Semua', isDark),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Makanan', isDark),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Minuman', isDark),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Cemilan', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Horizontal separator/scrollbar representation
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _getIndicatorWidth(context),
                      margin: EdgeInsets.only(
                        left: _getIndicatorOffset(context),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Menu items grid/list
        if (filteredItems.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Column(
                children: [
                  Icon(
                    _searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.restaurant_menu_outlined,
                    size: 56,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'Menu "$_searchQuery" tidak ditemukan'
                        : 'Tidak ada item menu',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildMenuItemCard(item, isDark),
              );
            },
          ),
          
        const SizedBox(height: 20),
        FooterWidget(
          onNavigateToHome: widget.onNavigateToHome,
          onNavigateToMenu: widget.onNavigateToMenu,
        ),
      ],
      ),
      ),
    );
  }

  Widget _buildCategoryButton(String category, bool isDark) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981)
              : (isDark ? Colors.white : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.transparent : Colors.grey[300]!,
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.black87 : Colors.grey[800]),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  double _getIndicatorWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 48; // padding
    return screenWidth / 4;
  }

  double _getIndicatorOffset(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 48;
    final buttonWidth = screenWidth / 4;
    if (_selectedCategory == 'Semua') return 0;
    if (_selectedCategory == 'Makanan') return buttonWidth;
    if (_selectedCategory == 'Minuman') return buttonWidth * 2;
    return buttonWidth * 3; // Cemilan
  }

  Widget _buildMenuItemCard(MenuItem item, bool isDark) {
    final formattedPrice =
        'Rp ${item.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Item Image & Popular Badge
          Stack(
            children: [
              MenuImageWidget(
                imageUrl: item.imageUrl,
                height: 180,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              if (item.isPopular)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Populer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Add to Cart Button
                GestureDetector(
                  onTap: () {
                    widget.appState.addToCart(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.name} berhasil ditambahkan ke keranjang!',
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
