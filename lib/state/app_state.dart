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
  // Use localhost for web, IP for native
  final String _baseUrl = 'http://localhost:8080/api';

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
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
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
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': '${username.toLowerCase()}@finaberry.com',
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

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

  // ─── Default menu (fallback jika backend & cache kosong) ───────────────────
  static final List<MenuItem> _defaultMenuItems = [
    // Makanan
    MenuItem(id: 'd1',  name: 'Bakso Daging Sapi',           price: 15000, category: 'Makanan', description: '', imageUrl: 'assets/images/baso sapi.jpg'),
    MenuItem(id: 'd2',  name: 'Bakso Krewedan',               price: 22000, category: 'Makanan', description: '', imageUrl: 'assets/images/baso krewedan (2).jpg'),
    MenuItem(id: 'd3',  name: 'Bakso Keju',                   price: 17000, category: 'Makanan', description: '', imageUrl: 'assets/images/baso keju.jpg'),
    MenuItem(id: 'd4',  name: 'Soto Ayam',                    price: 10000, category: 'Makanan', description: '', imageUrl: 'assets/images/sotyam.jpg'),
    MenuItem(id: 'd5',  name: 'Soto Ayam Komplit',            price: 20000, category: 'Makanan', description: '', imageUrl: ''),
    MenuItem(id: 'd6',  name: 'Soto Daging Sapi',             price: 23000, category: 'Makanan', description: '', imageUrl: 'assets/images/soto daging sapi3.jpg'),
    MenuItem(id: 'd7',  name: 'Soto Babat',                   price: 20000, category: 'Makanan', description: '', imageUrl: 'assets/images/soto babt...jpg'),
    MenuItem(id: 'd8',  name: 'Nasi Goreng',                  price: 15000, category: 'Makanan', description: '', imageUrl: 'assets/images/nasigoreng.jpg'),
    MenuItem(id: 'd9',  name: 'Sop Daging Sapi + Nasi',       price: 25000, category: 'Makanan', description: '', imageUrl: ''),
    MenuItem(id: 'd10', name: 'Ca Kangkung',                  price: 8000,  category: 'Makanan', description: '', imageUrl: 'assets/images/ca kangkung.jpg'),
    MenuItem(id: 'd11', name: 'Paket Ayam Goreng',            price: 15000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/paket ayam goreng.jpg'),
    MenuItem(id: 'd12', name: 'Paket Ayam Bakar',             price: 15000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/ayambakarbiasa.jpg'),
    MenuItem(id: 'd13', name: 'Paket Ayam Goreng Penyet',     price: 16000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/ayam penyet.jpg'),
    MenuItem(id: 'd14', name: 'Paket Ayam Bakar Penyet',      price: 16000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/pnyt.jpg'),
    MenuItem(id: 'd15', name: 'Paket Ayam Goreng Kampung',    price: 25000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/paket ayam kampung.jpg'),
    MenuItem(id: 'd16', name: 'Paket Ayam Bakar Kampung',     price: 27000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/paket ayam bakar kam.jpg'),
    MenuItem(id: 'd17', name: 'Paket Ikan Mujair Goreng',     price: 20000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/paket ikan mujair goreng.jpg'),
    MenuItem(id: 'd18', name: 'Paket Ikan Mujair Bakar',      price: 20000, category: 'Makanan', description: 'Termasuk Nasi + Lauk + Lalap Sambal', imageUrl: 'assets/images/paket ikan bakar.jpg'),
    // Minuman
    MenuItem(id: 'd19', name: 'Teh Tawar',                    price: 2000,  category: 'Minuman', description: '', imageUrl: 'assets/images/tawar.jpeg'),
    MenuItem(id: 'd20', name: 'Es Teh Tawar',                 price: 3000,  category: 'Minuman', description: '', imageUrl: 'assets/images/tawar.jpg'),
    MenuItem(id: 'd21', name: 'Teh Manis Anget',              price: 3000,  category: 'Minuman', description: '', imageUrl: 'assets/images/teh anget.jpeg'),
    MenuItem(id: 'd22', name: 'Es Teh Manis',                 price: 4000,  category: 'Minuman', description: '', imageUrl: 'assets/images/es te.jpg'),
    MenuItem(id: 'd23', name: 'Lemon Tea Anget',              price: 9000,  category: 'Minuman', description: '', imageUrl: 'assets/images/lemon tea anget.jpeg'),
    MenuItem(id: 'd24', name: 'Es Lemon Tea',                 price: 10000, category: 'Minuman', description: '', imageUrl: 'assets/images/lemon tea.jpeg'),
    MenuItem(id: 'd25', name: 'Jeruk Anget',                  price: 4000,  category: 'Minuman', description: '', imageUrl: 'assets/images/jeruk angget.jpg'),
    MenuItem(id: 'd26', name: 'Es Jeruk',                     price: 5000,  category: 'Minuman', description: '', imageUrl: 'assets/images/es jeruk.jpeg'),
    MenuItem(id: 'd27', name: 'Aneka Kopi',                   price: 3000,  category: 'Minuman', description: '', imageUrl: 'assets/images/aneka ki.jpg'),
    MenuItem(id: 'd28', name: 'Kopi Cappucino',               price: 5000,  category: 'Minuman', description: '', imageUrl: 'assets/images/kopi i.jpg'),
    MenuItem(id: 'd29', name: 'Es Kopi Cappucino',            price: 5000,  category: 'Minuman', description: '', imageUrl: 'assets/images/es kopi c.jpg'),
    MenuItem(id: 'd30', name: 'Jahe Susu',                    price: 3000,  category: 'Minuman', description: '', imageUrl: 'assets/images/jahe susu.jpeg'),
    MenuItem(id: 'd31', name: 'Soda Susu',                    price: 10000, category: 'Minuman', description: '', imageUrl: 'assets/images/soda susu.jpeg'),
    MenuItem(id: 'd32', name: 'Wedang Jahe',                  price: 7000,  category: 'Minuman', description: '', imageUrl: 'assets/images/wedang.jpeg'),
    MenuItem(id: 'd33', name: 'Jus Strawberry',               price: 12000, category: 'Minuman', description: '', imageUrl: 'assets/images/jus Strawberry.jpg'),
    MenuItem(id: 'd34', name: 'Jus Melon',                    price: 10000, category: 'Minuman', description: '', imageUrl: ''),
    MenuItem(id: 'd35', name: 'Jus Jambu',                    price: 10000, category: 'Minuman', description: '', imageUrl: 'assets/images/jus jambu.jpg'),
    MenuItem(id: 'd36', name: 'Jus Mangga',                   price: 12000, category: 'Minuman', description: '', imageUrl: ''),
    MenuItem(id: 'd37', name: 'Jus Jeruk',                    price: 10000, category: 'Minuman', description: '', imageUrl: ''),
    MenuItem(id: 'd38', name: 'Jus Buah Naga',                price: 10000, category: 'Minuman', description: '', imageUrl: 'assets/images/buah naga.jpg'),
    MenuItem(id: 'd39', name: 'Jus Alpukat',                  price: 12000, category: 'Minuman', description: '', imageUrl: ''),
    // Cemilan
    MenuItem(id: 'd40', name: 'Mendoan',                      price: 10000, category: 'Cemilan', description: '1 Porsi', imageUrl: 'assets/images/mendoan.jpeg'),
    MenuItem(id: 'd41', name: 'Tahu Brontak',                 price: 10000, category: 'Cemilan', description: '1 Porsi', imageUrl: 'assets/images/tahun berontak.jpg'),
    MenuItem(id: 'd42', name: 'Pisang Goreng',                price: 10000, category: 'Cemilan', description: '1 Porsi', imageUrl: 'assets/images/pisang.jpg'),
  ];

  // Menu items list
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => List.unmodifiable(_menuItems);

  // ─── Simpan menu ke SharedPreferences ────────────────────────────────────────
  Future<void> _saveMenusToCache(List<MenuItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(items.map((m) => {
        'id': m.id,
        'name': m.name,
        'description': m.description,
        'price': m.price,
        'imageUrl': m.imageUrl,
        'category': m.category,
        'isPopular': m.isPopular,
      }).toList());
      await prefs.setString('cached_menus', encoded);
    } catch (e) {
      debugPrint('Cache save error: $e');
    }
  }

  // ─── Load menu dari SharedPreferences ────────────────────────────────────────
  Future<List<MenuItem>> _loadMenusFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_menus');
      if (cached != null && cached.isNotEmpty) {
        final List<dynamic> data = json.decode(cached);
        return data.map((jsonItem) => MenuItem(
          id: jsonItem['id'],
          name: jsonItem['name'],
          description: jsonItem['description'] ?? '',
          price: double.parse(jsonItem['price'].toString()),
          imageUrl: jsonItem['imageUrl'] ?? '',
          category: jsonItem['category'],
          isPopular: jsonItem['isPopular'] ?? true,
        )).toList();
      }
    } catch (e) {
      debugPrint('Cache load error: $e');
    }
    return [];
  }

  // ─── Fetch menu: Backend → Cache (merge) → Default ──────────────────────────
  Future<void> fetchMenus() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/menus'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Load cache dulu untuk preserve foto base64 yang sudah diupload lokal
        final cachedItems = await _loadMenusFromCache();
        final cachedMap = <String, MenuItem>{
          for (var item in cachedItems) item.id: item
        };

        final fetched = data.map((jsonItem) {
          final id = jsonItem['id'].toString();
          final backendImageUrl = _formatImageUrl(jsonItem['imageUrl']);

          // Prioritaskan base64 lokal jika ada (selalu bisa tampil tanpa internet)
          String imageUrl = backendImageUrl;
          if (cachedMap.containsKey(id) &&
              cachedMap[id]!.imageUrl.startsWith('data:image')) {
            imageUrl = cachedMap[id]!.imageUrl;
          }

          return MenuItem(
            id: id,
            name: jsonItem['name'],
            description: jsonItem['description'] ?? '',
            price: double.parse(jsonItem['price'].toString()),
            imageUrl: imageUrl,
            category: jsonItem['category'],
            isPopular: jsonItem['isAvailable'] ?? true,
          );
        }).toList();

        _menuItems = fetched;
        await _saveMenusToCache(fetched); // simpan (sudah termasuk foto lokal)
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint(
        'Sync warning: Cannot fetch menus from backend, using local data. Error: $e',
      );
    }

    // Layer 2: load dari cache lokal
    final cached = await _loadMenusFromCache();
    if (cached.isNotEmpty) {
      debugPrint('Menu loaded from local cache (${cached.length} items)');
      _menuItems = cached;
      notifyListeners();
      return;
    }

    // Layer 3: gunakan data default hardcoded
    debugPrint('Menu loaded from built-in defaults (${_defaultMenuItems.length} items)');
    _menuItems = List.from(_defaultMenuItems);
    notifyListeners();
  }

  Future<void> addMenuItem(MenuItem item, {List<int>? imageBytes, String? imageFilename}) async {
    // LANGKAH 1: Simpan base64 lokal dulu agar foto langsung tampil
    String localImageUrl = item.imageUrl;
    if (imageBytes != null) {
      final base64Str = base64Encode(Uint8List.fromList(imageBytes));
      final ext = (imageFilename ?? 'upload.jpg').toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      localImageUrl = 'data:image/$ext;base64,$base64Str';
    }
    final localItem = MenuItem(
      id: item.id,
      name: item.name,
      description: item.description,
      category: item.category,
      price: item.price,
      imageUrl: localImageUrl,
      isPopular: item.isPopular,
    );
    _menuItems.add(localItem);
    await _saveMenusToCache(_menuItems);
    notifyListeners(); // tampilkan foto segera

    // LANGKAH 2: Coba sinkronisasi ke backend (opsional, tidak blokir UI)
    try {
      if (imageBytes != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/menus'),
        );
        request.fields['name'] = item.name;
        request.fields['description'] = item.description;
        request.fields['price'] = item.price.toString();
        request.fields['category'] = item.category;
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFilename ?? 'upload.jpg',
        ));
        final streamedResponse = await request.send().timeout(const Duration(seconds: 8));
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus(); // sinkron ulang dengan data backend
        }
      } else {
        final response = await http.post(
          Uri.parse('$_baseUrl/menus'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': item.name,
            'description': item.description,
            'price': item.price,
            'category': item.category,
            'imageUrl': item.imageUrl,
          }),
        ).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus();
        }
      }
    } catch (e) {
      debugPrint('Backend sync skipped (offline): $e');
    }
  }

  Future<void> updateMenuItem(MenuItem item, {List<int>? imageBytes, String? imageFilename}) async {
    // LANGKAH 1: Simpan base64 lokal dulu agar foto langsung tampil
    String localImageUrl = item.imageUrl;
    if (imageBytes != null) {
      final base64Str = base64Encode(Uint8List.fromList(imageBytes));
      final ext = (imageFilename ?? 'upload.jpg').toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      localImageUrl = 'data:image/$ext;base64,$base64Str';
    }
    final updatedItem = MenuItem(
      id: item.id,
      name: item.name,
      description: item.description,
      category: item.category,
      price: item.price,
      imageUrl: localImageUrl,
      isPopular: item.isPopular,
    );
    final index = _menuItems.indexWhere((m) => m.id == item.id);
    if (index >= 0) {
      _menuItems[index] = updatedItem;
    }
    await _saveMenusToCache(_menuItems);
    notifyListeners(); // tampilkan foto segera

    // LANGKAH 2: Coba sinkronisasi ke backend (opsional, tidak blokir UI)
    try {
      if (imageBytes != null) {
        var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/menus/${item.id}'));
        request.fields['_method'] = 'PATCH';
        request.fields['name'] = item.name;
        request.fields['description'] = item.description;
        request.fields['price'] = item.price.toString();
        request.fields['category'] = item.category;
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFilename ?? 'upload.jpg',
        ));
        final streamedResponse = await request.send().timeout(const Duration(seconds: 8));
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus();
        }
      } else {
        final response = await http.patch(
          Uri.parse('$_baseUrl/menus/${item.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': item.name,
            'description': item.description,
            'price': item.price,
            'category': item.category,
            'imageUrl': item.imageUrl,
          }),
        ).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchMenus();
        }
      }
    } catch (e) {
      debugPrint('Backend sync skipped (offline): $e');
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
      final response = await http
          .delete(Uri.parse('$_baseUrl/menus/$id'))
          .timeout(const Duration(seconds: 4));

      // Treat any successful 2xx response as deleted and refresh from server
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint(
          'Delete successful for id=$id (status ${response.statusCode})',
        );
        await fetchMenus();
        return;
      }

      // Non-2xx: log and refresh from server to keep UI in sync (don't remove locally)
      debugPrint(
        'Delete failed for id=$id, status=${response.statusCode}, body=${response.body}',
      );
      await fetchMenus();
    } catch (e) {
      debugPrint(
        'Sync warning: Cannot delete menu item from backend, running locally. Error: $e',
      );
      _menuItems.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }

  // Cart state
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get cartTax => 0.0; // Pajak & Layanan Rp 0 as per design

  double get cartTotal => cartSubtotal + cartTax;

  void addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem.item.id == item.id,
    );
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
    final index = _cartItems.indexWhere(
      (cartItem) => cartItem.item.id == itemId,
    );
    if (index >= 0) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _cartItems.indexWhere(
      (cartItem) => cartItem.item.id == itemId,
    );
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
      final response = await http
          .get(Uri.parse('$_baseUrl/orders'))
          .timeout(const Duration(seconds: 4));
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
                imageUrl: _formatImageUrl(menuJson['imageUrl']),
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

    final String localId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
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

      final response = await http
          .post(
            Uri.parse('$_baseUrl/orders'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'customerName': customerName,
              'tableNumber': tableNumber,
              'paymentMethod': paymentMethod,
              'total': cachedTotal,
              'items': itemsList,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['redirect_url'] != null) {
          final uri = Uri.parse(responseData['redirect_url']);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
        await fetchOrders();
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(
        'Sync warning: Cannot submit order to backend, running locally. Error: $e',
      );
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
      final response = await http
          .patch(
            Uri.parse('$_baseUrl/orders/$orderId/status'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'status': statusStr}),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        await fetchOrders();
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(
        'Sync warning: Cannot update order status on backend, running locally. Error: $e',
      );
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
      .where(
        (order) =>
            order.status == OrderStatus.pending ||
            order.status == OrderStatus.processing,
      )
      .length;

  int get availableMenuItemsCount => _menuItems.length;

  // Raw materials stock state
  final List<BahanBaku> _bahanBakuList = [
    BahanBaku(
      id: 'bb1',
      name: 'Daging Sapi Segar',
      stockAmount: 15.5,
      unit: 'kg',
      minimumStock: 5.0,
    ),
    BahanBaku(
      id: 'bb2',
      name: 'Daging Ayam Kampung',
      stockAmount: 24.0,
      unit: 'pcs',
      minimumStock: 10.0,
    ),
    BahanBaku(
      id: 'bb3',
      name: 'Beras Premium',
      stockAmount: 50.0,
      unit: 'kg',
      minimumStock: 15.0,
    ),
    BahanBaku(
      id: 'bb4',
      name: 'Udang Pancet',
      stockAmount: 8.0,
      unit: 'kg',
      minimumStock: 3.0,
    ),
    BahanBaku(
      id: 'bb5',
      name: 'Jeruk Murni',
      stockAmount: 12.0,
      unit: 'kg',
      minimumStock: 4.0,
    ),
    BahanBaku(
      id: 'bb6',
      name: 'Kopi Espresso Blend',
      stockAmount: 5.5,
      unit: 'kg',
      minimumStock: 2.0,
    ),
    BahanBaku(
      id: 'bb7',
      name: 'Gula Aren Cair',
      stockAmount: 10.0,
      unit: 'kg',
      minimumStock: 3.0,
    ),
    BahanBaku(
      id: 'bb8',
      name: 'Minyak Goreng',
      stockAmount: 20.0,
      unit: 'liter',
      minimumStock: 5.0,
    ),
    BahanBaku(
      id: 'bb9',
      name: 'Susu Premium Full Cream',
      stockAmount: 15.0,
      unit: 'liter',
      minimumStock: 4.0,
    ),
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

  void removeBahanBaku(String id) {
    _bahanBakuList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
