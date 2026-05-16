import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProdukService {
  // 🔥 PAKAI IP LAPTOP (WAJIB untuk HP)
  final String baseUrl = 'http://192.168.1.8:3001';

  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Get Barang'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);

        final List<ProductModel> products = decoded
            .map((item) => ProductModel.fromJson(item))
            .toList();

        return {
          'status': true,
          'data': products,
        };
      }

      return {
        'status': false,
        'data': [],
      };
    } catch (e) {
      print('ERROR: $e');

      return {
        'status': false,
        'data': [],
      };
    }
  }
}