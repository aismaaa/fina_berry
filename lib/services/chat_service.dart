import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  // Ambil API Key dari file .env
  static String get _groqApiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  
  static const String _groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile'; // Model terbaru Groq

  // Inisialisasi history dengan system prompt dinamis
  final List<Map<String, dynamic>> _conversationHistory = [];

  void setMenuContext(List<dynamic> menus) {
    if (_conversationHistory.isNotEmpty) return; // Jangan set ulang jika sudah ada

    String menuList = menus.map((m) => '- ${m.name}: Rp ${m.price.toInt()} (${m.category})${m.isPopular ? " ⭐ BEST SELLER" : ""}').join('\n');

    String systemPrompt = '''Kamu adalah AI asisten kasir "Fina Berry". Jawablah dengan ramah, informatif, ringkas, dan bahasa Indonesia.

Informasi Fina Berry: Restoran yang menyajikan aneka makanan dan minuman lezat.

Daftar Menu Asli dari Database:
$menuList

Panduan menjawab:
1. Jika ditanya harga atau menu, jawab SESUAI dengan daftar di atas saja.
2. Jika ditanya rekomendasi, rekomendasikan menu dari daftar di atas yang harganya rasional atau menarik.
3. Selalu tawarkan tambahan minuman atau cemilan jika pelanggan memesan makanan.
4. Jika pesanan tidak ada di menu, mohon maaf dan katakan menu tersebut tidak tersedia di Fina Berry.
5. PENTING: Jika pelanggan menyatakan ingin memesan sesuatu (contoh: "saya ingin memesan jus jeruk", "pesan nasi goreng 1", dll) dan menu tersebut ADA di daftar, kamu WAJIB menyertakan tag [ORDER: Nama Menu] di akhir balasanmu untuk memasukkannya ke keranjang sistem. Pastikan Nama Menu sama persis dengan yang ada di daftar. 
   Contoh balasan: "Baik, pesanan Jus Jeruk akan saya siapkan. [ORDER: Jus Jeruk]"
   Jika pelanggan memesan beberapa menu, sertakan tag untuk masing-masing menu. Contoh: "[ORDER: Jus Jeruk] [ORDER: Nasi Goreng]"
''';

    _conversationHistory.add({
      'role': 'system', 
      'content': systemPrompt
    });
  }



  Future<String> sendMessage(String message) async {
    // Tambah pesan user ke history
    _conversationHistory.add({'role': 'user', 'content': message});

    try {
      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': _conversationHistory,
          'temperature': 0.7, // Tingkat kreativitas (0.0 - 1.0)
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;

        // Simpan balasan bot ke history
        _conversationHistory.add({'role': 'assistant', 'content': reply});

        return reply;
      } else {
        return 'Maaf, terjadi kesalahan pada AI (Status: ${response.statusCode}). Coba lagi nanti.';
      }
    } on Exception catch (e) {
      // Hapus pesan terakhir dari history jika gagal
      if (_conversationHistory.isNotEmpty) {
        _conversationHistory.removeLast();
      }
      final errMsg = e.toString();
      if (errMsg.contains('TimeoutException')) {
        return 'Koneksi timeout. Periksa internet kamu.';
      }
      return 'Koneksi gagal: $e';
    }
  }

  /// Reset riwayat percakapan (menyisakan system prompt saja)
  void clearHistory() {
    _conversationHistory.removeWhere((msg) => msg['role'] != 'system');
  }
}
