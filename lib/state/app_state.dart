import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../models/bahan_baku_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/platform_stub.dart'
  if (dart.library.io) '../src/platform_io.dart';

class AppState extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.0.104:8080/api';

  AppState() {
    // Try to load initial data from Laravel backend on startup
    fetchInitialData();
  }

  Uri _apiUri(String path, {bool backup = false}) {
    final baseUrl = backup ? _backupBaseUrl : _baseUrl;
    return Uri.parse('$baseUrl$path');
  }

  /// Public helper to construct API URIs from widgets/pages.
  Uri apiUrl(String path, {bool backup = false}) => _apiUri(path, backup: backup);

  Future<http.Response> _tryRequest(
    String path,
    Future<http.Response> Function(Uri uri) request,
  ) async {
    try {
      return await request(_apiUri(path));
    } catch (e) {
      debugPrint('Request to $_baseUrl$path failed, trying backup url: $e');
      return await request(_apiUri(path, backup: true));
    }
  }

  Future<void> fetchInitialData() async {
    await fetchMenus();
    await fetchOrders();
  }

  // Theme state
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  // Table state
  String? _tableNumber;
  String? get tableNumber => _tableNumber;

  void setTableNumber(String tableNumber) {
    _tableNumber = tableNumber;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Auth State
  String? _currentUserRole; // null, 'admin', 'kasir'
  String? get currentUserRole => _currentUserRole;
  String? _lastLoginError;
  String? get lastLoginError => _lastLoginError;

  Future<bool> login(String username, String password) async {
    _lastLoginError = null;
    try {
      final email = username.contains('@')
          ? username.toLowerCase()
          : '${username.toLowerCase()}@gmail.com';

      final response = await _tryRequest(
        '/login',
        (uri) => http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
          }),
        ).timeout(const Duration(seconds: 4)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUserRole = data['user']['role'];
        notifyListeners();
        return true;
      } else {
        final body = response.body;
        _lastLoginError = 'Server: ${response.statusCode} - $body';
        debugPrint('Login failed: ${response.statusCode} ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      _lastLoginError = 'Error: $e';
      debugPrint('Login Error: $e');
      notifyListeners();
    }
    return false;
  }

  void logout() {
    _currentUserRole = null;
    notifyListeners();
  }

  // Menu items list — kosong, diisi manual oleh admin/kasir
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => List.unmodifiable(_menuItems);

  Future<void> fetchMenus() async {
    try {
      final response = await _tryRequest(
        '/menus',
        (uri) => http.get(uri).timeout(const Duration(seconds: 4)),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _menuItems = data.map((jsonItem) {
          return MenuItem(
            id: jsonItem['id'].toString(),
            name: jsonItem['name'],
            description: jsonItem['description'] ?? '',
            price: double.parse(jsonItem['price'].toString()),
            imageUrl: jsonItem['imageUrl'] ?? '',
            category: jsonItem['category'],
            isPopular: jsonItem['isAvailable'] ?? true, // maps availability status
          );
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Sync warning: Cannot fetch menus from backend, using local data. Error: $e');
    }
  }

  Future<void> addMenuItem(MenuItem item, {List<int>? imageBytes, String? imageFilename}) async {
    try {
      if (imageBytes != null) {
        var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/menus'));
        request.fields['name'] = item.name;
        request.fields['description'] = item.description;
        request.fields['price'] = item.price.toString();
        request.fields['category'] = item.category;
        
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFilename ?? 'upload.jpg',
        ));
        
        final streamedResponse = await request.send().timeout(const Duration(seconds: 4));
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus();
        }
      } else {
        final response = await _tryRequest(
          '/menus',
          (uri) => http.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': item.name,
              'description': item.description,
              'price': item.price,
              'category': item.category,
              'imageUrl': item.imageUrl,
            }),
          ).timeout(const Duration(seconds: 4)),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus();
        }
      }
    } catch (e) {
      debugPrint('Sync warning: Cannot add menu item to backend, running locally. Error: $e');
      _menuItems.add(item);
      notifyListeners();
    }
  }

  Future<void> removeMenuItem(String id) async {
    // If the id looks like a local-only id (created on client), remove locally
    if (id.startsWith('menu-')) {
      _menuItems.removeWhere((item) => item.id == id);
      notifyListeners();
      return;
    }

    try {
      final response = await _tryRequest(
        '/menus/$id',
        (uri) => http.delete(uri).timeout(const Duration(seconds: 4)),
      );

      // Treat any successful 2xx response as deleted and refresh from server
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Delete successful for id=$id (status ${response.statusCode})');
        await fetchMenus();
        return;
      }

      // Non-2xx: log and refresh from server to keep UI in sync (don't remove locally)
      debugPrint('Delete failed for id=$id, status=${response.statusCode}, body=${response.body}');
      await fetchMenus();
    } catch (e) {
      debugPrint('Delete exception for id=$id: $e');
      // Attempt to re-sync from server so the item will reappear if it wasn't deleted
      try {
        await fetchMenus();
      } catch (_) {
        // ignore
      }
    }
  }

  // Cart state
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get cartTax => 0.0; // Pajak & Layanan Rp 0 as per design

  double get cartTotal => cartSubtotal + cartTax;

  void addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cartItems.removeWhere((cartItem) => cartItem.item.id == itemId);
    notifyListeners();
  }
  
  void incrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((c) => c.item.id == itemId);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((c) => c.item.id == itemId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  Future<void> fetchOrders() async {
    try {
      final response = await _tryRequest(
        '/orders',
        (uri) => http.get(uri).timeout(const Duration(seconds: 4)),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _orders = data.map((jsonOrder) {
          final List<dynamic> itemsJson = jsonOrder['items'] ?? [];
          final items = itemsJson.map((itemJson) {
            final menuJson = itemJson['item'] ?? {};
            return CartItem(
              item: MenuItem(
                id: menuJson['id'].toString(),
                name: menuJson['name'] ?? 'Unknown',
                description: menuJson['description'] ?? '',
                price: double.parse(menuJson['price'].toString()),
                imageUrl: menuJson['imageUrl'] ?? '',
                category: menuJson['category'] ?? 'Makanan',
              ),
              quantity: itemJson['quantity'] ?? 1,
            );
          }).toList();

          OrderStatus status = OrderStatus.pending;
          if (jsonOrder['status'] == 'processing') {
            status = OrderStatus.processing;
          } else if (jsonOrder['status'] == 'completed') {
            status = OrderStatus.completed;
          } else if (jsonOrder['status'] == 'cancelled') {
            status = OrderStatus.cancelled;
          }

          return OrderModel(
            id: jsonOrder['id'].toString(),
            items: items,
            total: double.parse(jsonOrder['total'].toString()),
            date: DateTime.parse(jsonOrder['date']),
            status: status,
            customerName: jsonOrder['customerName'] ?? 'Guest',
            tableNumber: jsonOrder['tableNumber'] ?? 'A4',
            paymentMethod: jsonOrder['paymentMethod'] ?? 'Cash',
          );
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Sync warning: Cannot fetch orders from backend. Error: $e');
    }
  }

  Future<void> checkout({
    required String customerName,
    required String tableNumber,
    required String paymentMethod,
  }) async {
    if (_cartItems.isEmpty) return;

    final String localId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final List<CartItem> cachedItems = List.from(_cartItems);
    final double cachedTotal = cartTotal;

    // Clear local cart first to ensure immediate responsive UI
    clearCart();

    try {
      final List<Map<String, dynamic>> itemsList = cachedItems.map((cartItem) {
        return {
          'menu_id': cartItem.item.id,
          'quantity': cartItem.quantity,
          'price': cartItem.item.price,
        };
      }).toList();

      final response = await _tryRequest(
        '/orders',
        (uri) => http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'customerName': customerName,
            'tableNumber': tableNumber,
            'paymentMethod': paymentMethod,
            'total': cachedTotal,
            'items': itemsList,
          }),
        ).timeout(const Duration(seconds: 4)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchOrders();
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sync warning: Cannot submit order to backend, running locally. Error: $e');
      // If server is offline, save order in local memory so the queue is still functional
      final fallbackOrder = OrderModel(
        id: localId,
        items: cachedItems,
        total: cachedTotal,
        date: DateTime.now(),
        status: OrderStatus.pending,
        customerName: customerName,
        tableNumber: tableNumber,
        paymentMethod: paymentMethod,
      );
      _orders.add(fallbackOrder);
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    String statusStr = 'pending';
    if (status == OrderStatus.processing) {
      statusStr = 'processing';
    } else if (status == OrderStatus.completed) {
      statusStr = 'completed';
    } else if (status == OrderStatus.cancelled) {
      statusStr = 'cancelled';
    }

    try {
      final response = await _tryRequest(
        '/orders/$orderId/status',
        (uri) => http.patch(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'status': statusStr}),
        ).timeout(const Duration(seconds: 4)),
      );

      if (response.statusCode == 200) {
        await fetchOrders();
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sync warning: Cannot update order status on backend, running locally. Error: $e');
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        _orders[index].status = status;
        notifyListeners();
      }
    }
  }

  // Admin Dashboard stats
  double get totalRevenue => _orders
      .where((order) => order.status == OrderStatus.completed)
      .fold(0.0, (sum, order) => sum + order.total);

  int get totalOrdersCount => _orders.length;

  int get activeOrdersCount => _orders
      .where((order) => order.status == OrderStatus.pending || order.status == OrderStatus.processing)
      .length;

  int get availableMenuItemsCount => _menuItems.length;

  // Raw materials stock state
  final List<BahanBaku> _bahanBakuList = [
    BahanBaku(id: 'bb1', name: 'Daging Sapi Segar', stockAmount: 15.5, unit: 'kg', minimumStock: 5.0),
    BahanBaku(id: 'bb2', name: 'Daging Ayam Kampung', stockAmount: 24.0, unit: 'pcs', minimumStock: 10.0),
    BahanBaku(id: 'bb3', name: 'Beras Premium', stockAmount: 50.0, unit: 'kg', minimumStock: 15.0),
    BahanBaku(id: 'bb4', name: 'Udang Pancet', stockAmount: 8.0, unit: 'kg', minimumStock: 3.0),
    BahanBaku(id: 'bb5', name: 'Jeruk Murni', stockAmount: 12.0, unit: 'kg', minimumStock: 4.0),
    BahanBaku(id: 'bb6', name: 'Kopi Espresso Blend', stockAmount: 5.5, unit: 'kg', minimumStock: 2.0),
    BahanBaku(id: 'bb7', name: 'Gula Aren Cair', stockAmount: 10.0, unit: 'kg', minimumStock: 3.0),
    BahanBaku(id: 'bb8', name: 'Minyak Goreng', stockAmount: 20.0, unit: 'liter', minimumStock: 5.0),
    BahanBaku(id: 'bb9', name: 'Susu Premium Full Cream', stockAmount: 15.0, unit: 'liter', minimumStock: 4.0),
  ];

  List<BahanBaku> get bahanBakuList => List.unmodifiable(_bahanBakuList);

  void updateStock(String id, double newAmount) {
    final index = _bahanBakuList.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _bahanBakuList[index].stockAmount = newAmount;
      notifyListeners();
    }
  }

  void addBahanBaku(BahanBaku item) {
    _bahanBakuList.add(item);
    notifyListeners();
  }
}
