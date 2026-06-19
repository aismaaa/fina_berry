import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // ✅ Menggunakan n8n webhook sebagai perantara ke AI
  // 192.168.101.22 = IP address komputer lokal (Wi-Fi) untuk test di HP fisik
  // Ganti PATH_WEBHOOK dengan path dari node Webhook di n8n kamu
  // Contoh: jika Production URL = http://localhost:5678/webhook/fina-ai
  //         maka _webhookPath = 'fina-ai'
  static const String _n8nBaseUrl = 'http://192.168.0.104:5678/webhook';
  static const String _webhookPath = 'chatbot'; // ← Ganti ini!

  final List<Map<String, dynamic>> _conversationHistory = [];

  Future<String> sendMessage(String message) async {
    // Tambah pesan user ke history
    _conversationHistory.add({'role': 'user', 'content': message});

    try {
      final response = await http
          .post(
            Uri.parse('$_n8nBaseUrl/$_webhookPath'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': message,
              'history': _conversationHistory,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // n8n biasanya mengembalikan output di field 'output' atau 'text' atau 'reply'
        final reply =
            data['output'] as String? ??
            data['text'] as String? ??
            data['reply'] as String? ??
            'Maaf, tidak ada respons.';

        // Simpan balasan bot ke history
        _conversationHistory.add({'role': 'assistant', 'content': reply});

        return reply;
      } else if (response.statusCode == 404) {
        return 'Webhook tidak ditemukan. Pastikan path webhook sudah benar dan workflow sudah Published.';
      } else if (response.statusCode == 429) {
        return 'Terlalu banyak permintaan. Coba lagi sebentar.';
      } else {
        return 'Error ${response.statusCode}: Gagal mendapatkan respons dari n8n.';
      }
    } on Exception catch (e) {
      // Hapus pesan terakhir dari history jika gagal
      if (_conversationHistory.isNotEmpty) {
        _conversationHistory.removeLast();
      }
      final errMsg = e.toString();
      if (errMsg.contains('TimeoutException')) {
        return 'Koneksi timeout. Periksa internet kamu dan pastikan n8n berjalan.';
      }
      return 'Koneksi gagal: $e';
    }
  }

  /// Reset riwayat percakapan
  void clearHistory() {
    _conversationHistory.clear();
  }
}
