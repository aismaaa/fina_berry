import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'checkout_page.dart';
import '../widgets/footer_widget.dart';

class KeranjangPage extends StatelessWidget {
  final AppState appState;
  final VoidCallback onNavigateToMenu;

  const KeranjangPage({
    super.key,
    required this.appState,
    required this.onNavigateToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cartItems = appState.cartItems;

    String formatPrice(double price) {
      return 'Rp ${price.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
    }

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
                            // Thumbnail Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                item.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.fastfood, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Text Content
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
                                      // Remove Button
                                      GestureDetector(
                                        onTap: () {
                                          appState.removeFromCart(item.id);
                                        },
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red[400],
                                          size: 22,
                                        ),
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
                                      // Quantity Selector
                                      Row(
                                        children: [
                                          _buildQuantityBtn(
                                            icon: Icons.remove,
                                            onTap: () => appState.decrementQuantity(item.id),
                                            isDark: isDark,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            '${cartItem.quantity}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.grey[900],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          _buildQuantityBtn(
                                            icon: Icons.add,
                                            onTap: () => appState.incrementQuantity(item.id),
                                            isDark: isDark,
                                          ),
                                        ],
                                      ),

                                      // Price
                                      Text(
                                        formatPrice(cartItem.totalPrice),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
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
                _buildSummaryRow('Subtotal (${appState.cartCount} item)', formatPrice(appState.cartSubtotal), isDark),
                const SizedBox(height: 8),
                _buildSummaryRow('Pajak & Layanan', formatPrice(appState.cartTax), isDark),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    Text(
                      formatPrice(appState.cartTotal),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF10B981),
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
                            appState: appState,
                            onOrderSuccess: () {
                              Navigator.pop(context); // Pop checkout page
                              onNavigateToMenu(); // Go to Menu
                            },
                            onCancel: () {
                              Navigator.pop(context); // Pop checkout page
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Lanjut ke Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Add more menu items
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: onNavigateToMenu,
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
        const FooterWidget(),
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
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onNavigateToMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Belanja Sekarang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildQuantityBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
