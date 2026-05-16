import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class FavoriteService {
  static const String baseUrl = 'http://192.168.1.8:3001';

  // 1️⃣ GET: Ambil semua produk favorit dari API
  Future<Map<String, dynamic>> getFavoriteProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Get Barang'), // Sesuaikan endpoint dengan API kamu
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('GET Favorites - Status: ${response.statusCode}');
      print('GET Favorites - Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        
        List<ProductModel> products = [];
        
        // Sesuaikan parsing dengan struktur response API kamu
        // Contoh jika response berupa list langsung: [{...}, {...}]
        if (jsonResponse is List) {
          products = jsonResponse.map((x) => ProductModel.fromJson(x)).toList();
        } 
        // Contoh jika response berbentuk: {"data": [{...}, {...}]}
        else if (jsonResponse is Map && jsonResponse['data'] != null) {
          products = (jsonResponse['data'] as List)
              .map((x) => ProductModel.fromJson(x))
              .toList();
        }
        // Contoh jika response berbentuk: {"favorites": [{...}, {...}]}
        else if (jsonResponse is Map && jsonResponse['favorites'] != null) {
          products = (jsonResponse['favorites'] as List)
              .map((x) => ProductModel.fromJson(x))
              .toList();
        }
        
        return {
          'status': true,
          'data': products,
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal memuat favorit (${response.statusCode})',
          'data': [],
        };
      }
    } catch (e) {
      print('Error getFavoriteProducts: $e');
      return {
        'status': false,
        'message': 'Error: $e',
        'data': [],
      };
    }
  }

  // 2️⃣ DELETE: Hapus produk dari favorit
  Future<Map<String, dynamic>> removeFavorite(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$productId'), // Sesuaikan endpoint
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('DELETE Favorite - Status: ${response.statusCode}');
      print('DELETE Favorite - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'status': true,
          'message': 'Berhasil dihapus dari favorit',
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal menghapus favorit (${response.statusCode})',
        };
      }
    } catch (e) {
      print('Error removeFavorite: $e');
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }

  // 3️⃣ POST: Tambah ke favorit
  Future<Map<String, dynamic>> addFavorite(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'product_id': productId}),
      ).timeout(const Duration(seconds: 10));

      print('POST Favorite - Status: ${response.statusCode}');
      print('POST Favorite - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'status': true,
          'message': 'Berhasil ditambahkan ke favorit',
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal menambahkan favorit',
        };
      }
    } catch (e) {
      print('Error addFavorite: $e');
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }
}