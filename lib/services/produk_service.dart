import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/app_config.dart' as url;
import '../models/produk_model.dart';
import '../models/response_data_list.dart';

class ProdukService {
  Future<ResponseDataList> getBarang() async {
    try {
      final uri = Uri.parse('${url.BaseUrl}/Get Barang');
      final response = await http.get(uri);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        final List list = decoded is List ? decoded : decoded['data'] ?? [];
        return ResponseDataList(
          status: true,
          message: 'Berhasil',
          data: list.map((e) => ProdukModel.fromJson(e)).toList(),
        );
      } else {
        return ResponseDataList(status: false, message: 'Gagal mengambil data');
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: 'Tidak dapat terhubung ke server.',
      );
    }
  }
}