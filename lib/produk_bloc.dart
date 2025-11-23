import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdukBloc {
  static const String baseUrl = "https://example.com/api"; // ganti dgn URL API kamu

  /// Fungsi menghapus produk
  static Future deleteProduk({required int id}) async {
    final url = Uri.parse("$baseUrl/produk/$id");

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Jika API mengembalikan JSON, decode di sini
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Gagal menghapus produk");
    }
  }
}
